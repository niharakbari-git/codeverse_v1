<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Applications</title>
<style>
body{margin:0;background:#0a0a0f;color:#e2e8f0;font-family:'Syne',sans-serif}
.wrap{max-width:1100px;margin:24px auto;padding:18px}
.top{display:flex;justify-content:space-between;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:14px}
.btn{text-decoration:none;padding:9px 12px;border:1px solid #2a2a3d;background:#13131a;border-radius:10px;color:#e2e8f0;font-weight:700}
.filter{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;padding:14px;margin-bottom:14px;display:grid;grid-template-columns:1fr auto;gap:10px;align-items:end}
label{display:block;font-size:12px;color:#64748b;margin-bottom:6px}
select,input{width:100%;padding:10px;border-radius:10px;border:1px solid #2a2a3d;background:#1c1c27;color:#e2e8f0}
button{padding:10px 14px;border:1px solid transparent;background:linear-gradient(135deg,#f97316,#06b6d4);color:#fff;border-radius:10px;font-weight:800;cursor:pointer;box-shadow:0 8px 20px rgba(6,182,212,.18);transition:transform .15s ease,filter .15s ease}
button:hover{transform:translateY(-1px);filter:brightness(1.05)}
.panel{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;overflow:auto}
table{width:100%;border-collapse:collapse;min-width:950px}
th,td{padding:12px;border-bottom:1px solid #2a2a3d;text-align:left;vertical-align:top}
th{font-size:12px;color:#64748b;text-transform:uppercase}
.rowform{display:grid;grid-template-columns:130px 130px auto;gap:8px;align-items:center}
.empty{padding:16px;color:#64748b}
@media(max-width:800px){.filter{grid-template-columns:1fr}.rowform{grid-template-columns:1fr}}
</style>
</head>
<body>
<c:if test="${not empty param.msg}">
  <div id="toast-data" data-type="${param.type == 'success' ? 'success' : 'error'}" style="display:none;"><c:out value="${param.msg}" /></div>
</c:if>
<div class="wrap">
  <div class="top">
    <h2>Application Management</h2>
    <div>
      <a class="btn" href="<c:url value='/organizer/results' />">Results</a>
      <a class="btn" href="<c:url value='/organizer-dashboard' />">Dashboard</a>
    </div>
  </div>

  <form class="filter" action="<c:url value='/organizer/applications' />" method="get">
    <div>
      <label>Hackathon</label>
      <select name="hackathonId" required>
        <c:forEach items="${myHackathons}" var="h">
          <option value="${h.hackathonId}" ${selectedHackathonId == h.hackathonId ? 'selected' : ''}>${h.title}</option>
        </c:forEach>
      </select>
    </div>
    <div>
      <button type="submit">Load Applications</button>
    </div>
  </form>

  <div class="panel">
    <table>
      <thead>
        <tr>
          <th>Application ID</th>
          <th>Participant</th>
          <th>Status</th>
          <th>Payment</th>
          <th>Applied On</th>
          <th>Update</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${applicationViews}" var="a">
          <tr>
            <td>#${a.application.applicationId}</td>
            <td>${a.participantName}</td>
            <td>${a.application.status}</td>
            <td>${a.application.paymentStatus}</td>
            <fmt:parseDate value="${a.application.appliedAt}" pattern="yyyy-MM-dd" var="parsedAppliedAt" type="date" />
            <td><fmt:formatDate value="${parsedAppliedAt}" pattern="dd/MM/yyyy" /></td>
            <td>
              <form class="rowform" action="<c:url value='/organizer/update-application-status' />" method="post">
                <input type="hidden" name="_csrf" value="${_csrfToken}">
                <input type="hidden" name="applicationId" value="${a.application.applicationId}">
                <select name="status" required>
                  <option value="APPLIED" ${a.application.status == 'APPLIED' ? 'selected' : ''}>APPLIED</option>
                  <option value="SHORTLISTED" ${a.application.status == 'SHORTLISTED' ? 'selected' : ''}>SHORTLISTED</option>
                  <option value="REJECTED" ${a.application.status == 'REJECTED' ? 'selected' : ''}>REJECTED</option>
                  <option value="FINALIST" ${a.application.status == 'FINALIST' ? 'selected' : ''}>FINALIST</option>
                  <option value="WINNER" ${a.application.status == 'WINNER' ? 'selected' : ''}>WINNER</option>
                </select>
                <select name="paymentStatus" required>
                  <option value="PENDING" ${a.application.paymentStatus == 'PENDING' ? 'selected' : ''}>PENDING</option>
                  <option value="PAID" ${a.application.paymentStatus == 'PAID' ? 'selected' : ''}>PAID</option>
                  <option value="FAILED" ${a.application.paymentStatus == 'FAILED' ? 'selected' : ''}>FAILED</option>
                  <option value="WAIVED" ${a.application.paymentStatus == 'WAIVED' ? 'selected' : ''}>WAIVED</option>
                </select>
                <button type="submit">Save</button>
              </form>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty applicationViews}">
          <tr><td colspan="6" class="empty">No applications found for this hackathon.</td></tr>
        </c:if>
      </tbody>
    </table>
  </div>
</div>
<%@ include file="../shared/Toast.jspf" %>
</body>
</html>
