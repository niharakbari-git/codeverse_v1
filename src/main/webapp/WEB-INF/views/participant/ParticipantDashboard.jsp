<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Participant Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
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
	--glow: rgba(124, 58, 237, 0.35);
}
body { font-family: 'Syne', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }
body::before {
	content: '';
	position: fixed;
	inset: 0;
	background-image: linear-gradient(rgba(124, 58, 237, 0.04) 1px, transparent 1px), linear-gradient(90deg, rgba(124, 58, 237, 0.04) 1px, transparent 1px);
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
.nav .btn { background: var(--accent); color: #fff; box-shadow: 0 0 20px var(--glow); }
.wrap { position: relative; z-index: 1; max-width: 1200px; margin: 0 auto; padding: 34px 22px 60px; }
.title { font-size: clamp(28px, 5vw, 44px); line-height: 1.1; font-weight: 800; letter-spacing: -1px; }
.title span { background: linear-gradient(135deg, var(--accent), var(--accent2)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.subtitle { margin-top: 8px; color: var(--muted); }
.cards { margin-top: 28px; display: grid; grid-template-columns: repeat(4, minmax(160px, 1fr)); gap: 16px; }
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
.quick-card h4 { font-size: 15px; margin-bottom: 6px; }
.quick-card p { font-size: 12px; color: var(--muted); }
.card { background: var(--surface); border: 1px solid var(--border); border-radius: 14px; padding: 20px; }
.card p { color: var(--muted); font-size: 13px; margin-bottom: 8px; }
.card h3 { font-family: 'Space Mono', monospace; font-size: 32px; background: linear-gradient(135deg, var(--accent2), var(--accent)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
@media (max-width: 900px) { .cards { grid-template-columns: repeat(2, minmax(160px, 1fr)); } .quick-grid { grid-template-columns: repeat(2, minmax(170px, 1fr)); } .header { padding: 0 14px; } }
@media (max-width: 560px) { .cards { grid-template-columns: 1fr; } .quick-grid { grid-template-columns: 1fr; } .nav a { padding: 7px 10px; font-size: 13px; } }
</style>
</head>
<body>
	<header class="header">
		<a class="logo" href="<c:url value='/participant/home' />">
			<div class="logo-icon"><span class="logo-mark">CV</span></div>
			CodeVerse
		</a>
		<nav class="nav">
			<a href="<c:url value='/participant/home' />">Explore</a>
			<a href="<c:url value='/participant/profile' />">Profile</a>
			<a href="<c:url value='/logout' />" class="btn">Logout</a>
		</nav>
	</header>

	<main class="wrap">
		<h1 class="title">Participant <span>Dashboard</span></h1>
		<p class="subtitle">Welcome ${sessionScope.user.firstName}. Here is a quick snapshot of available opportunities.</p>

		<section class="cards">
			<article class="card">
				<p>Total Hackathons</p>
				<h3>${totalHackathons}</h3>
			</article>
			<article class="card">
				<p>Live Hackathons</p>
				<h3>${liveHackathons}</h3>
			</article>
			<article class="card">
				<p>Free Events</p>
				<h3>${freeHackathons}</h3>
			</article>
			<article class="card">
				<p>Paid Events</p>
				<h3>${paidHackathons}</h3>
			</article>
		</section>

		<section class="quick-grid">
			<a class="quick-card" href="<c:url value='/participant/home' />">
				<h4>Explore Hackathons</h4>
				<p>Browse and filter all active opportunities.</p>
			</a>
			<a class="quick-card" href="<c:url value='/participant/my-applications' />">
				<h4>My Applications</h4>
				<p>Track status, payment, and applied events.</p>
			</a>
			<a class="quick-card" href="<c:url value='/participant/my-teams' />">
				<h4>My Teams</h4>
				<p>View team roster and linked hackathons.</p>
			</a>
			<a class="quick-card" href="<c:url value='/participant/profile' />">
				<h4>My Profile</h4>
				<p>See your account and personal details.</p>
			</a>
			<a class="quick-card" href="<c:url value='/charge' />">
				<h4>Open Payments</h4>
				<p>Test registration payment flow quickly.</p>
			</a>
			<a class="quick-card" href="<c:url value='/logout' />">
				<h4>Logout</h4>
				<p>End current session safely.</p>
			</a>
		</section>
	</main>
</body>
</html>