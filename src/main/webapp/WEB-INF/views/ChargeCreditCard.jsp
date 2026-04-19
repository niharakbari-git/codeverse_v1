<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Charge Credit Card | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260415b">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260415b"></script>
<style>
.wrap{min-height:100vh;display:grid;place-items:center;padding:16px}
.card{width:min(620px,100%);padding:24px}
.card h1{font-size:clamp(30px,5vw,44px)}
.field{margin-top:12px}
.field label{display:block;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;margin-bottom:6px}
.grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px}
@media(max-width:760px){.grid{grid-template-columns:1fr}}
.actions{margin-top:14px;display:flex;gap:8px;flex-wrap:wrap}
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
    <h1 class="neo-title">Charge Credit Card</h1>
    <p style="margin-top:8px;color:#5e6673;font-weight:600">${fixedFeeLabel}</p>
    <form action="${pageContext.request.contextPath}/charge" method="post">
      <input type="hidden" name="_csrf" value="${_csrf.token}" />
      <div class="field">
        <label for="amount">Application Fee (fixed)</label>
        <input type="number" name="amount" id="amount" value="${amount}" min="1" step="0.01" readonly required>
      </div>
      <div class="field">
        <label for="cardNumber">Card Number</label>
        <input type="text" name="cardNumber" id="cardNumber" maxlength="16" required>
      </div>
      <div class="grid">
        <div class="field">
          <label for="expMonth">Expiry Month</label>
          <input type="number" name="expMonth" id="expMonth" min="1" max="12" required>
        </div>
        <div class="field">
          <label for="expYear">Expiry Year</label>
          <input type="number" name="expYear" id="expYear" min="2024" required>
        </div>
        <div class="field">
          <label for="cvv">CVV</label>
          <input type="password" name="cvv" id="cvv" maxlength="4" required>
        </div>
      </div>
      <p style="margin-top:10px;color:#5e6673;font-size:13px">This fee is charged once per team application, not per team member.</p>
      <div class="actions">
        <button type="submit">Submit Payment</button>
        <a class="btn" href="<c:url value='${empty cancelPath ? "/participant/participant-dashboard" : cancelPath}' />">Cancel</a>
      </div>
    </form>
  </div>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>

