<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Applications</title>
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Space+Grotesk:wght@500;700&display=swap" rel="stylesheet">
<style>
:root{
  --ink:#f4f7fb;
  --muted:#9fb3c8;
  --line:#1d3349;
  --panel:#081322;
  --panel-soft:#0d1b2d;
  --mint:#42d5c1;
  --amber:#ffb84d;
  --sky:#63b3ff;
  --rose:#ff7d8f;
}
*{box-sizing:border-box}
body{
  margin:0;
  color:var(--ink);
  font-family:'Manrope',sans-serif;
  background:
    radial-gradient(circle at 10% 8%, rgba(66,213,193,.24), transparent 42%),
    radial-gradient(circle at 92% 12%, rgba(255,184,77,.20), transparent 38%),
    linear-gradient(170deg,#030912 0%,#050f1a 46%,#03111d 100%);
  min-height:100vh;
}
.wrap{max-width:1180px;margin:26px auto;padding:18px}
.hero{
  display:flex;
  justify-content:space-between;
  align-items:flex-start;
  gap:18px;
  flex-wrap:wrap;
  margin-bottom:16px;
}
.title h1{
  margin:0 0 6px;
  font:700 30px/1.1 'Space Grotesk',sans-serif;
  letter-spacing:.3px;
}
.title p{margin:0;color:var(--muted);font-size:14px}
.quick-stats{display:flex;gap:10px;flex-wrap:wrap}
.stat{
  min-width:120px;
  background:linear-gradient(145deg,rgba(13,27,45,.95),rgba(8,19,34,.95));
  border:1px solid var(--line);
  border-radius:12px;
  padding:10px 12px;
}
.stat .label{font-size:11px;color:var(--muted);text-transform:uppercase;letter-spacing:.8px}
.stat .value{margin-top:4px;font-size:20px;font-weight:800;line-height:1}
.nav-row{display:flex;gap:10px;flex-wrap:wrap;margin-bottom:14px}
.btn{
  text-decoration:none;
  padding:10px 14px;
  border:1px solid var(--line);
  background:rgba(8,19,34,.72);
  border-radius:11px;
  color:var(--ink);
  font-weight:700;
  transition:transform .15s ease, border-color .2s ease, background .2s ease;
}
.btn:hover{transform:translateY(-1px);border-color:var(--sky);background:rgba(14,34,57,.9)}
.btn.accent{background:linear-gradient(130deg,var(--amber),var(--mint));color:#05273b;border-color:transparent}
.panel{background:linear-gradient(180deg,rgba(8,19,34,.96),rgba(6,14,25,.95));border:1px solid var(--line);border-radius:16px;overflow:auto}
table{width:100%;border-collapse:collapse;min-width:980px}
th,td{padding:14px 12px;border-bottom:1px solid rgba(38,69,97,.6);text-align:left;vertical-align:top}
th{font-size:11px;color:var(--muted);text-transform:uppercase;letter-spacing:.8px;background:rgba(7,16,29,.85);position:sticky;top:0;z-index:1}
.hack-name{font-weight:700}
.subtle{color:var(--muted);font-size:12px;margin-top:4px}
.badge{display:inline-block;padding:5px 10px;border-radius:999px;font-size:11px;font-weight:800;letter-spacing:.3px}
.status-applied{background:rgba(99,179,255,.16);color:#9dd0ff}
.status-approved{background:rgba(66,213,193,.15);color:#83ecd8}
.status-rejected{background:rgba(255,125,143,.16);color:#ffb5bf}
.status-default{background:rgba(159,179,200,.15);color:#d0dfef}
.pay-pending{background:rgba(255,184,77,.18);color:#ffcf8c}
.pay-paid{background:rgba(66,213,193,.17);color:#9cf3e5}
.pay-default{background:rgba(159,179,200,.15);color:#d0dfef}
.submit-box{
  background:var(--panel-soft);
  border:1px solid #1a3250;
  border-radius:12px;
  padding:10px;
}
.submit-box summary{
  cursor:pointer;
  list-style:none;
  color:#9de4ff;
  font-size:12px;
  font-weight:800;
}
.submit-box summary::-webkit-details-marker{display:none}
.submit-box form{margin-top:10px;display:grid;gap:8px}
.field{width:100%;padding:9px 10px;border-radius:8px;border:1px solid #224062;background:#071628;color:var(--ink);font-size:12px}
textarea.field{resize:vertical;min-height:74px}
.save-btn{padding:9px 12px;border-radius:8px;border:none;background:linear-gradient(130deg,var(--amber),var(--mint));color:#05273b;font-size:12px;font-weight:800;cursor:pointer}
.save-btn:hover{filter:brightness(1.04)}
.links{display:flex;gap:8px;flex-wrap:wrap;margin:2px 0 6px}
.mini-link{font-size:11px;color:#9de4ff;text-decoration:none;border-bottom:1px dashed rgba(157,228,255,.45)}
.alert{padding:10px 12px;border-radius:10px;margin:0 0 12px;font-size:13px;font-weight:700}
.alert.success{background:rgba(66,213,193,.15);border:1px solid rgba(66,213,193,.45);color:#9cf3e5}
.alert.error{background:rgba(255,125,143,.15);border:1px solid rgba(255,125,143,.4);color:#ffc1c9}
.empty{padding:18px;color:var(--muted)}
@media (max-width:900px){
  .title h1{font-size:26px}
  .stat{min-width:100px}
}
@media (max-width:640px){
  .wrap{padding:14px}
  .title h1{font-size:24px}
  .nav-row .btn{flex:1 1 auto;text-align:center}
}
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260409a">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260409a"></script>
</head>
<body>
<div class="wrap">
  <div class="hero">
    <div class="title">
      <h1>My Applications</h1>
      <p>Track decisions, payment status, and submit your work from one place.</p>
    </div>
    <div class="quick-stats">
      <div class="stat">
        <div class="label">Total</div>
        <div class="value">${appViews.size()}</div>
      </div>
      <div class="stat">
        <div class="label">Action</div>
        <div class="value" style="font-size:13px;margin-top:7px;line-height:1.2;color:#9de4ff;">Submit or update</div>
      </div>
    </div>
  </div>

  <div class="nav-row">
    <a class="btn" href="<c:url value='/participant/profile' />">Profile</a>
    <a class="btn" href="<c:url value='/participant/my-teams' />">My Teams</a>
    <a class="btn accent" href="<c:url value='/participant/home' />">Explore Hackathons</a>
  </div>

  <c:if test="${not empty param.msg}">
    <div class="alert ${param.type == 'error' ? 'error' : 'success'}">${param.msg}</div>
  </c:if>

  <div class="panel">
    <table>
      <thead>
        <tr>
          <th>Hackathon</th>
          <th>Team</th>
          <th>Status</th>
          <th>Payment</th>
          <th>Applied On</th>
          <th>Submission</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${appViews}" var="v">
          <tr>
            <td>
              <div class="hack-name">${v.hackathonTitle}</div>
              <div class="subtle">Application #${v.application.applicationId}</div>
            </td>
            <td>
              <div class="hack-name">${v.teamName}</div>
            </td>
            <td>
              <c:choose>
                <c:when test="${v.application.status == 'APPLIED'}">
                  <span class="badge status-applied">${v.application.status}</span>
                </c:when>
                <c:when test="${v.application.status == 'APPROVED'}">
                  <span class="badge status-approved">${v.application.status}</span>
                </c:when>
                <c:when test="${v.application.status == 'REJECTED'}">
                  <span class="badge status-rejected">${v.application.status}</span>
                </c:when>
                <c:otherwise>
                  <span class="badge status-default">${v.application.status}</span>
                </c:otherwise>
              </c:choose>
            </td>
            <td>
              <c:choose>
                <c:when test="${v.application.paymentStatus == 'PENDING'}">
                  <span class="badge pay-pending">${v.application.paymentStatus}</span>
                </c:when>
                <c:when test="${v.application.paymentStatus == 'PAID'}">
                  <span class="badge pay-paid">${v.application.paymentStatus}</span>
                </c:when>
                <c:otherwise>
                  <span class="badge pay-default">${v.application.paymentStatus}</span>
                </c:otherwise>
              </c:choose>
            </td>
            <fmt:parseDate value="${v.application.appliedAt}" pattern="yyyy-MM-dd" var="parsedAppliedAt" type="date" />
            <td><fmt:formatDate value="${parsedAppliedAt}" pattern="dd/MM/yyyy" /></td>
            <td>
              <c:choose>
                <c:when test="${v.application.status == 'APPROVED' || v.application.status == 'APPLIED'}">
                  <details class="submit-box">
                    <summary>
                      <c:choose>
                        <c:when test="${not empty v.application.submissionUrl}">Submission Saved: Update</c:when>
                        <c:otherwise>Open Submission Form</c:otherwise>
                      </c:choose>
                    </summary>
                    <div class="subtle" style="margin:6px 0 2px;">Submitting work does not change application status; organizers update status later.</div>
                    <form action="<c:url value='/participant/application/submit-work' />" method="post">
                      <input type="hidden" name="_csrf" value="${_csrfToken}">
                      <input type="hidden" name="applicationId" value="${v.application.applicationId}">
                      <c:if test="${not empty v.application.submissionUrl || not empty v.application.frontendGithubLink || not empty v.application.backendGithubLink}">
                        <div class="links">
                          <c:if test="${not empty v.application.submissionUrl}">
                            <a class="mini-link" target="_blank" rel="noopener noreferrer" href="${v.application.submissionUrl}">Current Demo Link</a>
                          </c:if>
                          <c:if test="${not empty v.application.frontendGithubLink}">
                            <a class="mini-link" target="_blank" rel="noopener noreferrer" href="${v.application.frontendGithubLink}">Current Frontend Repo</a>
                          </c:if>
                          <c:if test="${not empty v.application.backendGithubLink}">
                            <a class="mini-link" target="_blank" rel="noopener noreferrer" href="${v.application.backendGithubLink}">Current Backend Repo</a>
                          </c:if>
                        </div>
                      </c:if>
                      <input class="field" type="url" name="submissionUrl" placeholder="Live demo or drive link" value="${v.application.submissionUrl}" required>
                      <input class="field" type="url" name="frontendGithubLink" placeholder="Frontend repository URL (optional)" value="${v.application.frontendGithubLink}">
                      <input class="field" type="url" name="backendGithubLink" placeholder="Backend repository URL (optional)" value="${v.application.backendGithubLink}">
                      <textarea class="field" name="submissionDescription" placeholder="Share what you built, key features, and architecture notes" required>${v.application.submissionDescription}</textarea>
                      <button class="save-btn" type="submit">Submit And Save</button>
                    </form>
                  </details>
                </c:when>
                <c:otherwise>
                  <span class="subtle">Not eligible yet</span>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty appViews}">
          <tr><td colspan="6" class="empty">No applications yet. Apply from Explore page.</td></tr>
        </c:if>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>













