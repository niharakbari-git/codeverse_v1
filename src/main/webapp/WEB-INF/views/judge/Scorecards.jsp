<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Judge Scorecards</title>
<style>
*,*::before,*::after{box-sizing:border-box}
body{margin:0;background:#0a0a0f;color:#e2e8f0;font-family:'Syne',sans-serif}
.wrap{max-width:1080px;margin:24px auto;padding:18px}
.top{display:flex;justify-content:space-between;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:14px}
.top h2{margin:0;font-size:clamp(24px,4vw,36px)}
.actions{display:flex;gap:8px;flex-wrap:wrap}
.btn{text-decoration:none;padding:9px 12px;border:1px solid #2a2a3d;background:#13131a;border-radius:10px;color:#e2e8f0;font-weight:700}
.filter{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;padding:14px;margin-bottom:14px;display:grid;grid-template-columns:1fr auto;gap:10px;align-items:end}
label{display:block;font-size:12px;color:#64748b;margin-bottom:6px}
select,input,textarea{width:100%;padding:10px;border-radius:10px;border:1px solid #2a2a3d;background:#1c1c27;color:#e2e8f0}
button{padding:10px 14px;border:1px solid transparent;background:linear-gradient(135deg,#f97316,#06b6d4);color:#fff;border-radius:10px;font-weight:800;cursor:pointer;box-shadow:0 8px 20px rgba(6,182,212,.18);transition:transform .15s ease,filter .15s ease}
button:hover{transform:translateY(-1px);filter:brightness(1.05)}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(420px,1fr));gap:12px}
.card{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;padding:14px}
.card h4{margin:0 0 8px}
.meta{margin:0 0 12px;color:#94a3b8;font-size:13px;line-height:1.6}
.submission-box{background:#1c1c27;padding:12px;border-radius:10px;margin-bottom:12px;font-size:13px}
.submission-desc{margin:4px 0}
.submission-link{color:#67e8f9;text-decoration:none;display:block;margin-top:4px;word-break:break-word}
.score-form{display:grid;gap:8px}
.score-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:8px;margin-bottom:8px}
.score-field{min-width:0}
.score-field input{display:block;width:100%;max-width:100%}
.score-total{margin-bottom:8px}
.score-total-value{font-size:20px;font-weight:800;color:#67e8f9}
.score-form textarea{display:block;width:100%;max-width:100%;resize:vertical;min-height:82px}
.score-form button{width:100%}
.help{font-size:12px;color:#64748b}
.msg{padding:10px 12px;border-radius:10px;margin-bottom:12px;font-size:13px}
.msg.success{background:#072e2f;border:1px solid #0f766e;color:#ccfbf1}
.msg.error{background:#3b0d0d;border:1px solid #7f1d1d;color:#fecaca}
.empty{padding:16px;color:#64748b;background:#13131a;border:1px solid #2a2a3d;border-radius:14px}
@media(max-width:980px){.grid{grid-template-columns:1fr}.score-grid{grid-template-columns:1fr}}
@media(max-width:760px){.filter{grid-template-columns:1fr}}
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260409a">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260409a"></script>
</head>
<body>
<div class="wrap">
  <div class="top">
    <h2>Judge Scorecards</h2>
    <div class="actions">
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
          <div class="submission-box">
            <strong>Submission Details:</strong><br>
            <c:if test="${not empty s.application.submissionDescription}">
              <p class="submission-desc">${s.application.submissionDescription}</p>
            </c:if>
            <c:if test="${not empty s.application.submissionUrl}">
              <a href="${s.application.submissionUrl}" target="_blank" class="submission-link">Project Link &#8599;</a>
            </c:if>
            <c:if test="${not empty s.application.frontendGithubLink}">
              <a href="${s.application.frontendGithubLink}" target="_blank" class="submission-link">Frontend GitHub Link &#8599;</a>
            </c:if>
            <c:if test="${not empty s.application.backendGithubLink}">
              <a href="${s.application.backendGithubLink}" target="_blank" class="submission-link">Backend GitHub Link &#8599;</a>
            </c:if>
          </div>
        </c:if>

        <form class="score-form" action="<c:url value='/judge/submit-score' />" method="post">
          <input type="hidden" name="_csrf" value="${_csrfToken}">
          <input type="hidden" name="applicationId" value="${s.application.applicationId}">
          <input type="hidden" name="hackathonId" value="${s.application.hackathonId}">

            <div class="score-grid">
              <div class="score-field">
                <label>Idea & Innovation (0-25)</label>
                <input type="number" name="ideaScore" min="0" max="25" value="${s.ideaScore}" required>
              </div>
              <div class="score-field">
                <label>Design & UX (0-25)</label>
                <input type="number" name="designScore" min="0" max="25" value="${s.designScore}" required>
              </div>
              <div class="score-field">
                <label>Execution & Code (0-25)</label>
                <input type="number" name="executionScore" min="0" max="25" value="${s.executionScore}" required>
              </div>
              <div class="score-field">
                <label>Pitch & Presentation (0-25)</label>
                <input type="number" name="pitchScore" min="0" max="25" value="${s.pitchScore}" required>
              </div>
            </div>

            <label>Total Score</label>
            <div class="score-total">
              <div class="score-total-value">${s.givenScore != null ? s.givenScore : 'Not Scored Yet'}</div>
            </div>
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













