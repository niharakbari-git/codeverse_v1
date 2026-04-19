<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Hackathon Ops</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260415b">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260415b"></script>
<style>
.wrap{padding:16px;display:grid;gap:12px}
.hero{padding:14px;display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap;background:#1f2937;color:#fff}
.hero h1{font-size:clamp(34px,5vw,52px)}
.hero p{margin-top:6px;color:#fff4ef}
.hero .actions{display:flex;gap:8px;flex-wrap:wrap}
.hero .actions a{padding:9px 10px;border:2px solid #1f2329;border-radius:12px;background:#fff;color:#1f2329;text-decoration:none;font-weight:700}
.board{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:10px}
.metric{padding:12px;border:2px solid #1f2329;border-radius:14px;background:#fff;display:block;text-decoration:none;color:inherit;transition:transform .18s ease,box-shadow .18s ease}
.metric:hover{transform:translateY(-2px)}
.metric.active{background:#1f2329;color:#fff}
.metric .k{font-size:11px;text-transform:uppercase;color:inherit;opacity:.72;font-weight:700}
.metric .v{font-size:34px;font-family:"Syne",sans-serif;line-height:1;margin-top:4px}
.table-card{overflow:auto;padding:10px}
.status{display:inline-flex;padding:4px 8px;border:2px solid #1f2329;border-radius:999px;background:#fff;font-size:11px;font-weight:700;text-transform:uppercase}
.ops{display:flex;gap:6px;flex-wrap:wrap}
.ops a{padding:6px 8px;border:2px solid #1f2329;border-radius:10px;text-decoration:none;font-weight:700;font-size:11px;color:#1f2329;background:#fff}
.empty{text-align:center;padding:16px;font-weight:700}
@media(max-width:1050px){.board{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:760px){.board{grid-template-columns:1fr}}
</style>
</head>
<body>
<div class="neo-shell wrap">
  <section class="neo-panel hero" data-reveal>
    <div>
      <h1 class="neo-title">Hackathon Ops</h1>
      <p>Control scheduling, participation windows, and status transitions from one board.</p>
    </div>
    <div class="actions">
      <a href="<c:url value='/newHackathon' />">Create</a>
      <c:choose>
        <c:when test="${sessionScope.user.role == 'ADMIN'}"><a href="<c:url value='/admin-dashboard' />">Dashboard</a></c:when>
        <c:when test="${sessionScope.user.role == 'ORGANIZER'}"><a href="<c:url value='/organizer-dashboard' />">Dashboard</a></c:when>
        <c:when test="${sessionScope.user.role == 'JUDGE'}"><a href="<c:url value='/judge-dashboard' />">Dashboard</a></c:when>
        <c:otherwise><a href="<c:url value='/participant/participant-dashboard' />">Dashboard</a></c:otherwise>
      </c:choose>
    </div>
  </section>

  <section class="board" data-reveal>
    <a class="metric ${selectedStatus == 'ALL' ? 'active' : ''}" href="<c:url value='/listHackathon' />"><div class="k">Total</div><div class="v">${totalCount}</div></a>
    <a class="metric ${selectedStatus == 'UPCOMING' ? 'active' : ''}" href="<c:url value='/listHackathon?status=UPCOMING' />"><div class="k">Upcoming</div><div class="v">${upcomingCount}</div></a>
    <a class="metric ${selectedStatus == 'ONGOING' ? 'active' : ''}" href="<c:url value='/listHackathon?status=ONGOING' />"><div class="k">Ongoing</div><div class="v">${ongoingCount}</div></a>
    <a class="metric ${selectedStatus == 'COMPLETED' ? 'active' : ''}" href="<c:url value='/listHackathon?status=COMPLETED' />"><div class="k">Completed</div><div class="v">${completedCount}</div></a>
  </section>

  <section class="neo-panel table-card" data-reveal>
    <table>
      <thead>
        <tr>
          <th>Title</th>
          <th>Registration Start</th>
          <th>Registration End</th>
          <th>Status</th>
          <th>Payment</th>
          <th>Application Fee</th>
          <th>Organizer ID</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty hackathons}">
            <tr><td class="empty" colspan="8">No hackathons available.</td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach items="${hackathons}" var="h">
              <tr>
                <td><c:out value="${h.title}"/></td>
                <td><fmt:parseDate value="${h.registrationStartDate}" pattern="yyyy-MM-dd" var="listRegStart" type="date" /><fmt:formatDate value="${listRegStart}" pattern="dd-MM-yyyy" /></td>
                <td><fmt:parseDate value="${h.registrationEndDate}" pattern="yyyy-MM-dd" var="listRegEnd" type="date" /><fmt:formatDate value="${listRegEnd}" pattern="dd-MM-yyyy" /></td>
                <td><span class="status"><c:out value="${empty h.displayStatus ? h.status : h.displayStatus}"/></span></td>
                <td><c:out value="${h.payment}"/></td>
                <td>
                  <c:choose>
                    <c:when test="${h.payment == 'FREE'}">Free</c:when>
                    <c:otherwise>Rs. ${empty h.entryFeeAmount ? 199 : h.entryFeeAmount}</c:otherwise>
                  </c:choose>
                </td>
                <td><c:out value="${h.userId}"/></td>
                <td>
                  <div class="ops">
                    <a href="viewHackathon?hackathonId=${h.hackathonId}">View</a>
                    <a href="editHackathon?hackathonId=${h.hackathonId}">Edit</a>
                    <a href="deleteHackathon?hackathonId=${h.hackathonId}" onclick="return confirm('Delete this hackathon?');">Delete</a>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </section>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>


