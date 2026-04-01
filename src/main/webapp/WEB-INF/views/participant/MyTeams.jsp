<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Teams</title>
<style>
body{margin:0;background:#0a0a0f;color:#e2e8f0;font-family:'Syne',sans-serif}
.wrap{max-width:1000px;margin:24px auto;padding:18px}
.top{display:flex;justify-content:space-between;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:14px}
.btn{text-decoration:none;padding:9px 12px;border:1px solid #2a2a3d;background:#13131a;border-radius:10px;color:#e2e8f0;font-weight:700}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:12px}
.card{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;padding:14px}
.card h4{margin:0 0 7px}
.card p{margin:0;color:#94a3b8;font-size:13px;line-height:1.6}
.members{margin:10px 0 8px;padding-left:16px;color:#cbd5e1;font-size:13px}
.members li{margin-bottom:4px}
.role{display:inline-block;margin-top:8px;padding:3px 8px;border-radius:999px;border:1px solid #334155;background:#111827;color:#93c5fd;font-size:11px;font-weight:700}
.form{display:grid;grid-template-columns:1fr auto;gap:8px;margin-top:10px}
.input{width:100%;padding:9px 10px;border-radius:10px;border:1px solid #2a2a3d;background:#1c1c27;color:#e2e8f0}
.submit{padding:9px 12px;border:1px solid #7c3aed;background:#7c3aed;color:#fff;border-radius:10px;font-weight:700;cursor:pointer}
.msg{padding:10px 12px;border-radius:10px;margin-bottom:12px;font-size:13px}
.msg.success{background:#072e2f;border:1px solid #0f766e;color:#ccfbf1}
.msg.error{background:#3b0d0d;border:1px solid #7f1d1d;color:#fecaca}
.empty{padding:16px;color:#64748b;background:#13131a;border:1px solid #2a2a3d;border-radius:14px}
@media(max-width:560px){.form{grid-template-columns:1fr}}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <h2>My Teams</h2>
    <div>
      <a class="btn" href="<c:url value='/participant/profile' />">Profile</a>
      <a class="btn" href="<c:url value='/participant/my-applications' />">My Applications</a>
      <a class="btn" href="<c:url value='/participant/home' />">Explore</a>
    </div>
  </div>

  <c:if test="${not empty param.msg}">
    <div class="msg ${param.type == 'success' ? 'success' : 'error'}">${param.msg}</div>
  </c:if>

  <c:if test="${empty teamViews}">
    <div class="empty">No teams yet. Create a team while applying to a hackathon.</div>
  </c:if>

  <div class="grid">
    <c:forEach items="${teamViews}" var="t">
      <div class="card">
        <h4>${t.team.teamName}</h4>
        <p>Hackathon: ${t.hackathonTitle}</p>
        <p>Members: ${t.memberCount}</p>
        <span class="role">${t.roleInTeam}</span>
        <fmt:parseDate value="${t.team.createdAt}" pattern="yyyy-MM-dd" var="parsedCreatedAt" type="date" />
        <p>Created: <fmt:formatDate value="${parsedCreatedAt}" pattern="dd/MM/yyyy" /></p>

        <ul class="members">
          <c:forEach items="${t.memberNames}" var="memberName">
            <li>${memberName}</li>
          </c:forEach>
        </ul>

        <c:if test="${t.canManageMembers}">
          <form class="form" action="<c:url value='/participant/team/add-member' />" method="post">
            <input type="hidden" name="teamId" value="${t.team.teamId}">
            <input class="input" type="email" name="memberEmail" placeholder="Add member by email" required>
            <button class="submit" type="submit">Add</button>
          </form>
        </c:if>
      </div>
    </c:forEach>
  </div>
</div>
</body>
</html>
