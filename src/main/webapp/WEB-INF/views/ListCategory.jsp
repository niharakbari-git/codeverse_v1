<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Category List</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--bg:#0a0f16;--surface:#131c27;--surface2:#1c2734;--border:#2a3d52;--text:#e2e8f0;--muted:#8ca0b3;--accent:#f97316;--accent2:#06b6d4}
body{font-family:'Syne',sans-serif;background:radial-gradient(circle at 12% 16%,rgba(6,182,212,.14),transparent 35%),radial-gradient(circle at 85% 82%,rgba(249,115,22,.14),transparent 40%),var(--bg);color:var(--text);min-height:100vh}
.wrap{max-width:1120px;margin:28px auto;padding:0 18px 28px}
.top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:14px}
.title{font-size:clamp(24px,4vw,36px);font-weight:800;letter-spacing:-.6px}
.title span{background:linear-gradient(135deg,var(--accent),var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.actions{display:flex;gap:8px;flex-wrap:wrap}
.btn{display:inline-block;text-decoration:none;padding:9px 12px;border:1px solid var(--border);border-radius:10px;background:var(--surface);color:var(--text);font-weight:700;font-size:13px}
.btn.primary{border:none;background:linear-gradient(135deg,var(--accent),var(--accent2));box-shadow:0 10px 24px rgba(6,182,212,.16)}
.panel{border:1px solid var(--border);border-radius:14px;background:var(--surface);overflow:auto}
table{width:100%;border-collapse:collapse;min-width:760px}
thead{background:var(--surface2)}
th,td{padding:12px 10px;border-bottom:1px solid var(--border);text-align:left;font-size:14px}
th{font-size:12px;text-transform:uppercase;letter-spacing:.8px;color:var(--muted)}
.badge{display:inline-block;padding:4px 8px;border-radius:999px;font-size:11px;font-weight:700}
.on{background:rgba(34,197,94,.16);color:#4ade80}
.off{background:rgba(239,68,68,.16);color:#fca5a5}
.row-actions{display:flex;gap:6px;flex-wrap:wrap}
.row-actions .btn{padding:6px 9px;font-size:12px}
.row-actions .warn{border-color:#f59e0b;color:#fbbf24}
.row-actions .danger{border-color:#ef4444;color:#fca5a5}
.empty{padding:16px;color:var(--muted);text-align:center}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <h1 class="title"><span>Category</span> List</h1>
    <div class="actions">
      <a class="btn" href="<c:url value='/admin-dashboard' />">Dashboard</a>
      <a class="btn primary" href="<c:url value='/newCategory' />">Create Category</a>
      <a class="btn" href="<c:url value='/logout' />">Logout</a>
    </div>
  </div>

  <div class="panel">
    <table>
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
                <c:when test="${cat.active}"><span class="badge on">Active</span></c:when>
                <c:otherwise><span class="badge off">Inactive</span></c:otherwise>
              </c:choose>
            </td>
            <td>
              <div class="row-actions">
                <a class="btn warn" href="<c:url value='/editCategory?id=${cat.categoryId}' />">Edit</a>
                <a class="btn danger" href="<c:url value='/deleteCategory?id=${cat.categoryId}' />" onclick="return confirm('Are you sure you want to delete this category?');">Delete</a>
              </div>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>