package com.grownited.exception;

import java.util.UUID;

import org.springframework.dao.DataIntegrityViolationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(IllegalArgumentException.class)
    public String handleIllegalArgument(IllegalArgumentException ex, Model model) {
        String correlationId = UUID.randomUUID().toString();
        logger.warn("Validation failure [{}]: {}", correlationId, ex.getMessage());
        model.addAttribute("errorMessage", ex.getMessage());
        model.addAttribute("correlationId", correlationId);
        return "Error";
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public String handleDataIntegrity(DataIntegrityViolationException ex, Model model) {
        String correlationId = UUID.randomUUID().toString();
        logger.warn("Data integrity violation [{}]", correlationId, ex);
        model.addAttribute("errorMessage", "Unable to save your changes because the data is invalid.");
        model.addAttribute("correlationId", correlationId);
        return "Error";
    }

    @ExceptionHandler(Exception.class)
    public String handleGenericException(Exception ex, Model model) {
        String correlationId = UUID.randomUUID().toString();
        logger.error("Unexpected server error [{}]", correlationId, ex);
        model.addAttribute("errorMessage", "Unexpected error occurred. Please try again.");
        model.addAttribute("correlationId", correlationId);
        return "Error";
    }
}
