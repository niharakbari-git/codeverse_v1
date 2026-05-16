<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Scoreboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
  <style>
    .container{max-width:980px;margin:18px auto;padding:12px}
    .header{display:flex;justify-content:space-between;align-items:end}
    .board{margin-top:12px}
    .row{display:grid;grid-template-columns:40px 1fr 120px 80px;gap:12px;padding:12px;border-bottom:1px solid #eef3f8;align-items:center}
    .row.header{font-weight:800;background:#f7fafc}
    .winner{background:linear-gradient(90deg,#fff7ed,#fffbeb)}
    @media(max-width:600px){.row{grid-template-columns:40px 1fr 80px}}
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <div>
        <h1>Scoreboard: ${hackathon.title}</h1>
        <div style="color:#52606d">Hackathon ID: ${hackathon.hackathonId}</div>
      </div>
      <div>
        <c:if test="${not empty isCompleted}">
          <div class="neo-badge">Completed</div>
        </c:if>
      </div>
    </div>

    <c:choose>
      <c:when test="${empty scoreboard}">
        <div style="margin-top:12px">No scores recorded yet for this hackathon.</div>
      </c:when>
      <c:otherwise>
        <div class="board">
          <div class="row header">
            <div>#</div>
            <div>Name</div>
            <div style="text-align:right">Avg Score</div>
            <div style="text-align:right">Judges</div>
          </div>
          <c:forEach items="${scoreboard}" var="s">
            <div class="row ${s.winner ? 'winner' : ''}">
              <div>${s.rank}</div>
              <div>
                <c:if test="${s.winner}"><span style="color:#b45309;margin-right:8px">🏆</span></c:if>
                ${s.name}
              </div>
              <div style="text-align:right"><fmt:formatNumber value="${s.averageScore}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
              <div style="text-align:right">${s.scoreCount}</div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</body>
</html>
