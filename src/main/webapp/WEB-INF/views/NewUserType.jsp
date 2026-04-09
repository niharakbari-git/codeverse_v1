<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add New User Type</title>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    body {
        background-color: #f8f9fa;
    }
    .card {
        margin-top: 80px;
        border-radius: 12px;
    }
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260409a">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260409a"></script>
</head>

<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card shadow">
                <div class="card-body p-4">
                    <h4 class="text-center mb-4">Add New User Type</h4>

                    <% String error = request.getParameter("error"); %>
                    <% if (error != null && !error.isBlank()) { %>
                        <div class="alert alert-danger" role="alert"><%= error %></div>
                    <% } %>

                    <form action="saveUserType" method="post">
                        <input type="hidden" name="_csrf" value="${_csrfToken}" />
                        
                        <!-- User Type -->
                        <div class="mb-3">
                            <label class="form-label">User Type</label>
                            <select name="userType" class="form-select" required>
                                <option value="">Select role</option>
                                <option value="PARTICIPANT">PARTICIPANT</option>
                                <option value="JUDGE">JUDGE</option>
                                <option value="ORGANIZER">ORGANIZER</option>
                                <option value="ADMIN">ADMIN</option>
                            </select>
                        </div>

                        <!-- Buttons -->
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">
                                Save User Type
                            </button>
                            <a href="admin-dashboard" class="btn btn-secondary">
                                Cancel
                            </a>
                        </div>

                    </form>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>













