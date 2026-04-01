package com.grownited.common;

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

    public static final String REDIRECT_LOGIN = "redirect:/login";
    public static final String PARTICIPANT_HOME_PATH = "/participant/home";
    public static final String REDIRECT_PARTICIPANT_HOME = "redirect:/participant/home";
}
