<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Forgot Password | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260512c"></script>
<style>
.wrap{min-height:100vh;display:grid;place-items:center;padding:16px}
.card{width:min(480px,100%);padding:22px}
.card h1{font-size:clamp(30px,5vw,44px)}
.sub{margin-top:8px;color:#5e6673}
.field{margin-top:14px}
.field label{display:block;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;margin-bottom:6px}
.actions{margin-top:14px;display:grid;gap:8px}
.actions a{text-align:center}
</style>
</head>
<body>
<c:set var="toastMessage" value="${empty error ? success : error}" />
<c:set var="toastType" value="${empty error ? 'success' : 'error'}" />
<c:if test="${not empty toastMessage}">
  <div id="toast-data" data-type="${toastType}" style="display:none;"><c:out value="${toastMessage}" /></div>
</c:if>
<div class="wrap">
  <div class="neo-panel card" data-reveal>
    <div class="neo-badge">CodeVerse Account</div>
    <h1 class="neo-title">Forgot Password</h1>
    <p class="sub">Enter your registered email and we will process your reset request.</p>
    <form action="sendResetLink" method="post" autocomplete="on">
      <input type="hidden" name="_csrf" value="${_csrfToken}">
      <div class="field">
        <label for="email">Email Address</label>
        <input type="email" name="email" id="email" placeholder="Enter your registered email" autocomplete="email" autocapitalize="none" spellcheck="false" required>
      </div>
      <div class="actions">
        <button type="submit">Send Reset Link</button>
        <a class="btn" href="login">Back to Login</a>
      </div>
    </form>
  </div>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>

