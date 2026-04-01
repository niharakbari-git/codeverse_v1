package com.grownited.filter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;

import org.springframework.stereotype.Component;

import com.grownited.entity.UserEntity;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class AuthFilter implements Filter {

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		
		String uri = req.getRequestURI().toString();

		ArrayList<String> publicUrl = new ArrayList<>();

		publicUrl.add("/login");
		publicUrl.add("/signup");
		publicUrl.add("/forget-password");
		publicUrl.add("/forgetpassword");
		publicUrl.add("/authenticate");
		publicUrl.add("/register");
		publicUrl.add("/sendResetLink");

		boolean isPublicEndpoint = publicUrl.stream().anyMatch(uri::endsWith);
		boolean isSignupOrRegister = uri.endsWith("/signup") || uri.endsWith("/register");

		HttpSession session = req.getSession(false);
		UserEntity user = session == null ? null : (UserEntity) session.getAttribute("user");
		String userRole = user == null || user.getRole() == null ? "" : user.getRole().trim().toUpperCase();

		if (isPublicEndpoint || uri.contains("assets")) {
			if (isSignupOrRegister && user != null && !"ADMIN".equals(userRole)) {
				res.sendRedirect("/participant/home");
				return;
			}
			// go ahead
			chain.doFilter(request, response);
		} else {
			System.out.println("AuthFilter ......" + new Date());
			System.out.println(uri);
			session = req.getSession(false);
			user = session == null ? null : (UserEntity) session.getAttribute("user");
			userRole = user == null || user.getRole() == null ? "" : user.getRole().trim().toUpperCase();
			if (user == null) {
				boolean isExpiredSession = req.getRequestedSessionId() != null && !req.isRequestedSessionIdValid();
				if (isExpiredSession) {
					res.sendRedirect("/login?timeout=1");
				} else {
					res.sendRedirect("/login");
				}
			} else {
				if (isGovernanceRoute(uri) && !"ADMIN".equals(userRole)) {
					res.sendRedirect("/participant/home");
					return;
				}

				if (isOrganizerRoute(uri) && !("ADMIN".equals(userRole) || "ORGANIZER".equals(userRole))) {
					res.sendRedirect("/participant/home");
					return;
				}

				if (isJudgeRoute(uri) && !("ADMIN".equals(userRole) || "JUDGE".equals(userRole))) {
					res.sendRedirect("/participant/home");
					return;
				}

				if (isParticipantRoute(uri) && "ADMIN".equals(userRole)) {
					chain.doFilter(request, response);
					return;
				}

				chain.doFilter(request, response);
			}

		}

		// login no
		// forgetpassword no
		// admin-dashboard yes

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

	private boolean isParticipantRoute(String uri) {
		return uri.contains("/participant/") || uri.endsWith("/charge");
	}
}
