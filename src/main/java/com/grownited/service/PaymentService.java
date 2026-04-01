package com.grownited.service;

import java.math.BigDecimal;
import java.math.RoundingMode;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import net.authorize.Environment;
import net.authorize.api.contract.v1.ANetApiResponse;
import net.authorize.api.contract.v1.CreateTransactionRequest;
import net.authorize.api.contract.v1.CreateTransactionResponse;
import net.authorize.api.contract.v1.CreditCardType;
import net.authorize.api.contract.v1.CustomerDataType;
import net.authorize.api.contract.v1.MerchantAuthenticationType;
import net.authorize.api.contract.v1.MessageTypeEnum;
import net.authorize.api.contract.v1.PaymentType;
import net.authorize.api.contract.v1.TransactionRequestType;
import net.authorize.api.contract.v1.TransactionResponse;
import net.authorize.api.contract.v1.TransactionTypeEnum;
import net.authorize.api.controller.CreateTransactionController;
import net.authorize.api.controller.base.ApiOperationBase;

@Service
public class PaymentService {

	private static final Logger logger = LoggerFactory.getLogger(PaymentService.class);

	
	 public static ANetApiResponse run(String apiLoginId, String transactionKey, Double amount) {

	        // Set the request to operate in either the sandbox or production environment
	        ApiOperationBase.setEnvironment(Environment.SANDBOX);

	        // Create object with merchant authentication details
	        MerchantAuthenticationType merchantAuthenticationType  = new MerchantAuthenticationType() ;
	        merchantAuthenticationType.setName(apiLoginId);
	        merchantAuthenticationType.setTransactionKey(transactionKey);

	        // Populate the payment data
	        PaymentType paymentType = new PaymentType();
	        CreditCardType creditCard = new CreditCardType();
	        creditCard.setCardNumber("4242424242424242");
	        creditCard.setExpirationDate("0835");
	        paymentType.setCreditCard(creditCard);

	        // Set email address (optional)
	        CustomerDataType customer = new CustomerDataType();
	        customer.setEmail("test@test.test");

	        // Create the payment transaction object
	        TransactionRequestType txnRequest = new TransactionRequestType();
	        txnRequest.setTransactionType(TransactionTypeEnum.AUTH_CAPTURE_TRANSACTION.value());
	        txnRequest.setPayment(paymentType);
	        txnRequest.setCustomer(customer);
	        txnRequest.setAmount(new BigDecimal(amount).setScale(2, RoundingMode.CEILING));

	        // Create the API request and set the parameters for this specific request
	        CreateTransactionRequest apiRequest = new CreateTransactionRequest();
	        apiRequest.setMerchantAuthentication(merchantAuthenticationType);
	        apiRequest.setTransactionRequest(txnRequest);

	        // Call the controller
	        CreateTransactionController controller = new CreateTransactionController(apiRequest);
	        controller.execute();

	        // Get the response
	        CreateTransactionResponse response = new CreateTransactionResponse();
	        response = controller.getApiResponse();
	        
	        // Parse the response to determine results
	        if (response!=null) {
	            // If API Response is OK, go ahead and check the transaction response
	            if (response.getMessages().getResultCode() == MessageTypeEnum.OK) {
	                TransactionResponse result = response.getTransactionResponse();
	                if (result.getMessages() != null) {
	                    logger.info("Transaction success: id={}, responseCode={}, authCode={}",
	                            result.getTransId(), result.getResponseCode(), result.getAuthCode());
	                } else {
	                    logger.warn("Transaction failed without success messages.");
	                    if (response.getTransactionResponse().getErrors() != null) {
	                        logger.error("Gateway error {}: {}",
	                                response.getTransactionResponse().getErrors().getError().get(0).getErrorCode(),
	                                response.getTransactionResponse().getErrors().getError().get(0).getErrorText());
	                    }
	                }
	            } else {
	                logger.warn("Transaction failed at API result level.");
	                if (response.getTransactionResponse() != null && response.getTransactionResponse().getErrors() != null) {
	                    logger.error("Gateway error {}: {}",
	                            response.getTransactionResponse().getErrors().getError().get(0).getErrorCode(),
	                            response.getTransactionResponse().getErrors().getError().get(0).getErrorText());
	                } else {
	                    logger.error("API message {}: {}",
	                            response.getMessages().getMessage().get(0).getCode(),
	                            response.getMessages().getMessage().get(0).getText());
	                }
	            }
	        } else {
	            // Display the error code and message when response is null 
	            ANetApiResponse errorResponse = controller.getErrorResponse();
	            logger.error("Failed to get gateway response.");
	            if (!errorResponse.getMessages().getMessage().isEmpty()) {
	                logger.error("Gateway error {}: {}",
	                        errorResponse.getMessages().getMessage().get(0).getCode(),
	                        errorResponse.getMessages().getMessage().get(0).getText());
	            }
	        }
	        
	        return response;
	    }
	

}
