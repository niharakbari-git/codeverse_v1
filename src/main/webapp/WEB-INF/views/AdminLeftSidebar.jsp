
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<nav class="sidebar sidebar-offcanvas" id="sidebar">
	<ul class="nav">
		<li class="nav-item"><a class="nav-link" href="<c:url value='/admin-dashboard' />"> <i
				class="icon-grid menu-icon"></i> <span class="menu-title">Dashboard</span>
		</a></li>
		<li class="nav-item"><a class="nav-link"
			data-bs-toggle="collapse" href="#ui-basic" aria-expanded="false"
			aria-controls="ui-basic"> <i class="icon-layout menu-icon"></i> <span
				class="menu-title">Manage Users</span> <i class="menu-arrow"></i>
		</a>
			<div class="collapse" id="ui-basic">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/signup' />">Add New User</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/listUser' />">User List</a></li>
				</ul>
			</div></li>
		<li class="nav-item"><a class="nav-link"
			data-bs-toggle="collapse" href="#form-elements" aria-expanded="false"
			aria-controls="form-elements"> <i class="icon-columns menu-icon"></i>
				<span class="menu-title">Category</span> <i class="menu-arrow"></i>
		</a>
			<div class="collapse" id="form-elements">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/newCategory' />">New Category</a></li>
						
						<li class="nav-item"><a class="nav-link"
						href="<c:url value='/listCategory' />">List Category</a></li>
				</ul>
			</div></li>
		<li class="nav-item"><a class="nav-link"
			data-bs-toggle="collapse" href="#charts" aria-expanded="false"
			aria-controls="charts"> <i class="icon-bar-graph menu-icon"></i>
				<span class="menu-title">Hackathon</span> <i class="menu-arrow"></i>
		</a>
			<div class="collapse" id="charts">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/newHackathon' />">New Hackathon</a></li>

				<li class="nav-item"><a class="nav-link"
						href="<c:url value='/listHackathon' />">List Hackathon</a></li>
				</ul>
			</div></li>
		<li class="nav-item"><a class="nav-link"
			data-bs-toggle="collapse" href="#tables" aria-expanded="false"
			aria-controls="tables"> <i class="icon-grid-2 menu-icon"></i> <span
				class="menu-title">Tables</span> <i class="menu-arrow"></i>
		</a>
			<div class="collapse" id="tables">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/charge' />">Payments</a></li>
				</ul>
			</div></li>
		<li class="nav-item"><a class="nav-link"
			data-bs-toggle="collapse" href="#icons" aria-expanded="false"
			aria-controls="icons"> <i class="icon-contract menu-icon"></i> <span
				class="menu-title">Icons</span> <i class="menu-arrow"></i>
		</a>
			<div class="collapse" id="icons">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/newUserType' />">User Types</a></li>
				</ul>
			</div></li>
		<li class="nav-item"><a class="nav-link"
			data-bs-toggle="collapse" href="#auth" aria-expanded="false"
			aria-controls="auth"> <i class="icon-head menu-icon"></i> <span
				class="menu-title">User Pages</span> <i class="menu-arrow"></i>
		</a>
			<div class="collapse" id="auth">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/login' />"> Login </a></li>
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/signup' />"> Register </a></li>
				</ul>
			</div></li>
		<li class="nav-item"><a class="nav-link"
			data-bs-toggle="collapse" href="#error" aria-expanded="false"
			aria-controls="error"> <i class="icon-ban menu-icon"></i> <span
				class="menu-title">Error pages</span> <i class="menu-arrow"></i>
		</a>
			<div class="collapse" id="error">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/admin-dashboard' />"> Dashboard </a></li>
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/participant/home' />"> Participant Home </a></li>
				</ul>
			</div></li>
		<li class="nav-item"><a class="nav-link"
			href="<c:url value='/logout' />"> <i
				class="icon-paper menu-icon"></i> <span class="menu-title">Documentation</span>
		</a></li>
	</ul>
</nav>