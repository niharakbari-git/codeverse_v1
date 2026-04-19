<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:choose><c:when test="${not empty hackathon.hackathonId}">Edit Hackathon</c:when><c:otherwise>Create Hackathon</c:otherwise></c:choose> | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260415b">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260415b"></script>
<style>
.wrap{max-width:1060px;margin:24px auto;padding:0 16px}
.top{display:flex;justify-content:space-between;align-items:flex-end;gap:10px;flex-wrap:wrap;margin-bottom:12px}
.sub{color:#5e6673;font-weight:500}
.actions{display:flex;gap:8px;flex-wrap:wrap}
.card{padding:22px}
.grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px}
.field.full{grid-column:1/-1}
.field label{display:block;font-size:12px;font-weight:700;letter-spacing:.06em;text-transform:uppercase;margin-bottom:6px}
.footer{margin-top:14px;display:flex;justify-content:flex-end;gap:8px;flex-wrap:wrap}
@media(max-width:860px){.grid{grid-template-columns:1fr}}
</style>
</head>
<body>
<c:if test="${not empty param.msg}">
  <div id="toast-data" data-type="${param.type == 'success' ? 'success' : 'error'}" style="display:none;"><c:out value="${param.msg}" /></div>
</c:if>
<div class="wrap">
  <div class="top">
    <div>
      <div class="neo-badge">Hackathons</div>
      <h1 class="neo-title"><c:choose><c:when test="${not empty hackathon.hackathonId}">Edit Hackathon</c:when><c:otherwise>Create Hackathon</c:otherwise></c:choose></h1>
      <p class="sub">Configure challenge details, team rules, and registration timeline.</p>
    </div>
    <div class="actions">
      <a class="btn" href="<c:url value='/listHackathon' />">Hackathon List</a>
      <c:choose>
        <c:when test="${sessionScope.user.role == 'ADMIN'}"><a class="btn" href="<c:url value='/admin-dashboard' />">Dashboard</a></c:when>
        <c:when test="${sessionScope.user.role == 'ORGANIZER'}"><a class="btn" href="<c:url value='/organizer-dashboard' />">Dashboard</a></c:when>
        <c:otherwise><a class="btn" href="<c:url value='/judge-dashboard' />">Dashboard</a></c:otherwise>
      </c:choose>
    </div>
  </div>

  <form class="neo-panel card" action="saveHackathon" method="post" data-reveal>
    <input type="hidden" name="_csrf" value="${_csrfToken}">
    <input type="hidden" name="hackathonId" value="${hackathon.hackathonId}">

    <div class="grid">
      <div class="field full"><label>Hackathon Title</label><input type="text" name="title" value="${hackathon.title}" required></div>
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
        <select name="eventType" id="eventTypeField" required>
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
        <label>Application Fee (Rs.)</label>
        <input type="number" name="entryFeeAmount" id="entryFeeAmount" min="0" value="${empty hackathon.entryFeeAmount ? 199 : hackathon.entryFeeAmount}" required>
      </div>
      <div class="field"><label>Minimum Team Size</label><input type="number" name="minTeamSize" min="1" value="${hackathon.minTeamSize}" required></div>
      <div class="field"><label>Maximum Team Size</label><input type="number" name="maxTeamSize" min="1" value="${hackathon.maxTeamSize}" required></div>
      <div class="field full" id="locationFieldWrap"><label id="locationLabel">Location</label><input type="text" name="location" id="locationField" value="${hackathon.location}"></div>
      <div class="field"><label>Registration Start Date</label><input type="date" name="registrationStartDate" value="${hackathon.registrationStartDate}" required></div>
      <div class="field"><label>Registration End Date</label><input type="date" name="registrationEndDate" value="${hackathon.registrationEndDate}" required></div>
      <div class="field"><label>Event Start Date</label><input type="date" name="eventStartDate" value="${hackathon.eventStartDate}"></div>
      <div class="field"><label>Event End Date</label><input type="date" name="eventEndDate" value="${hackathon.eventEndDate}"></div>
      <div class="field"><label>Submission Deadline</label><input type="date" name="submissionDeadline" value="${hackathon.submissionDeadline}"></div>
      <div class="field"><label>Grace Period Hours</label><input type="number" name="gracePeriodHours" min="0" value="${hackathon.gracePeriodHours}"></div>
      <div class="field full"><label>Problem Title</label><input type="text" name="problemTitle" value="${hackathon.problemTitle}" required></div>
      <div class="field full"><label>Problem Statement</label><textarea name="problemStatement" rows="3" required>${hackathon.problemStatement}</textarea></div>
      <div class="field full"><label>Problem Constraints</label><textarea name="problemConstraints" rows="3">${hackathon.problemConstraints}</textarea></div>
      <div class="field full"><label>Problem Deliverables</label><textarea name="problemDeliverables" rows="3" required>${hackathon.problemDeliverables}</textarea></div>
      <div class="field full"><label>Evaluation Criteria</label><textarea name="evaluationCriteria" rows="3">${hackathon.evaluationCriteria}</textarea></div>
      <div class="field full"><label>Submission Checklist</label><textarea name="submissionChecklist" rows="3">${hackathon.submissionChecklist}</textarea></div>
      <div class="field full"><label>Description</label><textarea name="description" rows="4">${hackathon.description}</textarea></div>
    </div>

    <div class="footer">
      <c:choose>
        <c:when test="${sessionScope.user.role == 'ADMIN'}"><a class="btn" href="<c:url value='/admin-dashboard' />">Cancel</a></c:when>
        <c:when test="${sessionScope.user.role == 'ORGANIZER'}"><a class="btn" href="<c:url value='/organizer-dashboard' />">Cancel</a></c:when>
        <c:when test="${sessionScope.user.role == 'JUDGE'}"><a class="btn" href="<c:url value='/judge-dashboard' />">Cancel</a></c:when>
        <c:otherwise><a class="btn" href="<c:url value='/participant/participant-dashboard' />">Cancel</a></c:otherwise>
      </c:choose>
      <button type="submit"><c:choose><c:when test="${not empty hackathon.hackathonId}">Update Hackathon</c:when><c:otherwise>Save Hackathon</c:otherwise></c:choose></button>
    </div>
  </form>
