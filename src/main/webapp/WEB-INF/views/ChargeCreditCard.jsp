<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Payments | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260512c"></script>
<style>
.wrap{min-height:100vh;display:grid;place-items:center;padding:16px}
.card{width:min(760px,100%);padding:24px;display:grid;gap:14px}
.card h1{font-size:clamp(30px,5vw,44px)}
.notice{padding:12px 14px;border-radius:12px;background:#f8fafc;border:1px solid #d7dce5;color:#1f2329;line-height:1.5}
.actions{display:flex;gap:10px;flex-wrap:wrap}
</style>
</head>
<body>
<c:set var="toastMessage" value="${not empty error ? error : (not empty success ? success : (not empty message ? message : ''))}" />
<c:set var="toastType" value="${not empty error ? 'error' : 'success'}" />
<c:if test="${not empty toastMessage}">
  <div id="toast-data" data-type="${toastType}" style="display:none;"><c:out value="${toastMessage}" /></div>
</c:if>
<div class="wrap">
  <div class="neo-panel card" data-reveal>
    <div class="neo-badge">CodeVerse Payments</div>
    <h1 class="neo-title">Razorpay checkout ready</h1>
    <p class="neo-sub">Use the payment button from My Applications to launch the secure checkout window.</p>
    <p style="margin-top:8px;color:#5e6673;font-weight:600">${fixedFeeLabel}</p>
    <div class="notice">${paymentGuide}</div>
    <div class="notice">UPI is supported by Razorpay checkout by default. No card form is stored in this app.</div>
    <div class="actions">
      <a class="btn" href="<c:url value='/participant/my-applications' />">Go to My Applications</a>
      <a class="btn" href="<c:url value='${empty cancelPath ? "/participant/participant-dashboard" : cancelPath}' />">Back</a>
    </div>
  </div>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>

