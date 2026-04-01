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
</head>

<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card shadow">
                <div class="card-body p-4">
                    <h4 class="text-center mb-4">Add New User Type</h4>

                    <form action="saveUserType" method="post">
                        <input type="hidden" name="_csrf" value="${_csrfToken}" />
                        
                        <!-- User Type -->
                        <div class="mb-3">
                            <label class="form-label">User Type</label>
                            <input type="text"
                                   name="userType"
                                   class="form-control"
                                   placeholder="Enter user type"
                                   required>
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
