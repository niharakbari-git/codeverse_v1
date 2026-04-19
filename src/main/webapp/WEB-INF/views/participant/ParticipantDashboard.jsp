<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Participant Dashboard</title>
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
.main{display:grid;gap:12px}
.hero{padding:16px;background:#1f2937;color:#fff}
.hero h1{font-size:clamp(34px,5vw,56px)}
.hero p{margin-top:8px;color:#fff4ef}
.metric-grid{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:12px}
.metric{padding:12px;border:2px solid #1f2329;border-radius:14px;background:#fff;display:block;text-decoration:none;color:inherit;transition:transform .18s ease,box-shadow .18s ease}
.metric:hover{transform:translateY(-2px)}
.metric.active{background:#eef4ff;color:#1f2329;border-color:#9fb4d9;box-shadow:0 6px 14px rgba(31,41,55,.08)}
.metric .k{font-size:11px;text-transform:uppercase;color:inherit;opacity:.72;font-weight:700}
.metric .v{font-size:34px;font-family:"Syne",sans-serif;line-height:1;margin-top:4px}
.app-metrics{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px;margin-bottom:14px}
.app-metric{padding:12px;border:2px solid #1f2329;border-radius:14px;background:#fff;transition:transform .18s ease,box-shadow .18s ease}
.app-metric:hover{transform:translateY(-2px);box-shadow:0 6px 14px rgba(31,41,55,.08)}
.app-metric-label{font-size:11px;text-transform:uppercase;color:#5e6673;font-weight:700;letter-spacing:.05em}
.app-metric-value{font-size:28px;font-family:"Syne",sans-serif;font-weight:800;line-height:1;margin-top:4px}
.app-metric-status{font-size:11px;margin-top:6px;font-weight:500}
.status-applied{color:#0f766e}
.status-approved{color:#1f2937}
.status-submitted{color:#0369a1}
.status-scored{color:#059669}
.workspace{padding:14px}
.workspace h3{font-size:30px}
.workspace-grid{display:grid;grid-template-columns:1.1fr .9fr;gap:10px;margin-top:10px}
.workspace-card{padding:12px;border:2px solid #1f2329;border-radius:12px;background:#fff}
.workspace-card h4{margin:0 0 8px;font-size:22px}
.workspace-list{margin:0;padding-left:18px;display:grid;gap:6px;color:#1f2329}
.workspace-list li{line-height:1.4}
.workspace-hint{margin-top:8px;font-size:13px;color:#5e6673;line-height:1.45}
.workspace-actions{display:grid;gap:8px;margin-top:10px}
.workspace-actions a{display:block;padding:11px 12px;border:2px solid #1f2329;border-radius:12px;text-decoration:none;background:#fff}
.workspace-actions a strong{display:block}
.workspace-actions a small{display:block;margin-top:3px;color:#5e6673}
@media(max-width:1100px){.metric-grid{grid-template-columns:repeat(2,minmax(0,1fr))}.app-metrics{grid-template-columns:1fr}.workspace-grid{grid-template-columns:1fr}}
@media(max-width:860px){.header{height:auto;padding:12px;align-items:flex-start;flex-direction:column}.page{grid-template-columns:1fr}.metric-grid{grid-template-columns:1fr}}
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
      <a href="<c:url value='/participant/my-teams' />">My Teams</a>
      <a href="<c:url value='/participant/profile' />">Profile</a>
      <a href="<c:url value='/charge' />">Open Payments</a>
    </div>
  </aside>

  <main class="main">
    <section class="neo-panel hero" data-reveal>
      <h1 class="neo-title">Participant Dashboard</h1>
      <p>Welcome ${sessionScope.user.firstName}. Track available hackathons and your participation journey.</p>
    </section>

    <section class="metric-grid" data-reveal>
      <a class="metric ${selectedView == 'ALL' ? 'active' : ''}" href="<c:url value='/participant/home?view=all' />"><div class="k">Total Hackathons</div><div class="v">${totalHackathons}</div></a>
      <a class="metric ${selectedView == 'LIVE' ? 'active' : ''}" href="<c:url value='/participant/home?view=live' />"><div class="k">Live Hackathons</div><div class="v">${liveHackathons}</div></a>
      <a class="metric ${selectedView == 'UPCOMING' ? 'active' : ''}" href="<c:url value='/participant/home?view=upcoming' />"><div class="k">Upcoming Hackathons</div><div class="v">${upcomingHackathons}</div></a>
      <a class="metric ${selectedView == 'FREE' ? 'active' : ''}" href="<c:url value='/participant/home?view=free' />"><div class="k">Free Events</div><div class="v">${freeHackathons}</div></a>
      <a class="metric ${selectedView == 'PAID' ? 'active' : ''}" href="<c:url value='/participant/home?view=paid' />"><div class="k">Paid Events</div><div class="v">${paidHackathons}</div></a>
    </section>

    <section class="neo-panel workspace" data-reveal>
      <h3 class="neo-title">Application Status</h3>
      <div class="app-metrics">
        <div class="app-metric">
          <div class="app-metric-label">Applied</div>
          <div class="app-metric-value">${applicationStats.applied != null ? applicationStats.applied : 0}</div>
          <div class="app-metric-status status-applied">Awaiting Decision</div>
        </div>
        <div class="app-metric">
          <div class="app-metric-label">Approved</div>
          <div class="app-metric-value">${applicationStats.approved != null ? applicationStats.approved : 0}</div>
          <div class="app-metric-status status-approved">Ready to Submit</div>
        </div>
        <div class="app-metric">
          <div class="app-metric-label">Submitted</div>
          <div class="app-metric-value">${applicationStats.submitted != null ? applicationStats.submitted : 0}</div>
          <div class="app-metric-status status-submitted">Under Review</div>
        </div>
      </div>
    </section>

    <section class="neo-panel workspace" data-reveal>
      <h3 class="neo-title">Participant Workspace</h3>
      <div class="workspace-grid">
        <article class="workspace-card">
          <h4>What To Do Next</h4>
          <ol class="workspace-list">
            <li>Explore hackathons that match your preferred team size and entry type.</li>
            <li>Submit applications and keep payment status completed.</li>
            <li>Manage team members and update your profile before final submission.</li>
          </ol>
          <p class="workspace-hint">Use the left panel for navigation and this area as your day-to-day action guide.</p>
        </article>
        <article class="workspace-card">
          <h4>Quick Start</h4>
          <div class="workspace-actions">
            <a href="<c:url value='/participant/home' />"><strong>Explore Hackathons</strong><small>Browse and filter active opportunities.</small></a>
            <a href="<c:url value='/participant/my-applications' />"><strong>Open My Applications</strong><small>Track status, submission, and payment details.</small></a>
            <a href="<c:url value='/participant/my-teams' />"><strong>Manage My Teams</strong><small>Update team lineup and members quickly.</small></a>
            <a href="<c:url value='/participant/profile' />"><strong>Update Profile</strong><small>Keep contact and social information current.</small></a>
            <a href="<c:url value='/charge' />"><strong>Open Payments</strong><small>Access payment workflow when required.</small></a>
          </div>
        </article>
      </div>
    </section>
  </main>
</div>
<%@ include file="../shared/Toast.jspf" %>
</body>
</html>
