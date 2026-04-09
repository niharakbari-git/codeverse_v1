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
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260409a">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260409a"></script>
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

        <c:if test="${not empty s.application.submissionDescription || not empty s.application.submissionUrl || not empty s.application.frontendGithubLink || not empty s.application.backendGithubLink}">
          <div style="background:#1c1c27;padding:12px;border-radius:10px;margin-bottom:12px;font-size:13px;">
            <strong>Submission Details:</strong><br>
            <c:if test="${not empty s.application.submissionDescription}">
              <p style="margin:4px 0">${s.application.submissionDescription}</p>
            </c:if>
            <c:if test="${not empty s.application.submissionUrl}">
              <a href="${s.application.submissionUrl}" target="_blank" style="color:var(--accent2);text-decoration:none;display:block;margin-top:4px;">Project Link &#8599;</a>
            </c:if>
            <c:if test="${not empty s.application.frontendGithubLink}">
              <a href="${s.application.frontendGithubLink}" target="_blank" style="color:var(--accent2);text-decoration:none;display:block;margin-top:4px;">Frontend GitHub Link &#8599;</a>
            </c:if>
            <c:if test="${not empty s.application.backendGithubLink}">
              <a href="${s.application.backendGithubLink}" target="_blank" style="color:var(--accent2);text-decoration:none;display:block;margin-top:4px;">Backend GitHub Link &#8599;</a>
            </c:if>
          </div>
        </c:if>

        <form class="form" action="<c:url value='/judge/submit-score' />" method="post">
          <input type="hidden" name="_csrf" value="${_csrfToken}">
          <input type="hidden" name="applicationId" value="${s.application.applicationId}">
          <input type="hidden" name="hackathonId" value="${s.application.hackathonId}">

            <div style="display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-bottom:8px;">
              <div>
                <label>Idea & Innovation (0-25)</label>
                <input type="number" name="ideaScore" min="0" max="25" value="${s.ideaScore}" required>
              </div>
              <div>
                <label>Design & UX (0-25)</label>
                <input type="number" name="designScore" min="0" max="25" value="${s.designScore}" required>
              </div>
              <div>
                <label>Execution & Code (0-25)</label>
                <input type="number" name="executionScore" min="0" max="25" value="${s.executionScore}" required>
              </div>
              <div>
                <label>Pitch & Presentation (0-25)</label>
                <input type="number" name="pitchScore" min="0" max="25" value="${s.pitchScore}" required>
              </div>
            </div>

            <label>Total Score</label>
            <div style="margin-bottom:8px;font-size:16px;font-weight:bold;color:var(--accent2);">${s.givenScore != null ? s.givenScore : 'Not Scored Yet'}</div>
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













