<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Hackathon Details</title>
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

.wrap{max-width:1020px;padding:0}
.top{display:flex;justify-content:space-between;align-items:flex-start;gap:10px;flex-wrap:wrap;margin-bottom:12px}
.title{font-size:clamp(28px,5vw,48px)}
.panel{padding:16px}
.chips{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:12px}
.grid{display:grid;grid-template-columns:repeat(2,minmax(220px,1fr));gap:10px}
.item{padding:12px;border:2px solid #1f2329;border-radius:12px;background:#fff}
.item p{font-size:12px;font-weight:700;color:#5e6673;text-transform:uppercase;letter-spacing:.06em;margin:0 0 4px}
.item h4{margin:0}
.desc{margin-top:10px;padding:12px;border:2px solid #1f2329;border-radius:12px;background:#fff}
.desc p{margin:0 0 6px;font-size:12px;font-weight:700;color:#5e6673;text-transform:uppercase;letter-spacing:.06em}
.actions{margin-top:12px;display:flex;gap:8px;flex-wrap:wrap}
@media(max-width:760px){.grid{grid-template-columns:1fr}}
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
      <a class="active" href="<c:url value='/participant/home' />">Explore Hackathons</a>
      <a href="<c:url value='/participant/my-applications' />">My Applications</a>
      <a href="<c:url value='/participant/my-teams' />">My Teams</a>
      <a href="<c:url value='/participant/profile' />">Profile</a>
      <a href="<c:url value='/charge' />">Open Payments</a>
    </div>
  </aside>

  <main class="content">
<div class="wrap">
  <div class="top" data-reveal>
    <h1 class="neo-title title">${hackathon.title}</h1>
    <a href="<c:url value='/participant/home' />" class="btn">Back to Explore</a>
  </div>

  <section class="neo-panel panel" data-reveal>
    <div class="chips">
      <span class="neo-badge status">${hackathon.status}</span>
      <span class="neo-badge">${hackathon.eventType}</span>
      <c:choose>
        <c:when test="${hackathon.participationScope == 'OPEN_TO_ALL'}"><span class="neo-badge">Open to All</span></c:when>
        <c:otherwise><span class="neo-badge">Campus Only</span></c:otherwise>
      </c:choose>
      <c:choose>
        <c:when test="${hackathon.payment == 'PAID'}"><span class="neo-badge">Application Fee: Rs. ${empty hackathon.entryFeeAmount ? 199 : hackathon.entryFeeAmount}</span></c:when>
        <c:otherwise><span class="neo-badge">Free Entry</span></c:otherwise>
      </c:choose>
    </div>

    <div class="grid">
      <div class="item"><p>Team Size</p><h4>${hackathon.minTeamSize} - ${hackathon.maxTeamSize} members</h4></div>
      <div class="item"><p>Location</p><h4>${hackathon.eventType == 'ONLINE' ? 'Online Event' : hackathon.location}</h4></div>
      <div class="item"><p>Eligibility</p><h4>${hackathon.participationScope == 'OPEN_TO_ALL' ? 'All Participants' : 'Campus Participants'}</h4></div>
      <div class="item"><p>Registration Window</p><h4>
        <fmt:parseDate value="${hackathon.registrationStartDate}" pattern="yyyy-MM-dd" var="parsedRegStart" type="date" />
        <fmt:parseDate value="${hackathon.registrationEndDate}" pattern="yyyy-MM-dd" var="parsedRegEnd" type="date" />
        <fmt:formatDate value="${parsedRegStart}" pattern="dd-MM-yyyy" /> to <fmt:formatDate value="${parsedRegEnd}" pattern="dd-MM-yyyy" />
      </h4></div>
      <div class="item"><p>Submission Deadline</p><h4>${hackathon.submissionDeadline}</h4></div>
      <div class="item"><p>Application Fee</p><h4><c:choose><c:when test="${hackathon.payment == 'PAID'}">Rs. ${empty hackathon.entryFeeAmount ? 199 : hackathon.entryFeeAmount} per team application</c:when><c:otherwise>Free</c:otherwise></c:choose></h4></div>
      <div class="item"><p>Problem Title</p><h4>${hackathon.problemTitle}</h4></div>
    </div>

    <div class="desc">
      <p>Description</p>
      <div>${hackathon.description}</div>
    </div>

    <div class="desc">
      <p>Problem Statement</p>
      <div>${hackathon.problemStatement}</div>
    </div>

    <div class="desc">
      <p>Deliverables</p>
      <div>${hackathon.problemDeliverables}</div>
    </div>

    <div class="desc">
      <p>Submission Checklist</p>
      <div>${hackathon.submissionChecklist}</div>
    </div>

    <c:if test="${isCampusOnly}">
      <div class="desc">
        <p>Campus Access Verification</p>
        <c:choose>
          <c:when test="${campusAccessVerified}">
            <div class="neo-badge">Verified for this hackathon</div>
          </c:when>
          <c:otherwise>
            <div style="display:grid;gap:10px;">
              <div style="color:#5e6673;">Verify campus email with invitation code before applying or joining a team.</div>
              <form action="<c:url value='/participant/hackathon/request-access-otp' />" method="post" style="display:grid;gap:8px;">
                <input type="hidden" name="_csrf" value="${_csrfToken}">
                <input type="hidden" name="hackathonId" value="${hackathon.hackathonId}">
                <input type="email" name="verificationEmail" placeholder="student@college.edu" required>
                <input type="text" name="inviteCode" placeholder="Invitation Code" required>
                <button type="submit">Send OTP</button>
              </form>
              <form action="<c:url value='/participant/hackathon/verify-access-otp' />" method="post" style="display:grid;gap:8px;">
                <input type="hidden" name="_csrf" value="${_csrfToken}">
                <input type="hidden" name="hackathonId" value="${hackathon.hackathonId}">
                <input type="email" name="verificationEmail" placeholder="student@college.edu" required>
                <input type="text" name="inviteCode" placeholder="Invitation Code" required>
                <input type="text" name="otp" placeholder="Enter OTP" required>
                <button type="submit">Verify OTP</button>
              </form>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </c:if>

    <div class="actions">
      <c:choose>
        <c:when test="${hasApplied}">
          <span class="btn">Already Applied</span>
          <a class="btn" href="<c:url value='/participant/my-applications' />">View My Applications</a>
        </c:when>
        <c:when test="${isExpired}">
          <span class="btn">Expired</span>
          <a class="btn" href="<c:url value='/participant/home?msg=This+hackathon+is+expired+and+cannot+be+applied+to&type=error' />">Back to Explore</a>
        </c:when>
        <c:when test="${isCampusOnly and not campusAccessVerified}">
          <span class="btn">Verify Campus Access First</span>
        </c:when>
        <c:otherwise>
          <a class="btn" href="<c:url value='/participant/team/new?hackathonId=${hackathon.hackathonId}' />">Apply With Team</a>
        </c:otherwise>
      </c:choose>
    </div>
  </section>
</div>
  </main>
</div>
<%@ include file="../shared/Toast.jspf" %>
</body>
</html>















