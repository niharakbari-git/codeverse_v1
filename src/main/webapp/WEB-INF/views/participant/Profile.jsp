<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Profile</title>
<style>
body{margin:0;background:#0a0a0f;color:#e2e8f0;font-family:'Syne',sans-serif}
.wrap{max-width:980px;margin:24px auto;padding:18px}
.top{display:flex;justify-content:space-between;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:14px}
.btn{text-decoration:none;padding:9px 12px;border:1px solid #2a2a3d;background:#13131a;border-radius:10px;color:#e2e8f0;font-weight:700}
.card{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;padding:16px}
.grid{display:grid;grid-template-columns:repeat(2,minmax(240px,1fr));gap:12px}
.item{padding:12px;border:1px solid #2a2a3d;border-radius:10px;background:#1b1b26}
.item p{margin:0;color:#94a3b8;font-size:12px}
.item h4{margin:6px 0 0;font-size:16px;word-break:break-word}
.avatar{width:92px;height:92px;border-radius:50%;object-fit:cover;border:2px solid #334155;background:#0f172a}
.header-row{display:flex;align-items:center;gap:14px;margin-bottom:16px;flex-wrap:wrap}
.badge{display:inline-block;padding:5px 10px;border-radius:999px;font-size:11px;font-weight:700;background:rgba(124,58,237,.22);border:1px solid #7c3aed;color:#ddd6fe}
.note{margin-top:10px;color:#64748b;font-size:13px}
@media(max-width:680px){.grid{grid-template-columns:1fr}}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <h2>My Profile</h2>
    <div>
      <a class="btn" href="<c:url value='/participant/home' />">Explore</a>
      <a class="btn" href="<c:url value='/participant/my-applications' />">My Applications</a>
      <a class="btn" href="<c:url value='/participant/my-teams' />">My Teams</a>
    </div>
  </div>

  <div class="card">
    <div class="header-row">
      <c:choose>
        <c:when test="${not empty profileUser.profilePicURL}">
          <img class="avatar" src="${profileUser.profilePicURL}" alt="Profile picture">
        </c:when>
        <c:otherwise>
          <img class="avatar" src="<c:url value='/assets/images/faces/dummy.jpg' />" alt="Profile picture">
        </c:otherwise>
      </c:choose>
      <div>
        <h3>${profileUser.firstName} ${profileUser.lastName}</h3>
        <p>${profileUser.email}</p>
        <span class="badge">${profileUser.role}</span>
      </div>
    </div>

    <div class="grid">
      <div class="item">
        <p>Contact Number</p>
        <h4><c:out value="${profileUser.contactNum}" default="Not provided" /></h4>
      </div>
      <div class="item">
        <p>Gender</p>
        <h4><c:out value="${profileUser.gender}" default="Not provided" /></h4>
      </div>
      <div class="item">
        <p>Birth Year</p>
        <h4><c:out value="${profileUser.birthYear}" default="Not provided" /></h4>
      </div>
      <div class="item">
        <p>Joined On</p>
        <h4>
          <c:choose>
            <c:when test="${not empty profileUser.createdAt}">
              <fmt:parseDate value="${profileUser.createdAt}" pattern="yyyy-MM-dd" var="parsedCreatedAt" type="date" />
              <fmt:formatDate value="${parsedCreatedAt}" pattern="dd/MM/yyyy" />
            </c:when>
            <c:otherwise>Not available</c:otherwise>
          </c:choose>
        </h4>
      </div>
      <div class="item">
        <p>Qualification</p>
        <h4><c:out value="${profileUserDetail.qualification}" default="Not provided" /></h4>
      </div>
      <div class="item">
        <p>Location</p>
        <h4>
          <c:out value="${profileUserDetail.city}" default="" />
          <c:if test="${not empty profileUserDetail.city and not empty profileUserDetail.state}">, </c:if>
          <c:out value="${profileUserDetail.state}" default="" />
          <c:if test="${(not empty profileUserDetail.city or not empty profileUserDetail.state) and not empty profileUserDetail.country}">, </c:if>
          <c:out value="${profileUserDetail.country}" default="Not provided" />
        </h4>
      </div>
    </div>

    <p class="note">Profile editing can be added next if you want update profile functionality from this page.</p>
  </div>
</div>
</body>
</html>
