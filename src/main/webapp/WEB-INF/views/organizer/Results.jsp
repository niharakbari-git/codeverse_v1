<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Results</title>
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

.page{display:grid;grid-template-columns:240px 1fr;gap:12px;min-height:calc(100vh - 64px);padding:16px;max-width:1320px;margin:0 auto}
.side{padding:14px}
.side h2{font-size:30px}
.side .links{display:grid;gap:8px;margin-top:10px}
.side .links a{padding:10px;border:2px solid #1f2329;border-radius:12px;text-decoration:none;background:#fff}
.side .links a.active{background:#1f2329;color:#fff}
.main{display:flex;flex-direction:column;gap:12px;flex:1}
.hero{padding:16px;background:#1f2937;color:#fff;flex-shrink:0}
.hero h1{font-size:clamp(32px,5vw,52px)}
.hero p{margin-top:8px;color:#fff4ef}
.filter{padding:8px 14px;display:flex;gap:10px;align-items:flex-end;flex-wrap:wrap;min-height:0;margin:0;flex-shrink:0}
.field{margin:0;flex:1 1 420px}
.field label{display:block;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;margin-bottom:6px}
.filter-action{align-self:flex-end;flex:0 0 auto}
.panel{padding:10px;overflow:auto;flex:1;display:flex;flex-direction:column}
table{min-width:760px}
.rank{font-weight:800}
.empty{padding:16px;text-align:center;font-weight:700}
@media(max-width:980px){.filter{align-items:stretch}.filter-action{align-self:stretch}}
@media(max-width:860px){.header{height:auto;padding:12px;align-items:flex-start;flex-direction:column}.page{grid-template-columns:1fr}}
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
      <a href="<c:url value='/organizer/judge-assignments' />">Assign Judges</a>
      <a href="<c:url value='/organizer/applications' />">Applications</a>
      <a class="active" href="<c:url value='/organizer/results' />">Results</a>
      <a href="<c:url value='/organizer/profile' />">Profile</a>
    </div>
  </aside>

  <main class="main">
    <section class="neo-panel hero" data-reveal>
      <h1 class="neo-title">Results & Leaderboard</h1>
      <p>Track rankings and final score averages for every application in your selected hackathon.</p>
    </section>

    <form class="neo-panel filter" action="<c:url value='/organizer/results' />" method="get" data-reveal>
      <div class="field">
        <label>Hackathon</label>
        <select name="hackathonId" required>
          <c:forEach items="${myHackathons}" var="h">
            <option value="${h.hackathonId}" ${selectedHackathonId == h.hackathonId ? 'selected' : ''}>${h.title}</option>
          </c:forEach>
        </select>
      </div>
      <div class="filter-action">
        <button type="submit">Load Results</button>
      </div>
    </form>

    <section class="neo-panel panel" data-reveal>
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
              <td><span class="neo-badge status">${r.status}</span></td>
              <td><fmt:formatNumber value="${r.averageScore}" type="number" minFractionDigits="1" maxFractionDigits="2" /></td>
              <td>${r.scoreCount}</td>
            </tr>
          </c:forEach>
          <c:if test="${empty resultViews}">
            <tr><td colspan="6" class="empty">No scored applications yet for this hackathon.</td></tr>
          </c:if>
        </tbody>
      </table>
    </section>
  </main>
</div>
<%@ include file="../shared/Toast.jspf" %>
</body>
</html>
















