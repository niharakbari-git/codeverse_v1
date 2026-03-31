<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Applications</title>
<style>
body{margin:0;background:#0a0a0f;color:#e2e8f0;font-family:'Syne',sans-serif}
.wrap{max-width:1100px;margin:24px auto;padding:18px}
.top{display:flex;justify-content:space-between;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:14px}
.btn{text-decoration:none;padding:9px 12px;border:1px solid #2a2a3d;background:#13131a;border-radius:10px;color:#e2e8f0;font-weight:700}
.panel{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;overflow:auto}
table{width:100%;border-collapse:collapse;min-width:760px}
th,td{padding:12px;border-bottom:1px solid #2a2a3d;text-align:left}
th{font-size:12px;color:#64748b;text-transform:uppercase}
.badge{display:inline-block;padding:4px 8px;border-radius:999px;font-size:11px;font-weight:700}
.applied{background:rgba(59,130,246,.16);color:#93c5fd}
.pending{background:rgba(245,158,11,.16);color:#fcd34d}
.empty{padding:16px;color:#64748b}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <h2>My Applications</h2>
    <div>
      <a class="btn" href="<c:url value='/participant/my-teams' />">My Teams</a>
      <a class="btn" href="<c:url value='/participant/home' />">Explore</a>
    </div>
  </div>

  <div class="panel">
    <table>
      <thead>
        <tr>
          <th>Hackathon</th>
          <th>Team</th>
          <th>Status</th>
          <th>Payment</th>
          <th>Applied On</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${appViews}" var="v">
          <tr>
            <td>${v.hackathonTitle}</td>
            <td>${v.teamName}</td>
            <td><span class="badge applied">${v.application.status}</span></td>
            <td><span class="badge pending">${v.application.paymentStatus}</span></td>
            <td><fmt:formatDate value="${v.application.appliedAt}" pattern="dd/MM/yyyy" /></td>
          </tr>
        </c:forEach>
        <c:if test="${empty appViews}">
          <tr><td colspan="5" class="empty">No applications yet. Apply from Explore page.</td></tr>
        </c:if>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>
