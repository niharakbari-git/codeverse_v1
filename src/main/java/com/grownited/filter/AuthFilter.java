package com.grownited.filter;

import java.io.IOException;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import com.grownited.common.AppConstants;
import com.grownited.entity.UserEntity;
import com.grownited.util.SessionUserUtil;

import org.springframework.beans.factory.annotation.Autowired;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
@Order(2)
public class AuthFilter implements Filter {

	private static final Logger logger = LoggerFactory.getLogger(AuthFilter.class);

	private static final Set<String> PUBLIC_ENDPOINTS = Set.of(
			"/login",
			"/signup",
			"/forget-password",
			"/forgetpassword",
			"/authenticate",
			"/register",
			"/sendResetLink");

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;

		String uri = req.getRequestURI().toString();

		boolean isPublicEndpoint = PUBLIC_ENDPOINTS.stream().anyMatch(uri::endsWith);
		boolean isAuthPage = uri.endsWith("/login") || uri.endsWith("/signup") || uri.endsWith("/register") || uri.endsWith("/authenticate");

		HttpSession session = req.getSession(false);
		UserEntity user = SessionUserUtil.getCurrentUser(session);
		String userRole = SessionUserUtil.getNormalizedRole(user);

		if (isPublicEndpoint || uri.contains("assets")) {
			if (isAuthPage && user != null) {
				if (AppConstants.ROLE_ADMIN.equals(userRole)) {
					res.sendRedirect("/admin-dashboard");
				} else if (AppConstants.ROLE_ORGANIZER.equals(userRole)) {
					res.sendRedirect("/organizer-dashboard");
				} else if (AppConstants.ROLE_JUDGE.equals(userRole)) {
					res.sendRedirect("/judge-dashboard");
				} else {
					res.sendRedirect(AppConstants.PARTICIPANT_HOME_PATH);
				}
				return;
			}
			chain.doFilter(request, response);
		} else {
			logger.debug("AuthFilter intercepted URI: {}", uri);
			session = req.getSession(false);
			user = SessionUserUtil.getCurrentUser(session);
			userRole = SessionUserUtil.getNormalizedRole(user);
			if (user == null) {
				boolean isExpiredSession = req.getRequestedSessionId() != null && !req.isRequestedSessionIdValid();
				if (isExpiredSession) {
					res.sendRedirect("/login?timeout=1");
				} else {
					res.sendRedirect("/login");
				}
			} else {
				if (isGovernanceRoute(uri) && !AppConstants.ROLE_ADMIN.equals(userRole)) {
					res.sendRedirect(AppConstants.PARTICIPANT_HOME_PATH);
					return;
				}

				if (isOrganizerRoute(uri)
						&& !(AppConstants.ROLE_ADMIN.equals(userRole) || AppConstants.ROLE_ORGANIZER.equals(userRole))) {
					res.sendRedirect(AppConstants.PARTICIPANT_HOME_PATH);
					return;
				}

				if (isJudgeRoute(uri)
						&& !(AppConstants.ROLE_ADMIN.equals(userRole) || AppConstants.ROLE_JUDGE.equals(userRole))) {
					res.sendRedirect(AppConstants.PARTICIPANT_HOME_PATH);
					return;
				}

				if (isParticipantStrictRoute(uri) && !AppConstants.ROLE_PARTICIPANT.equals(userRole)) {
					res.sendRedirect(AppConstants.PARTICIPANT_HOME_PATH);
					return;
				}

				chain.doFilter(request, response);
			}

		}

	}

	private boolean isGovernanceRoute(String uri) {
		return uri.endsWith("/admin-dashboard") || uri.endsWith("/newCategory") || uri.endsWith("/saveCategory")
				|| uri.endsWith("/listCategory") || uri.endsWith("/editCategory") || uri.endsWith("/deleteCategory")
				|| uri.endsWith("/listUser") || uri.endsWith("/viewUser")
				|| uri.endsWith("/editUser") || uri.endsWith("/updateUser") || uri.endsWith("/deleteUser")
				|| uri.endsWith("/newUserType") || uri.endsWith("/saveUserType");
	}

	private boolean isOrganizerRoute(String uri) {
		return uri.contains("/organizer/") || uri.endsWith("/organizer-dashboard") || uri.endsWith("/newHackathon") || uri.endsWith("/saveHackathon")
				|| uri.endsWith("/listHackathon") || uri.endsWith("/editHackathon") || uri.endsWith("/viewHackathon")
				|| uri.endsWith("/deleteHackathon");
	}

	private boolean isJudgeRoute(String uri) {
		return uri.endsWith("/judge-dashboard") || uri.contains("/judge/");
	}

	private boolean isParticipantStrictRoute(String uri) {
		// Everyone can visit /participant/home, /participant/hackathon/* (details)
		if (uri.endsWith("/participant/home") || uri.contains("/participant/hackathon/")) {
			return false;
		}
		// Participant-only actions
		return uri.contains("/participant/") || uri.endsWith("/charge");
	}
}
