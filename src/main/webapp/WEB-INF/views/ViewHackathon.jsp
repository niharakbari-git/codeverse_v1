<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Hackathon</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--bg:#0a0f16;--surface:#131c27;--surface2:#1c2734;--border:#2a3d52;--text:#e2e8f0;--muted:#8ca0b3;--accent:#f97316;--accent2:#06b6d4}
body{font-family:'Syne',sans-serif;background:radial-gradient(circle at 12% 16%,rgba(6,182,212,.14),transparent 35%),radial-gradient(circle at 85% 82%,rgba(249,115,22,.14),transparent 40%),var(--bg);color:var(--text);min-height:100vh}
.wrap{max-width:900px;margin:28px auto;padding:0 18px 28px}
.top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:14px}
h1{font-size:clamp(24px,4vw,36px);font-weight:800;letter-spacing:-.6px}
h1 span{background:linear-gradient(135deg,var(--accent),var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.actions{display:flex;gap:8px;flex-wrap:wrap}
.btn{display:inline-block;text-decoration:none;padding:9px 12px;border:1px solid var(--border);border-radius:10px;background:var(--surface);color:var(--text);font-weight:700;font-size:13px;cursor:pointer;transition:all .2s}
.btn:hover{border-color:var(--accent2);box-shadow:0 4px 12px rgba(6,182,212,.12)}
.btn.primary{border:none;background:linear-gradient(135deg,var(--accent),var(--accent2));box-shadow:0 10px 24px rgba(6,182,212,.16)}
.btn.primary:hover{transform:translateY(-2px);box-shadow:0 14px 28px rgba(6,182,212,.2)}
.btn.danger{border-color:#dc2626;color:#fecaca}
.btn.danger:hover{background:rgba(220,38,38,.1)}
.card{border:1px solid var(--border);border-radius:14px;background:var(--surface);padding:20px}
.field-group{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:20px;margin-bottom:20px}
.field{display:flex;flex-direction:column}
.field-label{font-size:12px;color:var(--muted);margin-bottom:8px;text-transform:uppercase;letter-spacing:.5px;font-weight:700}
.field-value{font-size:15px;color:var(--text);line-height:1.5}
.field-value.muted{color:var(--muted)}
.badge{display:inline-block;padding:4px 10px;border-radius:6px;font-size:12px;font-weight:600;width:fit-content}
.badge.upcoming{background:rgba(59,130,246,.15);color:#93c5fd}
.badge.ongoing{background:rgba(34,197,94,.15);color:#86efac}
.badge.completed{background:rgba(107,114,128,.15);color:#d1d5db}
.badge.free{background:rgba(34,197,94,.15);color:#86efac}
.badge.paid{background:rgba(249,115,22,.15);color:#fed7aa}
.description{background:var(--surface2);padding:14px;border-radius:10px;border-left:3px solid var(--accent2);font-size:14px;line-height:1.6;margin-bottom:20px}
.footer{margin-top:20px;display:flex;justify-content:flex-end;gap:8px;flex-wrap:wrap;padding-top:16px;border-top:1px solid var(--border)}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <h1><span>Hackathon</span> Details</h1>
    <div class="actions">
      <a class="btn" href="<c:url value='/listHackathon' />">Back</a>
    </div>
  </div>

  <div class="card">
    <div class="field-group">
      <div class="field">
        <div class="field-label">Title</div>
        <div class="field-value">${hackathon.title}</div>
      </div>
      <div class="field">
        <div class="field-label">Status</div>
        <div class="field-value">
          <span class="badge ${hackathon.status == 'UPCOMING' ? 'upcoming' : hackathon.status == 'ONGOING' ? 'ongoing' : 'completed'}">${hackathon.status}</span>
        </div>
      </div>
      <div class="field">
        <div class="field-label">Event Type</div>
        <div class="field-value">${hackathon.eventType}</div>
      </div>
      <div class="field">
        <div class="field-label">Payment</div>
        <div class="field-value">
          <span class="badge ${hackathon.payment == 'PAID' ? 'paid' : 'free'}">${hackathon.payment}</span>
        </div>
      </div>
      <div class="field">
        <div class="field-label">Team Size</div>
        <div class="field-value">${hackathon.minTeamSize} - ${hackathon.maxTeamSize} members</div>
      </div>
      <div class="field">
        <div class="field-label">Location</div>
        <div class="field-value">${hackathon.location}</div>
      </div>
      <div class="field">
        <div class="field-label">User Type ID</div>
        <div class="field-value">${hackathon.userTypeId}</div>
      </div>
      <div class="field">
        <div class="field-label">Registration Period</div>
        <div class="field-value"><fmt:formatDate value="${hackathon.registrationStartDate}" pattern="dd/MM/yyyy" /> to <fmt:formatDate value="${hackathon.registrationEndDate}" pattern="dd/MM/yyyy" /></div>
      </div>
    </div>

    <div class="field">
      <div class="field-label">Description</div>
      <div class="description">${hackathon.description}</div>
    </div>

    <div class="footer">
      <a href="deleteHackathon?hackathonId=${hackathon.hackathonId}" class="btn danger" onclick="return confirm('Delete this hackathon?')">Delete</a>
      <a href="editHackathon?hackathonId=${hackathon.hackathonId}" class="btn primary">Edit</a>
    </div>
  </div>
</div>
</body>
</html>
