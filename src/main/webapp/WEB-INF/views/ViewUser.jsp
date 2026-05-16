<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>User Profile | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260512c"></script>
<style>
.wrap{max-width:980px;margin:24px auto;padding:0 16px}
.card{padding:22px}
.table-like{display:grid;grid-template-columns:220px 1fr;gap:8px 14px;margin-top:14px}
.table-like div{padding:10px;border:1px solid #d7dce5;border-radius:12px;background:#fff}
.table-like .k{font-weight:700;background:#f8fafc}
@media(max-width:760px){.table-like{grid-template-columns:1fr}}
.actions{margin-top:14px;display:flex;gap:8px;flex-wrap:wrap}
</style>
</head>
<body>
<div class="wrap">
  <div class="neo-panel card" data-reveal>
    <div class="neo-badge">Admin - Users</div>
    <h1 class="neo-title">User Profile</h1>
    <fmt:parseDate value="${user.createdAt}" pattern="yyyy-MM-dd" var="createdDate" type="date"/>
    <div class="table-like">
      <div class="k">User ID</div><div>${user.userId}</div>
      <div class="k">Name</div><div>${user.firstName} ${user.lastName}</div>
      <div class="k">Email</div><div>${user.email}</div>
      <div class="k">Phone</div><div>${user.contactNum}</div>
      <div class="k">Gender</div><div>${user.gender}</div>
      <div class="k">Role</div><div>${user.role}</div>
      <div class="k">Status</div><div>${user.active == true ? 'Active' : 'Inactive'}</div>
      <div class="k">Created Date</div><div><fmt:formatDate value="${createdDate}" pattern="dd-MM-yyyy"/></div>
    </div>
    <div class="actions">
      <a class="btn" href="<c:url value='/editUser?userId=${user.userId}' />">Edit User</a>
      <a class="btn" href="<c:url value='/admin/user-list' />">Back to List</a>
    </div>
  </div>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>

