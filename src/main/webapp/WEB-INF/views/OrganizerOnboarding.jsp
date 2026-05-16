<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Organizer Onboarding | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260512c"></script>
<style>
.page{max-width:1080px;margin:24px auto;padding:0 16px;display:grid;gap:12px}
.hero{padding:16px;background:#1f2937;color:#fff}
.hero .neo-badge{background:#fff;color:#1f2937;border:none}
.hero h1{font-size:clamp(30px,5vw,56px)}
.hero p{margin-top:8px;color:#ecfffb}
.form{padding:16px}
.grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px}
.field{display:flex;flex-direction:column;gap:6px}
.field.full{grid-column:1/-1}
.field label{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.06em}
.actions{margin-top:12px;display:flex;justify-content:space-between;gap:10px;flex-wrap:wrap;align-items:center}
@media(max-width:860px){.grid{grid-template-columns:1fr}}
</style>
</head>
<body>
<c:set var="toastMessage" value="${empty success ? error : success}" />
<c:set var="toastType" value="${empty success ? 'error' : 'success'}" />
<c:if test="${not empty toastMessage}">
  <div id="toast-data" data-type="${toastType}" style="display:none;"><c:out value="${toastMessage}" /></div>
</c:if>

<div class="neo-shell page">
  <section class="neo-panel hero" data-reveal>
    <div class="neo-badge">Organizer Access Request</div>
    <h1 class="neo-title">Host Hackathons On CodeVerse</h1>
    <p>Submit your organizer profile. Admin reviews every request before account activation.</p>
  </section>

  <section class="neo-panel form" data-reveal>
    <form action="<c:url value='/organizer-onboarding/request' />" method="post" autocomplete="off">
      <input type="hidden" name="_csrf" value="${_csrfToken}">
      <!-- Honeypot / Dummy fields to trick browser autofill mechanisms (Professional Industry Standard) -->
      <input style="display:none" type="email" name="fakeusernameremembered" />
      <input style="display:none" type="password" name="fakepasswordremembered" />
      <div class="grid">
        <div class="field"><label>First Name*</label><input type="text" name="firstName" value="${onboardingRequest.firstName}" autocomplete="new-password" required></div>
        <div class="field"><label>Last Name*</label><input type="text" name="lastName" value="${onboardingRequest.lastName}" autocomplete="new-password" required></div>
        <div class="field"><label>Email*</label><input type="text" name="email" value="${onboardingRequest.email}" autocomplete="new-password" required></div>
        <div class="field"><label>Password*</label><input type="password" id="password" name="password" minlength="6" autocomplete="new-password" required></div>
        <div class="field"><label>Contact Number*</label><input type="text" name="contactNum" value="${onboardingRequest.contactNum}" autocomplete="new-password" required></div>
        <div class="field"><label>Organization Name*</label><input type="text" name="organizationName" value="${onboardingRequest.organizationName}" autocomplete="new-password" required></div>
        <div class="field"><label>City*</label><input type="text" name="city" value="${onboardingRequest.city}" autocomplete="new-password" required></div>
        <div class="field"><label>State*</label><input type="text" name="state" value="${onboardingRequest.state}" autocomplete="new-password" required></div>
        <div class="field"><label>Country*</label><input type="text" name="country" value="${empty onboardingRequest.country ? 'India' : onboardingRequest.country}" autocomplete="new-password" required></div>
        <div class="field url-field"><label>Website URL*</label><div class="url-input-group"><input type="text" name="websiteUrl" value="${onboardingRequest.websiteUrl}" placeholder="www.example.com" autocomplete="new-password" required><div class="url-actions"><button type="button" class="url-action-btn copy-url" title="Copy link"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 9h8a2 2 0 0 1 2 2v8"></path><rect x="5" y="5" width="10" height="10" rx="2"></rect><path d="M13 13l6-6"></path><path d="M14 7h5v5"></path></svg></button><button type="button" class="url-action-btn open-url" title="Open link"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M14 5h5v5"></path><path d="M10 14L19 5"></path><path d="M19 13v6a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h6"></path></svg></button></div></div><span class="url-feedback">Copied!</span></div>
        <div class="field full url-field"><label>LinkedIn URL</label><div class="url-input-group"><input type="text" name="linkedinUrl" value="${onboardingRequest.linkedinUrl}" placeholder="www.linkedin.com/in/username" autocomplete="new-password"><div class="url-actions"><button type="button" class="url-action-btn copy-url" title="Copy link"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 9h8a2 2 0 0 1 2 2v8"></path><rect x="5" y="5" width="10" height="10" rx="2"></rect><path d="M13 13l6-6"></path><path d="M14 7h5v5"></path></svg></button><button type="button" class="url-action-btn open-url" title="Open link"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M14 5h5v5"></path><path d="M10 14L19 5"></path><path d="M19 13v6a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h6"></path></svg></button></div></div><span class="url-feedback">Copied!</span></div>
        <div class="field full"><label>Event Experience</label><textarea name="eventExperience" rows="4" placeholder="Share hackathon/event operations experience" autocomplete="new-password">${onboardingRequest.eventExperience}</textarea></div>
      </div>

      <div class="actions">
        <button type="submit">Submit Organizer Request</button>
        <span>Already approved? <a href="<c:url value='/login' />">Login</a></span>
      </div>
    </form>
  </section>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>
