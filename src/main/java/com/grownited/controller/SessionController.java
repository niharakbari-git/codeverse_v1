package com.grownited.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import com.grownited.common.AppConstants;
import com.grownited.entity.UserDetailEntity;
import com.grownited.entity.UserEntity;
import com.grownited.service.AuthService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class SessionController {

    @Autowired
    AuthService authService;

    @GetMapping("/signup")
    public String openSignupPage(Model model) {
        model.addAttribute("allUserType", authService.getAllUserTypesWithDefault());
        return "Signup";
    }

    @GetMapping("/login")
    public String openLoginPage() {
        return "Login";
    }

    @PostMapping("/authenticate")
    public String authenticate(String email, String password, Model model, HttpSession session, HttpServletRequest request) {
        AuthService.AuthResult authResult = authService.authenticate(email, password);
        if (!authResult.isAuthenticated()) {
            model.addAttribute("error", authResult.getErrorMessage());
            return "Login";
        }

        request.changeSessionId();
        HttpSession authenticatedSession = request.getSession(false);
        authenticatedSession.setAttribute(AppConstants.SESSION_USER, authResult.getUser());
        return authResult.getRedirectPath();
    }

    @GetMapping("/forgetpassword")
    public String openForgetPassword() {
        return "ForgetPassword";
    }

    @PostMapping("/sendResetLink")
    public String sendResetLink(String email, Model model) {
        String errorMessage = authService.requestPasswordReset(email);
        if (errorMessage != null) {
            model.addAttribute("error", errorMessage);
            return "ForgetPassword";
        }

        model.addAttribute("success", "Reset link request received. Please contact admin to reset your password.");
        return "ForgetPassword";
    }

    @PostMapping("/register")
    public String register(UserEntity userEntity, UserDetailEntity userDetailEntity, MultipartFile profilePic, Model model) {
        AuthService.RegistrationResult registrationResult = authService.registerParticipant(userEntity, userDetailEntity,
                profilePic);
        if (!registrationResult.isSuccessful()) {
            model.addAttribute("error", registrationResult.getErrorMessage());
            model.addAttribute("allUserType", authService.getAllUserTypesWithDefault());
            return "Signup";
        }

        return "Login";
    }

    @GetMapping("logout")
    public String logout(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        session.invalidate();

        Cookie cookie = new Cookie("JSESSIONID", "");
        String contextPath = request.getContextPath();
        cookie.setPath(contextPath == null || contextPath.isBlank() ? "/" : contextPath);
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        response.addCookie(cookie);

        return AppConstants.REDIRECT_LOGIN;
    }
}
