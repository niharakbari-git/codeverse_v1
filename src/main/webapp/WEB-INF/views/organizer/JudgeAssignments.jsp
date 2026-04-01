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
.wrap{max-width:1050px;margin:24px auto;padding:18px}
.top{display:flex;justify-content:space-between;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:14px}
.btn{text-decoration:none;padding:9px 12px;border:1px solid #2a2a3d;background:#13131a;border-radius:10px;color:#e2e8f0;font-weight:700}
.form{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;padding:14px;margin-bottom:14px;display:grid;grid-template-columns:1fr 1fr auto;gap:10px;align-items:end}
label{display:block;font-size:12px;color:#64748b;margin-bottom:6px}
select{width:100%;padding:10px;border-radius:10px;border:1px solid #2a2a3d;background:#1c1c27;color:#e2e8f0}
button{padding:10px 14px;border:1px solid #7c3aed;background:#7c3aed;color:#fff;border-radius:10px;font-weight:700;cursor:pointer}
.panel{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;overflow:auto}
table{width:100%;border-collapse:collapse;min-width:700px}
th,td{padding:12px;border-bottom:1px solid #2a2a3d;text-align:left}
th{font-size:12px;color:#64748b;text-transform:uppercase}
.empty{padding:16px;color:#64748b}
@media(max-width:780px){.form{grid-template-columns:1fr}}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <h2>Judge Assignments</h2>
    <a class="btn" href="<c:url value='/organizer-dashboard' />">Dashboard</a>
  </div>

  <form class="form" action="<c:url value='/organizer/assign-judge' />" method="post">
    <div>
      <label>Hackathon</label>
      <select name="hackathonId" required>
        <option value="">-- Select Hackathon --</option>
        <c:forEach items="${myHackathons}" var="h">
          <option value="${h.hackathonId}">${h.title}</option>
        </c:forEach>
      </select>
    </div>
    <div>
      <label>Judge</label>
      <select name="judgeUserId" required>
        <option value="">-- Select Judge --</option>
        <c:forEach items="${judges}" var="j">
          <option value="${j.userId}">${j.firstName} ${j.lastName} (${j.email})</option>
        </c:forEach>
      </select>
    </div>
    <div>
      <button type="submit">Assign Judge</button>
    </div>
  </form>

  <div class="panel">
    <table>
      <thead>
        <tr>
          <th>Hackathon</th>
          <th>Judge</th>
          <th>Assigned On</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${assignmentViews}" var="a">
          <tr>
            <td>${a.hackathonTitle}</td>
            <td>${a.judgeName}</td>
            <fmt:parseDate value="${a.assignedAt}" pattern="yyyy-MM-dd" var="parsedAssignedAt" type="date" />
            <td><fmt:formatDate value="${parsedAssignedAt}" pattern="dd/MM/yyyy" /></td>
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
