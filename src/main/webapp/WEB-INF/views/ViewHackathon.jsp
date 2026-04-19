<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Hackathon | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260415b">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260415b"></script>
<style>
.wrap{max-width:1060px;margin:24px auto;padding:0 16px}
.card{padding:22px}
.info{display:grid;grid-template-columns:220px 1fr;gap:8px 14px;margin-top:14px}
.info div{padding:10px;border:1px solid #d7dce5;border-radius:12px;background:#fff}
.info .k{font-weight:700;background:#f8fafc}
@media(max-width:760px){.info{grid-template-columns:1fr}}
.status{display:inline-flex;align-items:center;padding:4px 10px;border-radius:999px;font-size:12px;font-weight:700;border:1px solid transparent}
.status.upcoming{background:rgba(15,118,110,.12);color:var(--cv-accent-2);border-color:rgba(15,118,110,.18)}
.status.ongoing{background:#1f2329;color:#fff;border-color:#1f2329}
.status.completed{background:#f1f5f9;color:#64748b;border-color:#d5dde8}
.pay{display:inline-flex;align-items:center;padding:4px 10px;border-radius:999px;font-size:12px;font-weight:700;border:1px solid transparent}
.pay.free{background:rgba(31,35,41,.06);color:var(--cv-accent);border-color:#d5dde8}
.pay.paid{background:rgba(217,119,6,.12);color:var(--cv-warn);border-color:rgba(217,119,6,.18)}
.actions{margin-top:14px;display:flex;gap:8px;flex-wrap:wrap}
</style>
</head>
<body>
<div class="wrap">
  <div class="neo-panel card" data-reveal>
    <div class="neo-badge">Admin | Hackathons</div>
    <h1 class="neo-title">Hackathon Details</h1>

    <div class="info">
      <div class="k">Hackathon ID</div><div>${hackathon.hackathonId}</div>
      <div class="k">Title</div><div>${hackathon.title}</div>
      <div class="k">Description</div><div>${hackathon.description}</div>
      <div class="k">Problem Title</div><div>${hackathon.problemTitle}</div>
      <div class="k">Problem Statement</div><div>${hackathon.problemStatement}</div>
      <div class="k">Constraints</div><div>${hackathon.problemConstraints}</div>
      <div class="k">Deliverables</div><div>${hackathon.problemDeliverables}</div>
      <div class="k">Evaluation Criteria</div><div>${hackathon.evaluationCriteria}</div>
      <div class="k">Submission Checklist</div><div>${hackathon.submissionChecklist}</div>
      <div class="k">Registration Start</div><div><fmt:parseDate value="${hackathon.registrationStartDate}" pattern="yyyy-MM-dd" var="viewRegStart" type="date" /><fmt:formatDate value="${viewRegStart}" pattern="dd-MM-yyyy" /></div>
      <div class="k">Registration End</div><div><fmt:parseDate value="${hackathon.registrationEndDate}" pattern="yyyy-MM-dd" var="viewRegEnd" type="date" /><fmt:formatDate value="${viewRegEnd}" pattern="dd-MM-yyyy" /></div>
      <div class="k">Event Start</div><div><fmt:parseDate value="${hackathon.eventStartDate}" pattern="yyyy-MM-dd" var="viewEventStart" type="date" /><fmt:formatDate value="${viewEventStart}" pattern="dd-MM-yyyy" /></div>
      <div class="k">Event End</div><div><fmt:parseDate value="${hackathon.eventEndDate}" pattern="yyyy-MM-dd" var="viewEventEnd" type="date" /><fmt:formatDate value="${viewEventEnd}" pattern="dd-MM-yyyy" /></div>
      <div class="k">Submission Deadline</div><div><fmt:parseDate value="${hackathon.submissionDeadline}" pattern="yyyy-MM-dd" var="viewSubmissionDeadline" type="date" /><fmt:formatDate value="${viewSubmissionDeadline}" pattern="dd-MM-yyyy" /></div>
      <div class="k">Grace Period Hours</div><div>${hackathon.gracePeriodHours}</div>
      <div class="k">Min Team Size</div><div>${hackathon.minTeamSize}</div>
      <div class="k">Max Team Size</div><div>${hackathon.maxTeamSize}</div>
      <div class="k">Event Type</div><div>${hackathon.eventType}</div>
      <div class="k">Location</div><div>${hackathon.location}</div>
      <div class="k">Status</div>
      <div>
        <span class="status ${fn:toLowerCase(hackathon.status)}">${hackathon.status}</span>
      </div>
      <div class="k">Fee Type</div>
      <div>
        <span class="pay ${fn:toLowerCase(hackathon.payment)}">${hackathon.payment}</span>
      </div>
      <div class="k">Application Fee</div><div><c:choose><c:when test="${hackathon.payment == 'PAID'}">Rs. ${empty hackathon.entryFeeAmount ? 199 : hackathon.entryFeeAmount} per team application</c:when><c:otherwise>Free</c:otherwise></c:choose></div>
      <div class="k">Organizer ID</div><div>${hackathon.userId}</div>
    </div>

    <div class="actions">
      <a class="btn" href="editHackathon?hackathonId=${hackathon.hackathonId}">Edit Hackathon</a>
      <a class="btn" href="deleteHackathon?hackathonId=${hackathon.hackathonId}" onclick="return confirm('Are you sure you want to delete this hackathon?');">Delete Hackathon</a>
      <a class="btn" href="listHackathon">Back to List</a>
    </div>
  </div>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>

