<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
<head>
<meta charset="UTF-8">
<title>Hackathons</title>
<link
	href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap"
	rel="stylesheet">
<style>
*, *::before, *::after {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

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

body {
	font-family: 'Syne', sans-serif;
	background: var(--bg);
	color: var(--text);
	min-height: 100vh;
	overflow-x: hidden;
}

body::before {
	content: '';
	position: fixed;
	inset: 0;
	background-image: linear-gradient(rgba(124, 58, 237, 0.04) 1px,
		transparent 1px), linear-gradient(90deg, rgba(124, 58, 237, 0.04) 1px,
		transparent 1px);
	background-size: 40px 40px;
	pointer-events: none;
	z-index: 0;
}

/* HEADER */
.header {
	position: sticky;
	top: 0;
	z-index: 100;
	background: rgba(10, 10, 15, 0.88);
	backdrop-filter: blur(20px);
	border-bottom: 1px solid var(--border);
	padding: 0 40px;
	height: 64px;
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.logo {
	display: flex;
	align-items: center;
	gap: 10px;
	font-family: 'Space Mono', monospace;
	font-size: 18px;
	font-weight: 700;
	color: var(--text);
	text-decoration: none;
}

.logo-icon {
	width: 34px;
	height: 34px;
	background: linear-gradient(135deg, var(--accent), var(--accent2));
	border-radius: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.logo-mark {
	font-family: 'Space Mono', monospace;
	font-weight: 700;
	font-size: 13px;
	letter-spacing: 0.05em;
	color: #fff;
}

.logo-text {
	font-family: 'Space Mono', monospace;
	font-weight: 700;
	font-size: 18px;
	letter-spacing: 0.06em;
	text-transform: uppercase;
	line-height: 1;
}

.nav-links {
	display: flex;
	align-items: center;
	gap: 8px;
}

.nav-links a {
	color: var(--muted);
	text-decoration: none;
	font-size: 14px;
	font-weight: 600;
	padding: 8px 18px;
	border-radius: 8px;
	transition: all 0.2s;
}

.nav-links a:hover {
	color: var(--text);
	background: var(--surface2);
}

.nav-links a.btn-primary {
	background: var(--accent);
	color: white;
	box-shadow: 0 0 20px var(--glow);
	display: flex;
	align-items: center;
	gap: 6px;
}

.nav-links a.btn-primary:hover {
	background: #6d28d9;
	transform: translateY(-1px);
}

/* HERO */
.hero {
	position: relative;
	z-index: 1;
	text-align: center;
	padding: 72px 20px 48px;
}

.hero-badge {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	background: rgba(124, 58, 237, 0.15);
	border: 1px solid rgba(124, 58, 237, 0.4);
	color: #a78bfa;
	font-size: 12px;
	font-family: 'Space Mono', monospace;
	padding: 6px 16px;
	border-radius: 100px;
	margin-bottom: 24px;
	animation: fadeUp 0.6s ease both;
}

.pulse-dot {
	width: 7px;
	height: 7px;
	background: #a78bfa;
	border-radius: 50%;
	flex-shrink: 0;
	animation: pulse 1.5s infinite;
}

@
keyframes pulse { 0%, 100% {
	opacity: 1;
	transform: scale(1);
}

50
%
{
opacity
:
0.4;
transform
:
scale(
1.5
);
}
}
.hero h1 {
	font-size: clamp(36px, 6vw, 68px);
	font-weight: 800;
	line-height: 1.05;
	letter-spacing: -2px;
	animation: fadeUp 0.6s 0.1s ease both;
}

.hero h1 span {
	background: linear-gradient(135deg, var(--accent), var(--accent2));
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.hero p {
	margin-top: 16px;
	color: var(--muted);
	font-size: 18px;
	animation: fadeUp 0.6s 0.2s ease both;
}

@
keyframes fadeUp {from { opacity:0;
	transform: translateY(20px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}

/* SEARCH */
.search-wrap {
	position: relative;
	z-index: 1;
	max-width: 640px;
	margin: 32px auto 0;
	animation: fadeUp 0.6s 0.3s ease both;
}

.search-wrap {
	position: relative;
}

.search-icon-wrap {
	position: absolute;
	left: 18px;
	top: 50%;
	transform: translateY(-50%);
	pointer-events: none;
	display: flex;
	align-items: center;
}

.search-wrap input {
	width: 100%;
	padding: 16px 20px 16px 50px;
	background: var(--surface);
	border: 1px solid var(--border);
	border-radius: 14px;
	color: var(--text);
	font-size: 16px;
	font-family: 'Syne', sans-serif;
	transition: all 0.3s;
	outline: none;
}

.search-wrap input::placeholder {
	color: var(--muted);
}

.search-wrap input:focus {
	border-color: var(--accent);
	box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.2), 0 0 30px
		rgba(124, 58, 237, 0.1);
}

/* STATS */
.stats {
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 0;
	padding: 32px 20px;
	position: relative;
	z-index: 1;
	animation: fadeUp 0.6s 0.4s ease both;
}

.stat {
	text-align: center;
	padding: 0 40px;
}

.stat-num {
	font-size: 30px;
	font-weight: 800;
	font-family: 'Space Mono', monospace;
	background: linear-gradient(135deg, var(--accent2), var(--accent));
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.stat-label {
	font-size: 11px;
	color: var(--muted);
	margin-top: 4px;
	letter-spacing: 1.5px;
	text-transform: uppercase;
}

.stat-divider {
	width: 1px;
	height: 40px;
	background: var(--border);
}

/* LAYOUT */
.container {
	position: relative;
	z-index: 1;
	display: flex;
	gap: 24px;
	padding: 0 40px 60px;
	max-width: 1400px;
	margin: 0 auto;
}

/* FILTERS */
.filters {
	width: 260px;
	flex-shrink: 0;
}

.filters-inner {
	background: var(--surface);
	border: 1px solid var(--border);
	border-radius: 16px;
	padding: 24px;
	position: sticky;
	top: 88px;
}

.filters-title {
	display: flex;
	align-items: center;
	gap: 8px;
	font-size: 12px;
	font-weight: 700;
	letter-spacing: 2px;
	text-transform: uppercase;
	color: var(--muted);
	margin-bottom: 24px;
	font-family: 'Space Mono', monospace;
}

.filter-group {
	margin-bottom: 22px;
}

.filter-label {
	font-size: 13px;
	font-weight: 700;
	color: var(--text);
	margin-bottom: 10px;
	display: block;
}

.radio-group {
	display: flex;
	gap: 8px;
}

.radio-option {
	flex: 1;
	position: relative;
}

.radio-option input[type="radio"] {
	position: absolute;
	opacity: 0;
	width: 0;
	height: 0;
}

.radio-option label {
	display: block;
	text-align: center;
	padding: 8px 4px;
	border: 1px solid var(--border);
	border-radius: 8px;
	font-size: 13px;
	font-weight: 600;
	color: var(--muted);
	cursor: pointer;
	transition: all 0.2s;
}

.radio-option input:checked+label {
	background: rgba(124, 58, 237, 0.2);
	border-color: var(--accent);
	color: #a78bfa;
}

.radio-option label:hover {
	border-color: var(--accent);
	color: var(--text);
}

.filter-select {
	width: 100%;
	padding: 10px 36px 10px 14px;
	background: var(--surface2);
	border: 1px solid var(--border);
	border-radius: 8px;
	color: var(--text);
	font-size: 14px;
	font-family: 'Syne', sans-serif;
	outline: none;
	cursor: pointer;
	transition: border-color 0.2s;
	appearance: none;
	background-image:
		url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%2364748b' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
	background-repeat: no-repeat;
	background-position: right 12px center;
}

.filter-select:focus {
	border-color: var(--accent);
}

.filter-select option {
	background: var(--surface2);
}

.divider {
	height: 1px;
	background: var(--border);
	margin: 20px 0;
}

.apply-btn {
	width: 100%;
	padding: 12px;
	background: linear-gradient(135deg, var(--accent), #6d28d9);
	border: none;
	border-radius: 10px;
	color: white;
	font-family: 'Syne', sans-serif;
	font-size: 14px;
	font-weight: 700;
	cursor: pointer;
	letter-spacing: 0.5px;
	transition: all 0.3s;
	box-shadow: 0 4px 20px var(--glow);
}

.apply-btn:hover {
	transform: translateY(-2px);
	box-shadow: 0 8px 30px var(--glow);
}

/* CARDS SECTION */
.cards-section {
	flex: 1;
	min-width: 0;
}

.cards-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 20px;
}

.cards-header h2 {
	font-size: 22px;
	font-weight: 800;
	letter-spacing: -0.5px;
}

.sort-select {
	padding: 8px 28px 8px 14px;
	background: var(--surface);
	border: 1px solid var(--border);
	border-radius: 8px;
	color: var(--muted);
	font-size: 13px;
	font-family: 'Syne', sans-serif;
	outline: none;
	cursor: pointer;
	appearance: none;
	background-image:
		url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%2364748b' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
	background-repeat: no-repeat;
	background-position: right 10px center;
}

.sort-select option {
	background: var(--surface);
}

/* CARDS GRID */
.cards {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
	gap: 20px;
}

/* CARD */
.card {
	background: var(--surface);
	border: 1px solid var(--border);
	border-radius: 16px;
	padding: 22px;
	display: flex;
	flex-direction: column;
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
	position: relative;
	overflow: hidden;
	animation: fadeUp 0.5s ease both;
}

.card::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 2px;
	background: linear-gradient(90deg, var(--accent), var(--accent2));
	opacity: 0;
	transition: opacity 0.3s;
}

.card:hover {
	transform: translateY(-6px);
	border-color: rgba(124, 58, 237, 0.45);
	box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
}

.card:hover::before {
	opacity: 1;
}

.card:nth-child(1) {
	animation-delay: .05s
}

.card:nth-child(2) {
	animation-delay: .10s
}

.card:nth-child(3) {
	animation-delay: .15s
}

.card:nth-child(4) {
	animation-delay: .20s
}

.card:nth-child(5) {
	animation-delay: .25s
}

.card:nth-child(6) {
	animation-delay: .30s
}

.card-top {
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	margin-bottom: 14px;
}

.card-icon {
	width: 44px;
	height: 44px;
	border-radius: 10px;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-shrink: 0;
}

.icon-purple {
	background: rgba(124, 58, 237, 0.2);
}

.icon-cyan {
	background: rgba(6, 182, 212, 0.18);
}

.icon-amber {
	background: rgba(245, 158, 11, 0.18);
}

.card-status {
	font-family: 'Space Mono', monospace;
	font-size: 10px;
	font-weight: 700;
	letter-spacing: 1px;
	padding: 4px 10px;
	border-radius: 100px;
	display: flex;
	align-items: center;
	gap: 5px;
}

.status-live {
	background: rgba(34, 197, 94, 0.12);
	color: #4ade80;
	border: 1px solid rgba(34, 197, 94, 0.3);
}

.status-soon {
	background: rgba(245, 158, 11, 0.12);
	color: #fbbf24;
	border: 1px solid rgba(245, 158, 11, 0.3);
}

.status-dot {
	width: 6px;
	height: 6px;
	border-radius: 50%;
	flex-shrink: 0;
}

.status-live .status-dot {
	background: #4ade80;
	animation: pulse 1.5s infinite;
}

.status-soon .status-dot {
	background: #fbbf24;
}

.card h3 {
	font-size: 18px;
	font-weight: 800;
	letter-spacing: -0.3px;
	margin-bottom: 8px;
	line-height: 1.3;
}

.card-desc {
	color: var(--muted);
	font-size: 14px;
	line-height: 1.6;
	flex: 1;
	display: -webkit-box;
	-webkit-line-clamp: 2;
	-webkit-box-orient: vertical;
	overflow: hidden;
	margin-bottom: 16px;
}

.tags {
	display: flex;
	flex-wrap: wrap;
	gap: 6px;
	margin-bottom: 20px;
}

.tag {
	font-size: 11px;
	font-weight: 700;
	font-family: 'Space Mono', monospace;
	padding: 4px 10px;
	border-radius: 6px;
	letter-spacing: 0.3px;
}

.tag-type {
	background: rgba(124, 58, 237, 0.15);
	color: #a78bfa;
	border: 1px solid rgba(124, 58, 237, 0.25);
}

.tag-team {
	background: rgba(6, 182, 212, 0.12);
	color: #67e8f9;
	border: 1px solid rgba(6, 182, 212, 0.2);
}

.tag-eligibility {
	background: rgba(245, 158, 11, 0.12);
	color: #fcd34d;
	border: 1px solid rgba(245, 158, 11, 0.2);
}

.card-footer {
	display: flex;
	align-items: center;
	gap: 10px;
	padding-top: 16px;
	border-top: 1px solid var(--border);
}

.card-btn {
	flex: 1;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 6px;
	background: var(--accent);
	color: white;
	text-decoration: none;
	padding: 10px 16px;
	border-radius: 8px;
	font-size: 14px;
	font-weight: 700;
	transition: all 0.2s;
	box-shadow: 0 2px 12px var(--glow);
}

.card-btn:hover {
	background: #6d28d9;
	transform: translateY(-1px);
	box-shadow: 0 6px 20px var(--glow);
}

.bookmark-btn {
	width: 38px;
	height: 38px;
	border-radius: 8px;
	border: 1px solid var(--border);
	background: transparent;
	color: var(--muted);
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	transition: all 0.2s;
	flex-shrink: 0;
}

.bookmark-btn:hover {
	background: var(--surface2);
	color: var(--text);
	border-color: var(--accent);
}

.results-count {
	font-size: 14px;
	font-weight: 600;
	color: var(--muted);
	font-family: 'Space Mono', monospace;
	margin-left: 8px;
}

.card.hidden {
	display: none;
}

.no-results-msg {
	grid-column: 1/-1;
	text-align: center;
	padding: 60px 20px;
	display: none;
}

.no-results-msg.visible {
	display: block;
}

.no-results-msg h3 {
	font-size: 20px;
	font-weight: 800;
	margin-bottom: 8px;
	color: var(--text);
}

.no-results-msg p {
	color: var(--muted);
	font-size: 14px;
}

.no-results-msg svg {
	margin-bottom: 16px;
}

@media ( max-width : 900px) {
	.container {
		flex-direction: column;
		padding: 0 20px 40px;
	}
	.filters {
		width: 100%;
	}
	.filters-inner {
		position: static;
	}
	.cards {
		grid-template-columns: 1fr 1fr;
	}
	.stat-divider {
		display: none;
	}
	.stat {
		padding: 0 20px;
	}
}

@media ( max-width : 600px) {
	.header {
		padding: 0 20px;
	}
	.cards {
		grid-template-columns: 1fr;
	}
	.hero {
		padding: 48px 20px 32px;
	}
	.stats {
		flex-wrap: wrap;
		gap: 20px;
	}
}
</style>
</head>
<body>

	<!-- HEADER -->
	<header class="header">
		<a class="logo" href="<c:url value='/participant/home' />">
			<div class="logo-icon"><span class="logo-mark">CV</span></div>
			<span class="logo-text">CODEVERSE</span>
		</a>
		<nav class="nav-links">
			<a href="<c:url value='/participant/home' />">Explore</a> <a href="<c:url value='/participant/participant-dashboard' />">Dashboard</a>
			<a href="<c:url value='/participant/profile' />">Profile</a>
			<a href="<c:url value='/participant/my-applications' />">My Applications</a>
			<a href="<c:url value='/logout' />">Logout</a>
		</nav>
	</header>

	<!-- HERO -->
	<section class="hero">
		<div class="hero-badge">
			<span class="pulse-dot"></span> 200+ Hackathons Live Now
		</div>
		<h1>
			Find Your Next<br>
			<span>Big Challenge</span>
		</h1>
		<p>Compete. Collaborate. Create. Win prizes worth millions.</p>

		<div class="search-wrap">
			<span class="search-icon-wrap"> <svg width="18" height="18"
					viewBox="0 0 24 24" fill="none" stroke="#64748b" stroke-width="2"
					stroke-linecap="round" stroke-linejoin="round">
        <circle cx="11" cy="11" r="8" />
					<line x1="21" y1="21" x2="16.65" y2="16.65" />
      </svg>
			</span> <input type="text" id="searchInput"
				placeholder="Search by name, theme, or technology...">
		</div>
	</section>

	<!-- STATS -->
	<div class="stats">
		<div class="stat">
			<div class="stat-num">247</div>
			<div class="stat-label">Active Events</div>
		</div>
		<div class="stat-divider"></div>
		<div class="stat">
			<div class="stat-num">Rs. 4.2Cr</div>
			<div class="stat-label">Prize Pool</div>
		</div>
		<div class="stat-divider"></div>
		<div class="stat">
			<div class="stat-num">18K+</div>
			<div class="stat-label">Participants</div>
		</div>
		<div class="stat-divider"></div>
		<div class="stat">
			<div class="stat-num">95%</div>
			<div class="stat-label">Free Entry</div>
		</div>
	</div>

	<!-- MAIN -->
	<div class="container">

		<!-- FILTERS -->
		<aside class="filters">
			<div class="filters-inner">
				<div class="filters-title">
					<svg width="14" height="14" viewBox="0 0 24 24" fill="none"
						stroke="#64748b" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round">
          <line x1="4" y1="6" x2="20" y2="6" />
						<line x1="8" y1="12" x2="16" y2="12" />
						<line x1="11" y1="18" x2="13" y2="18" />
        </svg>
					Filters
				</div>

				<div class="filter-group">
					<span class="filter-label">Entry Type</span>
					<div class="radio-group">
						<div class="radio-option">
							<input type="radio" name="type" value="" id="type-all" checked>
							<label for="type-all">All</label>
						</div>
						<div class="radio-option">
							<input type="radio" name="type" value="FREE" id="type-free">
							<label for="type-free">Free</label>
						</div>
						<div class="radio-option">
							<input type="radio" name="type" value="PAID" id="type-paid">
							<label for="type-paid">Paid</label>
						</div>
					</div>
				</div>

				<div class="filter-group">
					<span class="filter-label">Team Size</span> <select
						id="teamSizeFilter" class="filter-select">
						<option value="">Any size</option>
						<option value="1">Solo (1)</option>
						<option value="2">Duo (2)</option>
						<option value="4">Squad (4)</option>
						<option value="6">Large (6)</option>
					</select>
				</div>

				<div class="filter-group">
					<span class="filter-label">Eligibility</span> <select
						id="eligibilityFilter" class="filter-select">
						<option value="">Everyone</option>
						<option value="2">Fresher</option>
						<option value="1">Working Professional</option>
						<option value="3">College Student</option>
						<option value="4">School Student</option>
				
					</select>
				</div>

				<div class="divider"></div>
				<button class="apply-btn" id="resetBtn">Reset Filters</button>
			</div>
		</aside>

		<!-- CARDS -->
		<main class="cards-section">
			<div class="cards-header">
				<h2>
					All Hackathons <span id="resultsCount" class="results-count"></span>
				</h2>
				<select class="sort-select" id="sortSelect">
					<option value="default">Sort: Latest</option>
					<option value="title-asc">Name: A to Z</option>
					<option value="title-desc">Name: Z to A</option>
					<option value="team-asc">Team Size: Low</option>
					<option value="team-desc">Team Size: High</option>
				</select>
			</div>

			<div class="cards" id="cardsGrid">
				<c:choose>
					<c:when test="${empty hackathons}">
						<div class="empty-state">
							<svg width="56" height="56" viewBox="0 0 24 24" fill="none"
								stroke="#64748b" stroke-width="1.5" stroke-linecap="round"
								stroke-linejoin="round">
              <circle cx="11" cy="11" r="8" />
								<line x1="21" y1="21" x2="16.65" y2="16.65" />
            </svg>
							<h3>No hackathons found</h3>
							<p>Try adjusting your filters or search terms.</p>
						</div>
					</c:when>
					<c:otherwise>
						<c:forEach items="${hackathons}" var="h" varStatus="loop">

							<c:set var="mod3" value="${loop.index % 3}" />
							<c:set var="isLive" value="${loop.index % 2 == 0}" />

							<div class="card" data-title="${fn:toLowerCase(h.title)}"
								data-desc="${fn:toLowerCase(h.description)}"
								data-type="${h.payment}" data-minteam="${h.minTeamSize}"
								data-maxteam="${h.maxTeamSize}"
								data-eligibility="${h.userTypeId}">
								<div class="card-top">

									<!-- Icon: rotate through 3 SVG symbols, each with its own colour -->
									<c:choose>
										<c:when test="${mod3 == 0}">
											<div class="card-icon icon-purple">
												<svg width="22" height="22" viewBox="0 0 24 24" fill="none"
													stroke="#a78bfa" stroke-width="1.8" stroke-linecap="round"
													stroke-linejoin="round">
                        <rect x="4" y="4" width="16" height="16" rx="2" />
													<rect x="9" y="9" width="6" height="6" />
                        <line x1="9" y1="1" x2="9" y2="4" />
                        <line x1="15" y1="1" x2="15" y2="4" />
                        <line x1="9" y1="20" x2="9" y2="23" />
                        <line x1="15" y1="20" x2="15" y2="23" />
                        <line x1="20" y1="9" x2="23" y2="9" />
                        <line x1="20" y1="14" x2="23" y2="14" />
                        <line x1="1" y1="9" x2="4" y2="9" />
                        <line x1="1" y1="14" x2="4" y2="14" />
                      </svg>
											</div>
										</c:when>
										<c:when test="${mod3 == 1}">
											<div class="card-icon icon-cyan">
												<svg width="22" height="22" viewBox="0 0 24 24" fill="none"
													stroke="#67e8f9" stroke-width="1.8" stroke-linecap="round"
													stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10" />
                        <line x1="2" y1="12" x2="22" y2="12" />
                        <path
														d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
                      </svg>
											</div>
										</c:when>
										<c:otherwise>
											<div class="card-icon icon-amber">
												<svg width="22" height="22" viewBox="0 0 24 24" fill="none"
													stroke="#fcd34d" stroke-width="1.8" stroke-linecap="round"
													stroke-linejoin="round">
                        <polyline
														points="13 2 3 14 12 14 11 22 21 10 12 10 13 2" />
                      </svg>
											</div>
										</c:otherwise>
									</c:choose>

									<!-- Status badge -->
									<c:choose>
										<c:when test="${h.status == 'ONGOING'}">
											<span class="card-status status-live"> <span
												class="status-dot"></span>LIVE
											</span>
										</c:when>

										<c:when test="${h.status == 'UPCOMING'}">
											<span class="card-status status-soon"> <span
												class="status-dot"></span>SOON
											</span>
										</c:when>
									</c:choose>

								</div>

								<h3>${h.title}</h3>
								<p class="card-desc">${h.description}</p>

								<div class="tags">
									<span class="tag tag-type">${h.eventType}</span> <span
										class="tag tag-team">${h.minTeamSize} -
										${h.maxTeamSize} members</span> <span class="tag tag-eligibility">${h.userTypeId}</span>
								</div>

								<div class="card-footer">
									<a href="<c:url value='/participant/hackathon/${h.hackathonId}' />" class="card-btn"> View
										Details <svg width="13" height="13" viewBox="0 0 24 24"
											fill="none" stroke="white" stroke-width="2.5"
											stroke-linecap="round" stroke-linejoin="round">
                    <line x1="5" y1="12" x2="19" y2="12" />
											<polyline points="12 5 19 12 12 19" />
                  </svg>
									</a>
									<button class="bookmark-btn" title="Save">
										<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
											stroke="currentColor" stroke-width="2" stroke-linecap="round"
											stroke-linejoin="round">
                    <path
												d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z" />
                  </svg>
									</button>
								</div>
							</div>

						</c:forEach>
					</c:otherwise>
				</c:choose>

				<!-- JS-driven no results message -->
				<div class="no-results-msg" id="noResults">
					<svg width="48" height="48" viewBox="0 0 24 24" fill="none"
						stroke="#64748b" stroke-width="1.5" stroke-linecap="round"
						stroke-linejoin="round">
          <circle cx="11" cy="11" r="8" />
						<line x1="21" y1="21" x2="16.65" y2="16.65" />
          <line x1="8" y1="11" x2="14" y2="11" />
        </svg>
					<h3>No hackathons match</h3>
					<p>Try different keywords or reset the filters.</p>
				</div>
			</div>
		</main>

	</div>

	<script>
(function () {
  const cards        = Array.from(document.querySelectorAll('.card'));
  const searchInput  = document.getElementById('searchInput');
  const teamSizeSel  = document.getElementById('teamSizeFilter');
  const eligSel      = document.getElementById('eligibilityFilter');
  const sortSel      = document.getElementById('sortSelect');
  const resetBtn     = document.getElementById('resetBtn');
  const noResults    = document.getElementById('noResults');
  const countEl      = document.getElementById('resultsCount');
  const grid         = document.getElementById('cardsGrid');

  // Save original DOM order for reset
  const originalOrder = [...cards];

  function getFilters() {
    return {
      keyword    : searchInput ? searchInput.value.trim().toLowerCase() : '',
      type       : (document.querySelector('input[name="type"]:checked') || {}).value || '',
      teamSize   : teamSizeSel.value,
      eligibility: eligSel.value,
      sort       : sortSel.value
    };
  }

  function applyFilters() {
    const f = getFilters();
    let visible = [];

    cards.forEach(card => {
      const title  = card.dataset.title       || '';
      const desc   = card.dataset.desc        || '';
      const type   = card.dataset.type        || '';
      const minT   = parseInt(card.dataset.minteam) || 0;
      const maxT   = parseInt(card.dataset.maxteam) || 99;
      const elig   = card.dataset.eligibility || '';

      // --- keyword ---
      const kw = f.keyword;
      const kwMatch = !kw || title.includes(kw) || desc.includes(kw) || type.toLowerCase().includes(kw) || elig.toLowerCase().includes(kw);

      // --- type ---
      const typeMatch = !f.type || type.toUpperCase() === f.type.toUpperCase();

      // --- team size: selected value must fall within min–max range ---
      let teamMatch = true;
      if (f.teamSize) {
        const sz = parseInt(f.teamSize);
        teamMatch = sz >= minT && sz <= maxT;
      }

      // --- eligibility ---
      const eligMatch = !f.eligibility || elig.toUpperCase() === f.eligibility.toUpperCase();

      const show = kwMatch && typeMatch && teamMatch && eligMatch;
      card.classList.toggle('hidden', !show);
      if (show) visible.push(card);
    });

    // --- sort visible cards ---
    sortCards(visible, f.sort);

    // --- update count ---
    countEl.textContent = '(' + visible.length + ')';

    // --- no-results state ---
    noResults.classList.toggle('visible', visible.length === 0);
  }

  function sortCards(visibleCards, mode) {
    // Re-append all cards in sorted order; hidden ones stay hidden
    let sorted;
    switch (mode) {
      case 'title-asc':
        sorted = [...cards].sort((a, b) => a.dataset.title.localeCompare(b.dataset.title));
        break;
      case 'title-desc':
        sorted = [...cards].sort((a, b) => b.dataset.title.localeCompare(a.dataset.title));
        break;
      case 'team-asc':
        sorted = [...cards].sort((a, b) => parseInt(a.dataset.minteam) - parseInt(b.dataset.minteam));
        break;
      case 'team-desc':
        sorted = [...cards].sort((a, b) => parseInt(b.dataset.maxteam) - parseInt(a.dataset.maxteam));
        break;
      default:
        sorted = [...originalOrder];
    }
    sorted.forEach(c => grid.insertBefore(c, noResults));
  }

  // --- Event listeners (instant, no submit) ---
  if (searchInput) searchInput.addEventListener('input', applyFilters);
  document.querySelectorAll('input[name="type"]').forEach(r => r.addEventListener('change', applyFilters));
  teamSizeSel.addEventListener('change', applyFilters);
  eligSel.addEventListener('change', applyFilters);
  sortSel.addEventListener('change', applyFilters);

  resetBtn.addEventListener('click', function () {
    if (searchInput) searchInput.value = '';
    document.getElementById('type-all').checked = true;
    teamSizeSel.value = '';
    eligSel.value = '';
    sortSel.value = 'default';
    applyFilters();
  });

  // --- Init ---
  applyFilters();
})();
</script>
</body>
</html>
