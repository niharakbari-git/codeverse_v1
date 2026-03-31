<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create Team</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
body{margin:0;background:#0a0a0f;color:#e2e8f0;font-family:'Syne',sans-serif}
.wrap{max-width:700px;margin:30px auto;padding:20px}
.card{background:#13131a;border:1px solid #2a2a3d;border-radius:14px;padding:20px}
h1{font-size:30px;margin:0 0 8px}
p{color:#64748b;margin:0 0 18px}
label{display:block;font-size:13px;color:#94a3b8;margin-bottom:6px}
input{width:100%;padding:11px 12px;border-radius:10px;border:1px solid #2a2a3d;background:#1c1c27;color:#e2e8f0;outline:none}
.actions{display:flex;gap:8px;margin-top:14px}
button,a{text-decoration:none;padding:10px 14px;border-radius:10px;border:1px solid #2a2a3d;background:#13131a;color:#e2e8f0;font-weight:700;cursor:pointer}
button{background:#7c3aed;border-color:#7c3aed}
</style>
</head>
<body>
<div class="wrap">
  <div class="card">
    <h1>Create Team</h1>
    <p>Apply to <strong>${hackathon.title}</strong> by creating your team.</p>
    <form action="<c:url value='/participant/team/create' />" method="post">
      <input type="hidden" name="hackathonId" value="${hackathon.hackathonId}">
      <label for="teamName">Team Name</label>
      <input id="teamName" type="text" name="teamName" placeholder="e.g. CodeStorm" required>
      <div class="actions">
        <button type="submit">Create Team & Apply</button>
        <a href="<c:url value='/participant/hackathon/${hackathon.hackathonId}' />">Back</a>
      </div>
    </form>
  </div>
</div>
</body>
</html>
