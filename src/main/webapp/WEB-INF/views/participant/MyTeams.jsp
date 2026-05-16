<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Teams</title>
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

.page{display:grid;grid-template-columns:260px 1fr;gap:12px;min-height:calc(100vh - 64px);padding:16px;max-width:1320px;margin:0 auto}
.side{padding:14px}
.side h2{font-size:30px}
.side .links{display:grid;gap:8px;margin-top:10px}
.side .links a{padding:10px;border:2px solid #1f2329;border-radius:12px;text-decoration:none;background:#fff}
.side .links a.active{background:#1f2329;color:#fff}
.content{display:grid;gap:12px}
.wrap{padding:0}
.top{display:flex;justify-content:space-between;align-items:flex-start;gap:10px;flex-wrap:wrap;margin-bottom:12px}
.actions{display:flex;gap:8px;flex-wrap:wrap}
.workspace-grid{display:grid;grid-template-columns:1.1fr .9fr;gap:10px;margin-bottom:14px}
.workspace-card{padding:12px;border:2px solid #1f2329;border-radius:12px;background:#fff}
.workspace-card h4{margin:0 0 8px;font-size:18px}
.workspace-list{margin:0;padding-left:18px;display:grid;gap:6px;color:#1f2329;font-size:14px;line-height:1.5}
.workspace-hint{margin-top:8px;font-size:12px;color:#5e6673;line-height:1.4}
.workspace-actions{display:grid;gap:8px;margin-top:10px}
.workspace-actions a{display:block;padding:10px 11px;border:2px solid #1f2329;border-radius:10px;text-decoration:none;background:#fff;font-size:13px;font-weight:700}
.workspace-actions a strong{display:block;margin-bottom:2px}
.workspace-actions a small{display:block;color:#5e6673;font-size:11px;font-weight:500}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:12px}
.card{padding:14px}
.card h4{margin:0 0 8px;font-size:16px}
.meta{margin:0;color:#5e6673;line-height:1.6;font-size:13px}
.members{margin:10px 0 8px;padding-left:18px;font-size:13px}
.members li{margin-bottom:4px}
.role{display:inline-block;margin-top:8px;font-size:11px}
.form{display:grid;grid-template-columns:1fr auto;gap:8px;margin-top:10px}
.form input,.form button{font-size:12px;padding:8px 10px;border:1px solid #d7dce5;border-radius:8px}
.form button{background:#1f2329;color:#fff;cursor:pointer;border-color:#1f2329;font-weight:700}
.empty{padding:20px;text-align:center;font-weight:700;color:#5e6673}
@media(max-width:560px){.form{grid-template-columns:1fr}.workspace-grid{grid-template-columns:1fr}}
@media(max-width:860px){.header{height:auto;padding:12px;align-items:flex-start;flex-direction:column}.page{grid-template-columns:1fr}}
</style>
</head>
<body>
<c:if test="${not empty param.msg}">
  <div id="toast-data" data-type="${param.type == 'success' ? 'success' : 'error'}" style="display:none;"><c:out value="${param.msg}" /></div>
</c:if>
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
  <div class="top" data-reveal>
    <div>
      <h2 class="neo-title">My Teams</h2>
      <p class="neo-sub">Manage team members for active hackathons.</p>
    </div>
  </div>

  <c:if test="${not empty teamViews}">
    <section class="neo-panel workspace-grid" data-reveal>
      <article class="workspace-card">
        <h4>Team Management Steps</h4>
        <ol class="workspace-list">
          <li>Review current team members and their roles.</li>
          <li>Add new members by their email address (if you're the leader).</li>
          <li>For campus-only hackathons, members must verify their campus email with OTP before joining.</li>
          <li>Keep team information updated before submission deadline.</li>
        </ol>
        <p class="workspace-hint">All team members receive notifications when added. They can view the team details from their dashboard.</p>
      </article>
      <article class="workspace-card">
        <h4>Quick Actions</h4>
        <div class="workspace-actions">
          <a href="<c:url value='/participant/my-applications' />"><strong>View Applications</strong><small>Check team's hackathon status</small></a>
          <a href="<c:url value='/participant/home' />"><strong>Explore More</strong><small>Join additional hackathons</small></a>
        </div>
      </article>
    </section>
  </c:if>

  <c:if test="${empty teamViews}">
    <div class="neo-panel empty" data-reveal>
      <p>No teams yet.</p>
      <p><small>Create a team when you apply to a hackathon. Navigate to Explore Hackathons to get started.</small></p>
      <a class="btn" href="<c:url value='/participant/home' />" style="margin-top:10px;display:inline-block">Explore Hackathons</a>
    </div>
  </c:if>

  <c:if test="${not empty teamViews}">
    <section>
      <h3 class="neo-title" style="padding:0 14px;margin-bottom:8px">Active Teams (${teamViews.size()})</h3>
      <div class="grid" data-reveal>
        <c:forEach items="${teamViews}" var="t">
          <div class="neo-panel card">
            <h4>${t.team.teamName}</h4>
            <p class="meta"><strong>Leader:</strong> ${t.leaderName}</p>
            <p class="meta"><strong>Hackathon:</strong> ${t.hackathonTitle}</p>
            <p class="meta"><strong>Members:</strong> ${t.memberCount}</p>
            <span class="neo-badge role">${t.roleInTeam}</span>
            <fmt:parseDate value="${t.team.createdAt}" pattern="yyyy-MM-dd" var="parsedCreatedAt" type="date" />
            <p class="meta"><strong>Created:</strong> <fmt:formatDate value="${parsedCreatedAt}" pattern="dd-MM-yyyy" /></p>

            <p class="meta" style="margin-top:8px;font-weight:700">Team Members:</p>
            <ul class="members">
              <c:forEach items="${t.memberNames}" var="memberName">
                <li>${memberName}</li>
              </c:forEach>
            </ul>

            <c:choose>
              <c:when test="${t.canManageMembers}">
                <form class="form" action="<c:url value='/participant/team/add-member' />" method="post">
                  <input type="hidden" name="_csrf" value="${_csrfToken}">
                  <input type="hidden" name="teamId" value="${t.team.teamId}">
                  <input type="email" name="memberEmail" placeholder="Add member by email" required>
                  <button type="submit">Add Member</button>
                </form>
              </c:when>
              <c:otherwise>
                <p class="meta" style="margin-top:10px;color:#8a5a00;font-weight:700">${empty t.memberManagementNote ? 'Member management is currently unavailable.' : t.memberManagementNote}</p>
              </c:otherwise>
            </c:choose>
          </div>
        </c:forEach>
      </div>
    </section>
  </c:if>
</div>
  </main>
</div>
<%@ include file="../shared/Toast.jspf" %>
</body>
</html>
