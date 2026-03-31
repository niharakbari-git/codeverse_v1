<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit User</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
	<div class="container mt-4 mb-5">
		<div class="card shadow-sm">
			<div class="card-header bg-primary text-white">
				<h5 class="mb-0">Edit User</h5>
			</div>
			<div class="card-body">
				<form action="updateUser" method="post">
					<input type="hidden" name="userId" value="${user.userId}" />

					<div class="row g-3">
						<div class="col-md-6">
							<label class="form-label">First Name</label>
							<input type="text" class="form-control" name="firstName" value="${user.firstName}" required>
						</div>
						<div class="col-md-6">
							<label class="form-label">Last Name</label>
							<input type="text" class="form-control" name="lastName" value="${user.lastName}" required>
						</div>

						<div class="col-md-6">
							<label class="form-label">Email</label>
							<input type="email" class="form-control" name="email" value="${user.email}" required>
						</div>
						<div class="col-md-6">
							<label class="form-label">Contact Number</label>
							<input type="text" class="form-control" name="contactNum" value="${user.contactNum}">
						</div>

						<div class="col-md-4">
							<label class="form-label">Role</label>
							<select class="form-control" name="role" required>
								<option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
								<option value="PARTICIPANT" ${user.role == 'PARTICIPANT' ? 'selected' : ''}>PARTICIPANT</option>
								<option value="JUDGE" ${user.role == 'JUDGE' ? 'selected' : ''}>JUDGE</option>
							</select>
						</div>
						<div class="col-md-4">
							<label class="form-label">Gender</label>
							<select class="form-control" name="gender">
								<option value="MALE" ${user.gender == 'MALE' ? 'selected' : ''}>MALE</option>
								<option value="FEMALE" ${user.gender == 'FEMALE' ? 'selected' : ''}>FEMALE</option>
								<option value="OTHER" ${user.gender == 'OTHER' ? 'selected' : ''}>OTHER</option>
							</select>
						</div>
						<div class="col-md-4">
							<label class="form-label">Birth Year</label>
							<input type="number" class="form-control" name="birthYear" value="${user.birthYear}">
						</div>

						<div class="col-md-6">
							<label class="form-label">Qualification</label>
							<input type="text" class="form-control" name="qualification" value="${userDetail.qualification}">
						</div>
						<div class="col-md-6">
							<label class="form-label">User Type</label>
							<select class="form-control" name="userTypeId">
								<option value="">-- Select --</option>
								<c:forEach items="${allUserType}" var="ut">
									<option value="${ut.userTypeId}" ${userDetail.userTypeId == ut.userTypeId ? 'selected' : ''}>${ut.userType}</option>
								</c:forEach>
							</select>
						</div>

						<div class="col-md-4">
							<label class="form-label">City</label>
							<input type="text" class="form-control" name="city" value="${userDetail.city}">
						</div>
						<div class="col-md-4">
							<label class="form-label">State</label>
							<input type="text" class="form-control" name="state" value="${userDetail.state}">
						</div>
						<div class="col-md-4">
							<label class="form-label">Country</label>
							<input type="text" class="form-control" name="country" value="${userDetail.country}">
						</div>

						<div class="col-md-4">
							<label class="form-label">Active</label>
							<select class="form-control" name="active">
								<option value="true" ${user.active ? 'selected' : ''}>Active</option>
								<option value="false" ${!user.active ? 'selected' : ''}>Inactive</option>
							</select>
						</div>
					</div>

					<div class="mt-4">
						<button type="submit" class="btn btn-success">Update User</button>
						<a href="listUser" class="btn btn-secondary">Cancel</a>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>
