<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Something went wrong</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-4">
                        <h3 class="mb-3">Oops! Something went wrong.</h3>
                        <p class="text-muted mb-4">${empty errorMessage ? 'Unexpected error occurred. Please try again.' : errorMessage}</p>
                        <a href="login" class="btn btn-primary">Back to login</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
