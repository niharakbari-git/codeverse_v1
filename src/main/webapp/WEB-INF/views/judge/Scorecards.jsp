<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Judge Scorecards</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260415b">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260415b"></script>
<style>
.header{position:sticky;top:0;z-index:100;height:64px;display:flex;align-items:center;justify-content:space-between;gap:10px;padding:0 24px;background:rgba(247,244,236,.92);backdrop-filter:blur(8px);border-bottom:1px solid #d7dce5}
.logo{display:flex;align-items:center;gap:10px;text-decoration:none;color:#1f2329}
.logo-icon{width:34px;height:34px;border-radius:10px;display:grid;place-items:center;background:#1f2937;color:#fff;font-weight:700}
.logo-text{font-family:'Space Grotesk',sans-serif;font-size:16px;font-weight:700;letter-spacing:.04em}
.nav-links{display:flex;align-items:center;gap:8px;flex-wrap:wrap}
.nav-links a{text-decoration:none;border:1px solid #d7dce5;border-radius:10px;background:#fff;color:#1f2329;font-size:13px;font-weight:700;padding:8px 12px}
.nav-links a:hover{background:#f5f7fb}
.nav-links a.active{background:#1f2329;color:#fff;border-color:#1f2329}

.page{display:grid;grid-template-columns:250px 1fr;gap:12px;max-width:1320px;margin:14px auto;padding:0 16px;align-items:start}
.rail{padding:14px}
.rail h3{font-size:28px}
.rail-links{display:grid;gap:8px;margin-top:10px}
.rail-links a{display:block;padding:10px;border:2px solid #1f2329;border-radius:12px;background:#fff;text-decoration:none}
.rail-links a.active{background:#1f2329;color:#fff;border-color:#1f2329}
.main{display:grid;gap:12px}
.hero{padding:16px;background:#1f2937;color:#fff}
.hero h1{font-size:clamp(32px,5vw,52px)}
.hero p{margin-top:8px;color:#ebfffb}
.filter{padding:14px;display:grid;grid-template-columns:1fr auto;gap:10px;align-items:end}
.field label{display:block;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;margin-bottom:6px}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(410px,1fr));gap:12px}
.card{padding:14px}
.card h4{margin:0 0 8px}
.meta{margin:0 0 10px;color:#5e6673;line-height:1.6}
.submission-box{border:2px solid #1f2329;border-radius:12px;background:#fff;padding:10px;margin-bottom:10px;font-size:13px}
.submission-desc{margin:4px 0}
.submission-link{display:block;margin-top:4px}
.score-form{display:grid;gap:8px}
.score-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:8px}
.score-total-value{font-size:22px;font-weight:800}
.help{font-size:12px;color:#5e6673}
.empty{padding:16px;text-align:center;font-weight:700}
@media(max-width:980px){.grid{grid-template-columns:1fr}.score-grid,.filter{grid-template-columns:1fr}}
@media(max-width:980px){.page{grid-template-columns:1fr}}
@media(max-width:860px){.header{height:auto;padding:12px;align-items:flex-start;flex-direction:column}}
</style>
</head>
<body>
<c:if test="${not empty msg}">
  <div id="toast-data" data-type="${msgType == 'success' ? 'success' : 'error'}" style="display:none;"><c:out value="${msg}" /></div>
</c:if>
<header class="header">
  <a class="logo" href="<c:url value='/judge-dashboard' />">
    <div class="logo-icon">CV</div>
    <span class="logo-text">CODEVERSE</span>
  </a>
  <nav class="nav-links">
    <a href="<c:url value='/participant/home' />">Explore</a>
    <a class="active" href="<c:url value='/judge-dashboard' />">Dashboard</a>
    <a href="<c:url value='/logout' />">Logout</a>
  </nav>
</header>

<div class="neo-shell page">
  <aside class="neo-panel rail" data-reveal>
    <div class="neo-badge">Judge Shortcuts</div>
    <h3 class="neo-title">Review Flow</h3>
    <div class="rail-links">
      <a href="<c:url value='/judge/my-assignments' />">My Assignments</a>
      <a class="active" href="<c:url value='/judge/scorecards' />">Scorecards</a>
      <a href="<c:url value='/participant/home' />">Explore Events</a>
    </div>
  </aside>

<main class="main">
    <section class="neo-panel hero" data-reveal>
      <h1 class="neo-title">Judge Scorecards</h1>
      <p>Evaluate submissions across idea, design, execution, and pitch dimensions.</p>
    </section>

    <form class="neo-panel filter" action="<c:url value='/judge/scorecards' />" method="get" data-reveal>
      <div class="field">
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
      <div class="neo-panel empty" data-reveal>No applications available to score for this hackathon yet.</div>
    </c:if>

    <div class="grid" data-reveal>
      <c:forEach items="${scorecards}" var="s">
        <div class="neo-panel card">
          <h4>Application #${s.application.applicationId}</h4>
          <p class="meta">
            Participant: ${s.participantName}<br>
            Status: ${s.application.status}<br>
            Payment: <c:choose>
              <c:when test="${s.application.paymentStatus == 'PENDING'}">Awaiting Payment</c:when>
              <c:when test="${s.application.paymentStatus == 'PAID'}">Paid</c:when>
              <c:when test="${s.application.paymentStatus == 'FAILED'}">Payment Failed</c:when>
              <c:otherwise>${s.application.paymentStatus}</c:otherwise>
            </c:choose>
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
              <div class="field">
                <label>Idea & Innovation (0-25)</label>
                <input type="number" name="ideaScore" min="0" max="25" value="${s.ideaScore}" required>
              </div>
              <div class="field">
                <label>Design & UX (0-25)</label>
                <input type="number" name="designScore" min="0" max="25" value="${s.designScore}" required>
              </div>
              <div class="field">
                <label>Execution & Code (0-25)</label>
                <input type="number" name="executionScore" min="0" max="25" value="${s.executionScore}" required>
              </div>
              <div class="field">
                <label>Pitch & Presentation (0-25)</label>
                <input type="number" name="pitchScore" min="0" max="25" value="${s.pitchScore}" required>
              </div>
            </div>

            <label>Total Score</label>
            <div class="score-total-value">${s.givenScore != null ? s.givenScore : 'Not Scored Yet'}</div>
            <textarea name="remarks" rows="3" placeholder="Strengths, weaknesses, innovation, execution...">${s.remarks}</textarea>

            <button type="submit">Save Score</button>
            <span class="help">You can resubmit to update your previous score.</span>
          </form>
        </div>
      </c:forEach>
    </div>
  </main>
</div>
<%@ include file="../shared/Toast.jspf" %>
</body>
</html>














