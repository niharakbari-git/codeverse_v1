<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Organizer Profile</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260512c"></script>
<style>
.header{position:sticky;top:0;z-index:100;height:64px;display:flex;align-items:center;justify-content:space-between;gap:10px;padding:0 24px;background:rgba(247,244,236,.92);backdrop-filter:blur(8px);border-bottom:1px solid #d7dce5}
.logo{display:flex;align-items:center;gap:10px;text-decoration:none;color:#1f2329}
.logo-icon{width:34px;height:34px;border-radius:10px;display:grid;place-items:center;background:#1f2937;color:#fff;font-weight:700}
.logo-text{font-family:'Space Grotesk',sans-serif;font-size:16px;font-weight:700;letter-spacing:.04em}
.nav-links{display:flex;align-items:center;gap:8px;flex-wrap:wrap}
.nav-links a{text-decoration:none;border:1px solid #d7dce5;border-radius:10px;background:#fff;color:#1f2329;font-size:13px;font-weight:700;padding:8px 12px}
.nav-links a:hover{background:#f5f7fb}
.nav-links a.active{background:#1f2329;color:#fff;border-color:#1f2329}

.page{display:grid;grid-template-columns:240px 1fr;gap:12px;min-height:calc(100vh - 64px);padding:16px;max-width:1320px;margin:0 auto}
.side{padding:14px}
.side h2{font-size:30px}
.side .links{display:grid;gap:8px;margin-top:10px}
.side .links a{padding:10px;border:2px solid #1f2329;border-radius:12px;text-decoration:none;background:#fff}
.side .links a:hover{background:#eef3ff;color:#1f2329;border-color:#1f2329}
.side .links a.active{background:#1f2329;color:#fff}
.main{display:grid;gap:12px}
.hero{padding:16px;background:#1f2937;color:#fff}
.hero h1{font-size:clamp(32px,5vw,52px)}
.hero p{margin-top:8px;color:#fff3ed}
.card{padding:16px}
.header-row{display:flex;align-items:center;gap:24px;flex-wrap:wrap;margin-bottom:12px}
.avatar-stack{display:flex;flex-direction:column;gap:12px;align-items:center;min-width:110px}
.avatar-controls{display:flex;flex-direction:row;gap:8px;justify-content:center}
.avatar{width:96px;height:96px;border-radius:999px;object-fit:cover;border:2px solid #1f2329;background:#fff}
.pfp-form{display:flex;flex-direction:row;align-items:center}
.pfp-file{display:none}
.pfp-btn{width:36px;height:36px;border-radius:50%;padding:0;display:flex;align-items:center;justify-content:center;border:2px solid #1f2329;background:#f5f7fb;cursor:pointer;transition:background-color .2s ease,border-color .2s ease}
.pfp-btn:hover{background:#e8eefb;border-color:#111827}
.pfp-btn svg{width:16px;height:16px;fill:#1f2329}
.profile-actions{display:flex;gap:8px;flex-wrap:wrap;margin-top:14px}
.action-btn{border:2px solid #1f2329;border-radius:10px;background:#fff;padding:8px 12px;font-weight:700;cursor:pointer;color:#1f2329;display:inline-flex;align-items:center;justify-content:center;min-height:38px;line-height:1.1}
.action-btn:hover{background:#eef3ff;border-color:#111827}
.action-panel{margin-top:12px;padding:14px;border:2px solid #1f2329;border-radius:12px;background:#f9fbff}
.action-panel.hidden{display:none}
.panel-title{margin:0 0 10px 0}
.form-grid{display:grid;grid-template-columns:repeat(2,minmax(220px,1fr));gap:10px}
.form-grid .full{grid-column:1/-1}
.field{display:flex;flex-direction:column;gap:6px}
.field label{font-size:12px;font-weight:700;letter-spacing:.05em;text-transform:uppercase;color:#5e6673}
.field input{border:2px solid #1f2329;border-radius:10px;padding:9px 10px;background:#fff}
.field input:focus{outline:none;box-shadow:0 0 0 3px rgba(31,41,55,.14)}
.panel-actions{margin-top:12px;display:flex;gap:8px;flex-wrap:wrap}
.grid{display:grid;grid-template-columns:repeat(2,minmax(240px,1fr));gap:10px}
.item{padding:12px;border:2px solid #1f2329;border-radius:12px;background:#fff}
.item p{margin:0;color:#5e6673;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.06em}
.item h4{margin:6px 0 0;font-size:16px;word-break:break-word}
.note{margin-top:10px;color:#5e6673}
@media(max-width:860px){.header{height:auto;padding:12px;align-items:flex-start;flex-direction:column}.page{grid-template-columns:1fr}.grid{grid-template-columns:1fr}.form-grid{grid-template-columns:1fr}}
</style>
</head>
<body>
<c:if test="${not empty param.msg}">
  <div id="toast-data" data-type="${param.type == 'success' ? 'success' : 'error'}" style="display:none;"><c:out value="${param.msg}" /></div>
</c:if>
<header class="header">
  <a class="logo" href="<c:url value='/participant/home' />">
    <div class="logo-icon">CV</div>
    <span class="logo-text">CODEVERSE</span>
  </a>
  <nav class="nav-links">
    <a href="<c:url value='/participant/home' />">Explore</a>
    <a class="active" href="<c:url value='/organizer-dashboard' />">Dashboard</a>
    <a href="<c:url value='/logout' />">Logout</a>
  </nav>
</header>
<div class="neo-shell page">
  <aside class="neo-panel side" data-reveal>
    <div class="neo-badge">Role Features</div>
    <h2 class="neo-title">Control</h2>
    <div class="links">
      <a href="<c:url value='/newHackathon' />">Create Hackathon</a>
      <a href="<c:url value='/listHackathon' />">My Hackathons</a>
      <a href="<c:url value='/organizer/judge-assignments' />">Assign Judges</a>
      <a href="<c:url value='/organizer/applications' />">Applications</a>
      <a href="<c:url value='/organizer/results' />">Results</a>
      <a class="active" href="<c:url value='/organizer/profile' />">Profile</a>
    </div>
  </aside>

  <main class="main">
    <section class="neo-panel hero" data-reveal>
      <h1 class="neo-title">Organizer Profile</h1>
      <p>Manage your identity details and keep your organizer information current.</p>
    </section>

    <section class="neo-panel card" data-reveal>
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
        <div class="avatar-controls">
          <form class="pfp-form" method="post" action="<c:url value='/organizer/profile/change-pfp' />" enctype="multipart/form-data">
            <input type="hidden" name="_csrf" value="${_csrfToken}">
            <input id="organizerPfpInput" class="pfp-file" type="file" name="profilePic" accept="image/*" required>
            <button class="pfp-btn" type="button" aria-label="Change profile picture" onclick="document.getElementById('organizerPfpInput').click();" title="Update Profile Picture">
              <svg viewBox="0 0 24 24"><path fill="#1f2329" d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zm2.92 2.33H5v-.92l9.06-9.06.92.92L5.92 19.58zM20.71 7.04a1 1 0 0 0 0-1.41L18.37 3.3a1 1 0 0 0-1.41 0l-1.13 1.13 3.75 3.75 1.13-1.14z"/></svg>
            </button>
          </form>
          <form class="pfp-form" method="post" action="<c:url value='/organizer/profile/remove-pfp' />">
            <input type="hidden" name="_csrf" value="${_csrfToken}">
            <button class="pfp-btn" type="submit" title="Remove Profile Picture" aria-label="Remove profile picture">
               <svg viewBox="0 0 24 24" style="fill: #ff4d4f;"><path d="M16 9v10H8V9h8m-1.5-6h-5l-1 1H5v2h14V4h-3.5l-1-1zM18 7H6v12c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7z"/></svg>
            </button>
          </form>
        </div>
      </div>
      <div>
          <h3>${profileUser.firstName} ${profileUser.lastName}</h3>
          <p>${profileUser.email}</p>
          <span class="neo-badge role">${profileUser.role}</span>
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
                <fmt:formatDate value="${parsedCreatedAt}" pattern="dd-MM-yyyy" />
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

      <div class="profile-actions">
        <button class="action-btn" type="button" data-target="organizerEditPanel">Edit Profile Details</button>
        <button class="action-btn" type="button" data-target="organizerPasswordPanel">Change Password</button>
      </div>

      <div id="organizerEditPanel" class="action-panel hidden">
        <h3 class="panel-title">Edit Profile Details</h3>
        <form method="post" action="<c:url value='/organizer/profile/update-details' />" class="profile-update-form">
          <input type="hidden" name="_csrf" value="${_csrfToken}">
          <div class="form-grid">
            <div class="field">
              <label>First Name</label>
              <input type="text" name="firstName" value="${profileUser.firstName}" maxlength="60" required>
            </div>
            <div class="field">
              <label>Last Name</label>
              <input type="text" name="lastName" value="${profileUser.lastName}" maxlength="60" required>
            </div>
            <div class="field">
              <label>Email</label>
              <input type="email" name="email" value="${profileUser.email}" maxlength="120" required>
            </div>
            <div class="field">
              <label>Gender</label>
              <select name="gender">
                <option value="" disabled ${empty profileUser.gender ? 'selected' : ''}>Select gender</option>
                <option value="MALE" ${profileUser.gender == 'MALE' ? 'selected' : ''}>Male</option>
                <option value="FEMALE" ${profileUser.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                <option value="OTHER" ${profileUser.gender == 'OTHER' ? 'selected' : ''}>Other</option>
                <option value="PREFER_NOT_TO_SAY" ${profileUser.gender == 'PREFER_NOT_TO_SAY' ? 'selected' : ''}>Prefer not to say</option>
                <c:if test="${not empty profileUser.gender && profileUser.gender != 'MALE' && profileUser.gender != 'FEMALE' && profileUser.gender != 'OTHER' && profileUser.gender != 'PREFER_NOT_TO_SAY'}">
                  <option value="${profileUser.gender}" selected>${profileUser.gender}</option>
                </c:if>
              </select>
            </div>
            <div class="field">
              <label>Birth Year</label>
              <input type="number" name="birthYear" value="${profileUser.birthYear}" min="1950" max="2100">
            </div>
            <div class="field">
              <label>Contact Number</label>
              <input type="text" name="contactNum" value="${profileUser.contactNum}" maxlength="20" placeholder="Enter contact number">
            </div>
            <div class="field">
              <label>Qualification</label>
              <input type="text" name="qualification" value="${profileUserDetail.qualification}" maxlength="100" placeholder="e.g. B.Tech, MBA">
            </div>
            <div class="field">
              <label>City</label>
              <input type="text" name="city" value="${profileUserDetail.city}" maxlength="80" placeholder="City">
            </div>
            <div class="field">
              <label>State</label>
              <input type="text" name="state" value="${profileUserDetail.state}" maxlength="80" placeholder="State">
            </div>
            <div class="field">
              <label>Country</label>
              <input type="text" name="country" value="${profileUserDetail.country}" maxlength="80" placeholder="Country">
            </div>
            <div class="field full url-field">
              <label>LinkedIn URL</label>
              <div class="url-input-group">
                <input type="url" name="linkedinUrl" value="${profileUserDetail.linkedinUrl}" maxlength="255" placeholder="https://linkedin.com/in/your-profile">
                <div class="url-actions">
                  <button type="button" class="url-action-btn copy-url" title="Copy link"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 9h8a2 2 0 0 1 2 2v8"></path><rect x="5" y="5" width="10" height="10" rx="2"></rect><path d="M13 13l6-6"></path><path d="M14 7h5v5"></path></svg></button>
                  <button type="button" class="url-action-btn open-url" title="Open link"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M14 5h5v5"></path><path d="M10 14L19 5"></path><path d="M19 13v6a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h6"></path></svg></button>
                </div>
              </div>
              <span class="url-feedback">Copied!</span>
            </div>
          </div>
          <div class="panel-actions">
            <button type="submit">Save Profile</button>
            <button class="action-btn" type="button" data-close="organizerEditPanel">Cancel</button>
          </div>
        </form>
      </div>

      <div id="organizerPasswordPanel" class="action-panel hidden">
        <h3 class="panel-title">Change Password</h3>
        <form method="post" action="<c:url value='/organizer/profile/change-password' />">
          <input type="hidden" name="_csrf" value="${_csrfToken}">
          <div class="form-grid">
            <div class="field full">
              <label>Current Password</label>
              <input type="password" name="currentPassword" required>
            </div>
            <div class="field">
              <label>New Password</label>
              <input type="password" name="newPassword" required>
            </div>
            <div class="field">
              <label>Confirm New Password</label>
              <input type="password" name="confirmPassword" required>
            </div>
          </div>
          <div class="panel-actions">
            <button type="submit">Update Password</button>
            <button class="action-btn" type="button" data-close="organizerPasswordPanel">Cancel</button>
          </div>
        </form>
      </div>

    </section>
  </main>
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

  document.querySelectorAll('[data-target]').forEach(function (button) {
    button.addEventListener('click', function () {
      var target = document.getElementById(button.getAttribute('data-target'));
      if (!target) return;

      document.querySelectorAll('.action-panel').forEach(function (panel) {
        if (panel !== target) {
          panel.classList.add('hidden');
        }
      });
      target.classList.toggle('hidden');
    });
  });

  document.querySelectorAll('[data-close]').forEach(function (button) {
    button.addEventListener('click', function () {
      var panel = document.getElementById(button.getAttribute('data-close'));
      if (panel) {
        panel.classList.add('hidden');
      }
    });
  });

  document.querySelectorAll('.profile-update-form').forEach(function (form) {
    form.addEventListener('submit', function (event) {
      if (!window.confirm('Save these profile changes now?')) {
        event.preventDefault();
      }
    });
  });
})();
</script>
<%@ include file="../shared/Toast.jspf" %>
</body>
</html>




