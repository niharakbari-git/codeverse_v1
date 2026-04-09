package com.grownited.filter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import com.grownited.common.AppConstants;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
@Order(1)
public class CsrfFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(CsrfFilter.class);
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();
    private static final Set<String> STATE_CHANGING_METHODS = Set.of("POST", "PUT", "PATCH", "DELETE");

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        if (isStaticResource(req) || isBypassedRoute(req)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(true);
        String sessionToken = (String) session.getAttribute(AppConstants.CSRF_SESSION_KEY);
        if (sessionToken == null || sessionToken.isBlank()) {
            sessionToken = generateToken();
            session.setAttribute(AppConstants.CSRF_SESSION_KEY, sessionToken);
        }

        req.setAttribute(AppConstants.CSRF_REQUEST_KEY, sessionToken);

        if (STATE_CHANGING_METHODS.contains(req.getMethod().toUpperCase())) {
            String providedToken = extractProvidedToken(req);

            if (!isTokenValid(sessionToken, providedToken)) {
                logger.warn("Blocked request with invalid CSRF token. method={}, uri={}", req.getMethod(), req.getRequestURI());
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private boolean isStaticResource(HttpServletRequest req) {
        String uri = req.getRequestURI();
        return uri.contains("/assets/") || uri.contains("/webjars/") || uri.endsWith(".css") || uri.endsWith(".js")
                || uri.endsWith(".png") || uri.endsWith(".jpg") || uri.endsWith(".jpeg") || uri.endsWith(".gif")
                || uri.endsWith(".svg") || uri.endsWith(".woff") || uri.endsWith(".woff2") || uri.endsWith(".ttf");
    }

    private boolean isBypassedRoute(HttpServletRequest req) {
        String method = req.getMethod();
        String uri = req.getRequestURI();
        return "OPTIONS".equalsIgnoreCase(method) || uri.endsWith("/error") || uri.endsWith("/favicon.ico");
    }

    private String extractProvidedToken(HttpServletRequest req) throws IOException, ServletException {
        String providedToken = req.getParameter(AppConstants.CSRF_FORM_FIELD);
        if (providedToken != null && !providedToken.isBlank()) {
            return providedToken;
        }

        providedToken = req.getHeader(AppConstants.CSRF_HEADER_NAME);
        if (providedToken != null && !providedToken.isBlank()) {
            return providedToken;
        }

        String contentType = req.getContentType();
        if (contentType != null && contentType.toLowerCase().startsWith("multipart/")) {
            for (Part part : req.getParts()) {
                if (AppConstants.CSRF_FORM_FIELD.equals(part.getName())) {
                    byte[] bytes = part.getInputStream().readAllBytes();
                    return new String(bytes, StandardCharsets.UTF_8).trim();
                }
            }
        }

        return null;
    }

    private String generateToken() {
        byte[] tokenBytes = new byte[32];
        SECURE_RANDOM.nextBytes(tokenBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
    }

    private boolean isTokenValid(String expectedToken, String providedToken) {
        if (expectedToken == null || providedToken == null) {
            return false;
        }
        byte[] expected = expectedToken.getBytes(StandardCharsets.UTF_8);
        byte[] provided = providedToken.getBytes(StandardCharsets.UTF_8);
        return MessageDigest.isEqual(expected, provided);
    }
}