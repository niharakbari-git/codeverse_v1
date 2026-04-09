<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Organizer Profile</title>
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
.avatar-stack{display:flex;flex-direction:column;gap:8px;align-items:center}
.pfp-form{display:flex;flex-direction:column;gap:8px;align-items:center}
.pfp-file{display:none}
.pfp-btn{width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;border:1px solid #2a2a3d;background:#13131a;border-radius:999px;color:#e2e8f0;cursor:pointer}
.pfp-btn svg{width:16px;height:16px;fill:currentColor}
.badge{display:inline-block;padding:5px 10px;border-radius:999px;font-size:11px;font-weight:700;background:rgba(6,182,212,.2);border:1px solid rgba(6,182,212,.4);color:#67e8f9}
.note{margin-top:10px;color:#64748b;font-size:13px}
@media(max-width:680px){.grid{grid-template-columns:1fr}}
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260409a">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260409a"></script>
</head>
<body>
<c:if test="${not empty param.msg}">
  <div id="toast-data" data-type="${param.type == 'success' ? 'success' : 'error'}" style="display:none;"><c:out value="${param.msg}" /></div>
</c:if>
<div class="wrap">
  <div class="top">
    <h2>Organizer Profile</h2>
    <div>
      <a class="btn" href="<c:url value='/organizer-dashboard' />">Dashboard</a>
      <a class="btn" href="<c:url value='/listHackathon' />">My Hackathons</a>
      <a class="btn" href="<c:url value='/organizer/applications' />">Applications</a>
    </div>
  </div>

  <div class="card">
    <div class="header-row">
      <div class="avatar-stack">
        <c:choose>
          <c:when test="${not empty profileUser.profilePicURL}">
            <img class="avatar" src="${profileUser.profilePicURL}" alt="Profile picture">
          </c:when>
          <c:otherwise>
            <img class="avatar" src="<c:url value='/assets/images/faces/dummy.jpg' />" alt="Profile picture">
          </c:otherwise>
        </c:choose>
        <form class="pfp-form" method="post" action="<c:url value='/organizer/profile/change-pfp' />" enctype="multipart/form-data">
          <input type="hidden" name="_csrf" value="${_csrfToken}">
          <input id="organizerPfpInput" class="pfp-file" type="file" name="profilePic" accept="image/*" required>
          <button class="pfp-btn" type="button" aria-label="Change profile picture" onclick="document.getElementById('organizerPfpInput').click();">
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 17.25V21h3.75l11-11-3.75-3.75-11 11zm14.71-9.04a1.003 1.003 0 0 0 0-1.42l-2.5-2.5a1.003 1.003 0 0 0-1.42 0l-1.83 1.83 3.75 3.75 2-1.66z"/></svg>
          </button>
        </form>
      </div>
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

    <p class="note">Use the pencil icon to update your profile picture.</p>
  </div>
</div>
<script>
(function () {
  var pfpInput = document.getElementById('organizerPfpInput');
  if (!pfpInput || !pfpInput.form) {
    return;
  }
  pfpInput.addEventListener('change', function () {
    if (pfpInput.files && pfpInput.files.length > 0) {
      pfpInput.form.submit();
    }
  });
})();
</script>
<%@ include file="../shared/Toast.jspf" %>
</body>
</html>

