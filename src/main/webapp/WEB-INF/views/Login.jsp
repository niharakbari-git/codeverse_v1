<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260512c"></script>
<style>
.auth-root{min-height:100vh;display:grid;grid-template-columns:1.1fr .9fr;gap:12px;padding:16px}
.hero{
  padding:22px;
  display:flex;
  flex-direction:column;
  justify-content:space-between;
  background-image:
    
    url('${pageContext.request.contextPath}/assets/images/auth-hero.svg');
  background-size:135% auto;
  background-position:center 18%;
  background-repeat:no-repeat;
}
.hero h1{font-size:clamp(44px,7vw,92px)}
.hero p{max-width:46ch;line-height:1.65}
.ribbon{display:flex;gap:8px;flex-wrap:wrap}
.ribbon span{padding:6px 10px;border:1px solid #d5dde8;border-radius:999px;background:#fff}
.form-card{padding:22px;display:grid;align-content:center}
.card{padding:22px;max-width:430px;margin:0 auto;width:100%}
.card h2{font-size:36px}
.field{margin-top:12px}
.field label{display:block;font-weight:700;font-size:12px;text-transform:uppercase;letter-spacing:.06em;margin-bottom:6px}
.field input{height:44px}
.submit{margin-top:14px;width:100%;height:46px;font-size:15px;font-weight:700}
.link-row{margin-top:10px;display:flex;justify-content:space-between;gap:8px;flex-wrap:wrap;font-size:13px}
@media(max-width:980px){.auth-root{grid-template-columns:1fr}.hero{order:2}.form-card{order:1}}
</style>
</head>
<body>
<c:set var="toastMessage" value="${empty success ? error : success}" />
<c:set var="toastType" value="${empty success ? 'error' : 'success'}" />
<c:if test="${param.timeout == '1'}">
  <c:set var="toastMessage" value="Session expired due to inactivity. Please login again." />
  <c:set var="toastType" value="info" />
</c:if>
<c:if test="${not empty toastMessage}">
  <div id="toast-data" data-type="${toastType}" style="display:none;"><c:out value="${toastMessage}" /></div>
</c:if>
<c:if test="${param.timeout == '1'}">
  <script>
    (function () {
      if (!window.history || !window.history.replaceState) return;
      var url = new URL(window.location.href);
      url.searchParams.delete('timeout');
      var query = url.searchParams.toString();
      window.history.replaceState({}, document.title, url.pathname + (query ? ('?' + query) : ''));
    })();
  </script>
</c:if>
<div class="auth-root neo-shell">
  <section class="neo-panel hero" data-reveal>
    <div>
      <div class="neo-badge">CodeVerse Platform</div>
      <h1 class="neo-title">Make.<br>Compete.<br>Win.</h1>
      <p class="neo-sub">One powerful workspace for participants, judges, organizers, and admins. Start your session to continue operations.</p>
    </div>
    <div class="ribbon">
      <span>Event Control</span>
      <span>Team Management</span>
      <span>Live Scoring</span>
    </div>
  </section>
  <section class="neo-panel form-card" data-reveal>
    <form class="card" action="authenticate" method="post" autocomplete="off">
      <h2 class="neo-title">Login</h2>
      <p class="neo-sub">Use your CodeVerse credentials.</p>
      <input type="hidden" name="_csrf" value="${_csrfToken}">
      <!-- Honeypot / Dummy fields to trick browser autofill mechanisms -->
      <input style="display:none" type="email" name="fakeusernameremembered" />
      <input style="display:none" type="password" name="fakepasswordremembered" />
      <div class="field">
        <label for="email">Email</label>
        <input type="email" id="email" name="email" placeholder="you@example.com" autocomplete="new-password" autocapitalize="none" spellcheck="false" required>
      </div>
      <div class="field">
        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="Enter password" autocomplete="new-password" required>
      </div>
      <button class="submit" type="submit">Enter Workspace</button>
      <div class="link-row">
        <a href="forgetpassword">Forgot password?</a>
        <span>New here? <a href="signup">Create account</a></span>
        <span>Want to host events? <a href="organizer-onboarding">Request organizer access</a></span>
      </div>
    </form>
  </section>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>


