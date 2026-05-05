<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>User Directory</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260415b">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260415b"></script>
<style>
.wrap{padding:16px;display:grid;gap:12px}
.top{padding:14px;display:flex;justify-content:space-between;gap:10px;flex-wrap:wrap;align-items:center;background:#1f2937;color:#fff}
.top h1{font-size:clamp(32px,5vw,48px)}
.top p{margin-top:6px;color:#effffc}
.top .act{display:flex;gap:8px;flex-wrap:wrap}
.top .act a{padding:9px 10px;border:2px solid #1f2329;border-radius:12px;background:#fff;color:#1f2329;text-decoration:none;font-weight:700}
.stats{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:10px}
.metric{padding:12px;border:2px solid #1f2329;border-radius:14px;background:#fff;display:block;text-decoration:none;color:inherit;transition:transform .18s ease,box-shadow .18s ease}
.metric:hover{transform:translateY(-2px)}
.metric.active{background:#1f2329;color:#fff}
.metric .k{font-size:11px;text-transform:uppercase;color:inherit;opacity:.72;font-weight:700}
.metric .v{font-size:34px;font-family:"Syne",sans-serif;line-height:1;margin-top:4px}
.table-card{overflow:auto;padding:10px}
.role{display:inline-flex;padding:4px 8px;border:2px solid #1f2329;border-radius:999px;background:#fff;font-size:11px;font-weight:700;text-transform:uppercase}
.actions{display:flex;gap:10px;flex-wrap:nowrap;align-items:center;min-height:36px}
.actions a{padding:8px 12px;border:2px solid #1f2329;border-radius:10px;text-decoration:none;font-weight:700;font-size:11px;background:#fff;color:#1f2329;height:36px;display:inline-flex;align-items:center;justify-content:center;white-space:nowrap}
.empty{text-align:center;padding:16px;font-weight:700}
@media(max-width:1050px){.stats{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:640px){.stats{grid-template-columns:1fr}}
</style>
</head>
<body>
<div class="neo-shell wrap">
  <section class="neo-panel top" data-reveal>
    <div>
      <h1 class="neo-title">User Directory</h1>
      <p>Administrative control panel for platform accounts.</p>
    </div>
    <div class="act">
      <a href="<c:url value='/admin/user/new' />">Add User</a>
      <c:choose>
        <c:when test="${sessionScope.user.role == 'ADMIN'}"><a href="<c:url value='/admin-dashboard' />">Dashboard</a></c:when>
        <c:when test="${sessionScope.user.role == 'ORGANIZER'}"><a href="<c:url value='/organizer-dashboard' />">Dashboard</a></c:when>
        <c:when test="${sessionScope.user.role == 'JUDGE'}"><a href="<c:url value='/judge-dashboard' />">Dashboard</a></c:when>
        <c:otherwise><a href="<c:url value='/participant/participant-dashboard' />">Dashboard</a></c:otherwise>
      </c:choose>
    </div>
  </section>

  <section class="stats" data-reveal>
    <a class="metric ${selectedRole == 'ALL' ? 'active' : ''}" href="<c:url value='/admin/user-list' />"><div class="k">All Users</div><div class="v">${totalUserCount}</div></a>
    <a class="metric ${selectedRole == 'ADMIN' ? 'active' : ''}" href="<c:url value='/admin/user-list?role=ADMIN' />"><div class="k">Admins</div><div class="v">${adminCount}</div></a>
    <a class="metric ${selectedRole == 'ORGANIZER' ? 'active' : ''}" href="<c:url value='/admin/user-list?role=ORGANIZER' />"><div class="k">Organizers</div><div class="v">${organizerCount}</div></a>
    <a class="metric ${selectedRole == 'JUDGE' ? 'active' : ''}" href="<c:url value='/admin/user-list?role=JUDGE' />"><div class="k">Judges</div><div class="v">${judgeCount}</div></a>
    <a class="metric ${selectedRole == 'PARTICIPANT' ? 'active' : ''}" href="<c:url value='/admin/user-list?role=PARTICIPANT' />"><div class="k">Participants</div><div class="v">${participantCount}</div></a>
  </section>

  <section class="neo-panel table-card" data-reveal>
    <table>
      <thead>
        <tr>
          <th>First</th>
          <th>Last</th>
          <th>Email</th>
          <th>Role</th>
          <th>Contact</th>
          <th>Birth Year</th>
          <th>Created</th>
          <th>Profile</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty users}">
            <tr><td class="empty" colspan="12">No users found.</td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach items="${users}" var="u">
              <tr>
                <td><c:out value="${u.firstName}"/></td>
                <td><c:out value="${u.lastName}"/></td>
                <td><c:out value="${u.email}"/></td>
                <td><span class="role"><c:out value="${u.role}"/></span></td>
                <td><c:out value="${u.contactNum}"/></td>
                <td><c:out value="${u.birthYear}"/></td>
                <td><c:out value="${u.createdAt}"/></td>
                <td><a href="<c:url value='/admin/viewUser?userId=${u.userId}' />">Open</a></td>
                <td>
                  <div class="actions">
                    <a href="<c:url value='/admin/viewUser?userId=${u.userId}' />">View</a>
                    <a href="<c:url value='/admin/editUser?userId=${u.userId}' />">Edit</a>
                    <a href="<c:url value='/admin/deleteUser?userId=${u.userId}' />" onclick="return confirm('Delete this user?');">Delete</a>
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


