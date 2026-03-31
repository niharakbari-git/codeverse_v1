<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Forgot Password | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--bg:#08121a;--surface:#121f2b;--border:#2a4358;--text:#eaf2f9;--muted:#8ca5b9;--accent:#f97316;--accent2:#06b6d4}
body{font-family:'Syne',sans-serif;background:radial-gradient(circle at 18% 18%, rgba(6,182,212,.18), transparent 40%),radial-gradient(circle at 90% 78%, rgba(249,115,22,.18), transparent 38%),var(--bg);color:var(--text);min-height:100vh;display:grid;place-items:center;padding:18px}
.card{width:min(460px,100%);background:rgba(18,31,43,.95);border:1px solid var(--border);border-radius:18px;padding:26px;box-shadow:0 18px 50px rgba(0,0,0,.28)}
.brand{font-family:'Space Mono',monospace;font-weight:700;letter-spacing:.06em;font-size:20px;margin-bottom:8px}
h2{font-size:30px}
.sub{margin-top:6px;color:var(--muted);font-size:14px}
.field{margin-top:16px}
label{display:block;font-size:13px;color:var(--muted);margin-bottom:6px}
input{width:100%;padding:12px 13px;border-radius:11px;border:1px solid var(--border);background:#101a24;color:var(--text);font-size:14px}
input:focus{outline:none;border-color:var(--accent2);box-shadow:0 0 0 3px rgba(6,182,212,.16)}
button{margin-top:14px;width:100%;padding:12px;border:none;border-radius:11px;background:linear-gradient(135deg,var(--accent),var(--accent2));color:#fff;font-weight:800;cursor:pointer}
.row{margin-top:12px;text-align:center}
.row a{color:#9ad8e3;text-decoration:none;font-weight:700}
.msg{margin-top:12px;padding:10px 12px;border-radius:10px;font-size:13px}
.msg.success{background:#072e2f;border:1px solid #0f766e;color:#ccfbf1}
.msg.error{background:#3b0d0d;border:1px solid #7f1d1d;color:#fecaca}
</style>
</head>
<body>
    <div class="card">
        <div class="brand">CODEVERSE</div>
        <h2>Forgot Password</h2>
        <p class="sub">Enter your registered email and we will process your reset request.</p>

        <c:if test="${not empty success}">
            <div class="msg success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="msg error">${error}</div>
        </c:if>

        <form action="sendResetLink" method="post" autocomplete="off">
            <div class="field">
                <label for="email">Email Address</label>
                <input type="email" name="email" id="email" placeholder="Enter your registered email" required>
            </div>
            <button type="submit">Send Reset Link</button>
            <div class="row"><a href="login">Back to Login</a></div>
        </form>
    </div>
</body>
</html>