package com.grownited.service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.grownited.common.AppConstants;
import com.grownited.config.RazorpayGatewayProperties;
import com.grownited.dto.RazorpayCheckoutView;
import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.PaymentTransactionEntity;
import com.grownited.entity.TeamEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.PaymentTransactionRepository;
import com.grownited.repository.TeamRepository;
import com.grownited.repository.UserRepository;

@Service
public class RazorpayPaymentService {

    private static final String HMAC_ALGORITHM = "HmacSHA256";

    private final RazorpayGatewayProperties gatewayProperties;
    private final PaymentTransactionService paymentTransactionService;
    private final PaymentTransactionRepository paymentTransactionRepository;
    private final HackathonApplicationRepository hackathonApplicationRepository;
    private final HackathonRepository hackathonRepository;
    private final TeamRepository teamRepository;
    private final UserRepository userRepository;
    private final ObjectMapper objectMapper;
    private final HttpClient httpClient;

    public RazorpayPaymentService(RazorpayGatewayProperties gatewayProperties,
            PaymentTransactionService paymentTransactionService,
            PaymentTransactionRepository paymentTransactionRepository,
            HackathonApplicationRepository hackathonApplicationRepository,
            HackathonRepository hackathonRepository,
            TeamRepository teamRepository,
            UserRepository userRepository,
            ObjectMapper objectMapper) {
        this.gatewayProperties = gatewayProperties;
        this.paymentTransactionService = paymentTransactionService;
        this.paymentTransactionRepository = paymentTransactionRepository;
        this.hackathonApplicationRepository = hackathonApplicationRepository;
        this.hackathonRepository = hackathonRepository;
        this.teamRepository = teamRepository;
        this.userRepository = userRepository;
        this.objectMapper = objectMapper;
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(15))
                .build();
    }

    @Transactional
    public RazorpayCheckoutView initiateCheckout(Integer applicationId, UserEntity currentUser) {
        if (currentUser == null) {
            throw new IllegalArgumentException("User session expired");
        }

        HackathonApplicationEntity application = hackathonApplicationRepository.findById(applicationId)
                .orElseThrow(() -> new IllegalArgumentException("Application not found"));
        if (application.getParticipantUserId() == null || !application.getParticipantUserId().equals(currentUser.getUserId())) {
            throw new IllegalArgumentException("You are not allowed to pay for this application");
        }

        if ("PAID".equalsIgnoreCase(application.getPaymentStatus())) {
            throw new IllegalArgumentException("This application is already settled");
        }

        HackathonEntity hackathon = hackathonRepository.findById(application.getHackathonId())
                .orElseThrow(() -> new IllegalArgumentException("Hackathon not found"));

        int amountRupees = resolveEntryFee(hackathon);
        if (amountRupees <= 0) {
            throw new IllegalArgumentException("This hackathon does not require payment");
        }

        String idempotencyKey = "razorpay-app-" + applicationId;
        PaymentTransactionEntity transaction = paymentTransactionService.startTransaction(applicationId,
                (double) amountRupees, idempotencyKey);

        if (transaction.getGatewayOrderId() == null || transaction.getGatewayOrderId().isBlank()) {
            String receipt = buildReceipt(applicationId, transaction.getPaymentTransactionId());
            String orderId = createOrder(amountRupees * 100, receipt, application);
            transaction = paymentTransactionService.linkOrder(transaction, orderId, gatewayProperties.getCurrency(),
                    "Razorpay order created");
        }

        return buildCheckoutView(transaction, application, hackathon, amountRupees);
    }

    @Transactional
    public PaymentTransactionEntity verifyCheckoutPayment(String razorpayOrderId, String razorpayPaymentId,
            String razorpaySignature) {
        if (razorpayOrderId == null || razorpayPaymentId == null || razorpaySignature == null) {
            throw new IllegalArgumentException("Missing payment verification data");
        }

        PaymentTransactionEntity transaction = paymentTransactionService.findByGatewayOrderId(razorpayOrderId)
                .orElseThrow(() -> new IllegalArgumentException("Payment order not found"));

        if ("SUCCESS".equalsIgnoreCase(transaction.getStatus())
                && razorpayPaymentId.equals(transaction.getGatewayTransactionId())) {
            return transaction;
        }

        String expectedSignature = calculateHmacHex(razorpayOrderId + "|" + razorpayPaymentId,
                gatewayProperties.getKeySecret());

        if (!constantTimeEquals(expectedSignature, razorpaySignature)) {
            paymentTransactionService.markFailure(transaction, "Razorpay signature mismatch");
            applicationPaymentStatus(transaction.getApplicationId(), "FAILED");
            throw new IllegalArgumentException("Payment signature verification failed");
        }

        PaymentTransactionEntity updated = paymentTransactionService.markCheckoutSuccess(transaction,
                razorpayPaymentId, razorpaySignature, "Checkout payment verified");
        applicationPaymentStatus(updated.getApplicationId(), "PAID");
        return updated;
    }

    @Transactional
    public void processWebhook(String rawBody, String receivedSignature) {
        verifyWebhookSignature(rawBody, receivedSignature);

        try {
            JsonNode root = objectMapper.readTree(rawBody);
            String event = textOrNull(root.path("event"));
            JsonNode paymentNode = root.path("payload").path("payment").path("entity");

            String orderId = firstNonBlank(
                    textOrNull(paymentNode.path("order_id")),
                    textOrNull(root.path("payload").path("order").path("entity").path("id")));
            String paymentId = textOrNull(paymentNode.path("id"));

            Optional<PaymentTransactionEntity> opTransaction = paymentTransactionService.findByGatewayOrderId(orderId);
            if (opTransaction.isEmpty() && paymentId != null) {
                opTransaction = paymentTransactionService.findByGatewayTransactionId(paymentId);
            }
            if (opTransaction.isEmpty()) {
                return;
            }

            PaymentTransactionEntity transaction = opTransaction.get();
            if (event != null && event.toLowerCase().contains("failed")) {
                paymentTransactionService.markFailure(transaction, "Razorpay webhook event: " + event);
                applicationPaymentStatus(transaction.getApplicationId(), "FAILED");
                return;
            }

            if (paymentId == null || paymentId.isBlank()) {
                paymentId = transaction.getGatewayTransactionId();
            }

            paymentTransactionService.markCheckoutSuccess(transaction, paymentId, receivedSignature,
                    "Razorpay webhook event: " + (event == null ? "unknown" : event));
            applicationPaymentStatus(transaction.getApplicationId(), "PAID");
        } catch (IOException ex) {
            throw new IllegalArgumentException("Unable to parse webhook payload", ex);
        }
    }

    public void verifyWebhookSignature(String rawBody, String receivedSignature) {
        if (rawBody == null || rawBody.isBlank() || receivedSignature == null || receivedSignature.isBlank()) {
            throw new IllegalArgumentException("Missing webhook signature data");
        }

        String expectedSignature = calculateHmacHex(rawBody, gatewayProperties.getWebhookSecret());
        if (!constantTimeEquals(expectedSignature, receivedSignature)) {
            throw new IllegalArgumentException("Invalid webhook signature");
        }
    }

    private RazorpayCheckoutView buildCheckoutView(PaymentTransactionEntity transaction, HackathonApplicationEntity application,
            HackathonEntity hackathon, int amountRupees) {
        RazorpayCheckoutView view = new RazorpayCheckoutView();
        view.setApplicationId(application.getApplicationId());
        view.setTransactionId(transaction.getPaymentTransactionId());
        view.setHackathonId(hackathon.getHackathonId());
        view.setHackathonTitle(hackathon.getTitle());
        view.setCurrency(gatewayProperties.getCurrency());
        view.setAmountPaise(amountRupees * 100);
        view.setAmountDisplay(String.format("%.2f", amountRupees * 1.0));
        view.setReceipt(buildReceipt(application.getApplicationId(), transaction.getPaymentTransactionId()));
        view.setKeyId(gatewayProperties.getKeyId());
        view.setOrderId(transaction.getGatewayOrderId());
        view.setCheckoutScriptUrl(gatewayProperties.getCheckoutScriptUrl());

        Optional<TeamEntity> opTeam = teamRepository.findById(application.getTeamId());
        view.setTeamName(opTeam.map(TeamEntity::getTeamName).orElse("Team"));

        Optional<UserEntity> opParticipant = userRepository.findById(application.getParticipantUserId());
        view.setParticipantName(opParticipant.map(user -> user.getFirstName() + " " + user.getLastName())
                .orElse("Participant"));

        return view;
    }

    private String createOrder(int amountPaise, String receipt, HackathonApplicationEntity application) {
        try {
            Map<String, Object> payload = new LinkedHashMap<>();
            payload.put("amount", amountPaise);
            payload.put("currency", gatewayProperties.getCurrency());
            payload.put("receipt", receipt);
            payload.put("payment_capture", 1);

            Map<String, Object> notes = new LinkedHashMap<>();
            notes.put("applicationId", application.getApplicationId());
            notes.put("hackathonId", application.getHackathonId());
            notes.put("teamId", application.getTeamId());
            notes.put("participantUserId", application.getParticipantUserId());
            payload.put("notes", notes);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(normalizeBaseUrl(gatewayProperties.getBaseUrl()) + "/orders"))
                    .header("Authorization", buildBasicAuthHeader())
                    .header("Content-Type", "application/json")
                    .timeout(Duration.ofSeconds(20))
                    .POST(HttpRequest.BodyPublishers.ofString(objectMapper.writeValueAsString(payload)))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                throw new IllegalStateException("Razorpay order creation failed: " + response.body());
            }

            JsonNode orderNode = objectMapper.readTree(response.body());
            String orderId = textOrNull(orderNode.path("id"));
            if (orderId == null || orderId.isBlank()) {
                throw new IllegalStateException("Razorpay order id missing in response");
            }
            return orderId;
        } catch (IOException | InterruptedException ex) {
            Thread.currentThread().interrupt();
            throw new IllegalStateException("Unable to create Razorpay order", ex);
        }
    }

    private void applicationPaymentStatus(Integer applicationId, String paymentStatus) {
        if (applicationId == null) {
            return;
        }
        hackathonApplicationRepository.findById(applicationId).ifPresent(application -> {
            application.setPaymentStatus(paymentStatus);
            hackathonApplicationRepository.save(application);
        });
    }

    private int resolveEntryFee(HackathonEntity hackathon) {
        if (hackathon.getEntryFeeAmount() != null && hackathon.getEntryFeeAmount() > 0) {
            return hackathon.getEntryFeeAmount();
        }
        return (int) AppConstants.HACKATHON_ENTRY_FEE_AMOUNT;
    }

    private String buildReceipt(Integer applicationId, Integer transactionId) {
        return "app-" + applicationId + "-tx-" + transactionId + "-" + UUID.randomUUID().toString().substring(0, 8);
    }

    private String buildBasicAuthHeader() {
        String auth = gatewayProperties.getKeyId() + ":" + gatewayProperties.getKeySecret();
        return "Basic " + Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));
    }

    private String normalizeBaseUrl(String baseUrl) {
        if (baseUrl == null || baseUrl.isBlank()) {
            return "https://api.razorpay.com/v1";
        }
        return baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
    }

    private String calculateHmacHex(String message, String secret) {
        try {
            Mac mac = Mac.getInstance(HMAC_ALGORITHM);
            mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), HMAC_ALGORITHM));
            byte[] digest = mac.doFinal(message.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder();
            for (byte b : digest) {
                hex.append(String.format("%02x", b));
            }
            return hex.toString();
        } catch (Exception ex) {
            throw new IllegalStateException("Unable to calculate signature", ex);
        }
    }

    private boolean constantTimeEquals(String left, String right) {
        if (left == null || right == null) {
            return false;
        }
        return MessageDigest.isEqual(left.getBytes(StandardCharsets.UTF_8), right.getBytes(StandardCharsets.UTF_8));
    }

    private String textOrNull(JsonNode node) {
        if (node == null || node.isMissingNode() || node.isNull()) {
            return null;
        }
        String value = node.asText();
        return value == null || value.isBlank() ? null : value;
    }

    private String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value;
            }
        }
        return null;
    }
}