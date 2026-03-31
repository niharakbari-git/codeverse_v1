<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Results</title>
<style>
body{margin:0;background:#0a0a0f;color:#e2e8f0;font-family:'Syne',sans-serif}
.wrap{max-width:1050px;margin:24px auto;padding:18px}
.top{display:flex;justify-content:space-between;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:14px}
.btn{text-decoration:none;padding:9px 12px;border:1px solid #2a2a3d;background:#13131a;border-radius:10px;color:#e2e8f0;font-weight:700}
.filter{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;padding:14px;margin-bottom:14px;display:grid;grid-template-columns:1fr auto;gap:10px;align-items:end}
label{display:block;font-size:12px;color:#64748b;margin-bottom:6px}
select{width:100%;padding:10px;border-radius:10px;border:1px solid #2a2a3d;background:#1c1c27;color:#e2e8f0}
button{padding:10px 14px;border:1px solid transparent;background:linear-gradient(135deg,#f97316,#06b6d4);color:#fff;border-radius:10px;font-weight:800;cursor:pointer;box-shadow:0 8px 20px rgba(6,182,212,.18);transition:transform .15s ease,filter .15s ease}
button:hover{transform:translateY(-1px);filter:brightness(1.05)}
.panel{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;overflow:auto}
table{width:100%;border-collapse:collapse;min-width:760px}
th,td{padding:12px;border-bottom:1px solid #2a2a3d;text-align:left}
th{font-size:12px;color:#64748b;text-transform:uppercase}
.rank{font-family:monospace;font-weight:700;color:#22d3ee}
.empty{padding:16px;color:#64748b}
@media(max-width:800px){.filter{grid-template-columns:1fr}}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <h2>Results & Leaderboard</h2>
    <div>
      <a class="btn" href="<c:url value='/organizer/applications' />">Applications</a>
      <a class="btn" href="<c:url value='/organizer-dashboard' />">Dashboard</a>
    </div>
  </div>

  <form class="filter" action="<c:url value='/organizer/results' />" method="get">
    <div>
      <label>Hackathon</label>
      <select name="hackathonId" required>
        <c:forEach items="${myHackathons}" var="h">
          <option value="${h.hackathonId}" ${selectedHackathonId == h.hackathonId ? 'selected' : ''}>${h.title}</option>
        </c:forEach>
      </select>
    </div>
    <div>
      <button type="submit">Load Results</button>
    </div>
  </form>

  <div class="panel">
    <table>
      <thead>
        <tr>
          <th>Rank</th>
          <th>Application ID</th>
          <th>Participant</th>
          <th>Status</th>
          <th>Average Score</th>
          <th>Judge Votes</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${resultViews}" var="r" varStatus="loop">
          <tr>
            <td class="rank">#${loop.index + 1}</td>
            <td>#${r.applicationId}</td>
            <td>${r.participantName}</td>
            <td>${r.status}</td>
            <td><fmt:formatNumber value="${r.averageScore}" type="number" minFractionDigits="1" maxFractionDigits="2" /></td>
            <td>${r.scoreCount}</td>
          </tr>
        </c:forEach>
        <c:if test="${empty resultViews}">
          <tr><td colspan="6" class="empty">No scored applications yet for this hackathon.</td></tr>
        </c:if>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>
