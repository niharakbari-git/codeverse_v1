<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Applications</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260415b">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260415b"></script>
<style>
.header{position:sticky;top:0;z-index:100;height:64px;display:flex;align-items:center;justify-content:space-between;gap:10px;padding:0 24px;background:rgba(247,244,236,.92);backdrop-filter:blur(8px);border-bottom:1px solid #d7dce5}
.logo{display:flex;align-items:center;gap:10px;text-decoration:none;color:#1f2329}
.logo-icon{width:34px;height:34px;border-radius:10px;display:grid;place-items:center;background:#1f2937;color:#fff;font-weight:700}
.logo-text{font-family:'Space Grotesk',sans-serif;font-size:16px;font-weight:700;letter-spacing:.04em}
.nav-links{display:flex;align-items:center;gap:8px;flex-wrap:wrap}
.nav-links a{text-decoration:none;border:1px solid #d7dce5;border-radius:10px;background:#fff;color:#1f2329;font-size:13px;font-weight:700;padding:8px 12px}
.nav-links a:hover{background:#f5f7fb}
.nav-links a.active{background:#1f2329;color:#fff;border-color:#1f2329}

.page{display:grid;grid-template-columns:260px 1fr;gap:12px;min-height:calc(100vh - 64px);padding:16px;max-width:1320px;margin:0 auto}
.side{padding:14px}
.side h2{font-size:30px}
.side .links{display:grid;gap:8px;margin-top:10px}
.side .links a{padding:10px;border:2px solid #1f2329;border-radius:12px;text-decoration:none;background:#fff}
.side .links a.active{background:#1f2329;color:#fff}
.content{display:grid;gap:12px}
.wrap{padding:0}
.top{display:flex;justify-content:space-between;align-items:flex-start;gap:10px;flex-wrap:wrap;margin-bottom:12px}
.stats{display:flex;gap:10px;flex-wrap:wrap}
.stat{padding:10px 12px;border:2px solid #1f2329;border-radius:12px;background:#fff;min-width:120px}
.stat .label{font-size:11px;font-weight:700;text-transform:uppercase;color:#5e6673;letter-spacing:.06em}
.stat .value{margin-top:4px;font-size:24px;font-weight:800;font-family:"Syne",sans-serif}
.actions{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:12px}
.alert{padding:10px 12px;border:2px solid #1f2329;border-radius:10px;margin-bottom:10px;background:#fff8f6}
.workspace-grid{display:grid;grid-template-columns:1.1fr .9fr;gap:10px;margin-bottom:14px}
.workspace-card{padding:12px;border:2px solid #1f2329;border-radius:12px;background:#fff}
.workspace-card h4{margin:0 0 8px;font-size:18px}
.workspace-list{margin:0;padding-left:18px;display:grid;gap:6px;color:#1f2329;font-size:14px;line-height:1.5}
.workspace-hint{margin-top:8px;font-size:12px;color:#5e6673;line-height:1.4}
.workspace-actions{display:grid;gap:8px;margin-top:10px}
.workspace-actions a{display:block;padding:10px 11px;border:2px solid #1f2329;border-radius:10px;text-decoration:none;background:#fff;font-size:13px;font-weight:700}
.workspace-actions a strong{display:block;margin-bottom:2px}
.workspace-actions a small{display:block;color:#5e6673;font-size:11px;font-weight:500}
.app-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(380px,1fr));gap:12px}
.app-card{padding:14px;border:2px solid #d7dce5;border-radius:14px;background:#fff;display:grid;gap:8px}
.app-card.active{border-color:#0f766e;background:#f0fffe}
.app-header{display:grid;gap:4px}
.app-title{font-size:16px;font-weight:700;color:#1f2329}
.app-hackathon{color:#5e6673;font-size:13px}
.app-meta{display:grid;grid-template-columns:1fr 1fr;gap:8px;font-size:12px}
.app-meta-item{display:grid;gap:2px}
.app-meta-label{text-transform:uppercase;color:#5e6673;font-weight:700;letter-spacing:.05em;font-size:10px}
.app-meta-value{color:#1f2329;font-weight:600}
.status-badges{display:flex;gap:6px;flex-wrap:wrap;margin:8px 0}
.status-badge{display:inline-flex;align-items:center;gap:4px;padding:5px 9px;border-radius:8px;font-size:11px;font-weight:700}
.status-applied{background:rgba(15,118,110,.12);color:var(--cv-accent-2)}
.status-approved{background:rgba(31,35,41,.08);color:var(--cv-accent)}
.status-submitted{background:rgba(14,165,233,.12);color:#0369a1}
.status-scored{background:rgba(217,119,6,.12);color:var(--cv-warn)}
.status-pending-payment{background:rgba(217,119,6,.12);color:var(--cv-warn)}
.status-payment-done{background:rgba(15,118,110,.12);color:var(--cv-accent-2)}
.payment-actions{display:flex;gap:8px;flex-wrap:wrap;margin-top:10px}
.payment-actions form{margin:0}
.payment-actions button{border:none;cursor:pointer;background:#1f2329;color:#fff;font-weight:700;padding:9px 12px;border-radius:8px}
.submit-section{display:grid;gap:8px;margin-top:10px;padding-top:10px;border-top:1px solid #e7ebf2}
.submit-header{font-weight:700;font-size:13px;color:#1f2329}
.submit-form{display:grid;gap:8px}
.submit-form input,.submit-form textarea{font-size:12px;padding:8px 10px;border:1px solid #d7dce5;border-radius:8px;font-family:inherit}
.submit-form button{background:#1f2329;color:#fff;cursor:pointer;font-weight:700;border:none;padding:9px 11px;border-radius:8px}
.form-links{display:flex;gap:6px;flex-wrap:wrap;font-size:11px}
.form-links a{color:#0369a1;text-decoration:none;border-bottom:1px solid #0369a1}
.form-links a:hover{text-decoration:underline}
.empty-state{padding:40px 20px;text-align:center;border:2px dashed #d7dce5;border-radius:12px;background:#fff}
.empty-state h3{color:#1f2329;margin:0 0 8px}
.empty-state p{color:#5e6673;margin:0;font-size:13px}
.empty-state a{margin-top:12px}
@media(max-width:860px){.header{height:auto;padding:12px;align-items:flex-start;flex-direction:column}.page{grid-template-columns:1fr}.app-grid{grid-template-columns:1fr}.workspace-grid{grid-template-columns:1fr}}
</style>
</head>
<body>
<c:if test="${not empty param.msg}">
  <div id="toast-data" data-type="${param.type == 'error' ? 'error' : 'success'}" style="display:none;"><c:out value="${param.msg}" /></div>
</c:if>
<header class="header">
  <a class="logo" href="<c:url value='/participant/home' />">
    <div class="logo-icon">CV</div>
    <span class="logo-text">CODEVERSE</span>
  </a>
  <nav class="nav-links">
    <a href="<c:url value='/participant/home' />">Explore</a>
    <a class="active" href="<c:url value='/participant/participant-dashboard' />">Dashboard</a>
    <a href="<c:url value='/logout' />">Logout</a>
  </nav>
</header>

<div class="neo-shell page">
  <aside class="neo-panel side" data-reveal>
    <div class="neo-badge">Participant Features</div>
    <h2 class="neo-title">Workspace</h2>
    <div class="links">
      <a href="<c:url value='/participant/home' />">Explore Hackathons</a>
      <a class="active" href="<c:url value='/participant/my-applications' />">My Applications</a>
      <a href="<c:url value='/participant/my-teams' />">My Teams</a>
      <a href="<c:url value='/participant/profile' />">Profile</a>
      <a href="<c:url value='/charge' />">Open Payments</a>
    </div>
  </aside>

  <main class="content">
<div class="wrap">
  <div class="top" data-reveal>
    <div>
      <h1 class="neo-title">My Applications</h1>
      <p class="neo-sub">Track decisions, payment status, and submit your work from one place.</p>
    </div>
    <div class="stats">
      <div class="stat"><div class="label">Total</div><div class="value">${appViews.size()}</div></div>
      <div class="stat"><div class="label">Action</div><div class="value" style="font-size:13px;margin-top:7px;line-height:1.2;">Submit work</div></div>
    </div>
  </div>

  <c:if test="${not empty param.msg}">
    <div class="alert neo-panel" data-reveal>${param.msg}</div>
  </c:if>

  <c:if test="${not empty appViews}">
    <section class="neo-panel workspace-grid" data-reveal>
      <article class="workspace-card">
        <h4>Application Workflow</h4>
        <ol class="workspace-list">
          <li><strong>Apply</strong> to hackathons that interest you.</li>
          <li><strong>Submit</strong> your work after approval (details below).</li>
          <li><strong>Pay</strong> if required to finalize participation.</li>
          <li><strong>Monitor</strong> status as judges score submissions.</li>
        </ol>
        <p class="workspace-hint">Check status badges to know what action is needed next.</p>
      </article>
      <article class="workspace-card">
        <h4>Quick Reference</h4>
        <div class="workspace-actions">
          <a href="<c:url value='/participant/home' />"><strong>Apply to More</strong><small>Browse additional hackathons</small></a>
          <a href="<c:url value='/participant/my-teams' />"><strong>Manage Teams</strong><small>Update team members</small></a>
          <a href="<c:url value='/charge' />"><strong>Make Payment</strong><small>Complete payment for events</small></a>
        </div>
      </article>
    </section>
  </c:if>

  <c:choose>
    <c:when test="${empty appViews}">
      <section class="neo-panel empty-state" data-reveal>
        <h3>No Applications Yet</h3>
        <p>Start by exploring hackathons and submitting your application.</p>
        <a class="btn" href="<c:url value='/participant/home' />">Explore Hackathons</a>
      </section>
    </c:when>
    <c:otherwise>
      <section data-reveal>
        <h3 class="neo-title" style="padding:0 14px;margin-bottom:8px">Active Applications (${appViews.size()})</h3>
        <div class="app-grid">
          <c:forEach items="${appViews}" var="v">
            <div class="neo-panel app-card">
              <div class="app-header">
                <div class="app-title">${v.hackathonTitle}</div>
                <div class="app-hackathon">Team: ${v.teamName}</div>
              </div>

              <div class="app-meta">
                <div class="app-meta-item">
                  <div class="app-meta-label">App Status</div>
                  <div class="app-meta-value">${v.application.status}</div>
                </div>
                <div class="app-meta-item">
                  <div class="app-meta-label">Payment</div>
                  <div class="app-meta-value">
                    <c:choose>
                      <c:when test="${v.application.paymentStatus == 'PENDING'}">Awaiting Payment</c:when>
                      <c:when test="${v.application.paymentStatus == 'PAID'}">Paid</c:when>
                      <c:when test="${v.application.paymentStatus == 'FAILED'}">Payment Failed</c:when>
                      <c:otherwise>${v.application.paymentStatus}</c:otherwise>
                    </c:choose>
                  </div>
                </div>
                <div class="app-meta-item">
                  <div class="app-meta-label">Application Fee</div>
                  <div class="app-meta-value"><c:choose><c:when test="${v.entryFeeAmount > 0}">Rs. ${v.entryFeeAmount}</c:when><c:otherwise>Free</c:otherwise></c:choose></div>
                </div>
              </div>

              <div class="status-badges">
                <span class="status-badge status-${fn:toLowerCase(v.application.status)}">${v.application.status}</span>
                <span class="status-badge status-${fn:toLowerCase(v.application.paymentStatus)}">
                  <c:choose>
                    <c:when test="${v.application.paymentStatus == 'PENDING'}">Awaiting Payment</c:when>
                    <c:when test="${v.application.paymentStatus == 'PAID'}">Paid</c:when>
                    <c:when test="${v.application.paymentStatus == 'FAILED'}">Payment Failed</c:when>
                    <c:otherwise>${v.application.paymentStatus}</c:otherwise>
                  </c:choose>
                </span>
              </div>

              <c:if test="${v.entryFeeAmount > 0 && v.application.paymentStatus != 'PAID'}">
                <div class="payment-actions">
                  <form action="<c:url value='/participant/payment/initiate' />" method="post">
                    <input type="hidden" name="_csrf" value="${_csrfToken}">
                    <input type="hidden" name="applicationId" value="${v.application.applicationId}">
                    <button type="submit">Pay with UPI / Cards</button>
                  </form>
                  <a class="btn" href="<c:url value='/charge' />">Payment Help</a>
                </div>
              </c:if>

              <div class="app-meta" style="margin:0">
                <div class="app-meta-item">
                  <div class="app-meta-label">Applied</div>
                  <fmt:parseDate value="${v.application.appliedAt}" pattern="yyyy-MM-dd" var="parsedAppliedAt" type="date" />
                  <div class="app-meta-value"><fmt:formatDate value="${parsedAppliedAt}" pattern="dd-MM-yyyy" /></div>
                </div>
                <div class="app-meta-item">
                  <div class="app-meta-label">Versions Saved</div>
                  <div class="app-meta-value">${v.submissionVersionCount}</div>
                </div>
              </div>

              <c:if test="${v.application.status == 'APPROVED' || v.application.status == 'APPLIED'}">
                <c:if test="${v.entryFeeAmount > 0 && v.application.paymentStatus != 'PAID'}">
                  <div style="font-size:12px;color:#5e6673;padding:8px;background:#f8fafc;border-radius:6px;text-align:center">
                    Submission unlocks after payment is completed.
                  </div>
                </c:if>
              </c:if>

              <c:if test="${(v.application.status == 'APPROVED' || v.application.status == 'APPLIED') && (v.entryFeeAmount == 0 || v.application.paymentStatus == 'PAID')}">
                <details class="submit-section">
                  <summary class="submit-header">
                    <c:choose>
                      <c:when test="${not empty v.application.submissionUrl}">📝 Update Submission</c:when>
                      <c:otherwise>📝 Submit Your Work</c:otherwise>
                    </c:choose>
                  </summary>
                  <div style="font-size:11px;color:#5e6673;margin:8px 0">
                    <strong>Deadline:</strong> ${v.submissionDeadline} | Submitting does not change your application status.
                  </div>
                  <form class="submit-form" action="<c:url value='/participant/application/submit-work' />" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="_csrf" value="${_csrfToken}">
                    <input type="hidden" name="applicationId" value="${v.application.applicationId}">
                    <c:if test="${not empty v.application.submissionUrl || not empty v.application.frontendGithubLink || not empty v.application.backendGithubLink}">
                      <div class="form-links">
                        <c:if test="${not empty v.application.submissionUrl}">
                          <a target="_blank" rel="noopener noreferrer" href="${v.application.submissionUrl}">Current Demo</a>
                        </c:if>
                        <c:if test="${not empty v.application.frontendGithubLink}">
                          <a target="_blank" rel="noopener noreferrer" href="${v.application.frontendGithubLink}">Frontend Repo</a>
                        </c:if>
                        <c:if test="${not empty v.application.backendGithubLink}">
                          <a target="_blank" rel="noopener noreferrer" href="${v.application.backendGithubLink}">Backend Repo</a>
                        </c:if>
                      </div>
                    </c:if>
                    <input type="url" name="submissionUrl" placeholder="Live demo or drive link" value="${v.application.submissionUrl}" required>
                    <input type="url" name="frontendGithubLink" placeholder="Frontend repository URL (optional)" value="${v.application.frontendGithubLink}">
                    <input type="url" name="backendGithubLink" placeholder="Backend repository URL (optional)" value="${v.application.backendGithubLink}">
                    <textarea name="submissionDescription" placeholder="Describe your project, features, and tech stack" required>${v.application.submissionDescription}</textarea>
                    <input type="file" name="submissionFile" accept=".pdf,.zip,.png,.jpg,.jpeg,.mp4,.txt">
                    <c:if test="${not empty v.application.submissionAttachmentUrl}">
                      <div style="font-size:11px">Current attachment: <a target="_blank" rel="noopener noreferrer" href="${v.application.submissionAttachmentUrl}">${v.application.submissionAttachmentName}</a></div>
                    </c:if>
                    <button type="submit">Save & Submit</button>
                  </form>
                </details>
              </c:if>

              <c:if test="${v.application.status != 'APPROVED' && v.application.status != 'APPLIED'}">
                <div style="font-size:12px;color:#5e6673;padding:8px;background:#f8fafc;border-radius:6px;text-align:center">
                  Submission not available for this status
                </div>
              </c:if>
            </div>
          </c:forEach>
        </div>
      </section>
    </c:otherwise>
  </c:choose>
</div>
  </main>
</div>
<%@ include file="../shared/Toast.jspf" %>
</body>
</html>
