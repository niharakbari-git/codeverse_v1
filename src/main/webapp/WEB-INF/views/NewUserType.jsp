<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add New User Type | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260415b">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260415b"></script>
<style>
.wrap{min-height:100vh;display:grid;place-items:center;padding:16px}
.card{width:min(520px,100%);padding:24px}
.card h1{font-size:clamp(28px,4.6vw,40px)}
.field{margin-top:12px}
.field label{display:block;font-size:12px;font-weight:700;letter-spacing:.06em;text-transform:uppercase;margin-bottom:6px}
.actions{margin-top:14px;display:grid;gap:8px}
.actions a{text-align:center}
</style>
</head>
<body>
<c:if test="${not empty param.error}">
  <div id="toast-data" data-type="error" style="display:none;"><c:out value="${param.error}" /></div>
</c:if>
<div class="wrap">
  <div class="neo-panel card" data-reveal>
    <div class="neo-badge">Admin - User Types</div>
    <h1 class="neo-title">Add New User Type</h1>
    <form action="saveUserType" method="post">
      <input type="hidden" name="_csrf" value="${_csrfToken}" />
      <div class="field">
        <label>User Type</label>
        <select name="userType" required>
          <option value="">Select role</option>
          <option value="PARTICIPANT">PARTICIPANT</option>
          <option value="JUDGE">JUDGE</option>
          <option value="ORGANIZER">ORGANIZER</option>
          <option value="ADMIN">ADMIN</option>
        </select>
      </div>
      <div class="actions">
        <button type="submit">Save User Type</button>
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

