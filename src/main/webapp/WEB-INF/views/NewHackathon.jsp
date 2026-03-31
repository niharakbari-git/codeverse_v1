<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:choose><c:when test="${not empty hackathon.hackathonId}">Edit Hackathon</c:when><c:otherwise>Create Hackathon</c:otherwise></c:choose></title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--bg:#0a0f16;--surface:#131c27;--surface2:#1c2734;--border:#2a3d52;--text:#e2e8f0;--muted:#8ca0b3;--accent:#f97316;--accent2:#06b6d4}
body{font-family:'Syne',sans-serif;background:radial-gradient(circle at 12% 16%, rgba(6,182,212,.15), transparent 35%),radial-gradient(circle at 85% 82%, rgba(249,115,22,.14), transparent 40%),var(--bg);color:var(--text);min-height:100vh}
.wrap{max-width:1020px;margin:28px auto;padding:0 18px 24px}
.top{display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap;margin-bottom:14px}
h2{font-size:clamp(26px,4vw,38px);line-height:1.1}
.sub{color:var(--muted);font-size:14px}
.actions{display:flex;gap:8px;flex-wrap:wrap}
.btn{text-decoration:none;padding:10px 13px;border:1px solid var(--border);background:var(--surface);border-radius:10px;color:var(--text);font-weight:700;font-size:13px}
.btn.primary{background:linear-gradient(135deg,var(--accent),var(--accent2));border:none}
.card{margin-top:14px;background:var(--surface);border:1px solid var(--border);border-radius:16px;padding:18px}
.grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.field{display:flex;flex-direction:column;gap:6px}
.field.full{grid-column:1 / -1}
label{font-size:12px;color:var(--muted)}
input,select,textarea{width:100%;padding:11px 12px;border-radius:10px;border:1px solid var(--border);background:var(--surface2);color:var(--text);font-size:14px}
input:focus,select:focus,textarea:focus{outline:none;border-color:var(--accent2);box-shadow:0 0 0 3px rgba(6,182,212,.14)}
.footer{margin-top:14px;display:flex;justify-content:flex-end;gap:10px;flex-wrap:wrap}
@media(max-width:760px){.grid{grid-template-columns:1fr}.footer{justify-content:stretch}.footer .btn{width:100%;text-align:center}}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <div>
      <h2><c:choose><c:when test="${not empty hackathon.hackathonId}">Edit Hackathon</c:when><c:otherwise>Create Hackathon</c:otherwise></c:choose></h2>
      <p class="sub">Configure challenge details, team rules, and registration timeline.</p>
    </div>
    <div class="actions">
      <a class="btn" href="<c:url value='/listHackathon' />">Hackathon List</a>
      <c:choose>
        <c:when test="${sessionScope.user.role == 'ADMIN'}">
          <a class="btn" href="<c:url value='/admin-dashboard' />">Dashboard</a>
        </c:when>
        <c:when test="${sessionScope.user.role == 'ORGANIZER'}">
          <a class="btn" href="<c:url value='/organizer-dashboard' />">Dashboard</a>
        </c:when>
        <c:otherwise>
          <a class="btn" href="<c:url value='/judge-dashboard' />">Dashboard</a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <form class="card" action="saveHackathon" method="post">
    <input type="hidden" name="hackathonId" value="${hackathon.hackathonId}">

    <div class="grid">
      <div class="field full">
        <label>Hackathon Title</label>
        <input type="text" name="title" value="${hackathon.title}" required>
      </div>

      <div class="field">
        <label>Status</label>
        <select name="status" required>
          <option value="">-- Select Status --</option>
          <option value="UPCOMING" ${hackathon.status == 'UPCOMING' ? 'selected' : ''}>Upcoming</option>
          <option value="ONGOING" ${hackathon.status == 'ONGOING' ? 'selected' : ''}>Ongoing</option>
          <option value="COMPLETED" ${hackathon.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
        </select>
      </div>

      <div class="field">
        <label>Event Type</label>
        <select name="eventType" required>
          <option value="">-- Select Event Type --</option>
          <option value="ONLINE" ${hackathon.eventType == 'ONLINE' ? 'selected' : ''}>Online</option>
          <option value="OFFLINE" ${hackathon.eventType == 'OFFLINE' ? 'selected' : ''}>Offline</option>
          <option value="HYBRID" ${hackathon.eventType == 'HYBRID' ? 'selected' : ''}>Hybrid</option>
        </select>
      </div>

      <div class="field">
        <label>Payment</label>
        <select name="payment" required>
          <option value="">-- Select Payment Type --</option>
          <option value="FREE" ${hackathon.payment == 'FREE' ? 'selected' : ''}>Free</option>
          <option value="PAID" ${hackathon.payment == 'PAID' ? 'selected' : ''}>Paid</option>
        </select>
      </div>

      <div class="field">
        <label>User Type</label>
        <select name="userTypeId" required>
          <option value="">-- Select User Type --</option>
          <c:forEach var="u" items="${allUserType}">
            <option value="${u.userTypeId}" ${hackathon.userTypeId == u.userTypeId ? 'selected' : ''}>${u.userType}</option>
          </c:forEach>
        </select>
      </div>

      <div class="field">
        <label>Minimum Team Size</label>
        <input type="number" name="minTeamSize" min="1" value="${hackathon.minTeamSize}" required>
      </div>

      <div class="field">
        <label>Maximum Team Size</label>
        <input type="number" name="maxTeamSize" min="1" value="${hackathon.maxTeamSize}" required>
      </div>

      <div class="field full">
        <label>Location</label>
        <input type="text" name="location" value="${hackathon.location}">
      </div>

      <div class="field">
        <label>Registration Start Date</label>
        <input type="date" name="registrationStartDate" value="${hackathon.registrationStartDate}" required>
      </div>

      <div class="field">
        <label>Registration End Date</label>
        <input type="date" name="registrationEndDate" value="${hackathon.registrationEndDate}" required>
      </div>

      <div class="field full">
        <label>Description</label>
        <textarea name="description" rows="4">${hackathon.description}</textarea>
      </div>
    </div>

    <div class="footer">
      <a class="btn" href="<c:url value='/listHackathon' />">Cancel</a>
      <button class="btn primary" type="submit"><c:choose><c:when test="${not empty hackathon.hackathonId}">Update Hackathon</c:when><c:otherwise>Save Hackathon</c:otherwise></c:choose></button>
    </div>
  </form>
</div>
</body>
</html>