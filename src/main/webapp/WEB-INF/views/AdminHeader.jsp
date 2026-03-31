<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<nav class="navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
	<div
		class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-start">
		<a class="navbar-brand brand-logo me-5" href="admin-dashboard"><img
			src="assets/images/logo.svg" class="me-2" alt="logo" /></a> <a
			class="navbar-brand brand-logo-mini" href="admin-dashboard"><img
			src="assets/images/logo-mini.svg" alt="logo" /></a>
	</div>
	<div
		class="navbar-menu-wrapper d-flex align-items-center justify-content-end">
		<button class="navbar-toggler navbar-toggler align-self-center"
			type="button" data-toggle="minimize">
			<span class="icon-menu"></span>
		</button>
		 
		<ul class="navbar-nav navbar-nav-right">

			<li class="nav-item nav-profile dropdown"><a
				class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown"
				id="profileDropdown"> <c:if
						test="${not empty sessionScope.user.profilePicURL}">
						<img src="${sessionScope.user.profilePicURL}" alt="profile" />

					</c:if> <c:if test="${empty sessionScope.user.profilePicURL}">
						<img src="assets/images/faces/dummy.jpg" alt="profile" />
					</c:if>



			</a>
				<div class="dropdown-menu dropdown-menu-right navbar-dropdown"
					aria-labelledby="profileDropdown">
					<a class="dropdown-item"> <i class="ti-settings text-primary"></i>
						Settings
					</a> <a class="dropdown-item" href="<c:url value='/logout' />"> <i
						class="ti-power-off text-primary"></i> Logout
					</a>
				</div></li>
		 
		</ul>
		<button
			class="navbar-toggler navbar-toggler-right d-lg-none align-self-center"
			type="button" data-toggle="offcanvas">
			<span class="icon-menu"></span>
		</button>
	</div>
</nav>