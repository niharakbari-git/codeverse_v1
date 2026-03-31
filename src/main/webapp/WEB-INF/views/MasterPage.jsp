<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add New Category</title>

<jsp:include page="AdminCSS.jsp"></jsp:include>

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
	<!-- header -->
	<jsp:include page="AdminHeader.jsp"></jsp:include>

	<!-- Sidebar -->
<%-- 	<jsp:include page="AdminSidebar.jsp"></jsp:include>
 --%>

	<div class="content">
		<div class="row justify-content-center">
			<div class="col-md-6 col-lg-5">
				<div class="card shadow">
					<div class="card-body p-4">
						<h4 class="text-center mb-4">Add New Category</h4>

						 

					</div>
				</div>
			</div>
		</div>


	</div>
	<jsp:include page="AdminFooter.jsp"></jsp:include>



</body>
</html>
