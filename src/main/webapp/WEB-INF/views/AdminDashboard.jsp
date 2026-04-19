<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard</title>
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
.hero h1{font-size:clamp(34px,5vw,58px)}
.dual{display:grid;grid-template-columns:1fr;gap:12px}
.panel{padding:14px}
.metric-link{display:block;text-decoration:none;color:inherit;transition:transform .18s ease,box-shadow .18s ease}
.metric-link:hover{transform:translateY(-2px)}
.metric-link.active{background:#1f2329;color:#fff}
.bars{display:grid;gap:10px;margin-top:10px}
.row{display:grid;grid-template-columns:120px 1fr 52px;gap:8px;align-items:center}
.track{height:14px;border:2px solid #1f2329;border-radius:99px;background:#fff}
.fill{height:100%;width:0;border-radius:99px;background:#0f766e;transition:width .45s ease}

.snapshot{padding:14px}
.snapshot-head{display:flex;align-items:center;justify-content:space-between;gap:10px;flex-wrap:wrap}
.snapshot-head h3{font-size:28px}
.snapshot-head .sub{font-size:13px;color:#5e6673}
.snapshot-table{margin-top:10px;overflow:auto}
.status-pill{display:inline-flex;padding:4px 8px;border:2px solid #1f2329;border-radius:999px;background:#fff;font-size:11px;font-weight:700;text-transform:uppercase}
.snapshot-empty{padding:16px;text-align:center;font-weight:700}
@media(max-width:1060px){.dual{grid-template-columns:1fr}}
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
    <c:choose>
      <c:when test="${sessionScope.user.role == 'ADMIN'}"><a class="active" href="<c:url value='/admin-dashboard' />">Dashboard</a></c:when>
      <c:when test="${sessionScope.user.role == 'ORGANIZER'}"><a class="active" href="<c:url value='/organizer-dashboard' />">Dashboard</a></c:when>
      <c:otherwise><a class="active" href="<c:url value='/judge-dashboard' />">Dashboard</a></c:otherwise>
    </c:choose>
    <a href="<c:url value='/logout' />">Logout</a>
  </nav>
</header>

<div class="neo-shell page">
  <aside class="neo-panel side" data-reveal>
    <div class="neo-badge">Role Features</div>
    <h2 class="neo-title">Control</h2>
    <div class="links">
      <c:choose>
        <c:when test="${sessionScope.user.role == 'ADMIN'}">
          <a href="<c:url value='/admin/user-list' />">User Directory</a>
          <a href="<c:url value='/admin/organizer-requests' />">Organizer Requests</a>
          <a href="<c:url value='/listHackathon' />">Hackathons</a>
          <a href="<c:url value='/listCategory' />">Categories</a>
          <a href="<c:url value='/newHackathon' />">Create Hackathon</a>
          <a href="<c:url value='/charge' />">Open Payments</a>
        </c:when>
        <c:when test="${sessionScope.user.role == 'ORGANIZER'}">
          <a href="<c:url value='/newHackathon' />">Create Hackathon</a>
          <a href="<c:url value='/listHackathon' />">My Hackathons</a>
          <a href="<c:url value='/organizer/judge-assignments' />">Assign Judges</a>
          <a href="<c:url value='/organizer/applications' />">Applications</a>
          <a href="<c:url value='/organizer/results' />">Results</a>
          <a href="<c:url value='/organizer/profile' />">Profile</a>
        </c:when>
        <c:otherwise>
          <a href="<c:url value='/judge/my-assignments' />">My Assignments</a>
          <a href="<c:url value='/judge/scorecards' />">Scorecards</a>
          <a href="<c:url value='/participant/home' />">Explore Events</a>
        </c:otherwise>
      </c:choose>
    </div>
  </aside>

  <main class="main">
    <section class="neo-panel hero" data-reveal>
      <h1 class="neo-title">
        <c:choose>
          <c:when test="${sessionScope.user.role == 'ORGANIZER'}">Organizer Hub</c:when>
          <c:when test="${sessionScope.user.role == 'JUDGE'}">Judge Hub</c:when>
          <c:otherwise>Admin Hub</c:otherwise>
        </c:choose>
      </h1>
      <p class="neo-sub" style="color:#fff">${sessionScope.user.firstName}, monitor events and team activity in one command surface.</p>
      <div style="margin-top:10px"><a class="btn" style="background:#fff;color:#1f2329" href="<c:url value='/charge' />">Open Payments</a></div>
    </section>

    <section class="neo-metric-grid" data-reveal>
      <c:choose>
        <c:when test="${sessionScope.user.role == 'ADMIN'}">
          <a class="neo-metric metric-link ${selectedStatus == 'ALL' ? 'active' : ''}" data-status="ALL" href="<c:url value='/admin-dashboard?status=ALL' />"><div class="k">Total Hackathons</div><div class="v">${totalHackathon}</div></a>
          <a class="neo-metric metric-link ${selectedStatus == 'UPCOMING' ? 'active' : ''}" data-status="UPCOMING" href="<c:url value='/admin-dashboard?status=UPCOMING' />"><div class="k">Upcoming</div><div class="v">${totalUpcoming}</div></a>
          <a class="neo-metric metric-link ${selectedStatus == 'ONGOING' ? 'active' : ''}" data-status="ONGOING" href="<c:url value='/admin-dashboard?status=ONGOING' />"><div class="k">Ongoing</div><div class="v">${totalOngoing}</div></a>
          <a class="neo-metric metric-link ${selectedStatus == 'COMPLETED' ? 'active' : ''}" data-status="COMPLETED" href="<c:url value='/admin-dashboard?status=COMPLETED' />"><div class="k">Completed</div><div class="v">${totalCompleted}</div></a>
        </c:when>
        <c:otherwise>
          <a class="neo-metric metric-link ${selectedStatus == 'ALL' ? 'active' : ''}" data-status="ALL" href="<c:url value='/organizer-dashboard?status=ALL' />"><div class="k">Total Hackathons</div><div class="v">${totalHackathon}</div></a>
          <a class="neo-metric metric-link ${selectedStatus == 'UPCOMING' ? 'active' : ''}" data-status="UPCOMING" href="<c:url value='/organizer-dashboard?status=UPCOMING' />"><div class="k">Upcoming</div><div class="v">${totalUpcoming}</div></a>
          <a class="neo-metric metric-link ${selectedStatus == 'ONGOING' ? 'active' : ''}" data-status="ONGOING" href="<c:url value='/organizer-dashboard?status=ONGOING' />"><div class="k">Ongoing</div><div class="v">${totalOngoing}</div></a>
          <a class="neo-metric metric-link ${selectedStatus == 'COMPLETED' ? 'active' : ''}" data-status="COMPLETED" href="<c:url value='/organizer-dashboard?status=COMPLETED' />"><div class="k">Completed</div><div class="v">${totalCompleted}</div></a>
        </c:otherwise>
      </c:choose>
      <c:choose>
        <c:when test="${sessionScope.user.role == 'ADMIN'}">
          <a class="neo-metric metric-link" href="<c:url value='/admin/user-list?role=PARTICIPANT' />"><div class="k">Participants</div><div class="v">${totalParticipant}</div></a>
        </c:when>
        <c:otherwise>
          <a class="neo-metric metric-link" href="<c:url value='/organizer/applications' />"><div class="k">Participants</div><div class="v">${totalParticipant}</div></a>
        </c:otherwise>
      </c:choose>
    </section>

    <section class="neo-panel snapshot" data-reveal>
      <div class="snapshot-head">
        <div>
          <h3 class="neo-title">Hackathon Snapshot</h3>
          <div class="sub" id="snapshotSub">Showing ${dashboardHackathonCount} entries for status: ${selectedStatus}</div>
        </div>
        <a class="btn" href="<c:url value='/listHackathon' />">Open Full List</a>
      </div>
      <div class="snapshot-table">
        <table>
          <thead>
            <tr>
              <th>Title</th>
              <th>Registration End</th>
              <th>Status</th>
              <th>Payment</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${allDashboardHackathons}" var="h">
              <tr class="snapshot-row" data-status="${h.displayStatus}">
                <td><c:out value="${h.title}"/></td>
                <td><c:out value="${h.registrationEndDate}"/></td>
                <td><span class="status-pill"><c:out value="${h.displayStatus}"/></span></td>
                <td><c:out value="${h.payment}"/></td>
                <td><a class="btn" href="<c:url value='/viewHackathon?hackathonId=${h.hackathonId}' />">View</a></td>
              </tr>
            </c:forEach>
            <tr id="snapshotEmpty" style="display:none;"><td colspan="5" class="snapshot-empty">No hackathons found for this filter.</td></tr>
          </tbody>
        </table>
      </div>
    </section>

    <section class="dual">
      <article class="neo-panel panel chart" data-total="${totalHackathon}" data-upcoming="${totalUpcoming}" data-ongoing="${totalOngoing}" data-completed="${totalCompleted}" data-participant="${totalParticipant}" data-reveal>
        <h3 class="neo-title" style="font-size:30px">Performance</h3>
        <div class="bars">
          <div class="row"><label>Hackathons</label><div class="track"><div class="fill" data-key="total"></div></div><span>${totalHackathon}</span></div>
          <div class="row"><label>Upcoming</label><div class="track"><div class="fill" data-key="upcoming"></div></div><span>${totalUpcoming}</span></div>
          <div class="row"><label>Ongoing</label><div class="track"><div class="fill" data-key="ongoing"></div></div><span>${totalOngoing}</span></div>
          <div class="row"><label>Completed</label><div class="track"><div class="fill" data-key="completed"></div></div><span>${totalCompleted}</span></div>
          <div class="row"><label>Participants</label><div class="track"><div class="fill" data-key="participant"></div></div><span>${totalParticipant}</span></div>
        </div>
      </article>

    </section>
  </main>
</div>
<script>
(function(){
  var chart = document.querySelector('.chart');
  if(!chart){ return; }
  var values = {
    total: Number(chart.dataset.total || 0),
    upcoming: Number(chart.dataset.upcoming || 0),
    ongoing: Number(chart.dataset.ongoing || 0),
    completed: Number(chart.dataset.completed || 0),
    participant: Number(chart.dataset.participant || 0)
  };
  var max = Math.max(values.total, values.upcoming, values.ongoing, values.completed, values.participant, 1);
  chart.querySelectorAll('.fill').forEach(function(el){
    var v = values[el.dataset.key] || 0;
    el.style.width = Math.max(8, Math.round((v / max) * 100)) + '%';
  });

  var activeStatus = (new URLSearchParams(window.location.search).get('status') || '${selectedStatus}' || 'ALL').toUpperCase();
  var rows = Array.prototype.slice.call(document.querySelectorAll('.snapshot-row'));
  var sub = document.getElementById('snapshotSub');
  var emptyRow = document.getElementById('snapshotEmpty');
  var metrics = Array.prototype.slice.call(document.querySelectorAll('.metric-link[data-status]'));

  function applyStatus(status){
    var visible = 0;
    rows.forEach(function(row){
      var rowStatus = (row.getAttribute('data-status') || '').toUpperCase();
      var show = status === 'ALL' || rowStatus === status;
      row.style.display = show ? '' : 'none';
      if(show){ visible++; }
    });
    if (emptyRow) {
      emptyRow.style.display = visible === 0 ? '' : 'none';
    }
    if (sub) {
      sub.textContent = 'Showing ' + visible + ' entries for status: ' + status;
    }
    metrics.forEach(function(metric){
      metric.classList.toggle('active', (metric.dataset.status || '').toUpperCase() === status);
    });
  }

  applyStatus(activeStatus);
})();
</script>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>
