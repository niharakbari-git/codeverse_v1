
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<nav class="sidebar sidebar-offcanvas" id="sidebar">
	<ul class="nav">
		<li class="nav-item"><a class="nav-link" href="<c:url value='/participant/home' />"> <i
				class="icon-grid menu-icon"></i> <span class="menu-title">Dashboard</span>
		</a></li>
		<li class="nav-item"><a class="nav-link"
			data-bs-toggle="collapse" href="#charts" aria-expanded="false"
			aria-controls="charts"> <i class="icon-bar-graph menu-icon"></i>
				<span class="menu-title">Hackathons</span> <i class="menu-arrow"></i>
		</a>
			<div class="collapse" id="charts">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/participant/home' />">Browse Hackathons</a></li>

				<li class="nav-item"><a class="nav-link"
						href="<c:url value='/charge' />">Payments</a></li>
				</ul>
			</div></li>
		<li class="nav-item"><a class="nav-link"
			data-bs-toggle="collapse" href="#tables" aria-expanded="false"
			aria-controls="tables"> <i class="icon-grid-2 menu-icon"></i> <span
				class="menu-title">My Space</span> <i class="menu-arrow"></i>
		</a>
			<div class="collapse" id="tables">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/participant/participant-dashboard' />">Participant Dashboard</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/participant/home' />">All Hackathons</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/participant/profile' />">My Profile</a></li>
				</ul>
			</div></li>
		<li class="nav-item"><a class="nav-link"
			data-bs-toggle="collapse" href="#session" aria-expanded="false"
			aria-controls="session"> <i class="icon-head menu-icon"></i> <span
				class="menu-title">Session</span> <i class="menu-arrow"></i>
		</a>
			<div class="collapse" id="session">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/participant/home' />"> Home </a></li>
					<li class="nav-item"><a class="nav-link"
						href="<c:url value='/logout' />"> Logout </a></li>
				</ul>
			</div></li>
		<li class="nav-item"><a class="nav-link"
			href="<c:url value='/participant/home' />"> <i
				class="icon-paper menu-icon"></i> <span class="menu-title">Documentation</span>
		</a></li>
	</ul>
</nav>