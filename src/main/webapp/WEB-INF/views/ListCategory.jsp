<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Category List | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260415b">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260415b"></script>
<style>
.wrap{max-width:1120px;margin:24px auto;padding:0 16px}
.top{display:flex;justify-content:space-between;align-items:flex-end;gap:10px;flex-wrap:wrap;margin-bottom:12px}
.actions{display:flex;gap:8px;flex-wrap:wrap}
.panel{padding:0;overflow:auto}
.table{width:100%;min-width:760px;border-collapse:collapse}
.table th,.table td{padding:12px;border-bottom:1px solid #d8deea;text-align:left}
.table th{font-size:12px;font-weight:800;text-transform:uppercase;letter-spacing:.06em;background:#f6f8fb;color:#4b5563}
.empty{text-align:center;color:#5e6673;padding:16px}
.status{display:inline-flex;padding:4px 10px;border-radius:999px;font-size:12px;font-weight:700;border:1px solid transparent}
.status.on{background:rgba(15,118,110,.12);color:var(--cv-accent-2);border-color:rgba(15,118,110,.18)}
.status.off{background:#f1f5f9;color:#64748b;border-color:#d5dde8}
.row-actions{display:flex;gap:6px;flex-wrap:wrap}
.row-actions a{padding:6px 10px;font-size:12px}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <div>
      <div class="neo-badge">Admin � Categories</div>
      <h1 class="neo-title">Category List</h1>
    </div>
    <div class="actions">
      <c:choose>
        <c:when test="${sessionScope.user.role == 'ADMIN'}"><a class="btn" href="<c:url value='/admin-dashboard' />">Dashboard</a></c:when>
        <c:when test="${sessionScope.user.role == 'ORGANIZER'}"><a class="btn" href="<c:url value='/organizer-dashboard' />">Dashboard</a></c:when>
        <c:when test="${sessionScope.user.role == 'JUDGE'}"><a class="btn" href="<c:url value='/judge-dashboard' />">Dashboard</a></c:when>
        <c:otherwise><a class="btn" href="<c:url value='/participant/participant-dashboard' />">Dashboard</a></c:otherwise>
      </c:choose>
      <a class="btn" href="<c:url value='/newCategory' />">Create Category</a>
      <a class="btn" href="<c:url value='/logout' />">Logout</a>
    </div>
  </div>

  <div class="neo-panel panel" data-reveal>
    <table class="table">
      <thead>
        <tr>
          <th>#</th>
          <th>Category Name</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <c:if test="${empty categoryList}">
          <tr><td colspan="4" class="empty">No categories found.</td></tr>
        </c:if>
        <c:forEach var="cat" items="${categoryList}" varStatus="i">
          <tr>
            <td>${i.index + 1}</td>
            <td>${cat.categoryName}</td>
            <td>
              <c:choose>
                <c:when test="${cat.active}"><span class="status on">Active</span></c:when>
                <c:otherwise><span class="status off">Inactive</span></c:otherwise>
              </c:choose>
            </td>
            <td>
              <div class="row-actions">
                <a class="btn" href="<c:url value='/editCategory?id=${cat.categoryId}' />">Edit</a>
                <a class="btn" href="<c:url value='/deleteCategory?id=${cat.categoryId}' />" onclick="return confirm('Are you sure you want to delete this category?');">Delete</a>
              </div>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>

