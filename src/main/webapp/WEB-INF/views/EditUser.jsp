<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit User | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260512c"></script>
<style>
.wrap{max-width:980px;margin:24px auto;padding:0 16px}
.card{padding:22px}
.grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px}
@media(max-width:860px){.grid{grid-template-columns:1fr}}
.field label{display:block;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;margin-bottom:6px}
.field{margin-top:10px}
.actions{margin-top:14px;display:flex;gap:8px;flex-wrap:wrap}
</style>
</head>
<body>
<c:set var="toastMessage" value="${not empty error ? error : success}" />
<c:set var="toastType" value="${not empty error ? 'error' : 'success'}" />
<c:if test="${not empty toastMessage}">
  <div id="toast-data" data-type="${toastType}" style="display:none;"><c:out value="${toastMessage}" /></div>
</c:if>
<div class="wrap">
  <div class="neo-panel card" data-reveal>
    <div class="neo-badge">Admin - Users</div>
    <h1 class="neo-title">Edit User</h1>
    <form action="updateUser" method="post">
      <input type="hidden" name="_csrf" value="${_csrfToken}">
      <input type="hidden" name="userId" value="${user.userId}">
      <div class="grid">
        <div class="field">
          <label for="firstName">First Name</label>
          <input type="text" id="firstName" name="firstName" value="${user.firstName}" required>
        </div>
        <div class="field">
          <label for="lastName">Last Name</label>
          <input type="text" id="lastName" name="lastName" value="${user.lastName}" required>
        </div>
        <div class="field">
          <label for="email">Email</label>
          <input type="email" id="email" name="email" value="${user.email}" required>
        </div>
        <div class="field">
          <label for="contactNum">Phone</label>
          <input type="text" id="contactNum" name="contactNum" value="${user.contactNum}" required>
        </div>
        <div class="field">
          <label for="gender">Gender</label>
          <select id="gender" name="gender" required>
            <option value="" disabled ${empty user.gender ? 'selected' : ''}>Select gender</option>
            <option value="MALE" ${user.gender == 'MALE' ? 'selected' : ''}>Male</option>
            <option value="FEMALE" ${user.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
            <option value="OTHER" ${user.gender == 'OTHER' ? 'selected' : ''}>Other</option>
            <option value="PREFER_NOT_TO_SAY" ${user.gender == 'PREFER_NOT_TO_SAY' ? 'selected' : ''}>Prefer not to say</option>
            <c:if test="${not empty user.gender && user.gender != 'MALE' && user.gender != 'FEMALE' && user.gender != 'OTHER' && user.gender != 'PREFER_NOT_TO_SAY'}">
              <option value="${user.gender}" selected>${user.gender}</option>
            </c:if>
          </select>
        </div>
        <div class="field">
          <label for="active">Status</label>
          <select id="active" name="active" required>
            <option value="true" ${user.active == true ? 'selected' : ''}>Active</option>
            <option value="false" ${user.active == false ? 'selected' : ''}>Inactive</option>
          </select>
        </div>
        <div class="field">
          <label for="role">Role</label>
          <select id="role" name="role" required>
            <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
            <option value="ORGANIZER" ${user.role == 'ORGANIZER' ? 'selected' : ''}>ORGANIZER</option>
            <option value="JUDGE" ${user.role == 'JUDGE' ? 'selected' : ''}>JUDGE</option>
            <option value="PARTICIPANT" ${user.role == 'PARTICIPANT' ? 'selected' : ''}>PARTICIPANT</option>
          </select>
        </div>
      </div>
      <div class="actions">
        <button type="submit">Update User</button>
        <c:choose>
          <c:when test="${sessionScope.user.role == 'ADMIN'}"><a class="btn" href="<c:url value='/admin-dashboard' />">Cancel</a></c:when>
          <c:when test="${sessionScope.user.role == 'ORGANIZER'}"><a class="btn" href="<c:url value='/organizer-dashboard' />">Cancel</a></c:when>
          <c:when test="${sessionScope.user.role == 'JUDGE'}"><a class="btn" href="<c:url value='/judge-dashboard' />">Cancel</a></c:when>
          <c:otherwise><a class="btn" href="<c:url value='/participant/participant-dashboard' />">Cancel</a></c:otherwise>
        </c:choose>
      </div>
    </form>
  </div>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>

