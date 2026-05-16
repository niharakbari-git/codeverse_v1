<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Something went wrong</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260512c"></script>
<style>
.wrap{min-height:100vh;display:grid;place-items:center;padding:16px}
.card{width:min(560px,100%);padding:24px;text-align:center}
.card h1{font-size:clamp(30px,5vw,48px)}
.card p{margin-top:10px;color:#5e6673;line-height:1.6}
.actions{margin-top:14px;display:flex;justify-content:center;gap:8px;flex-wrap:wrap}
</style>
</head>
<body>
<div class="wrap">
  <div class="neo-panel card" data-reveal>
    <div class="neo-badge">CodeVerse System</div>
    <h1 class="neo-title">Oops</h1>
    <p>${empty errorMessage ? 'Unexpected error occurred. Please try again.' : errorMessage}</p>
    <c:if test="${not empty correlationId}">
      <p>Support reference: ${correlationId}</p>
    </c:if>
    <div class="actions">
      <a class="btn" href="login">Back to Login</a>
    </div>
  </div>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>

