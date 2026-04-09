<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Judge Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260409a">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260409a"></script>
<style>
* { box-sizing: border-box; margin: 0; padding: 0; }
:root {
	--bg: #0a0a0f;
	--surface: #13131a;
	--surface2: #1c1c27;
	--border: #2a2a3d;
	--accent: #7c3aed;
	--accent2: #06b6d4;
	--text: #e2e8f0;
	--muted: #64748b;
}
body { background: var(--bg); color: var(--text); font-family: 'Syne', sans-serif; min-height: 100vh; }
.header {
	position: sticky; top: 0; z-index: 20; height: 64px; padding: 0 28px;
	border-bottom: 1px solid var(--border); background: rgba(10, 10, 15, 0.88); backdrop-filter: blur(20px);
	display: flex; justify-content: space-between; align-items: center;
}
.logo { display: flex; gap: 10px; align-items: center; color: var(--text); text-decoration: none; }
.logo-icon { width: 34px; height: 34px; border-radius: 8px; background: linear-gradient(135deg, var(--accent), var(--accent2)); display: grid; place-items: center; }
.logo-mark { font-family: 'Space Mono', monospace; font-weight: 700; font-size: 13px; color: #fff; }
.logo-text { font-family: 'Space Mono', monospace; font-weight: 700; font-size: 18px; text-transform: uppercase; line-height: 1; }
.nav-links { display: flex; gap: 8px; align-items: center; }
.nav-links a { text-decoration: none; color: var(--muted); padding: 8px 18px; border-radius: 8px; font-size: 14px; font-weight: 600; }
.nav-links a:hover { color: var(--text); background: var(--surface2); }
.wrap { padding: 34px 22px 60px; max-width: 1200px; margin: 0 auto; }
.title { font-size: 44px; font-weight: 800; line-height: 1.1; }
.title span { background: linear-gradient(135deg, #06b6d4, #f97316); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.subtitle { margin-top: 8px; color: var(--muted); }
.actions { margin-top: 22px; display: flex; gap: 10px; flex-wrap: wrap; }
.actions a { text-decoration: none; padding: 10px 14px; border-radius: 10px; border: 1px solid var(--border); background: var(--surface); color: var(--text); font-size: 14px; font-weight: 600; }
.cards { margin-top: 32px; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; }
.card { background: var(--surface); border: 1px solid var(--border); border-radius: 14px; padding: 22px; }
.card p { color: var(--muted); font-size: 13px; margin-bottom: 8px; font-weight: 600; }
.card h3 { font-family: 'Space Mono', monospace; font-size: 38px; color: var(--text); }
</style>
</head>
<body>
	<header class="header">
		<a class="logo" href="<c:url value='/judge-dashboard' />">
			<div class="logo-icon"><span class="logo-mark">CV</span></div>
			<span class="logo-text">CODEVERSE</span>
		</a>
		<nav class="nav-links">
			<a href="<c:url value='/participant/home' />">Explore</a>
			<a href="<c:url value='/judge/my-assignments' />">Assignments</a>
			<a href="<c:url value='/logout' />">Logout</a>
		</nav>
	</header>
	<main class="wrap">
		<h1 class="title">Judge <span>Dashboard</span></h1>
		<p class="subtitle">Welcome, ${sessionScope.user.firstName}. Ready to evaluate some stellar projects?</p>

		<div class="actions">
			<a href="<c:url value='/judge/my-assignments' />">View Assignments</a>
			<a href="<c:url value='/judge/scorecards' />">Go to Scorecards</a>
		</div>

		<section class="cards">
			<article class="card">
				<p>Assigned Hackathons</p>
				<h3>${totalAssigned}</h3>
			</article>
			<article class="card">
				<p>Total Submissions Evaluated</p>
				<h3>${totalEvaluated}</h3>
			</article>
			<article class="card">
				<p>Pending Evaluations (Estimated)</p>
				<h3>${totalPending}</h3>
			</article>
		</section>
	</main>
</body>
</html>