</div>
<script>
(function () {
  const eventTypeField = document.getElementById('eventTypeField');
  const locationField = document.getElementById('locationField');
  const locationLabel = document.getElementById('locationLabel');
  const paymentField = document.querySelector('select[name="payment"]');
  const feeField = document.getElementById('entryFeeAmount');

  function syncLocationRules() {
    const eventType = (eventTypeField.value || '').toUpperCase();
    if (eventType === 'ONLINE') {
      locationField.value = 'Online';
      locationField.readOnly = true;
      locationField.required = false;
      locationLabel.textContent = 'Location (Auto)';
    } else {
      locationField.readOnly = false;
      locationField.required = true;
      locationLabel.textContent = eventType === 'OFFLINE' ? 'Venue Address' : 'Location';
      if (locationField.value === 'Online') {
        locationField.value = '';
      }
    }
  }

  function syncFeeRules() {
    const payment = (paymentField.value || '').toUpperCase();
    if (payment === 'FREE') {
      feeField.value = 0;
      feeField.readOnly = true;
    } else if (payment === 'PAID') {
      feeField.value = feeField.value && Number(feeField.value) > 0 ? feeField.value : 199;
      feeField.readOnly = false; // Allow user to edit the price
    } else {
      feeField.readOnly = false;
    }
  }

  eventTypeField.addEventListener('change', syncLocationRules);
  paymentField.addEventListener('change', syncFeeRules);
  syncLocationRules();
  syncFeeRules();
})();
</script>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>

