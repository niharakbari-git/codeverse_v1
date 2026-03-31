<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>User List</title>
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
	--danger: #ef4444;
	--ok: #22c55e;
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
.wrap { position: relative; z-index: 1; max-width: 1250px; margin: 0 auto; padding: 30px 18px 40px; }
.topbar { display: flex; justify-content: space-between; align-items: center; gap: 12px; flex-wrap: wrap; margin-bottom: 16px; }
.title { font-size: clamp(24px, 4vw, 34px); font-weight: 800; letter-spacing: -0.6px; }
.title span { background: linear-gradient(135deg, var(--accent), var(--accent2)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.actions { display: flex; gap: 8px; }
.btn {
	text-decoration: none;
	border: 1px solid var(--border);
	background: var(--surface);
	color: var(--text);
	padding: 8px 12px;
	border-radius: 10px;
	font-size: 13px;
	font-weight: 700;
	display: inline-block;
}
.btn.primary { background: var(--accent); border-color: var(--accent); }
.panel { border: 1px solid var(--border); border-radius: 14px; background: var(--surface); overflow: auto; }
table { width: 100%; border-collapse: collapse; min-width: 920px; }
thead { background: var(--surface2); }
th, td { text-align: left; padding: 12px 10px; border-bottom: 1px solid var(--border); font-size: 14px; }
th { font-size: 12px; text-transform: uppercase; letter-spacing: 0.9px; color: var(--muted); }
.profile-pic { width: 38px; height: 38px; border-radius: 50%; object-fit: cover; }
.badge {
	font-size: 11px;
	border-radius: 999px;
	padding: 3px 8px;
	display: inline-block;
	font-weight: 700;
}
.badge.role { background: rgba(6, 182, 212, 0.18); color: #67e8f9; }
.badge.on { background: rgba(34, 197, 94, 0.14); color: #4ade80; }
.badge.off { background: rgba(239, 68, 68, 0.14); color: #fca5a5; }
.row-actions { display: flex; gap: 6px; }
.row-actions .btn { padding: 6px 9px; font-size: 12px; }
.row-actions .warn { border-color: #f59e0b; color: #fbbf24; }
.row-actions .danger { border-color: #ef4444; color: #fca5a5; }
.empty { padding: 18px; color: var(--muted); text-align: center; }
</style>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">

</head>

<body>
	<div class="wrap">
		<div class="topbar">
			<h1 class="title"><span>User</span> Directory</h1>
			<div class="actions">
				<a href="<c:url value='/admin-dashboard' />" class="btn">Dashboard</a>
				<a href="<c:url value='/signup' />" class="btn primary">Add User</a>
				<a href="<c:url value='/logout' />" class="btn">Logout</a>
			</div>
		</div>

		<div class="panel">
			<table>
				<thead>
					<tr>
						<th>#</th>
						<th>Name</th>
						<th>Email</th>
						<th>Role</th>
						<th>Gender</th>
						<th>Birth Year</th>
						<th>Profile</th>
						<th>Status</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="user" items="${userList}" varStatus="s">
						<tr>
							<td>${s.count}</td>
							<td>${user.firstName} ${user.lastName}</td>
							<td>${user.email}</td>
							<td><span class="badge role">${user.role}</span></td>
							<td>${user.gender}</td>
							<td>${user.birthYear}</td>
							<td>
								<c:if test="${not empty user.profilePicURL}">
									<img src="${user.profilePicURL}" class="profile-pic" alt="profile">
								</c:if>
							</td>
							<td>
								<c:choose>
									<c:when test="${user.active}"><span class="badge on">Active</span></c:when>
									<c:otherwise><span class="badge off">Inactive</span></c:otherwise>
								</c:choose>
							</td>
							<td>
								<div class="row-actions">
									<a href="<c:url value='/viewUser?userId=${user.userId}' />" class="btn">View</a>
									<a href="<c:url value='/editUser?userId=${user.userId}' />" class="btn warn">Edit</a>
									<a href="<c:url value='/deleteUser?userId=${user.userId}' />" class="btn danger" onclick="return confirm('Are you sure?');">Delete</a>
								</div>
							</td>
						</tr>
					</c:forEach>
					<c:if test="${empty userList}">
						<tr>
							<td colspan="9" class="empty">No users found</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>
