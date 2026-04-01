<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Hackathon List</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--bg:#0a0f16;--surface:#131c27;--surface2:#1c2734;--border:#2a3d52;--text:#e2e8f0;--muted:#8ca0b3;--accent:#f97316;--accent2:#06b6d4}
body{font-family:'Syne',sans-serif;background:radial-gradient(circle at 12% 16%,rgba(6,182,212,.14),transparent 35%),radial-gradient(circle at 85% 82%,rgba(249,115,22,.14),transparent 40%),var(--bg);color:var(--text);min-height:100vh}
.wrap{max-width:1260px;margin:28px auto;padding:0 18px 28px}
.top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:14px}
.title{font-size:clamp(24px,4vw,36px);font-weight:800;letter-spacing:-.6px}
.title span{background:linear-gradient(135deg,var(--accent),var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.actions{display:flex;gap:8px;flex-wrap:wrap}
.btn{display:inline-block;text-decoration:none;padding:9px 12px;border:1px solid var(--border);border-radius:10px;background:var(--surface);color:var(--text);font-weight:700;font-size:13px}
.btn.primary{border:none;background:linear-gradient(135deg,var(--accent),var(--accent2));box-shadow:0 10px 24px rgba(6,182,212,.16)}
.panel{border:1px solid var(--border);border-radius:14px;background:var(--surface);overflow:auto}
table{width:100%;border-collapse:collapse;min-width:1020px}
thead{background:var(--surface2)}
th,td{padding:12px 10px;border-bottom:1px solid var(--border);text-align:left;font-size:14px;vertical-align:top}
th{font-size:12px;text-transform:uppercase;letter-spacing:.8px;color:var(--muted)}
.badge{display:inline-block;padding:4px 8px;border-radius:999px;font-size:11px;font-weight:700}
.status-upcoming{background:rgba(6,182,212,.16);color:#67e8f9}
.status-ongoing{background:rgba(34,197,94,.16);color:#4ade80}
.status-completed{background:rgba(148,163,184,.2);color:#cbd5e1}
.pay-free{background:rgba(34,197,94,.16);color:#4ade80}
.pay-paid{background:rgba(239,68,68,.16);color:#fca5a5}
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
    <h1 class="title"><span>Hackathon</span> List</h1>
    <div class="actions">
      <a class="btn" href="<c:url value='/admin-dashboard' />">Dashboard</a>
      <a class="btn primary" href="<c:url value='/newHackathon' />">Create Hackathon</a>
      <a class="btn" href="<c:url value='/logout' />">Logout</a>
    </div>
  </div>

  <div class="panel">
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Title</th>
          <th>Status</th>
          <th>Event</th>
          <th>Payment</th>
          <th>Team Size</th>
          <th>Location</th>
          <th>Registration</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty allHackthon}">
            <tr><td colspan="9" class="empty">No hackathons found.</td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="h" items="${allHackthon}" varStatus="i">
              <tr>
                <td>${i.count}</td>
                <td>${h.title}</td>
                <td>
                  <c:choose>
                    <c:when test="${h.status == 'UPCOMING'}"><span class="badge status-upcoming">UPCOMING</span></c:when>
                    <c:when test="${h.status == 'ONGOING'}"><span class="badge status-ongoing">ONGOING</span></c:when>
                    <c:otherwise><span class="badge status-completed">COMPLETED</span></c:otherwise>
                  </c:choose>
                </td>
                <td>${h.eventType}</td>
                <td>
                  <c:choose>
                    <c:when test="${h.payment == 'FREE'}"><span class="badge pay-free">FREE</span></c:when>
                    <c:otherwise><span class="badge pay-paid">PAID</span></c:otherwise>
                  </c:choose>
                </td>
                <td>${h.minTeamSize} - ${h.maxTeamSize}</td>
                <td>${h.location}</td>
                <td>
                    <fmt:parseDate value="${h.registrationStartDate}" pattern="yyyy-MM-dd" var="parsedRegStart" type="date" />
                    <fmt:parseDate value="${h.registrationEndDate}" pattern="yyyy-MM-dd" var="parsedRegEnd" type="date" />
                    <fmt:formatDate value="${parsedRegStart}" pattern="dd/MM/yyyy" /> to <fmt:formatDate value="${parsedRegEnd}" pattern="dd/MM/yyyy" />
                </td>
                <td>
                  <div class="row-actions">
                    <a class="btn" href="<c:url value='/viewHackathon?hackathonId=${h.hackathonId}' />">View</a>
                    <a class="btn warn" href="<c:url value='/editHackathon?hackathonId=${h.hackathonId}' />">Edit</a>
                    <a class="btn danger" href="<c:url value='/deleteHackathon?hackathonId=${h.hackathonId}' />" onclick="return confirm('Are you sure you want to delete this hackathon?');">Delete</a>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>