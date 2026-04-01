<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Hackathon Details</title>
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
.wrap { position: relative; z-index: 1; max-width: 1000px; margin: 0 auto; padding: 28px 18px 40px; }
.top { display: flex; justify-content: space-between; align-items: center; gap: 10px; flex-wrap: wrap; margin-bottom: 18px; }
.title { font-size: clamp(26px, 4.5vw, 42px); line-height: 1.1; font-weight: 800; letter-spacing: -0.8px; }
.title span { background: linear-gradient(135deg, var(--accent), var(--accent2)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.btn { text-decoration: none; border: 1px solid var(--border); background: var(--surface); color: var(--text); border-radius: 10px; padding: 9px 13px; font-size: 13px; font-weight: 700; }
.panel { border: 1px solid var(--border); border-radius: 14px; background: var(--surface); padding: 18px; }
.chips { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 14px; }
.chip { padding: 5px 10px; font-size: 11px; border-radius: 999px; border: 1px solid var(--border); background: var(--surface2); color: var(--muted); font-weight: 700; }
.grid { display: grid; grid-template-columns: repeat(2, minmax(220px, 1fr)); gap: 12px; }
.item { border: 1px solid var(--border); border-radius: 10px; background: var(--surface2); padding: 12px; }
.item p { color: var(--muted); font-size: 12px; margin-bottom: 4px; }
.item h4 { font-size: 16px; font-weight: 700; }
.desc { margin-top: 14px; border: 1px solid var(--border); border-radius: 10px; padding: 14px; background: #10111a; }
.desc p { color: var(--muted); margin-bottom: 6px; font-size: 12px; }
.desc div { line-height: 1.7; }
.actions { margin-top: 14px; display: flex; gap: 8px; flex-wrap: wrap; }
.btn.primary { background: #7c3aed; border-color: #7c3aed; color: #fff; }
.btn.ok { background: rgba(34,197,94,.16); border-color: rgba(34,197,94,.35); color: #86efac; }
@media (max-width: 680px) { .grid { grid-template-columns: 1fr; } }
</style>
</head>
<body>
<div class="wrap">
	<div class="top">
		<h1 class="title"><span>${hackathon.title}</span></h1>
		<a href="<c:url value='/participant/home' />" class="btn">Back to Explore</a>
	</div>

	<div class="panel">
		<div class="chips">
			<span class="chip">${hackathon.status}</span>
			<span class="chip">${hackathon.eventType}</span>
			<span class="chip">${hackathon.payment}</span>
		</div>

		<div class="grid">
			<div class="item"><p>Team Size</p><h4>${hackathon.minTeamSize} - ${hackathon.maxTeamSize} members</h4></div>
			<div class="item"><p>Location</p><h4>${hackathon.location}</h4></div>
			<div class="item"><p>Eligibility Group</p><h4>${hackathon.userTypeId}</h4></div>
			<div class="item"><p>Registration Window</p><h4>
				<fmt:parseDate value="${hackathon.registrationStartDate}" pattern="yyyy-MM-dd" var="parsedRegStart" type="date" />
				<fmt:parseDate value="${hackathon.registrationEndDate}" pattern="yyyy-MM-dd" var="parsedRegEnd" type="date" />
				<fmt:formatDate value="${parsedRegStart}" pattern="dd/MM/yyyy" /> to <fmt:formatDate value="${parsedRegEnd}" pattern="dd/MM/yyyy" />
			</h4></div>
		</div>

		<div class="desc">
			<p>Description</p>
			<div>${hackathon.description}</div>
		</div>

		<div class="actions">
			<c:choose>
				<c:when test="${hasApplied}">
					<span class="btn ok">Already Applied</span>
					<a class="btn" href="<c:url value='/participant/my-applications' />">View My Applications</a>
				</c:when>
				<c:otherwise>
					<a class="btn primary" href="<c:url value='/participant/team/new?hackathonId=${hackathon.hackathonId}' />">Apply With Team</a>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</div>
</body>
</html>
