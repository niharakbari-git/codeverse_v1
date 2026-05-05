package com.grownited.common;

import java.util.Set;

public final class AppConstants {

    private AppConstants() {
    }

    public static final String SESSION_USER = "user";
    public static final String CSRF_SESSION_KEY = "csrfToken";
    public static final String CSRF_REQUEST_KEY = "_csrfToken";
    public static final String CSRF_FORM_FIELD = "_csrf";
    public static final String CSRF_HEADER_NAME = "X-CSRF-TOKEN";

    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_ORGANIZER = "ORGANIZER";
    public static final String ROLE_PARTICIPANT = "PARTICIPANT";
    public static final String ROLE_JUDGE = "JUDGE";

        public static final Set<String> ALLOWED_ROLES = Set.of(
            ROLE_ADMIN,
            ROLE_ORGANIZER,
            ROLE_PARTICIPANT,
            ROLE_JUDGE);

    public static final String REDIRECT_LOGIN = "redirect:/login";
    public static final String PARTICIPANT_HOME_PATH = "/participant/home";
    public static final String REDIRECT_PARTICIPANT_HOME = "redirect:/participant/home";
    public static final double HACKATHON_ENTRY_FEE_AMOUNT = 199.00;
    public static final String HACKATHON_SCOPE_CAMPUS_ONLY = "CAMPUS_ONLY";
    public static final String HACKATHON_SCOPE_OPEN_TO_ALL = "OPEN_TO_ALL";

    public static String normalizeRole(String role) {
        return role == null ? "" : role.trim().toUpperCase();
    }

    public static boolean isAllowedRole(String role) {
        return ALLOWED_ROLES.contains(normalizeRole(role));
    }
}
