<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit User</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--bg:#0a0f16;--surface:#131c27;--surface2:#1c2734;--border:#2a3d52;--text:#e2e8f0;--muted:#8ca0b3;--accent:#f97316;--accent2:#06b6d4}
body{font-family:'Syne',sans-serif;background:radial-gradient(circle at 12% 16%,rgba(6,182,212,.14),transparent 35%),radial-gradient(circle at 85% 82%,rgba(249,115,22,.14),transparent 40%),var(--bg);color:var(--text);min-height:100vh}
.wrap{max-width:1040px;margin:28px auto;padding:0 18px 30px}
.top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:14px}
h1{font-size:clamp(24px,4vw,36px);font-weight:800;letter-spacing:-.6px}
h1 span{background:linear-gradient(135deg,var(--accent),var(--accent2));background-clip:text;-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.actions{display:flex;gap:8px;flex-wrap:wrap}
.btn{display:inline-block;text-decoration:none;padding:9px 12px;border:1px solid var(--border);border-radius:10px;background:var(--surface);color:var(--text);font-weight:700;font-size:13px;cursor:pointer}
.btn.primary{border:none;background:linear-gradient(135deg,var(--accent),var(--accent2));box-shadow:0 10px 24px rgba(6,182,212,.16)}
.card{border:1px solid var(--border);border-radius:14px;background:var(--surface);padding:16px}
.grid{display:grid;grid-template-columns:repeat(12,minmax(0,1fr));gap:12px}
.col-6{grid-column:span 6}
.col-4{grid-column:span 4}
label{display:block;font-size:12px;color:var(--muted);margin-bottom:6px}
input,select{width:100%;padding:11px 12px;border-radius:10px;border:1px solid var(--border);background:var(--surface2);color:var(--text);font-size:14px}
input:focus,select:focus{outline:none;border-color:var(--accent2);box-shadow:0 0 0 3px rgba(6,182,212,.14)}
.footer{margin-top:14px;display:flex;justify-content:flex-end;gap:8px;flex-wrap:wrap}
@media (max-width:900px){.col-6,.col-4{grid-column:span 12}}
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260409a">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260409a"></script>
</head>
<body>
	<c:if test="${not empty error}">
		<div id="toast-data" data-type="error" style="display:none;"><c:out value="${error}" /></div>
	</c:if>
	<c:if test="${not empty success}">
		<div id="toast-data" data-type="success" style="display:none;"><c:out value="${success}" /></div>
	</c:if>

	<div class="wrap">
		<div class="top">
			<h1><span>User</span> Editor</h1>
			<div class="actions">
				<a class="btn" href="listUser">User List</a>
				<a class="btn" href="admin-dashboard">Dashboard</a>
			</div>
		</div>

		<form class="card" action="updateUser" method="post">
			<input type="hidden" name="_csrf" value="${_csrfToken}" />
			<input type="hidden" name="userId" value="${user.userId}" />

			<div class="grid">
				<div class="col-6">
					<label>First Name</label>
					<input type="text" name="firstName" value="${user.firstName}" required>
				</div>
				<div class="col-6">
					<label>Last Name</label>
					<input type="text" name="lastName" value="${user.lastName}" required>
				</div>

				<div class="col-6">
					<label>Email</label>
					<input type="email" name="email" value="${user.email}" required>
				</div>
				<div class="col-6">
					<label>Contact Number</label>
					<input type="text" name="contactNum" value="${user.contactNum}">
				</div>

				<div class="col-4">
					<label>Role</label>
					<select name="role" required>
						<option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
						<option value="PARTICIPANT" ${user.role == 'PARTICIPANT' ? 'selected' : ''}>PARTICIPANT</option>
						<option value="ORGANIZER" ${user.role == 'ORGANIZER' ? 'selected' : ''}>ORGANIZER</option>
						<option value="JUDGE" ${user.role == 'JUDGE' ? 'selected' : ''}>JUDGE</option>
					</select>
				</div>
				<div class="col-4">
					<label>Gender</label>
					<select name="gender">
						<option value="MALE" ${user.gender == 'MALE' ? 'selected' : ''}>MALE</option>
						<option value="FEMALE" ${user.gender == 'FEMALE' ? 'selected' : ''}>FEMALE</option>
						<option value="OTHER" ${user.gender == 'OTHER' ? 'selected' : ''}>OTHER</option>
					</select>
				</div>
				<div class="col-4">
					<label>Birth Year</label>
					<input type="number" name="birthYear" value="${user.birthYear}">
				</div>

				<div class="col-6">
					<label>Qualification</label>
					<input type="text" name="qualification" value="${userDetail.qualification}">
				</div>

				<div class="col-4">
					<label>City</label>
					<input type="text" name="city" value="${userDetail.city}">
				</div>
				<div class="col-4">
					<label>State</label>
					<input type="text" name="state" value="${userDetail.state}">
				</div>
				<div class="col-4">
					<label>Country</label>
					<input type="text" name="country" value="${userDetail.country}">
				</div>

				<div class="col-4">
					<label>Active</label>
					<select name="active">
						<option value="true" ${user.active ? 'selected' : ''}>Active</option>
						<option value="false" ${!user.active ? 'selected' : ''}>Inactive</option>
					</select>
				</div>
			</div>

			<div class="footer">
				<a class="btn" href="listUser">Cancel</a>
				<button type="submit" class="btn primary">Update User</button>
			</div>
		</form>
	</div>
	<%@ include file="shared/Toast.jspf" %>
</body>
</html>














