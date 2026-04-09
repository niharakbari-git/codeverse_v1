<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create User</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--bg:#0a0a0f;--surface:#13131a;--border:#2a2a3d;--text:#e2e8f0;--muted:#64748b;--accent:#7c3aed;--accent2:#06b6d4}
body{font-family:'Syne',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}
.wrap{max-width:980px;margin:0 auto;padding:26px 16px 38px}
.top{display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap;margin-bottom:16px}
.btn{text-decoration:none;border:1px solid var(--border);background:var(--surface);color:var(--text);padding:8px 12px;border-radius:10px;font-size:13px;font-weight:700}
.card{background:var(--surface);border:1px solid var(--border);border-radius:14px;padding:18px}
.grid{display:grid;grid-template-columns:repeat(2,minmax(240px,1fr));gap:12px}
.field{display:flex;flex-direction:column;gap:6px}
.field.full{grid-column:1 / -1}
label{font-size:12px;color:var(--muted)}
input,select{width:100%;padding:11px 12px;border-radius:10px;border:1px solid var(--border);background:#10101a;color:var(--text)}
input:focus,select:focus{outline:none;border-color:var(--accent2);box-shadow:0 0 0 3px rgba(6,182,212,.16)}
.submit{margin-top:14px;padding:11px 16px;border:none;border-radius:10px;background:linear-gradient(135deg,var(--accent),var(--accent2));color:#fff;font-weight:700;cursor:pointer}
@media(max-width:760px){.grid{grid-template-columns:1fr}}
</style>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260409a">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260409a"></script>
</head>
<body>
<c:if test="${not empty param.msg}">
  <div id="toast-data" data-type="${param.type == 'success' ? 'success' : 'error'}" style="display:none;"><c:out value="${param.msg}" /></div>
</c:if>
<div class="wrap">
  <div class="top">
    <h2>Create User</h2>
    <div>
      <a class="btn" href="<c:url value='/listUser' />">Back to Users</a>
      <a class="btn" href="<c:url value='/admin-dashboard' />">Dashboard</a>
    </div>
  </div>

  <div class="card">
    <form action="<c:url value='/admin/user/save' />" method="post" autocomplete="off">
      <input type="hidden" name="_csrf" value="${_csrfToken}">
      <div class="grid">
        <div class="field">
          <label>First Name</label>
          <input type="text" name="firstName" required>
        </div>
        <div class="field">
          <label>Last Name</label>
          <input type="text" name="lastName" required>
        </div>
        <div class="field">
          <label>Email</label>
          <input type="email" name="email" required>
        </div>
        <div class="field">
          <label>Password</label>
          <input type="password" name="password" required>
        </div>
        <div class="field">
          <label>Role</label>
          <select name="role" required>
            <option value="PARTICIPANT">Participant</option>
            <option value="ORGANIZER">Organizer</option>
            <option value="JUDGE">Judge</option>
            <option value="ADMIN">Admin</option>
          </select>
        </div>
        <div class="field">
          <label>Gender</label>
          <select name="gender">
            <option value="">Select</option>
            <option value="MALE">Male</option>
            <option value="FEMALE">Female</option>
            <option value="OTHER">Other</option>
          </select>
        </div>
        <div class="field">
          <label>Birth Year</label>
          <input type="number" name="birthYear" min="1900" max="2100">
        </div>
        <div class="field">
          <label>Contact Number</label>
          <input type="text" name="contactNum">
        </div>

        <div class="field">
          <label>Qualification</label>
          <input type="text" name="qualification">
        </div>
        <div class="field">
          <label>City</label>
          <input type="text" name="city">
        </div>
        <div class="field">
          <label>State</label>
          <input type="text" name="state">
        </div>
        <div class="field">
          <label>Country</label>
          <input type="text" name="country" value="India">
        </div>
        <div class="field">
          <label>LinkedIn URL</label>
          <input type="url" name="linkedinUrl" placeholder="https://linkedin.com/in/username">
        </div>

        <div class="field full">
          <label>Active</label>
          <select name="active">
            <option value="true" selected>Yes</option>
            <option value="false">No</option>
          </select>
        </div>
      </div>
      <button class="submit" type="submit">Create User</button>
    </form>
  </div>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>
