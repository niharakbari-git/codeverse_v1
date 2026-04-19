<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create Team</title>
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

.page{display:grid;grid-template-columns:260px 1fr;gap:12px;min-height:calc(100vh - 64px);padding:16px;max-width:1320px;margin:0 auto}
.side{padding:14px}
.side h2{font-size:30px}
.side .links{display:grid;gap:8px;margin-top:10px}
.side .links a{padding:10px;border:2px solid #1f2329;border-radius:12px;text-decoration:none;background:#fff}
.side .links a.active{background:#1f2329;color:#fff}
.content{display:grid;gap:12px}

.wrap{max-width:760px;padding:0}
.card{padding:20px}
h1{font-size:clamp(30px,5vw,48px);margin:0 0 8px}
p{margin:0 0 16px;color:#5e6673}
label{display:block;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;margin-bottom:6px}
.actions{display:flex;gap:8px;margin-top:14px;flex-wrap:wrap}
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
    <a class="active" href="<c:url value='/participant/participant-dashboard' />">Dashboard</a>
    <a href="<c:url value='/logout' />">Logout</a>
  </nav>
</header>

<div class="neo-shell page">
  <aside class="neo-panel side" data-reveal>
    <div class="neo-badge">Participant Features</div>
    <h2 class="neo-title">Workspace</h2>
    <div class="links">
      <a href="<c:url value='/participant/home' />">Explore Hackathons</a>
      <a href="<c:url value='/participant/my-applications' />">My Applications</a>
      <a class="active" href="<c:url value='/participant/my-teams' />">My Teams</a>
      <a href="<c:url value='/participant/profile' />">Profile</a>
      <a href="<c:url value='/charge' />">Open Payments</a>
    </div>
  </aside>

  <main class="content">
<div class="wrap">
  <div class="neo-panel card" data-reveal>
    <h1 class="neo-title">Create Team</h1>
    <p>Apply to <strong>${hackathon.title}</strong> by creating your team.</p>
    <form action="<c:url value='/participant/team/create' />" method="post">
      <input type="hidden" name="_csrf" value="${_csrfToken}">
      <input type="hidden" name="hackathonId" value="${hackathon.hackathonId}">
      <label for="teamName">Team Name</label>
      <input id="teamName" type="text" name="teamName" placeholder="e.g. CodeStorm" required>
      <div class="actions">
        <button type="submit">Create Team & Apply</button>
        <a class="btn" href="<c:url value='/participant/hackathon/${hackathon.hackathonId}' />">Back</a>
      </div>
    </form>
  </div>
</div>
  </main>
</div>
<%@ include file="../shared/Toast.jspf" %>
</body>
</html>















