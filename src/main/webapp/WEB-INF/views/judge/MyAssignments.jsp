<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Judge Assignments</title>
<style>
body{margin:0;background:#0a0a0f;color:#e2e8f0;font-family:'Syne',sans-serif}
.wrap{max-width:900px;margin:24px auto;padding:18px}
.top{display:flex;justify-content:space-between;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:14px}
.btn{text-decoration:none;padding:9px 12px;border:1px solid #2a2a3d;background:#13131a;border-radius:10px;color:#e2e8f0;font-weight:700}
.panel{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;overflow:auto}
table{width:100%;border-collapse:collapse;min-width:660px}
th,td{padding:12px;border-bottom:1px solid #2a2a3d;text-align:left}
th{font-size:12px;color:#64748b;text-transform:uppercase}
.empty{padding:16px;color:#64748b}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <h2>My Judge Assignments</h2>
    <a class="btn" href="<c:url value='/judge-dashboard' />">Dashboard</a>
  </div>

  <div class="panel">
    <table>
      <thead>
        <tr>
          <th>Hackathon</th>
          <th>Assigned By</th>
          <th>Date</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${assignmentViews}" var="a">
          <tr>
            <td>${a.hackathonTitle}</td>
            <td>${a.assignedBy}</td>
            <td><fmt:formatDate value="${a.assignedAt}" pattern="dd/MM/yyyy" /></td>
          </tr>
        </c:forEach>
        <c:if test="${empty assignmentViews}">
          <tr><td colspan="3" class="empty">No assignments yet.</td></tr>
        </c:if>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>
