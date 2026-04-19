<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Organizer Requests | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260415b">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260415b"></script>
<style>
.page{padding:16px;display:grid;gap:12px}
.hero{padding:14px;display:flex;justify-content:space-between;gap:10px;align-items:center;flex-wrap:wrap;background:#1f2937;color:#fff}
.hero h1{font-size:clamp(30px,5vw,48px)}
.hero a{padding:9px 10px;border:2px solid #1f2329;border-radius:12px;background:#fff;color:#1f2329;text-decoration:none;font-weight:700}
.metrics{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:10px}
.metric{padding:12px;border:2px solid #1f2329;border-radius:14px;background:#fff;display:block;color:inherit;text-decoration:none}
.metric.active{background:#1f2329;color:#fff}
.metric .k{font-size:11px;text-transform:uppercase;opacity:.72;font-weight:700}
.metric .v{font-size:34px;font-family:'Syne',sans-serif;line-height:1;margin-top:4px}
.panel{padding:10px;overflow:auto}
.status{display:inline-flex;padding:4px 8px;border:2px solid #1f2329;border-radius:999px;background:#fff;font-size:11px;font-weight:700;text-transform:uppercase}
.status.pending{background:rgba(217,119,6,.12);color:var(--cv-warn);border-color:rgba(217,119,6,.18)}
.status.approved{background:rgba(15,118,110,.12);color:var(--cv-accent-2);border-color:rgba(15,118,110,.18)}
.status.rejected{background:#f1f5f9;color:#64748b;border-color:#d5dde8}
.action-col{min-width:280px}
.action-form{display:grid;gap:6px}
.action-row{display:flex;gap:6px;flex-wrap:wrap}
.empty{text-align:center;padding:16px;font-weight:700}
@media(max-width:960px){.metrics{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:640px){.metrics{grid-template-columns:1fr}}
</style>
</head>
<body>
<c:if test="${not empty param.msg}">
  <div id="toast-data" data-type="${param.type == 'success' ? 'success' : 'error'}" style="display:none;"><c:out value="${param.msg}" /></div>
</c:if>

<div class="neo-shell page">
  <section class="neo-panel hero" data-reveal>
    <div>
      <h1 class="neo-title">Organizer Requests</h1>
      <p>Review onboarding requests and approve verified organizers.</p>
    </div>
    <a href="<c:url value='/admin-dashboard' />">Dashboard</a>
  </section>

  <section class="metrics" data-reveal>
    <a class="metric ${selectedStatus == 'ALL' ? 'active' : ''}" href="<c:url value='/admin/organizer-requests' />"><div class="k">All</div><div class="v">${pendingCount + approvedCount + rejectedCount}</div></a>
    <a class="metric ${selectedStatus == 'PENDING' ? 'active' : ''}" href="<c:url value='/admin/organizer-requests?status=PENDING' />"><div class="k">Pending</div><div class="v">${pendingCount}</div></a>
    <a class="metric ${selectedStatus == 'APPROVED' ? 'active' : ''}" href="<c:url value='/admin/organizer-requests?status=APPROVED' />"><div class="k">Approved</div><div class="v">${approvedCount}</div></a>
    <a class="metric ${selectedStatus == 'REJECTED' ? 'active' : ''}" href="<c:url value='/admin/organizer-requests?status=REJECTED' />"><div class="k">Rejected</div><div class="v">${rejectedCount}</div></a>
  </section>

  <section class="neo-panel panel" data-reveal>
    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Email</th>
          <th>Organization</th>
          <th>Website</th>
          <th>Location</th>
          <th>Status</th>
          <th>Created</th>
          <th class="action-col">Action</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty requests}">
            <tr><td colspan="8" class="empty">No organizer requests found.</td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach items="${requests}" var="r">
              <tr>
                <td>${r.firstName} ${r.lastName}</td>
                <td>${r.email}</td>
                <td>${r.organizationName}</td>
                <td><a href="${r.websiteUrl}" target="_blank" rel="noopener noreferrer">${r.websiteUrl != null ? (r.websiteUrl.length() > 30 ? r.websiteUrl.substring(0, 30).concat('...') : r.websiteUrl) : '-'}</a></td>
                <td>${r.city}, ${r.state}</td>
                <td>
                  <span class="status ${r.status == 'APPROVED' ? 'approved' : (r.status == 'REJECTED' ? 'rejected' : 'pending')}">${r.status}</span>
                </td>
                <td>${r.createdAt}</td>
                <td class="action-col">
                  <c:choose>
                    <c:when test="${r.status == 'PENDING'}">
                      <div class="action-form">
                        <form action="<c:url value='/admin/organizer-requests/approve' />" method="post">
                          <input type="hidden" name="_csrf" value="${_csrfToken}">
                          <input type="hidden" name="requestId" value="${r.organizerOnboardingRequestId}">
                          <input type="text" name="reviewNotes" placeholder="Approval note (optional)">
                          <div class="action-row">
                            <button type="submit">Approve</button>
                          </div>
                        </form>
                        <form action="<c:url value='/admin/organizer-requests/reject' />" method="post">
                          <input type="hidden" name="_csrf" value="${_csrfToken}">
                          <input type="hidden" name="requestId" value="${r.organizerOnboardingRequestId}">
                          <input type="text" name="reviewNotes" placeholder="Rejection reason" required>
                          <div class="action-row">
                            <button type="submit">Reject</button>
                          </div>
                        </form>
                      </div>
                    </c:when>
                    <c:otherwise>
                      <span>${empty r.reviewNotes ? '-' : r.reviewNotes}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </section>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>
