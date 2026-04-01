<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View User</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--bg:#0a0f16;--surface:#131c27;--surface2:#1c2734;--border:#2a3d52;--text:#e2e8f0;--muted:#8ca0b3;--accent:#f97316;--accent2:#06b6d4}
body{font-family:'Syne',sans-serif;background:radial-gradient(circle at 12% 16%,rgba(6,182,212,.14),transparent 35%),radial-gradient(circle at 85% 82%,rgba(249,115,22,.14),transparent 40%),var(--bg);color:var(--text);min-height:100vh}
.wrap{max-width:900px;margin:28px auto;padding:0 18px 28px}
.top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:14px}
h1{font-size:clamp(24px,4vw,36px);font-weight:800;letter-spacing:-.6px}
h1 span{background:linear-gradient(135deg,var(--accent),var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.actions{display:flex;gap:8px;flex-wrap:wrap}
.btn{display:inline-block;text-decoration:none;padding:9px 12px;border:1px solid var(--border);border-radius:10px;background:var(--surface);color:var(--text);font-weight:700;font-size:13px;cursor:pointer;transition:all .2s}
.btn:hover{border-color:var(--accent2);box-shadow:0 4px 12px rgba(6,182,212,.12)}
.btn.primary{border:none;background:linear-gradient(135deg,var(--accent),var(--accent2));box-shadow:0 10px 24px rgba(6,182,212,.16)}
.btn.primary:hover{transform:translateY(-2px);box-shadow:0 14px 28px rgba(6,182,212,.2)}
.btn.danger{border-color:#dc2626;color:#fecaca}
.btn.danger:hover{background:rgba(220,38,38,.1)}
.card{border:1px solid var(--border);border-radius:14px;background:var(--surface);padding:20px}
.profile-section{display:flex;gap:24px;margin-bottom:28px;padding-bottom:20px;border-bottom:1px solid var(--border)}
.profile-pic{width:140px;height:140px;border-radius:12px;object-fit:cover;border:2px solid var(--border);flex-shrink:0}
.profile-info{flex:1;display:flex;flex-direction:column;justify-content:center}
.profile-name{font-size:22px;font-weight:700;margin-bottom:8px}
.profile-meta{display:flex;gap:12px;flex-wrap:wrap}
.badge{display:inline-block;padding:4px 10px;border-radius:6px;font-size:12px;font-weight:600;width:fit-content}
.badge.active{background:rgba(34,197,94,.15);color:#86efac}
.badge.inactive{background:rgba(220,38,38,.15);color:#fecaca}
.badge.role{background:rgba(59,130,246,.15);color:#93c5fd}
.field-group{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:20px;margin-bottom:20px}
.field{display:flex;flex-direction:column}
.field-label{font-size:12px;color:var(--muted);margin-bottom:8px;text-transform:uppercase;letter-spacing:.5px;font-weight:700}
.field-value{font-size:15px;color:var(--text);line-height:1.5;word-break:break-word}
.footer{margin-top:20px;display:flex;justify-content:flex-end;gap:8px;flex-wrap:wrap;padding-top:16px;border-top:1px solid var(--border)}
</style>
</head>

<body>
<div class="wrap">
  <div class="top">
    <h1><span>User</span> Details</h1>
    <div class="actions">
      <a class="btn" href="<c:url value='/listUser' />">Back</a>
    </div>
  </div>

  <div class="card">
    <!-- Profile Section -->
    <div class="profile-section">
      <c:choose>
        <c:when test="${not empty user.profilePicURL}">
          <img src="${user.profilePicURL}" class="profile-pic" alt="${user.firstName} ${user.lastName}">
        </c:when>
        <c:otherwise>
          <img src="https://via.placeholder.com/140" class="profile-pic" alt="Profile">
        </c:otherwise>
      </c:choose>
      <div class="profile-info">
        <div class="profile-name">${user.firstName} ${user.lastName}</div>
        <div class="profile-meta">
          <span class="badge role">${user.role}</span>
          <c:choose>
            <c:when test="${user.active}">
              <span class="badge active">Active</span>
            </c:when>
            <c:otherwise>
              <span class="badge inactive">Inactive</span>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <!-- Details Grid -->
    <div class="field-group">
      <div class="field">
        <div class="field-label">User ID</div>
        <div class="field-value">#${user.userId}</div>
      </div>
      <div class="field">
        <div class="field-label">Email</div>
        <div class="field-value">${user.email}</div>
      </div>
      <div class="field">
        <div class="field-label">Gender</div>
        <div class="field-value">${user.gender}</div>
      </div>
      <div class="field">
        <div class="field-label">Birth Year</div>
        <div class="field-value">${user.birthYear}</div>
      </div>
      <div class="field">
        <div class="field-label">Contact Number</div>
        <div class="field-value">${user.contactNum}</div>
      </div>
      <div class="field">
        <div class="field-label">Member Since</div>
        <div class="field-value">
            <fmt:parseDate value="${user.createdAt}" pattern="yyyy-MM-dd" var="parsedCreatedAt" type="date" />
            <fmt:formatDate value="${parsedCreatedAt}" pattern="dd/MM/yyyy" />
        </div>
      </div>
      <div class="field">
        <div class="field-label">Country</div>
        <div class="field-value">${userDetail.country}</div>
      </div>
      <div class="field">
        <div class="field-label">State</div>
        <div class="field-value">${userDetail.state}</div>
      </div>
      <div class="field">
        <div class="field-label">City</div>
        <div class="field-value">${userDetail.city}</div>
      </div>
    </div>

    <!-- Actions -->
    <div class="footer">
      <a href="editUser?userId=${user.userId}" class="btn primary">Edit</a>
    </div>
  </div>
</div>
</body>
</html>
