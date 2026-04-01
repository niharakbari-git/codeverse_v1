<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Judge Scorecards</title>
<style>
body{margin:0;background:#0a0a0f;color:#e2e8f0;font-family:'Syne',sans-serif}
.wrap{max-width:1080px;margin:24px auto;padding:18px}
.top{display:flex;justify-content:space-between;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:14px}
.btn{text-decoration:none;padding:9px 12px;border:1px solid #2a2a3d;background:#13131a;border-radius:10px;color:#e2e8f0;font-weight:700}
.filter{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;padding:14px;margin-bottom:14px;display:grid;grid-template-columns:1fr auto;gap:10px;align-items:end}
label{display:block;font-size:12px;color:#64748b;margin-bottom:6px}
select,input,textarea{width:100%;padding:10px;border-radius:10px;border:1px solid #2a2a3d;background:#1c1c27;color:#e2e8f0}
button{padding:10px 14px;border:1px solid transparent;background:linear-gradient(135deg,#f97316,#06b6d4);color:#fff;border-radius:10px;font-weight:800;cursor:pointer;box-shadow:0 8px 20px rgba(6,182,212,.18);transition:transform .15s ease,filter .15s ease}
button:hover{transform:translateY(-1px);filter:brightness(1.05)}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:12px}
.card{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;padding:14px}
.card h4{margin:0 0 8px}
.meta{margin:0 0 12px;color:#94a3b8;font-size:13px;line-height:1.6}
.form{display:grid;gap:8px}
.help{font-size:12px;color:#64748b}
.msg{padding:10px 12px;border-radius:10px;margin-bottom:12px;font-size:13px}
.msg.success{background:#072e2f;border:1px solid #0f766e;color:#ccfbf1}
.msg.error{background:#3b0d0d;border:1px solid #7f1d1d;color:#fecaca}
.empty{padding:16px;color:#64748b;background:#13131a;border:1px solid #2a2a3d;border-radius:14px}
@media(max-width:760px){.filter{grid-template-columns:1fr}}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <h2>Judge Scorecards</h2>
    <div>
      <a class="btn" href="<c:url value='/judge/my-assignments' />">My Assignments</a>
      <a class="btn" href="<c:url value='/judge-dashboard' />">Dashboard</a>
    </div>
  </div>

  <c:if test="${not empty msg}">
    <div class="msg ${msgType == 'success' ? 'success' : 'error'}">${msg}</div>
  </c:if>

  <form class="filter" action="<c:url value='/judge/scorecards' />" method="get">
    <div>
      <label>Hackathon</label>
      <select name="hackathonId" required>
        <c:forEach items="${assignedHackathons}" var="h">
          <option value="${h.hackathonId}" ${selectedHackathonId == h.hackathonId ? 'selected' : ''}>${h.title}</option>
        </c:forEach>
      </select>
    </div>
    <div>
      <button type="submit">Load Scorecards</button>
    </div>
  </form>

  <c:if test="${empty scorecards}">
    <div class="empty">No applications available to score for this hackathon yet.</div>
  </c:if>

  <div class="grid">
    <c:forEach items="${scorecards}" var="s">
      <div class="card">
        <h4>Application #${s.application.applicationId}</h4>
        <p class="meta">
          Participant: ${s.participantName}<br>
          Status: ${s.application.status}<br>
          Payment: ${s.application.paymentStatus}
        </p>

        <form class="form" action="<c:url value='/judge/submit-score' />" method="post">
          <input type="hidden" name="_csrf" value="${_csrfToken}">
          <input type="hidden" name="applicationId" value="${s.application.applicationId}">
          <input type="hidden" name="hackathonId" value="${s.application.hackathonId}">

          <label>Score (0-100)</label>
          <input type="number" name="score" min="0" max="100" value="${s.givenScore}" required>

          <label>Remarks</label>
          <textarea name="remarks" rows="3" placeholder="Strengths, weaknesses, innovation, execution...">${s.remarks}</textarea>

          <button type="submit">Save Score</button>
          <span class="help">You can resubmit to update your previous score.</span>
        </form>
      </div>
    </c:forEach>
  </div>
</div>
</body>
</html>
