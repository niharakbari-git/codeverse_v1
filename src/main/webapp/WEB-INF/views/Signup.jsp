<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260415b">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260415b"></script>
<style>
.reg-shell{min-height:100vh;display:grid;grid-template-columns:320px 1fr;gap:12px;padding:16px}
.info{
  padding:20px;
  display:flex;
  flex-direction:column;
  gap:14px;
  background-image:
    
    url('${pageContext.request.contextPath}/assets/images/auth-hero.svg');
  background-size:135% auto;
  background-position:center 18%;
  background-repeat:no-repeat;
}
.info h1{font-size:clamp(36px,5vw,68px)}
.info ul{list-style:none;padding:0;margin:0;display:grid;gap:8px}
.info li{padding:8px 10px;border:1px solid #d5dde8;border-radius:12px;background:#fff}
.form-wrap{padding:20px}
.form-head h2{font-size:46px}
.grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px;margin-top:10px}
.field{display:flex;flex-direction:column;gap:6px}
.field.full{grid-column:1 / -1}
label{font-size:11px;font-weight:700;letter-spacing:.06em;text-transform:uppercase}
.gender{display:flex;gap:12px;flex-wrap:wrap}
.gender label{font-size:13px;text-transform:none;letter-spacing:0}
.actions{margin-top:14px;display:flex;justify-content:space-between;align-items:center;gap:8px;flex-wrap:wrap}
@media(max-width:1120px){.grid{grid-template-columns:1fr 1fr}}
@media(max-width:860px){.reg-shell{grid-template-columns:1fr}.grid{grid-template-columns:1fr}}
</style>
</head>
<body>
<c:if test="${not empty error}">
  <div id="toast-data" data-type="error" style="display:none;"><c:out value="${error}" /></div>
</c:if>
<div class="neo-shell reg-shell">
  <aside class="neo-panel info" data-reveal>
    <div class="neo-badge">New Creator Setup</div>
    <h1 class="neo-title">Create<br>Your<br>Identity</h1>
    <p class="neo-sub">Join CodeVerse and unlock hackathons, teams, and scoring systems in one account.</p>
    <ul>
      <li>Profile and contact details</li>
      <li>Academic and location data</li>
      <li>LinkedIn handle</li>
    </ul>
  </aside>
  <section class="neo-panel form-wrap" data-reveal>
    <div class="form-head">
      <h2 class="neo-title">Register</h2>
      <p class="neo-sub">All field names are preserved for backend compatibility.</p>
    </div>
    <form action="register" method="post" autocomplete="off">
      <input type="hidden" name="_csrf" value="${_csrfToken}">
      <!-- Honeypot / Dummy fields to trick browser autofill mechanisms -->
      <input style="display:none" type="email" name="fakeusernameremembered" />
      <input style="display:none" type="password" name="fakepasswordremembered" />
      <div class="grid">
        <!-- Personal Details -->
        <div class="field"><label>First Name*</label><input type="text" name="firstName" autocomplete="new-password" required></div>
        <div class="field"><label>Last Name*</label><input type="text" name="lastName" autocomplete="new-password" required></div>
        <div class="field" style="display: flex; flex-direction: column;">
          <label>Gender*</label>
          <div class="gender" style="display: flex; gap: 15px; flex: 1; align-items: center;">
            <label style="display: flex; align-items: center; gap: 5px; margin: 0; cursor: pointer;"><input type="radio" name="gender" value="MALE" required autocomplete="new-password" style="margin: 0;"> Male</label>
            <label style="display: flex; align-items: center; gap: 5px; margin: 0; cursor: pointer;"><input type="radio" name="gender" value="FEMALE" autocomplete="new-password" style="margin: 0;"> Female</label>
            <label style="display: flex; align-items: center; gap: 5px; margin: 0; cursor: pointer;"><input type="radio" name="gender" value="OTHER" autocomplete="new-password" style="margin: 0;"> Other</label>
          </div>
        </div>

        <!-- Account Details -->
        <div class="field"><label>Email*</label><input type="text" name="email" value="" autocomplete="new-password" autocapitalize="none" spellcheck="false" required></div>
        <div class="field"><label>Contact Number*</label><input type="text" name="contactNum" autocomplete="new-password" required></div>
        <div class="field"><label>Password*</label><input type="password" name="password" value="" autocomplete="new-password" required></div>

        <!-- Location -->
        <div class="field"><label>City*</label><input type="text" name="city" autocomplete="new-password" required></div>
        <div class="field"><label>State*</label><input type="text" name="state" autocomplete="new-password" required></div>
        <div class="field"><label>Country*</label><input type="text" name="country" value="India" autocomplete="new-password" required></div>

        <!-- Education & Professional -->
        <div class="field"><label>Birth Year*</label><input type="number" name="birthYear" min="1900" max="2100" autocomplete="new-password" required></div>
        <div class="field"><label>Qualification*</label><input type="text" name="qualification" placeholder="e.g. B.Tech, MCA" autocomplete="new-password" required></div>
        <div class="field"><label>LinkedIn URL</label><input type="text" name="linkedinUrl" placeholder="linkedin.com/in/username" autocomplete="new-password"></div>
      </div>
      <div style="margin-top: 2rem; display: flex; flex-direction: column; gap: 1rem; align-items: center;">
        <button type="submit" style="width: 100%; max-width: 400px; padding: 1rem; font-size: 1.1rem; font-weight: bold; border-radius: 8px;">Create Account</button>
        
        <div style="margin-top: 1rem; text-align: center; color: var(--neo-text-light);">
          <p style="margin-bottom: 0.5rem; font-size: 1rem;">Already registered? <a href="login" style="font-weight: 600; text-decoration: underline;">Login here</a></p>
          <p style="font-size: 0.95rem;">Want to organize your own hackathon? <a href="organizer-onboarding" style="font-weight: 500; text-decoration: underline;">Submit request</a></p>
        </div>
      </div>
    </form>
  </section>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>


