<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Judge Assignments</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260512c"></script>
<style>
.header{position:sticky;top:0;z-index:100;height:64px;display:flex;align-items:center;justify-content:space-between;gap:10px;padding:0 24px;background:rgba(247,244,236,.92);backdrop-filter:blur(8px);border-bottom:1px solid #d7dce5}
.logo{display:flex;align-items:center;gap:10px;text-decoration:none;color:#1f2329}
.logo-icon{width:34px;height:34px;border-radius:10px;display:grid;place-items:center;background:#1f2937;color:#fff;font-weight:700}
.logo-text{font-family:'Space Grotesk',sans-serif;font-size:16px;font-weight:700;letter-spacing:.04em}
.nav-links{display:flex;align-items:center;gap:8px;flex-wrap:wrap}
.nav-links a{text-decoration:none;border:1px solid #d7dce5;border-radius:10px;background:#fff;color:#1f2329;font-size:13px;font-weight:700;padding:8px 12px}
.nav-links a:hover{background:#f5f7fb}
.nav-links a.active{background:#1f2329;color:#fff;border-color:#1f2329}

.page{display:grid;grid-template-columns:240px 1fr;gap:12px;min-height:calc(100vh - 64px);padding:16px;max-width:1320px;margin:0 auto}
.side{padding:14px}
.side h2{font-size:30px}
.side .links{display:grid;gap:8px;margin-top:10px}
.side .links a{padding:10px;border:2px solid #1f2329;border-radius:12px;text-decoration:none;background:#fff}
.side .links a.active{background:#1f2329;color:#fff}
.main{display:flex;flex-direction:column;gap:12px;flex:1;min-width:0}
.hero{padding:16px;background:#1f2937;color:#fff;flex-shrink:0}
.hero h1{font-size:clamp(32px,5vw,52px)}
.hero p{margin-top:8px;color:#ecfffb}
.assignment-form-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px}
.assignment-form-card{padding:14px;display:flex;flex-direction:column;gap:12px;min-width:0}
.assignment-form-copy{display:grid;gap:6px}
.assignment-form-copy .eyebrow{font-size:12px;font-weight:800;text-transform:uppercase;letter-spacing:.08em;color:#0f766e}
.assignment-form-copy h3{font-size:20px;line-height:1.1}
.assignment-form-copy p{color:#52606d;font-size:14px;line-height:1.5}
.form{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px;align-items:end}
.field{margin:0;min-width:0}
.field label{display:block;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;margin-bottom:6px}
.field select,.field input{width:100%;min-width:0}
.form-action{align-self:end}
.form-action button{width:100%}
.assignments-panel{display:flex;flex-direction:column;gap:14px;padding:14px}
.panel-head{display:flex;align-items:flex-start;justify-content:space-between;gap:12px;flex-wrap:wrap}
.panel-head h3{font-size:24px}
.panel-head p{margin-top:4px;color:#52606d;font-size:14px}
.panel-metrics{display:flex;gap:8px;flex-wrap:wrap}
.metric-pill{display:inline-flex;align-items:center;gap:6px;padding:8px 12px;border-radius:999px;background:#eef3f8;color:#1f2937;font-size:12px;font-weight:700;border:1px solid #d7dce5}
.assignment-grid{display:grid;gap:12px}
.assignment-card{border:1px solid #d7dce5;border-radius:18px;background:#fff;overflow:hidden;box-shadow:0 10px 24px rgba(31,35,41,.05)}
.assignment-card[open]{border-color:#cfd8e3}
.assignment-summary{list-style:none;display:flex;align-items:center;justify-content:space-between;gap:12px;padding:16px 18px;background:linear-gradient(180deg,#ffffff 0%,#f7f9fc 100%);cursor:pointer}
.assignment-summary::-webkit-details-marker{display:none}
.assignment-summary-left{display:grid;gap:4px;min-width:0}
.assignment-summary-left h4{font-size:20px;line-height:1.15;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.assignment-summary-left p{font-size:13px;color:#52606d}
.assignment-summary-right{display:flex;align-items:center;gap:8px;flex-wrap:wrap;justify-content:flex-end}
.count-badge,.date-badge{display:inline-flex;align-items:center;gap:6px;padding:8px 12px;border-radius:999px;font-size:12px;font-weight:800;white-space:nowrap}
.count-badge{background:#1f2329;color:#fff}
.date-badge{background:#e7f4f1;color:#0f766e;border:1px solid #c8e9e1}
.assignment-body{padding:0 18px 18px}
.judge-list{display:grid;gap:10px}
.judge-row{display:grid;grid-template-columns:minmax(0,1fr) auto;gap:12px;align-items:center;padding:14px;border:1px solid #e3e7ee;border-radius:14px;background:#fff}
.judge-info{min-width:0}
.judge-name{font-size:15px;font-weight:800;color:#1f2329;line-height:1.2}
.judge-email{margin-top:4px;font-size:13px;color:#52606d;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.judge-date{display:grid;justify-items:end;gap:4px;text-align:right}
.judge-date .label{font-size:11px;font-weight:800;text-transform:uppercase;letter-spacing:.08em;color:#52606d}
.judge-date .value{font-size:14px;font-weight:800;color:#1f2329}
.empty{padding:16px;text-align:center;font-weight:700}
.empty.compact{border:1px dashed #d7dce5;border-radius:14px;background:#fafbfc}
@media(max-width:1080px){.assignment-form-grid{grid-template-columns:1fr}.form{grid-template-columns:1fr 1fr}}
@media(max-width:860px){.header{height:auto;padding:12px;align-items:flex-start;flex-direction:column}.page{grid-template-columns:1fr}.assignment-summary,.judge-row{grid-template-columns:1fr}.assignment-summary-right,.judge-date{justify-items:flex-start;justify-content:flex-start;text-align:left}.form{grid-template-columns:1fr}}
</style>
</head>
<body>
<header class="header">
  <a class="logo" href="<c:url value='/participant/home' />">
    <div class="logo-icon">CV</div>
    <span class="logo-text">CODEVERSE</span>
  </a>
  <nav class="nav-links">
    <a href="<c:url value='/participant/home' />">Explore</a>
    <a class="active" href="<c:url value='/organizer-dashboard' />">Dashboard</a>
    <a href="<c:url value='/logout' />">Logout</a>
  </nav>
</header>
<div class="neo-shell page">
  <aside class="neo-panel side" data-reveal>
    <div class="neo-badge">Role Features</div>
    <h2 class="neo-title">Control</h2>
    <div class="links">
      <a href="<c:url value='/newHackathon' />">Create Hackathon</a>
      <a href="<c:url value='/listHackathon' />">My Hackathons</a>
      <a class="active" href="<c:url value='/organizer/judge-assignments' />">Assign Judges</a>
      <a href="<c:url value='/organizer/applications' />">Applications</a>
      <a href="<c:url value='/organizer/results' />">Results</a>
      <a href="<c:url value='/organizer/profile' />">Profile</a>
    </div>
  </aside>

  <main class="main">
    <section class="neo-panel hero" data-reveal>
      <h1 class="neo-title">Judge Assignments</h1>
      <p>Use your own judges (faculty, alumni, industry mentors) and map them to each hackathon.</p>
    </section>

    <section class="neo-panel assignment-form-grid" data-reveal>
      <div class="neo-panel assignment-form-card">
        <div class="assignment-form-copy">
          <div class="eyebrow">Existing Judge</div>
          <h3 class="neo-title">Assign from the judge list</h3>
          <p>Select a judge account and attach it to the hackathon you manage.</p>
        </div>
        <form class="form" action="<c:url value='/organizer/assign-judge' />" method="post">
          <input type="hidden" name="_csrf" value="${_csrfToken}">
          <div class="field">
            <label>Hackathon</label>
            <select name="hackathonId" required>
              <option value="">-- Select Hackathon --</option>
              <c:forEach items="${myHackathons}" var="h">
                <option value="${h.hackathonId}">${h.title}</option>
              </c:forEach>
            </select>
          </div>
          <div class="field">
            <label>Judge</label>
            <select name="judgeUserId" required>
              <option value="">-- Select Judge --</option>
              <c:forEach items="${judges}" var="j">
                <option value="${j.userId}">${j.firstName} ${j.lastName} (${j.email})</option>
              </c:forEach>
            </select>
          </div>
          <div class="form-action">
            <button type="submit">Assign Judge</button>
          </div>
        </form>
      </div>

      <div class="neo-panel assignment-form-card">
        <div class="assignment-form-copy">
          <div class="eyebrow">Direct Email</div>
          <h3 class="neo-title">Assign by email</h3>
          <p>Promote a participant account to judge if needed, then assign them in one step.</p>
        </div>
        <form class="form" action="<c:url value='/organizer/assign-judge-by-email' />" method="post">
          <input type="hidden" name="_csrf" value="${_csrfToken}">
          <div class="field">
            <label>Hackathon</label>
            <select name="hackathonId" required>
              <option value="">-- Select Hackathon --</option>
              <c:forEach items="${myHackathons}" var="h">
                <option value="${h.hackathonId}">${h.title}</option>
              </c:forEach>
            </select>
          </div>
          <div class="field">
            <label>Judge Email</label>
            <input type="email" name="judgeEmail" placeholder="judge@example.com" required>
          </div>
          <div class="form-action">
            <button type="submit">Assign by Email</button>
          </div>
        </form>
      </div>
    </section>

    <section class="neo-panel assignments-panel" data-reveal>
      <div class="panel-head">
        <div>
          <div class="neo-badge">Assignments</div>
          <h3 class="neo-title">Grouped by Hackathon</h3>
          <p>Each hackathon opens into a compact judge list with assignment dates.</p>
        </div>
        <div class="panel-metrics">
          <span class="metric-pill">${assignmentGroups.size()} hackathons</span>
          <span class="metric-pill">${judges.size()} judges available</span>
        </div>
      </div>

      <c:choose>
        <c:when test="${empty assignmentGroups}">
          <div class="empty">No hackathons available to assign judges.</div>
        </c:when>
        <c:otherwise>
          <div class="assignment-grid">
            <c:forEach items="${assignmentGroups}" var="group">
              <details class="assignment-card" open>
                <summary class="assignment-summary">
                  <div class="assignment-summary-left">
                    <h4>${group.hackathonTitle}</h4>
                    <p>Hackathon ID #${group.hackathonId}</p>
                  </div>
                  <div class="assignment-summary-right">
                    <span class="count-badge">${group.judgeCount} judge<c:if test="${group.judgeCount != 1}">s</c:if></span>
                    <c:if test="${not empty group.latestAssignedAtLabel}">
                      <span class="date-badge">Latest: ${group.latestAssignedAtLabel}</span>
                    </c:if>
                  </div>
                </summary>

                <div class="assignment-body">
                  <c:choose>
                    <c:when test="${empty group.judges}">
                      <div class="empty compact">No judges assigned yet.</div>
                    </c:when>
                    <c:otherwise>
                      <div class="judge-list">
                        <c:forEach items="${group.judges}" var="judge">
                          <article class="judge-row">
                            <div class="judge-info">
                              <div class="judge-name">${judge.judgeName}</div>
                              <c:if test="${not empty judge.judgeEmail}">
                                <div class="judge-email">${judge.judgeEmail}</div>
                              </c:if>
                            </div>
                            <div class="judge-date">
                              <div class="label">Assigned On</div>
                              <div class="value">${judge.assignedAtLabel}</div>
                            </div>
                          </article>
                        </c:forEach>
                      </div>
                    </c:otherwise>
                  </c:choose>
                </div>
              </details>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>
    </section>
  </main>
</div>
<%@ include file="../shared/Toast.jspf" %>
</body>
</html>
















