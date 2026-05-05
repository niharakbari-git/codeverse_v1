<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
      <!DOCTYPE html>
      <html lang="en">

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Judge Assignments</title>
        <link
          href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap"
          rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260415b">
        <script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260415b"></script>
        <style>
          .header {
            position: sticky;
            top: 0;
            z-index: 100;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            padding: 0 24px;
            background: rgba(247, 244, 236, .92);
            backdrop-filter: blur(8px);
            border-bottom: 1px solid #d7dce5
          }

          .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: #1f2329
          }

          .logo-icon {
            width: 34px;
            height: 34px;
            border-radius: 10px;
            display: grid;
            place-items: center;
            background: #1f2937;
            color: #fff;
            font-weight: 700
          }

          .logo-text {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 16px;
            font-weight: 700;
            letter-spacing: .04em
          }

          .nav-links {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap
          }

          .nav-links a {
            text-decoration: none;
            border: 1px solid #d7dce5;
            border-radius: 10px;
            background: #fff;
            color: #1f2329;
            font-size: 13px;
            font-weight: 700;
            padding: 8px 12px
          }

          .nav-links a:hover {
            background: #f5f7fb
          }

          .nav-links a.active {
            background: #1f2329;
            color: #fff;
            border-color: #1f2329
          }

          .page {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 12px;
            max-width: 1320px;
            margin: 14px auto;
            padding: 0 16px;
            align-items: start
          }

          .rail {
            padding: 14px
          }

          .rail h3 {
            font-size: 28px
          }

          .rail-links {
            display: grid;
            gap: 8px;
            margin-top: 10px
          }

          .rail-links a {
            display: block;
            padding: 10px;
            border: 2px solid #1f2329;
            border-radius: 12px;
            background: #fff;
            text-decoration: none
          }

          .rail-links a.active {
            background: #1f2329;
            color: #fff;
            border-color: #1f2329
          }

          .main {
            display: grid;
            gap: 12px
          }

          .hero {
            padding: 16px;
            background: #1f2937;
            color: #fff
          }

          .hero h1 {
            font-size: clamp(32px, 5vw, 52px)
          }

          .hero p {
            margin-top: 8px;
            color: #ebfffb
          }

          .panel {
            padding: 10px;
            overflow: auto
          }

          table {
            min-width: 660px
          }

          .empty {
            padding: 16px;
            text-align: center;
            font-weight: 700
          }

          @media(max-width:980px) {
            .page {
              grid-template-columns: 1fr
            }
          }

          @media(max-width:860px) {
            .header {
              height: auto;
              padding: 12px;
              align-items: flex-start;
              flex-direction: column
            }
          }
        </style>
      </head>

      <body>
        <header class="header">
          <a class="logo" href="<c:url value='/judge-dashboard' />">
            <div class="logo-icon">CV</div>
            <span class="logo-text">CODEVERSE</span>
          </a>
          <nav class="nav-links">
            <a href="<c:url value='/participant/home' />">Explore</a>
            <a class="active" href="<c:url value='/judge-dashboard' />">Dashboard</a>
            <a href="<c:url value='/logout' />">Logout</a>
          </nav>
        </header>

        <div class="neo-shell page">
          <aside class="neo-panel rail" data-reveal>
            <div class="neo-badge">Judge Shortcuts</div>
            <h3 class="neo-title">Review Flow</h3>
            <div class="rail-links">
              <a class="active" href="<c:url value='/judge/my-assignments' />">My Assignments</a>
              <a href="<c:url value='/judge/scorecards' />">Scorecards</a>
              <a href="<c:url value='/participant/home' />">Explore Events</a>
            </div>
          </aside>

          <main class="main">
            <section class="neo-panel hero" data-reveal>
              <h1 class="neo-title">My Judge Assignments</h1>
              <p>Review all hackathons assigned to you and jump to scoring quickly.</p>
            </section>

            <section class="neo-panel panel" data-reveal>
              <table>
                <thead>
                  <tr>
                    <th>Hackathon</th>
                    <th>Assigned By</th>
                    <th>Date</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach items="${assignmentViews}" var="a">
                    <tr>
                      <td>${a.hackathonTitle}</td>
                      <td>${a.assignedBy}</td>
                      <fmt:parseDate value="${a.assignedAt}" pattern="yyyy-MM-dd" var="parsedAssignedAt" type="date" />
                      <td>
                        <fmt:formatDate value="${parsedAssignedAt}" pattern="dd-MM-yyyy" />
                      </td>
                    </tr>
                  </c:forEach>
                  <c:if test="${empty assignmentViews}">
                    <tr>
                      <td colspan="3" class="empty">No assignments yet.</td>
                    </tr>
                  </c:if>
                </tbody>
              </table>
            </section>
          </main>
        </div>
        <%@ include file="../shared/Toast.jspf" %>
      </body>

      </html>