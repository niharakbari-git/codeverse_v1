<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
<head>
<meta charset="UTF-8">
<title>Hackathons</title>
<link
	href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@400;600;700;800&display=swap"
	rel="stylesheet">
<style>
.header { position: sticky; top: 0; z-index: 100; height: 64px; display: flex; align-items: center; justify-content: space-between; gap: 10px; padding: 0 24px; background: rgba(247,244,236,.92); backdrop-filter: blur(8px); border-bottom: 1px solid #d7dce5; }
.logo { display: flex; align-items: center; gap: 10px; text-decoration: none; color: #1f2329; }
.logo-icon { width: 34px; height: 34px; border-radius: 10px; display: grid; place-items: center; background: #1f2937; color: #fff; font-weight: 700; }
.logo-text { font-family: 'Space Grotesk', sans-serif; font-size: 16px; font-weight: 700; letter-spacing: .04em; }

.nav-links { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.nav-links a { text-decoration: none; border: 1px solid #d7dce5; border-radius: 10px; background: #fff; color: #1f2329; font-size: 13px; font-weight: 700; padding: 8px 12px; }
.nav-links a:hover { background: #f5f7fb; }
.nav-links a.active { background: #1f2329; color: #fff; border-color: #1f2329; }

.hero { text-align: center; padding: 56px 20px 34px; }
.hero-badge { display: inline-flex; align-items: center; gap: 8px; font-size: 12px; font-weight: 700; letter-spacing: .04em; border: 1px solid #d7dce5; border-radius: 999px; background: #fff; padding: 6px 12px; }
.pulse-dot { width: 7px; height: 7px; border-radius: 999px; background: #0f8b8d; }
.hero h1 { font-size: clamp(34px, 6vw, 62px); font-weight: 800; letter-spacing: -.02em; line-height: 1.06; margin-top: 16px; color: #1f2329; }
.hero h1 span { color: #1f2937; }
.hero p { margin-top: 12px; color: #5e6673; font-weight: 500; }

.search-wrap { max-width: 640px; margin: 24px auto 0; position: relative; }
.search-icon-wrap { position: absolute; left: 16px; top: 50%; transform: translateY(-50%); pointer-events: none; }
.search-wrap input { width: 100%; padding: 14px 16px 14px 48px; border: 1px solid #d7dce5; border-radius: 12px; background: #fff; color: #1f2329; font-family: 'Syne', sans-serif; font-size: 15px; }

.stats { display: grid; grid-template-columns: repeat(auto-fit,minmax(150px,1fr)); gap: 10px; max-width: 1080px; margin: 0 auto; padding: 0 20px 24px; }
.stat { border: 1px solid #d7dce5; border-radius: 12px; background: #fff; text-align: center; padding: 12px; }
.stat-num { font-family: 'Space Grotesk', sans-serif; font-size: 24px; font-weight: 700; color: #1f2329; }
.stat-label { margin-top: 4px; font-size: 11px; text-transform: uppercase; letter-spacing: .06em; color: #5e6673; }
.stat-divider { display: none; }

.container { display: flex; gap: 18px; max-width: 1320px; margin: 0 auto; padding: 0 20px 42px; }
.filters { width: 270px; flex-shrink: 0; }
.filters-inner { border: 1px solid #d7dce5; border-radius: 14px; background: #fff; padding: 16px; position: sticky; top: 82px; }
.filters-title { display: flex; align-items: center; gap: 8px; margin-bottom: 16px; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: .07em; color: #5e6673; }
.filter-group { margin-bottom: 14px; }
.filter-label { display: block; margin-bottom: 8px; font-size: 12px; font-weight: 700; color: #1f2329; text-transform: uppercase; letter-spacing: .06em; }

.radio-group { display: grid; grid-template-columns: repeat(3,minmax(0,1fr)); gap: 8px; }
.radio-option input[type="radio"] { position: absolute; opacity: 0; }
.radio-option label { display: block; text-align: center; border: 1px solid #d7dce5; border-radius: 10px; background: #fff; color: #5e6673; font-size: 12px; font-weight: 700; padding: 8px 6px; cursor: pointer; }
.radio-option input:checked + label { background: #1f2329; color: #fff; border-color: #1f2329; }

.filter-select, .sort-select { width: 100%; padding: 10px 12px; border: 1px solid #d7dce5; border-radius: 10px; background: #fff; color: #1f2329; font-family: 'Syne', sans-serif; }
.divider { height: 1px; margin: 14px 0; background: #e7ebf2; }
.apply-btn { width: 100%; padding: 11px 12px; border: none; border-radius: 10px; background: #1f2329; color: #fff; font-weight: 700; cursor: pointer; transition: background-color .2s ease; }
.apply-btn:hover { background: #111827; }

.cards-section { flex: 1; min-width: 0; }
.cards-header { display: flex; align-items: center; justify-content: space-between; gap: 10px; flex-wrap: wrap; margin-bottom: 14px; }
.cards-header h2 { font-size: 24px; letter-spacing: -.02em; color: #1f2329; }
.results-count { margin-left: 8px; color: #5e6673; font-family: 'Space Grotesk', sans-serif; font-size: 13px; }

.cards { display: grid; grid-template-columns: repeat(auto-fill,minmax(280px,1fr)); gap: 14px; }
.card { border: 1px solid #d7dce5; border-radius: 14px; background: #fff; padding: 16px; display: flex; flex-direction: column; gap: 10px; }
.card.hidden { display: none; }
.card-top { display: flex; align-items: center; justify-content: space-between; gap: 8px; }
.card-icon { width: 40px; height: 40px; border-radius: 10px; display: grid; place-items: center; }
.icon-purple { background: #f3f2ff; }
.icon-cyan { background: #ecfeff; }
.icon-amber { background: #fff7ed; }

.card-status { display: inline-flex; align-items: center; gap: 6px; border-radius: 999px; padding: 4px 10px; font-size: 11px; font-weight: 700; letter-spacing: .06em; }
.status-live { background: #1f2329; color: #fff; box-shadow: 0 6px 16px rgba(31,35,41,.12); }
.status-soon { background: rgba(15,118,110,.12); color: var(--cv-accent-2); border: 1px solid rgba(15,118,110,.18); }
.status-expired { background: #f1f5f9; color: #64748b; border: 1px solid #d5dde8; }
.status-dot { width: 6px; height: 6px; border-radius: 999px; background: currentColor; }

.card h3 { font-size: 18px; color: #1f2329; line-height: 1.35; }
.card-desc { color: #5e6673; font-size: 14px; line-height: 1.55; min-height: 42px; }
.tags { display: flex; flex-wrap: wrap; gap: 6px; }
.tag { border-radius: 999px; padding: 4px 10px; font-size: 11px; font-weight: 700; border: 1px solid #d7dce5; background: #f8fafc; color: #1f2329; }

.card-footer { margin-top: auto; padding-top: 10px; border-top: 1px solid #e7ebf2; display: flex; align-items: center; gap: 8px; }
.card-btn { flex: 1; display: inline-flex; align-items: center; justify-content: center; gap: 6px; text-decoration: none; border-radius: 10px; background: #1f2329; color: #fff; padding: 10px 12px; font-size: 13px; font-weight: 700; transition: background-color .2s ease; }
.card-btn:hover { background: #111827; }
.bookmark-btn { width: 38px; height: 38px; border: 1px solid #d7dce5; border-radius: 10px; background: #fff; color: #5e6673; cursor: pointer; display: grid; place-items: center; }
.bookmark-btn:hover { background: #f8fafc; border-color: #cbd5e1; color: #334155; }
.bookmark-btn:active { transform: translateY(1px); }

.empty-state, .no-results-msg { grid-column: 1/-1; border: 1px dashed #d7dce5; border-radius: 12px; background: #fff; text-align: center; padding: 34px 16px; }
.no-results-msg { display: none; }
.no-results-msg.visible { display: block; }
.no-results-msg h3, .empty-state h3 { color: #1f2329; margin-bottom: 6px; }
.no-results-msg p, .empty-state p { color: #5e6673; }

@media (max-width: 980px) {
	.container { flex-direction: column; }
	.filters { width: 100%; }
	.filters-inner { position: static; }
	.stats { grid-template-columns: repeat(2,minmax(0,1fr)); }
}

@media (max-width: 640px) {
	.header { height: auto; padding: 12px; align-items: flex-start; flex-direction: column; }
	.stats { grid-template-columns: 1fr; }
	.cards { grid-template-columns: 1fr; }
}
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260512c"></script>
</head>
<body>
	<c:if test="${not empty param.msg}">
		<div id="toast-data" data-type="${param.type == 'success' ? 'success' : 'error'}" style="display:none;"><c:out value="${param.msg}" /></div>
	</c:if>

	<%@ include file="../shared/Toast.jspf" %>

	<!-- HEADER -->
	<header class="header">
		<c:choose>
			<c:when test="${sessionScope.user.role == 'ADMIN'}">
				<a class="logo" href="<c:url value='/admin-dashboard' />">
					<div class="logo-icon"><span class="logo-mark">CV</span></div>
					<span class="logo-text">CODEVERSE</span>
				</a>
			</c:when>
			<c:when test="${sessionScope.user.role == 'ORGANIZER'}">
				<a class="logo" href="<c:url value='/organizer-dashboard' />">
					<div class="logo-icon"><span class="logo-mark">CV</span></div>
					<span class="logo-text">CODEVERSE</span>
				</a>
			</c:when>
			<c:when test="${sessionScope.user.role == 'JUDGE'}">
				<a class="logo" href="<c:url value='/judge-dashboard' />">
					<div class="logo-icon"><span class="logo-mark">CV</span></div>
					<span class="logo-text">CODEVERSE</span>
				</a>
			</c:when>
			<c:otherwise>
				<a class="logo" href="<c:url value='/participant/home' />">
					<div class="logo-icon"><span class="logo-mark">CV</span></div>
					<span class="logo-text">CODEVERSE</span>
				</a>
			</c:otherwise>
		</c:choose>
		
		<nav class="nav-links">
			<a class="active" href="<c:url value='/participant/home' />">Explore</a>
			<c:choose>
				<c:when test="${sessionScope.user.role == 'ADMIN'}">
					<a href="<c:url value='/admin-dashboard' />">Dashboard</a>
				</c:when>
				<c:when test="${sessionScope.user.role == 'ORGANIZER'}">
					<a href="<c:url value='/organizer-dashboard' />">Dashboard</a>
				</c:when>
				<c:when test="${sessionScope.user.role == 'JUDGE'}">
					<a href="<c:url value='/judge-dashboard' />">Dashboard</a>
				</c:when>
				<c:otherwise>
					<a href="<c:url value='/participant/participant-dashboard' />">Dashboard</a>
				</c:otherwise>
			</c:choose>
			<a href="<c:url value='/logout' />">Logout</a>
		</nav>
	</header>

	<!-- HERO -->
	<section class="hero">
		<div class="hero-badge">
			<span class="pulse-dot"></span> ${liveHackathons} Hackathons Live Now
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
			<div class="stat-num">${totalHackathons}</div>
			<div class="stat-label">Visible Events</div>
		</div>
		<div class="stat-divider"></div>
		<div class="stat">
			<div class="stat-num">${liveHackathons}</div>
			<div class="stat-label">Live Now</div>
		</div>
		<div class="stat-divider"></div>
		<div class="stat">
			<div class="stat-num">${upcomingHackathons}</div>
			<div class="stat-label">Upcoming</div>
		</div>
		<div class="stat-divider"></div>
		<div class="stat">
			<div class="stat-num">${freeHackathons}</div>
			<div class="stat-label">Free Entry</div>
		</div>
		<div class="stat-divider"></div>
		<div class="stat">
			<div class="stat-num">${paidHackathons}</div>
			<div class="stat-label">Paid Entry</div>
		</div>
		<div class="stat-divider"></div>
		<div class="stat">
			<div class="stat-num">${openToAllHackathons}</div>
			<div class="stat-label">Open To All</div>
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
					<span class="filter-label">Participation Scope</span>
					<select id="scopeFilter" class="filter-select">
						<option value="">All scopes</option>
						<option value="CAMPUS_ONLY">Campus Only</option>
						<option value="OPEN_TO_ALL">Open To All</option>
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
								data-maxteam="${h.maxTeamSize}" data-scope="${empty h.participationScope ? 'CAMPUS_ONLY' : h.participationScope}">
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
										<c:when test="${h.displayStatus == 'ONGOING'}">
											<span class="card-status status-live"> <span
												class="status-dot"></span>LIVE
											</span>
										</c:when>

										<c:when test="${h.displayStatus == 'UPCOMING'}">
											<span class="card-status status-soon"> <span
												class="status-dot"></span>SOON
											</span>
										</c:when>

										<c:when test="${h.displayStatus == 'COMPLETED'}">
											<span class="card-status status-expired"> <span
												class="status-dot"></span>EXPIRED
											</span>
										</c:when>
									</c:choose>

								</div>

								<h3>${h.title}</h3>
								<p class="card-desc">${h.description}</p>

								<div class="tags">
									<span class="tag tag-type">${h.eventType}</span> <span
										class="tag tag-team">${h.minTeamSize} -
											${h.maxTeamSize} members</span>
										<c:choose>
											<c:when test="${h.participationScope == 'OPEN_TO_ALL'}"><span class="tag tag-eligibility">Open to All</span></c:when>
											<c:otherwise><span class="tag tag-eligibility">Campus Only</span></c:otherwise>
										</c:choose>
									<c:choose>
										<c:when test="${h.payment == 'PAID'}"><span class="tag tag-fee">Application Fee: Rs. ${empty h.entryFeeAmount ? 199 : h.entryFeeAmount}</span></c:when>
										<c:otherwise><span class="tag tag-fee">Free Entry</span></c:otherwise>
									</c:choose>
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

				<c:if test="${not empty hackathons}">
					<!-- JS-driven no results message (only when card list exists) -->
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
				</c:if>
			</div>
		</main>

	</div>

	<script>
(function () {
  const cards        = Array.from(document.querySelectorAll('.card'));
  const searchInput  = document.getElementById('searchInput');
  const teamSizeSel  = document.getElementById('teamSizeFilter');
	const scopeSel     = document.getElementById('scopeFilter');
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
			scope      : scopeSel ? scopeSel.value : '',
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
	const scope  = card.dataset.scope       || 'CAMPUS_ONLY';

      // --- keyword ---
      const kw = f.keyword;
	const kwMatch = !kw || title.includes(kw) || desc.includes(kw) || type.toLowerCase().includes(kw);

      // --- type ---
      const typeMatch = !f.type || type.toUpperCase() === f.type.toUpperCase();

      // --- team size: selected value must fall within min–max range ---
      let teamMatch = true;
      if (f.teamSize) {
        const sz = parseInt(f.teamSize);
        teamMatch = sz >= minT && sz <= maxT;
      }

	const scopeMatch = !f.scope || scope.toUpperCase() === f.scope.toUpperCase();

	const show = kwMatch && typeMatch && teamMatch && scopeMatch;
      card.classList.toggle('hidden', !show);
      if (show) visible.push(card);
    });

    // --- sort visible cards ---
    sortCards(visible, f.sort);

    // --- update count ---
    countEl.textContent = '(' + visible.length + ')';

    // --- no-results state ---
		if (noResults) {
			noResults.classList.toggle('visible', visible.length === 0);
		}
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
	if (scopeSel) scopeSel.addEventListener('change', applyFilters);
  sortSel.addEventListener('change', applyFilters);

  resetBtn.addEventListener('click', function () {
    if (searchInput) searchInput.value = '';
    document.getElementById('type-all').checked = true;
    teamSizeSel.value = '';
		if (scopeSel) scopeSel.value = '';
    sortSel.value = 'default';
    applyFilters();
  });

  // --- Init ---
  applyFilters();
})();
</script>
</body>
</html>
















