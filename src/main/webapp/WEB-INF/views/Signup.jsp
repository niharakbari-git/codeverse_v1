<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;600;700;800&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--bg:#08121a;--surface:#121f2b;--border:#2a4358;--text:#eaf2f9;--muted:#8ca5b9;--accent:#f97316;--accent2:#06b6d4}
body{font-family:'Syne',sans-serif;background:radial-gradient(circle at 18% 18%, rgba(6,182,212,.19), transparent 40%),radial-gradient(circle at 90% 78%, rgba(249,115,22,.18), transparent 38%),var(--bg);color:var(--text);min-height:100vh}
.layout{min-height:100vh;display:grid;grid-template-columns:1fr 1.2fr}
.visual{position:relative;overflow:hidden}
.visual::before{content:'';position:absolute;inset:0;background:linear-gradient(140deg,rgba(8,18,26,.1),rgba(8,18,26,.88)),url('<c:url value="/assets/images/auth/register-bg.jpg" />') center/cover no-repeat}
.visual-content{position:relative;z-index:1;height:100%;padding:46px;display:flex;flex-direction:column;justify-content:space-between}
.brand{font-family:'Space Mono',monospace;font-weight:700;letter-spacing:.06em;font-size:22px}
.hero h1{font-size:clamp(28px,3.5vw,48px);line-height:1.08;max-width:510px}
.hero p{margin-top:14px;max-width:510px;color:#d7e4ef;line-height:1.62}
.pill{display:inline-block;margin-top:20px;padding:8px 12px;border:1px solid rgba(255,255,255,.32);border-radius:999px;background:rgba(255,255,255,.1);font-size:12px}
.form-wrap{display:grid;place-items:center;padding:20px}
.card{width:min(760px,100%);background:rgba(18,31,43,.95);border:1px solid var(--border);border-radius:18px;padding:24px;box-shadow:0 18px 50px rgba(0,0,0,.28)}
.card h2{font-size:28px}
.card p{margin-top:7px;color:var(--muted)}
.grid{margin-top:14px;display:grid;grid-template-columns:1fr 1fr;gap:12px}
.field{display:flex;flex-direction:column;gap:6px}
.field.full{grid-column:1 / -1}
label{font-size:12px;color:var(--muted)}
input:not([type='radio']):not([type='file']),select{width:100%;padding:11px 12px;border-radius:10px;border:1px solid var(--border);background:#101a24;color:var(--text);font-size:14px}
input:not([type='radio']):not([type='file']):focus,select:focus{outline:none;border-color:var(--accent2);box-shadow:0 0 0 3px rgba(6,182,212,.16)}
input:-webkit-autofill,
input:-webkit-autofill:hover,
input:-webkit-autofill:focus,
input:-webkit-autofill:active{
  -webkit-box-shadow:0 0 0 1000px #101a24 inset !important;
  -webkit-text-fill-color:var(--text) !important;
  caret-color:var(--text);
  transition:background-color 9999s ease-in-out 0s;
}
input[type='file']{padding:9px 10px;border-radius:10px;border:1px dashed var(--border);background:#0d1721;color:#b9ccdc}
input[type='file']::file-selector-button{margin-right:10px;padding:8px 12px;border:1px solid transparent;border-radius:8px;background:linear-gradient(135deg,var(--accent),var(--accent2));color:#fff;font-weight:700;cursor:pointer}
.gender{display:flex;gap:14px;flex-wrap:wrap;padding-top:6px}
.gender label{display:flex;align-items:center;gap:6px;color:#cbd8e3;font-size:13px}
.actions{margin-top:15px;display:flex;gap:10px;align-items:center;justify-content:space-between;flex-wrap:wrap}
.submit{padding:12px 18px;border:none;border-radius:10px;background:linear-gradient(135deg,var(--accent),var(--accent2));color:#fff;font-weight:800;cursor:pointer}
.actions a{color:#9ad8e3;text-decoration:none;font-weight:700}
@media(max-width:1080px){.layout{grid-template-columns:1fr}.visual{min-height:240px}.visual-content{padding:28px}}
@media(max-width:700px){.grid{grid-template-columns:1fr}.card{padding:18px}}
</style>
</head>
<body>
<c:if test="${not empty error}">
  <div id="toast-data" data-type="error" style="display:none;"><c:out value="${error}" /></div>
</c:if>
<div class="layout">
  <section class="visual">
    <div class="visual-content">
      <div class="brand">CODEVERSE</div>
      <div class="hero">
        <h1>Build your profile and join the challenge circuit.</h1>
        <p>Create your account to discover hackathons, form teams, and compete in curated innovation tracks.</p>
        <span class="pill">New Creator</span>
      </div>
    </div>
  </section>

  <section class="form-wrap">
    <div class="card">
      <h2>Create Account</h2>
      <p>Start in less than a minute.</p>

      <form action="register" method="post" enctype="multipart/form-data" autocomplete="off">
        <input type="hidden" name="_csrf" value="${_csrfToken}">
        <input type="text" name="fake-user" style="display:none" autocomplete="off">
        <input type="password" name="fake-pass" style="display:none" autocomplete="new-password">
        <div class="grid">
          <div class="field">
            <label>First Name</label>
            <input type="text" name="firstName" required>
          </div>
          <div class="field">
            <label>Last Name</label>
            <input type="text" name="lastName" required>
          </div>

          <div class="field">
            <label>Email</label>
            <input type="email" name="email" value="" autocomplete="off" autocapitalize="none" spellcheck="false" readonly onfocus="this.removeAttribute('readonly');" required>
          </div>
          <div class="field">
            <label>Password</label>
            <input type="password" name="password" value="" autocomplete="new-password" readonly onfocus="this.removeAttribute('readonly');" required>
          </div>

          <div class="field full">
            <label>Gender</label>
            <div class="gender">
              <label><input type="radio" name="gender" value="MALE" required> Male</label>
              <label><input type="radio" name="gender" value="FEMALE"> Female</label>
              <label><input type="radio" name="gender" value="OTHER"> Other</label>
            </div>
          </div>

          <div class="field">
            <label>Birth Year</label>
            <input type="number" name="birthYear" min="1900" max="2100" required>
          </div>
          <div class="field">
            <label>Contact Number</label>
            <input type="text" name="contactNum" required>
          </div>

          <div class="field">
            <label>Qualification</label>
            <input type="text" name="qualification" placeholder="e.g. B.Tech, MCA" required>
          </div>
          <div class="field">
            <label>User Type</label>
            <select name="userTypeId" required>
              <option value="-1">---Select User Type---</option>
              <c:forEach items="${allUserType}" var="ut">
                <option value="${ut.userTypeId}">${ut.userType}</option>
              </c:forEach>
            </select>
          </div>

          <div class="field">
            <label>City</label>
            <input type="text" name="city" required>
          </div>
          <div class="field">
            <label>State</label>
            <input type="text" name="state" required>
          </div>

          <div class="field">
            <label>Country</label>
            <input type="text" name="country" value="India" required>
          </div>
          <div class="field">
            <label>Profile Picture</label>
            <input type="file" name="profilePic">
          </div>
        </div>

        <div class="actions">
          <button class="submit" type="submit">Create Account</button>
          <span>Already registered? <a href="login">Login</a></span>
        </div>
      </form>
    </div>
  </section>
</div>
<%@ include file="shared/Toast.jspf" %>
</body>
</html>
