package com.grownited.util;

import com.grownited.common.AppConstants;
import com.grownited.entity.UserEntity;

import jakarta.servlet.http.HttpSession;

public final class SessionUserUtil {

    private SessionUserUtil() {
    }

    public static UserEntity getCurrentUser(HttpSession session) {
        if (session == null) {
            return null;
        }
        return (UserEntity) session.getAttribute(AppConstants.SESSION_USER);
    }

    public static String getNormalizedRole(UserEntity user) {
        if (user == null || user.getRole() == null) {
            return "";
        }
        return user.getRole().trim().toUpperCase();
    }
}
