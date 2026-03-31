<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
* { box-sizing: border-box; margin: 0; padding: 0; }
:root {
	--bg: #0a1118;
	--surface: #121c26;
	--surface2: #1a2633;
	--border: #294055;
	--accent: #f97316;
	--accent2: #06b6d4;
	--text: #e2e8f0;
	--muted: #89a0b3;
	--glow: rgba(249, 115, 22, 0.35);
}
html, body {
	background: var(--bg) !important;
	color: var(--text);
}
body {
	font-family: 'Syne', sans-serif;
	background: var(--bg);
	color: var(--text);
	min-height: 100vh;
}
body::before {
	content: '';
	position: fixed;
	inset: 0;
	background-image: linear-gradient(rgba(124, 58, 237, 0.04) 1px, transparent 1px), linear-gradient(90deg, rgba(124, 58, 237, 0.04) 1px, transparent 1px);
	background-image: linear-gradient(rgba(6, 182, 212, 0.05) 1px, transparent 1px), linear-gradient(90deg, rgba(249, 115, 22, 0.05) 1px, transparent 1px);
	background-size: 40px 40px;
	pointer-events: none;
	z-index: 0;
}
.header {
	position: sticky;
	top: 0;
	z-index: 20;
	height: 64px;
	padding: 0 28px;
	border-bottom: 1px solid var(--border);
	background: rgba(10, 10, 15, 0.88);
	backdrop-filter: blur(20px);
	display: flex;
	justify-content: space-between;
	align-items: center;
}
.logo {
	display: flex;
	gap: 10px;
	align-items: center;
	color: var(--text);
	text-decoration: none;
	font-family: 'Space Mono', monospace;
	font-weight: 700;
}
.logo-icon {
	width: 34px;
	height: 34px;
	border-radius: 8px;
	background: linear-gradient(135deg, var(--accent), var(--accent2));
	display: grid;
	place-items: center;
}
.logo-mark { font-family: 'Space Mono', monospace; font-weight: 700; font-size: 13px; letter-spacing: 0.05em; color: #fff; }
.nav { display: flex; gap: 8px; }
.nav a {
	text-decoration: none;
	color: var(--muted);
	padding: 8px 14px;
	border-radius: 8px;
	font-size: 14px;
	font-weight: 600;
}
.nav a:hover { color: var(--text); background: var(--surface2); }
.nav .btn {
	background: var(--accent);
	color: #fff;
	box-shadow: 0 0 20px var(--glow);
}
.wrap {
	position: relative;
	z-index: 1;
	max-width: 1200px;
	margin: 0 auto;
	padding: 34px 22px 60px;
}
.title {
	font-size: clamp(28px, 5vw, 44px);
	line-height: 1.1;
	font-weight: 800;
	letter-spacing: -1px;
}
.title span {
	background: linear-gradient(135deg, var(--accent), var(--accent2));
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
}
.subtitle { margin-top: 8px; color: var(--muted); }
.actions {
	margin-top: 22px;
	display: flex;
	gap: 10px;
	flex-wrap: wrap;
}
.actions a {
	text-decoration: none;
	padding: 10px 14px;
	border-radius: 10px;
	border: 1px solid var(--border);
	background: var(--surface);
	color: var(--text);
	font-size: 14px;
	font-weight: 600;
}
.cards {
	margin-top: 28px;
	display: grid;
	grid-template-columns: repeat(4, minmax(160px, 1fr));
	gap: 16px;
}
.quick-grid {
	margin-top: 22px;
	display: grid;
	grid-template-columns: repeat(3, minmax(180px, 1fr));
	gap: 12px;
}
.quick-card {
	text-decoration: none;
	background: var(--surface);
	border: 1px solid var(--border);
	border-radius: 12px;
	padding: 14px;
	color: var(--text);
	transition: border-color 0.2s, transform 0.2s;
}
.quick-card:hover {
	border-color: var(--accent);
	transform: translateY(-2px);
}
.quick-card h4 {
	font-size: 15px;
	margin-bottom: 6px;
}
.quick-card p {
	font-size: 12px;
	color: var(--muted);
}
.card {
	background: var(--surface);
	border: 1px solid var(--border);
	border-radius: 14px;
	padding: 20px;
}
.card p { color: var(--muted); font-size: 13px; margin-bottom: 8px; }
.card h3 {
	font-family: 'Space Mono', monospace;
	font-size: 32px;
	background: linear-gradient(135deg, var(--accent2), var(--accent));
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
}
.chart {
	margin-top: 18px;
	background: var(--surface);
	border: 1px solid var(--border);
	border-radius: 14px;
	padding: 16px;
}
.chart h3 { font-size: 17px; margin-bottom: 10px; }
.bar-row { display: grid; grid-template-columns: 120px 1fr 60px; gap: 10px; align-items: center; margin: 8px 0; }
.bar-row label { color: var(--muted); font-size: 12px; }
.track { height: 10px; border-radius: 999px; background: #0e1720; border: 1px solid var(--border); overflow: hidden; }
.fill { height: 100%; width: 0; border-radius: inherit; background: linear-gradient(90deg, var(--accent), var(--accent2)); transition: width .5s ease; }
.bar-row span { font-family: 'Space Mono', monospace; font-size: 12px; color: #c8d8e8; text-align: right; }
@media (max-width: 900px) {
	.cards { grid-template-columns: repeat(2, minmax(160px, 1fr)); }
	.quick-grid { grid-template-columns: repeat(2, minmax(170px, 1fr)); }
	.header { padding: 0 14px; }
}
@media (max-width: 560px) {
	.cards { grid-template-columns: 1fr; }
	.quick-grid { grid-template-columns: 1fr; }
	.nav a { padding: 7px 10px; font-size: 13px; }
}
</style>
</head>
<body>
	<header class="header">
		<c:choose>
			<c:when test="${sessionScope.user.role == 'ADMIN'}">
				<a class="logo" href="<c:url value='/admin-dashboard' />">
					<div class="logo-icon"><span class="logo-mark">CV</span></div>
					CodeVerse
				</a>
			</c:when>
			<c:when test="${sessionScope.user.role == 'ORGANIZER'}">
				<a class="logo" href="<c:url value='/organizer-dashboard' />">
					<div class="logo-icon"><span class="logo-mark">CV</span></div>
					CodeVerse
				</a>
			</c:when>
			<c:otherwise>
				<a class="logo" href="<c:url value='/judge-dashboard' />">
					<div class="logo-icon"><span class="logo-mark">CV</span></div>
					CodeVerse
				</a>
			</c:otherwise>
		</c:choose>
		<nav class="nav">
			<a href="<c:url value='/participant/home' />">Explore</a>
			<a href="<c:url value='/logout' />" class="btn">Logout</a>
		</nav>
	</header>

	<main class="wrap">
		<h1 class="title">
			<c:choose>
				<c:when test="${sessionScope.user.role == 'ORGANIZER'}">Organizer <span>Dashboard</span></c:when>
				<c:when test="${sessionScope.user.role == 'JUDGE'}">Judge <span>Dashboard</span></c:when>
				<c:otherwise>Admin <span>Dashboard</span></c:otherwise>
			</c:choose>
		</h1>
		<p class="subtitle">Welcome ${sessionScope.user.firstName}. Platform metrics are shown below.</p>

		<div class="actions">
			<c:choose>
				<c:when test="${sessionScope.user.role == 'ADMIN'}">
					<a href="<c:url value='/listUser' />">Manage Users</a>
					<a href="<c:url value='/listHackathon' />">Manage Hackathons</a>
					<a href="<c:url value='/listCategory' />">Manage Categories</a>
				</c:when>
				<c:when test="${sessionScope.user.role == 'ORGANIZER'}">
					<a href="<c:url value='/newHackathon' />">Create Hackathon</a>
					<a href="<c:url value='/listHackathon' />">Manage Hackathons</a>
					<a href="<c:url value='/organizer/judge-assignments' />">Assign Judges</a>
					<a href="<c:url value='/organizer/applications' />">Applications</a>
					<a href="<c:url value='/organizer/results' />">Results</a>
					<a href="<c:url value='/charge' />">Payments</a>
				</c:when>
				<c:otherwise>
					<a href="<c:url value='/judge/my-assignments' />">My Assignments</a>
					<a href="<c:url value='/judge/scorecards' />">Scorecards</a>
					<a href="<c:url value='/participant/home' />">Explore Events</a>
				</c:otherwise>
			</c:choose>
		</div>

		<section class="cards">
			<article class="card">
				<p>Total Hackathons</p>
				<h3>${totalHackathon}</h3>
			</article>
			<article class="card">
				<p>Upcoming</p>
				<h3>${totalUpcoming}</h3>
			</article>
			<article class="card">
				<p>Completed</p>
				<h3>${totalCompleted}</h3>
			</article>
			<article class="card">
				<p>Participants</p>
				<h3>${totalParticipant}</h3>
			</article>
		</section>

		<c:if test="${sessionScope.user.role == 'ADMIN'}">
			<section class="chart" data-total="${totalHackathon}" data-upcoming="${totalUpcoming}" data-completed="${totalCompleted}" data-participant="${totalParticipant}">
				<h3>Platform Pulse</h3>
				<div class="bar-row"><label>Hackathons</label><div class="track"><div class="fill" data-key="total"></div></div><span>${totalHackathon}</span></div>
				<div class="bar-row"><label>Upcoming</label><div class="track"><div class="fill" data-key="upcoming"></div></div><span>${totalUpcoming}</span></div>
				<div class="bar-row"><label>Completed</label><div class="track"><div class="fill" data-key="completed"></div></div><span>${totalCompleted}</span></div>
				<div class="bar-row"><label>Participants</label><div class="track"><div class="fill" data-key="participant"></div></div><span>${totalParticipant}</span></div>
			</section>
		</c:if>

		<section class="quick-grid">
			<c:choose>
				<c:when test="${sessionScope.user.role == 'ADMIN'}">
					<a class="quick-card" href="<c:url value='/listUser' />">
						<h4>User Directory</h4>
						<p>View, edit, and manage platform users.</p>
					</a>
					<a class="quick-card" href="<c:url value='/newCategory' />">
						<h4>Create Category</h4>
						<p>Add new tracks like AI, Web3, and Cloud.</p>
					</a>
					<a class="quick-card" href="<c:url value='/listCategory' />">
						<h4>Category List</h4>
						<p>Review all categories and update taxonomy.</p>
					</a>
					<a class="quick-card" href="<c:url value='/newHackathon' />">
						<h4>Create Hackathon</h4>
						<p>Publish a new event with team and date rules.</p>
					</a>
					<a class="quick-card" href="<c:url value='/listHackathon' />">
						<h4>Hackathon List</h4>
						<p>Manage existing events and organizer content.</p>
					</a>
					<a class="quick-card" href="<c:url value='/charge' />">
						<h4>Payments</h4>
						<p>Open payment module and test transactions.</p>
					</a>
				</c:when>
				<c:when test="${sessionScope.user.role == 'ORGANIZER'}">
					<a class="quick-card" href="<c:url value='/newHackathon' />">
						<h4>Create Hackathon</h4>
						<p>Post a new challenge with registration details.</p>
					</a>
					<a class="quick-card" href="<c:url value='/listHackathon' />">
						<h4>My Hackathons</h4>
						<p>Edit, view, and track listed events.</p>
					</a>
					<a class="quick-card" href="<c:url value='/organizer/judge-assignments' />">
						<h4>Assign Judges</h4>
						<p>Map judges to hackathons for evaluation.</p>
					</a>
					<a class="quick-card" href="<c:url value='/organizer/applications' />">
						<h4>Applications</h4>
						<p>Accept, shortlist, and track payment state.</p>
					</a>
					<a class="quick-card" href="<c:url value='/organizer/results' />">
						<h4>Leaderboard</h4>
						<p>View ranked results by average judge score.</p>
					</a>
					<a class="quick-card" href="<c:url value='/charge' />">
						<h4>Payments</h4>
						<p>Use payment module for paid registration checks.</p>
					</a>
				</c:when>
				<c:otherwise>
					<a class="quick-card" href="<c:url value='/judge/my-assignments' />">
						<h4>My Assignments</h4>
						<p>See all hackathons assigned for judging.</p>
					</a>
					<a class="quick-card" href="<c:url value='/judge/scorecards' />">
						<h4>Scorecards</h4>
						<p>Score applications and submit remarks.</p>
					</a>
					<a class="quick-card" href="<c:url value='/participant/home' />">
						<h4>Explore Hackathons</h4>
						<p>Browse all active and upcoming listings.</p>
					</a>
					<a class="quick-card" href="<c:url value='/charge' />">
						<h4>Payments</h4>
						<p>Access payment workflow for testing.</p>
					</a>
				</c:otherwise>
			</c:choose>
		</section>
	</main>
	<script>
	(function(){
		var chart = document.querySelector('.chart');
		if(!chart){ return; }
		var values = {
			total: Number(chart.dataset.total || 0),
			upcoming: Number(chart.dataset.upcoming || 0),
			completed: Number(chart.dataset.completed || 0),
			participant: Number(chart.dataset.participant || 0)
		};
		var max = Math.max(values.total, values.upcoming, values.completed, values.participant, 1);
		chart.querySelectorAll('.fill').forEach(function(el){
			var v = values[el.dataset.key] || 0;
			el.style.width = Math.max(8, Math.round((v / max) * 100)) + '%';
		});
	})();
	</script>
</body>
</html>