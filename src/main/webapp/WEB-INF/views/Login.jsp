<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--bg:#08121a;--surface:#121f2b;--border:#2a4358;--text:#eaf2f9;--muted:#8ca5b9;--accent:#f97316;--accent2:#06b6d4}
body{font-family:'Syne',sans-serif;background:radial-gradient(circle at 12% 18%, rgba(6,182,212,.2), transparent 40%),radial-gradient(circle at 84% 82%, rgba(249,115,22,.2), transparent 42%),var(--bg);color:var(--text);min-height:100vh}
.layout{min-height:100vh;display:grid;grid-template-columns:1.1fr 1fr}
.visual{position:relative;overflow:hidden}
.visual::before{content:'';position:absolute;inset:0;background:linear-gradient(130deg,rgba(8,18,26,.2),rgba(8,18,26,.86)),url('<c:url value="/assets/images/auth/login-bg.jpg" />') center/cover no-repeat}
.visual-content{position:relative;z-index:1;height:100%;padding:48px;display:flex;flex-direction:column;justify-content:space-between}
.brand{font-family:'Space Mono',monospace;font-weight:700;letter-spacing:.06em;font-size:22px}
.hero h1{font-size:clamp(30px,4vw,54px);line-height:1.07;max-width:520px}
.hero p{margin-top:14px;max-width:500px;color:#d7e4ef;line-height:1.6}
.pill{display:inline-block;margin-top:20px;padding:8px 12px;border:1px solid rgba(255,255,255,.35);border-radius:999px;background:rgba(255,255,255,.1);font-size:12px}
.form-wrap{display:grid;place-items:center;padding:24px}
.card{width:min(460px,100%);background:rgba(18,31,43,.95);border:1px solid var(--border);border-radius:18px;padding:28px;box-shadow:0 18px 50px rgba(0,0,0,.28)}
.card h2{font-size:30px}
.card p{margin-top:8px;color:var(--muted)}
.field{margin-top:14px}
label{display:block;font-size:13px;color:var(--muted);margin-bottom:6px}
input{width:100%;padding:12px 13px;border-radius:11px;border:1px solid var(--border);background:#101a24;color:var(--text);font-size:14px}
input:focus{outline:none;border-color:var(--accent2);box-shadow:0 0 0 3px rgba(6,182,212,.18)}
input:-webkit-autofill,
input:-webkit-autofill:hover,
input:-webkit-autofill:focus,
input:-webkit-autofill:active{
  -webkit-box-shadow:0 0 0 1000px #101a24 inset !important;
  -webkit-text-fill-color:var(--text) !important;
  caret-color:var(--text);
  transition:background-color 9999s ease-in-out 0s;
}
.submit{margin-top:16px;width:100%;padding:12px;border:none;border-radius:11px;background:linear-gradient(135deg,var(--accent),var(--accent2));color:#fff;font-weight:800;cursor:pointer}
.row{margin-top:12px;display:flex;justify-content:space-between;gap:8px;align-items:center;flex-wrap:wrap}
.row a{color:#9ad8e3;text-decoration:none;font-weight:700}
@media(max-width:950px){.layout{grid-template-columns:1fr}.visual{min-height:260px}.visual-content{padding:28px}.hero h1{max-width:100%}}
</style>
</head>
<body>
<c:set var="toastMessage" value="${error}" />
<c:set var="toastType" value="error" />
<c:if test="${param.timeout == '1'}">
  <c:set var="toastMessage" value="Session expired due to inactivity. Please login again." />
  <c:set var="toastType" value="info" />
</c:if>
<c:if test="${not empty toastMessage}">
  <div id="toast-data" data-type="${toastType}" style="display:none;"><c:out value="${toastMessage}" /></div>
</c:if>
<div class="layout">
  <section class="visual">
    <div class="visual-content">
      <div class="brand">CODEVERSE</div>
      <div class="hero">
        <h1>Ship bold ideas into winning hacks.</h1>
        <p>Collaborate with teams, join curated hackathons, and move from concept to spotlight with a product-first platform.</p>
        <span class="pill">Builder Mode</span>
      </div>
    </div>
  </section>
  <section class="form-wrap">
    <div class="card">
      <h2>Welcome Back</h2>
      <p>Sign in to continue your CodeVerse journey.</p>
      <form action="authenticate" method="post" autocomplete="off">
        <input type="hidden" name="_csrf" value="${_csrfToken}">
        <input type="text" name="fake-user" style="display:none" autocomplete="off">
        <input type="password" name="fake-pass" style="display:none" autocomplete="new-password">
        <div class="field">
          <label>Email</label>
          <input type="email" name="email" placeholder="you@example.com" value="" autocomplete="off" autocapitalize="none" spellcheck="false" readonly onfocus="this.removeAttribute('readonly');" required>
        </div>
        <div class="field">
          <label>Password</label>
          <input type="password" name="password" placeholder="Enter password" value="" autocomplete="new-password" readonly onfocus="this.removeAttribute('readonly');" required>
        </div>
        <button class="submit" type="submit">Login</button>
        <div class="row">
          <a href="forgetpassword">Forgot password?</a>
          <span>New here? <a href="signup">Create account</a></span>
        </div>
      </form>
    </div>
  </section>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>