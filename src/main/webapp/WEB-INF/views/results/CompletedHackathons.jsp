<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Completed Hackathons</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
  <style>
    .list {max-width:980px;margin:18px auto;padding:12px}
    .card{border:1px solid #d7dce5;border-radius:12px;padding:12px;margin-bottom:10px;background:#fff}
    .card h3{margin:0 0 6px}
    .meta{color:#52606d;font-size:13px}
    .actions{margin-top:8px}
    .actions a{display:inline-block;padding:8px 12px;background:#1f2329;color:#fff;border-radius:8px;text-decoration:none}
  </style>
</head>
<body>
  <div class="list">
    <h1>Completed Hackathons</h1>
    <c:choose>
      <c:when test="${empty completedHackathons}">
        <div class="card">No completed hackathons found.</div>
      </c:when>
      <c:otherwise>
        <c:forEach items="${completedHackathons}" var="h">
          <div class="card">
            <h3>${h.title}</h3>
            <div class="meta">Hackathon ID: ${h.hackathonId} — ${h.eventStartDate} to ${h.eventEndDate}</div>
            <div style="margin-top:8px">${fn:escapeXml(h.description)}</div>
            <div class="actions">
              <c:url var="scoreboardUrl" value="/results/scoreboard">
                <c:param name="hackathonId" value="${h.hackathonId}" />
              </c:url>
              <a href="${scoreboardUrl}">View Scoreboard</a>
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</body>
</html>
