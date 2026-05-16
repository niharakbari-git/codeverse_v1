<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:choose><c:when test="${not empty category.categoryId}">Edit Category</c:when><c:otherwise>New Category</c:otherwise></c:choose> | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260512c"></script>
<style>
.wrap{max-width:760px;margin:24px auto;padding:0 16px}
.top{display:flex;justify-content:space-between;align-items:flex-end;gap:10px;flex-wrap:wrap;margin-bottom:12px}
.actions{display:flex;gap:8px;flex-wrap:wrap}
.card{padding:20px}
.field label{display:block;font-size:12px;font-weight:700;letter-spacing:.06em;text-transform:uppercase;margin-bottom:6px}
.footer{margin-top:14px;display:flex;justify-content:flex-end;gap:8px;flex-wrap:wrap}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <div>
      <div class="neo-badge">Admin � Categories</div>
      <h1 class="neo-title"><c:choose><c:when test="${not empty category.categoryId}">Edit Category</c:when><c:otherwise>New Category</c:otherwise></c:choose></h1>
    </div>
    <div class="actions">
      <a class="btn" href="<c:url value='/listCategory' />">Category List</a>
      <a class="btn" href="<c:url value='/admin-dashboard' />">Dashboard</a>
    </div>
  </div>

  <form class="neo-panel card" action="saveCategory" method="post" data-reveal>
    <input type="hidden" name="_csrf" value="${_csrfToken}">
    <input type="hidden" name="categoryId" value="${category.categoryId}">
    <input type="hidden" name="active" value="${category.active}">

    <div class="field">
      <label>Category Name</label>
      <input type="text" name="categoryName" placeholder="Enter category name" value="${category.categoryName}" required>
    </div>

    <div class="footer">
      <c:choose>
        <c:when test="${sessionScope.user.role == 'ADMIN'}"><a class="btn" href="<c:url value='/admin-dashboard' />">Cancel</a></c:when>
        <c:when test="${sessionScope.user.role == 'ORGANIZER'}"><a class="btn" href="<c:url value='/organizer-dashboard' />">Cancel</a></c:when>
        <c:when test="${sessionScope.user.role == 'JUDGE'}"><a class="btn" href="<c:url value='/judge-dashboard' />">Cancel</a></c:when>
        <c:otherwise><a class="btn" href="<c:url value='/participant/participant-dashboard' />">Cancel</a></c:otherwise>
      </c:choose>
      <button type="submit"><c:choose><c:when test="${not empty category.categoryId}">Update Category</c:when><c:otherwise>Save Category</c:otherwise></c:choose></button>
    </div>
  </form>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>

