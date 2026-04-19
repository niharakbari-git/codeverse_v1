<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Judge Dashboard</title>
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
.main{display:grid;gap:12px}
.hero{padding:16px;background:#1f2937;color:#fff}
.hero h1{font-size:clamp(34px,5vw,56px)}
.hero p{margin-top:8px;color:#ebfffb}
.rail{padding:14px}
.rail h3{font-size:28px}
.rail-links{display:grid;gap:8px;margin-top:10px}
.rail-links a{display:block;padding:10px;border:2px solid #1f2329;border-radius:12px;background:#fff;text-decoration:none}
.rail-links a.active{background:#1f2329;color:#fff;border-color:#1f2329}
.rail-note{margin-top:10px;color:#5e6673;font-size:13px;line-height:1.5}
.content-stack{display:grid;gap:12px}
.metric-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px}
.metric{padding:12px;border:2px solid #1f2329;border-radius:14px;background:#fff;display:block;text-decoration:none;color:inherit;transition:transform .18s ease,box-shadow .18s ease}
.metric:hover{transform:translateY(-2px)}
.metric .k{font-size:11px;text-transform:uppercase;color:inherit;opacity:.72;font-weight:700}
.metric .v{font-size:34px;font-family:"Syne",sans-serif;line-height:1;margin-top:4px}
.workspace{padding:14px}
.workspace h3{font-size:30px}
.workspace-grid{display:grid;grid-template-columns:1.1fr .9fr;gap:10px;margin-top:10px}
.workspace-card{padding:12px;border:2px solid #1f2329;border-radius:12px;background:#fff}
.workspace-card h4{margin:0 0 8px;font-size:22px}
.todo-list{margin:0;padding-left:18px;display:grid;gap:6px;color:#1f2329}
.todo-list li{line-height:1.4}
.hint{margin-top:8px;font-size:13px;color:#5e6673;line-height:1.45}
.workspace-actions{display:grid;gap:8px;margin-top:10px}
.workspace-actions a{display:block;padding:11px 12px;border:2px solid #1f2329;border-radius:12px;text-decoration:none;background:#fff}
.workspace-actions a strong{display:block}
.workspace-actions a small{display:block;margin-top:3px;color:#5e6673}
@media(max-width:980px){.page,.metric-grid,.workspace-grid{grid-template-columns:1fr}}
@media(max-width:860px){.header{height:auto;padding:12px;align-items:flex-start;flex-direction:column}}
</style>
</head>
<body>
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
        <a class="active" href="<c:url value='/judge/my-assignments' />">My Assignments</a>
        <a href="<c:url value='/judge/scorecards' />">Scorecards</a>
        <a href="<c:url value='/participant/home' />">Explore Events</a>
      </div>
    </aside>

    <main class="main">
    <section class="neo-panel hero" data-reveal>
      <h1 class="neo-title">Judge Dashboard</h1>
      <p>Welcome, ${sessionScope.user.firstName}. Evaluate submissions and keep scoring progress on track.</p>
    </section>

      <div class="content-stack">
        <section class="metric-grid" data-reveal>
          <a class="metric" href="<c:url value='/judge/my-assignments' />"><div class="k">Assigned Hackathons</div><div class="v">${totalAssigned}</div></a>
          <a class="metric" href="<c:url value='/judge/scorecards' />"><div class="k">Evaluated</div><div class="v">${totalEvaluated}</div></a>
          <a class="metric" href="<c:url value='/judge/scorecards' />"><div class="k">Pending</div><div class="v">${totalPending}</div></a>
        </section>

        <section class="neo-panel workspace" data-reveal>
          <h3 class="neo-title">Active Assignments</h3>
          <c:choose>
            <c:when test="${empty judgeTasks}">
              <p class="rail-note" style="margin-top:10px">No assignments yet. Check back when an organizer assigns you to a hackathon.</p>
            </c:when>
            <c:otherwise>
              <div class="table-response" style="margin-top:12px; overflow-x:auto;">
                <table style="width:100%; border-collapse:collapse; text-align:left; font-size:14px; border:2px solid #1f2329; border-radius:12px; overflow:hidden; background:#fff;">
                  <thead>
                    <tr style="background:#1f2937; color:#fff;">
                      <th style="padding:12px 14px; font-weight:700; border-bottom:2px solid #1f2329;">Hackathon</th>
                      <th style="padding:12px 14px; font-weight:700; border-bottom:2px solid #1f2329; text-align:center;">Total Subs</th>
                      <th style="padding:12px 14px; font-weight:700; border-bottom:2px solid #1f2329; text-align:center;">Evaluated</th>
                      <th style="padding:12px 14px; font-weight:700; border-bottom:2px solid #1f2329; text-align:center;">Pending</th>
                      <th style="padding:12px 14px; font-weight:700; border-bottom:2px solid #1f2329; text-align:right;">Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="t" items="${judgeTasks}">
                      <tr style="border-bottom:1px solid #d7dce5;">
                        <td style="padding:12px 14px; font-weight:500; color:#1f2329;">${t.hackathonTitle}</td>
                        <td style="padding:12px 14px; text-align:center;">${t.totalSubmissions}</td>
                        <td style="padding:12px 14px; text-align:center; color:#0f766e;">${t.evaluated}</td>
                        <td style="padding:12px 14px; text-align:center; color:#dc2626; font-weight:700;">${t.pending}</td>
                        <td style="padding:12px 14px; text-align:right;">
                          <a href="<c:url value='/judge/scorecards?hackathonId=${t.hackathonId}' />" style="display:inline-block; padding:6px 12px; background:#1f2329; color:#fff; text-decoration:none; border-radius:6px; font-size:12px; font-weight:700;">Score</a>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </c:otherwise>
          </c:choose>
        </section>

        <section class="neo-panel workspace" data-reveal>
          <h3 class="neo-title">Judge Workspace</h3>
          <div class="workspace-grid">
            <article class="workspace-card">
              <h4>Next Steps</h4>
              <ol class="todo-list">
                <li>Open assigned hackathons and verify submission completeness.</li>
                <li>Score entries using idea, design, execution, and pitch criteria.</li>
                <li>Add short remarks so participants understand improvement points.</li>
              </ol>
              <p class="hint">Tip: prioritize pending entries first to keep leaderboard updates timely.</p>
            </article>
            <article class="workspace-card">
              <h4>Scoring Focus</h4>
              <p class="hint">Default rubric weight per submission:</p>
              <ul class="todo-list">
                <li>Idea & Innovation: 25</li>
                <li>Design & UX: 25</li>
                <li>Execution & Code: 25</li>
                <li>Pitch & Presentation: 25</li>
              </ul>
            </article>
          </div>
          <div class="workspace-actions">
            <a href="<c:url value='/judge/my-assignments' />"><strong>Start With Assignments</strong><small>Review event list and pick the next submission batch.</small></a>
            <a href="<c:url value='/judge/scorecards' />"><strong>Continue Scoring</strong><small>Directly open scorecards and submit evaluations.</small></a>
          </div>
        </section>
      </div>
    </main>
  </div>
<%@ include file="../shared/Toast.jspf" %>
</body>
</html>


