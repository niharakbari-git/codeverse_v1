<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:choose><c:when test="${not empty category.categoryId}">Edit Category</c:when><c:otherwise>New Category</c:otherwise></c:choose></title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--bg:#0a0f16;--surface:#131c27;--surface2:#1c2734;--border:#2a3d52;--text:#e2e8f0;--muted:#8ca0b3;--accent:#f97316;--accent2:#06b6d4}
body{font-family:'Syne',sans-serif;background:radial-gradient(circle at 12% 16%,rgba(6,182,212,.14),transparent 35%),radial-gradient(circle at 85% 82%,rgba(249,115,22,.14),transparent 40%),var(--bg);color:var(--text);min-height:100vh}
.wrap{max-width:760px;margin:28px auto;padding:0 18px 28px}
.top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:14px}
h1{font-size:clamp(24px,4vw,36px);font-weight:800;letter-spacing:-.6px}
h1 span{background:linear-gradient(135deg,var(--accent),var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.actions{display:flex;gap:8px;flex-wrap:wrap}
.btn{display:inline-block;text-decoration:none;padding:9px 12px;border:1px solid var(--border);border-radius:10px;background:var(--surface);color:var(--text);font-weight:700;font-size:13px}
.btn.primary{border:none;background:linear-gradient(135deg,var(--accent),var(--accent2));box-shadow:0 10px 24px rgba(6,182,212,.16)}
.card{border:1px solid var(--border);border-radius:14px;background:var(--surface);padding:16px}
label{display:block;font-size:12px;color:var(--muted);margin-bottom:6px}
input{width:100%;padding:11px 12px;border-radius:10px;border:1px solid var(--border);background:var(--surface2);color:var(--text);font-size:14px}
input:focus{outline:none;border-color:var(--accent2);box-shadow:0 0 0 3px rgba(6,182,212,.14)}
.footer{margin-top:14px;display:flex;justify-content:flex-end;gap:8px;flex-wrap:wrap}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <h1><span>Category</span> <c:choose><c:when test="${not empty category.categoryId}">Editor</c:when><c:otherwise>Creator</c:otherwise></c:choose></h1>
    <div class="actions">
      <a class="btn" href="<c:url value='/listCategory' />">Category List</a>
      <a class="btn" href="<c:url value='/admin-dashboard' />">Dashboard</a>
    </div>
  </div>

  <form class="card" action="saveCategory" method="post">
    <input type="hidden" name="categoryId" value="${category.categoryId}">
    <input type="hidden" name="active" value="${category.active}">

    <label>Category Name</label>
    <input type="text" name="categoryName" placeholder="Enter category name" value="${category.categoryName}" required>

    <div class="footer">
      <a class="btn" href="<c:url value='/listCategory' />">Cancel</a>
      <button class="btn primary" type="submit"><c:choose><c:when test="${not empty category.categoryId}">Update Category</c:when><c:otherwise>Save Category</c:otherwise></c:choose></button>
    </div>
  </form>
</div>
</body>
</html>