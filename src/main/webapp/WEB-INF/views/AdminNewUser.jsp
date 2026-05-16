<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create User | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260512c"></script>
<style>
.wrap{max-width:1080px;margin:24px auto;padding:0 16px}
.top{display:flex;justify-content:space-between;align-items:flex-end;gap:10px;flex-wrap:wrap;margin-bottom:12px}
.top h1{font-size:clamp(28px,4.6vw,44px)}
.actions{display:flex;gap:8px;flex-wrap:wrap}
.card{padding:22px}
.grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px}
.field{margin-top:2px}
.field.full{grid-column:1/-1}
.field label{display:block;font-size:12px;font-weight:700;letter-spacing:.06em;text-transform:uppercase;margin-bottom:6px}
.submit-row{margin-top:14px;display:flex;gap:8px;flex-wrap:wrap}
@media(max-width:860px){.grid{grid-template-columns:1fr}}
</style>
</head>
<body>
<c:if test="${not empty param.msg}">
  <div id="toast-data" data-type="${param.type == 'success' ? 'success' : 'error'}" style="display:none;"><c:out value="${param.msg}" /></div>
</c:if>
<div class="wrap">
  <div class="top">
    <div>
      <div class="neo-badge">Admin � Users</div>
      <h1 class="neo-title">Create User</h1>
    </div>
    <div class="actions">
      <a class="btn" href="<c:url value='/admin/user-list' />">Back to Users</a>
      <a class="btn" href="<c:url value='/admin-dashboard' />">Dashboard</a>
    </div>
  </div>

  <div class="neo-panel card" data-reveal>
    <form action="<c:url value='/admin/user/save' />" method="post" autocomplete="off">
      <input type="hidden" name="_csrf" value="${_csrfToken}">
      <!-- Honeypot / Dummy fields to trick browser autofill mechanisms (Professional Industry Standard) -->
      <input style="display:none" type="email" name="fakeusernameremembered" />
      <input style="display:none" type="password" name="fakepasswordremembered" />
      <div class="grid">
        <div class="field"><label>First Name</label><input type="text" name="firstName" autocomplete="new-password" required></div>
        <div class="field"><label>Last Name</label><input type="text" name="lastName" autocomplete="new-password" required></div>
        <div class="field"><label>Email</label><input type="email" name="email" autocomplete="new-password" required></div>
        <div class="field"><label>Password</label><input type="password" name="password" autocomplete="new-password" required></div>
        <div class="field">
          <label>Role</label>
          <select name="role" required autocomplete="new-password">
            <option value="PARTICIPANT">Participant</option>
            <option value="ORGANIZER">Organizer</option>
            <option value="JUDGE">Judge</option>
            <option value="ADMIN">Admin</option>
          </select>
        </div>
        <div class="field">
          <label>Gender</label>
          <select name="gender" autocomplete="new-password">
            <option value="">Select gender</option>
            <option value="MALE">Male</option>
            <option value="FEMALE">Female</option>
            <option value="OTHER">Other</option>
            <option value="PREFER_NOT_TO_SAY">Prefer not to say</option>
          </select>
        </div>
        <div class="field"><label>Birth Year</label><input type="number" name="birthYear" min="1900" max="2100" autocomplete="new-password"></div>
        <div class="field"><label>Contact Number</label><input type="text" name="contactNum" autocomplete="new-password"></div>
        <div class="field"><label>Qualification</label><input type="text" name="qualification" autocomplete="new-password"></div>
        <div class="field"><label>City</label><input type="text" name="city" autocomplete="new-password"></div>
        <div class="field"><label>State</label><input type="text" name="state" autocomplete="new-password"></div>
        <div class="field"><label>Country</label><input type="text" name="country" value="India" autocomplete="new-password"></div>
        <div class="field full url-field">
          <label>LinkedIn URL</label>
          <div class="url-input-group">
            <input type="url" name="linkedinUrl" placeholder="https://linkedin.com/in/username" autocomplete="new-password">
            <div class="url-actions">
              <button type="button" class="url-action-btn copy-url" title="Copy link"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 9h8a2 2 0 0 1 2 2v8"></path><rect x="5" y="5" width="10" height="10" rx="2"></rect><path d="M13 13l6-6"></path><path d="M14 7h5v5"></path></svg></button>
              <button type="button" class="url-action-btn open-url" title="Open link"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M14 5h5v5"></path><path d="M10 14L19 5"></path><path d="M19 13v6a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h6"></path></svg></button>
            </div>
          </div>
          <span class="url-feedback">Copied!</span>
        </div>
        <div class="field full">
          <label>Active</label>
          <select name="active" autocomplete="new-password">
            <option value="true" selected>Yes</option>
            <option value="false">No</option>
          </select>
        </div>
      </div>
      <div class="submit-row">
        <button type="submit">Create User</button>
      </div>
    </form>
  </div>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>

