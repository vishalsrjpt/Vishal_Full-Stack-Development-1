<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ page import="com.jobfinder.model.User" %>

    <% User user=(User) session.getAttribute("loggedUser"); if (user==null) {
      response.sendRedirect(request.getContextPath() + "/index.html" ); return; } String
      currentPage=request.getParameter("page"); if (currentPage==null) currentPage="dashboard" ; %>
      <!DOCTYPE html>
      <html lang="en">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Dashboard — <%= user.getName() %>
        </title>
        <link
          href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap"
          rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
          *,
          *::before,
          *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
          }

          :root {
            --bg: #F0EBE3;
            --card: #0C0C0C;
            --accent: #C9A96E;
            --text-card: #E8E2D9;
            --muted: #6B6B6B;
            --font-head: 'Playfair Display', serif;
            --font-body: 'DM Sans', sans-serif;
          }

          body {
            font-family: var(--font-body);
            background: var(--bg);
            display: flex;
            min-height: 100vh;
          }

          /* ─── SIDEBAR ─── */
          .sidebar {
            width: 240px;
            background: var(--card);
            padding: 2rem 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            z-index: 100;
          }

          .sidebar-logo {
            font-family: var(--font-head);
            font-size: 1.3rem;
            color: #fff;
            margin-bottom: 2rem;
            letter-spacing: -0.5px;
          }

          .sidebar-logo span {
            color: var(--accent);
          }

          .nav-item {
            display: flex;
            align-items: center;
            gap: 0.7rem;
            padding: 0.7rem 0.9rem;
            border-radius: 8px;
            color: rgba(232, 226, 217, 0.5);
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s, color 0.2s;
            text-decoration: none;
          }

          .nav-item:hover,
          .nav-item.active {
            background: rgba(201, 169, 110, 0.1);
            color: var(--accent);
          }

          .sidebar-user {
            margin-top: auto;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.04);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.07);
          }

          .user-name {
            font-size: 0.85rem;
            color: #fff;
            font-weight: 600;
          }

          .user-role {
            font-size: 0.72rem;
            color: rgba(232, 226, 217, 0.35);
          }

          /* ─── MAIN ─── */
          .main {
            margin-left: 240px;
            flex: 1;
            padding: 2.5rem 3rem;
          }

          .page-title {
            font-family: var(--font-head);
            font-size: 2rem;
            color: #111;
            font-weight: 700;
            letter-spacing: -0.5px;
            margin-bottom: 0.4rem;
          }

          .page-sub {
            font-size: 0.85rem;
            color: var(--muted);
            margin-bottom: 2rem;
          }

          /* ─── STAT CARDS ─── */
          .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.2rem;
            margin-bottom: 2.5rem;
          }

          .stat-wrap {
            position: relative;
          }

          .stat-wrap::before {
            content: '';
            position: absolute;
            inset: 0;
            background: #0C0C0C;
            border-radius: 12px;
            transform: rotate(2.5deg) translateX(7px) translateY(6px);
            opacity: 0.5;
            z-index: 0;
            transition: transform 0.3s;
          }

          .stat-wrap:hover::before {
            transform: rotate(3.5deg) translateX(11px) translateY(9px);
          }

          .stat-card {
            position: relative;
            z-index: 1;
            background: var(--card);
            border-radius: 12px;
            padding: 1.4rem 1.5rem;
            border: 1px solid rgba(201, 169, 110, 0.1);
            color: var(--text-card);
          }

          .stat-card-val {
            font-family: var(--font-head);
            font-size: 2rem;
            color: var(--accent);
            font-weight: 700;
            letter-spacing: -1px;
          }

          .stat-card-label {
            font-size: 0.78rem;
            color: rgba(232, 226, 217, 0.4);
            margin-top: 0.3rem;
          }

          /* ─── CHART ─── */
          .chart-wrap {
            position: relative;
          }

          .chart-wrap::before {
            content: '';
            position: absolute;
            inset: 0;
            background: #0C0C0C;
            border-radius: 14px;
            transform: rotate(2deg) translateX(10px) translateY(8px);
            opacity: 0.45;
            z-index: 0;
          }

          .chart-card {
            position: relative;
            z-index: 1;
            background: var(--card);
            border-radius: 14px;
            padding: 1.8rem;
            border: 1px solid rgba(201, 169, 110, 0.1);
            margin-bottom: 2.5rem;
          }

          .chart-title {
            font-family: var(--font-head);
            font-size: 1.1rem;
            color: #fff;
            margin-bottom: 1.2rem;
          }

          /* ─── JOBS LIST (not used currently, kept for reference) ─── */
          .section-title {
            font-family: var(--font-head);
            font-size: 1.3rem;
            color: #111;
            margin-bottom: 1.2rem;
            font-weight: 600;
          }

          .jobs-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
          }

          .job-wrap {
            position: relative;
          }

          .job-wrap::before {
            content: '';
            position: absolute;
            inset: 0;
            background: #0C0C0C;
            border-radius: 12px;
            transform: rotate(2deg) translateX(7px) translateY(6px);
            opacity: 0.4;
            z-index: 0;
            transition: transform 0.3s;
          }

          .job-wrap:hover::before {
            transform: rotate(3.5deg) translateX(12px) translateY(9px);
          }

          .job-card {
            position: relative;
            z-index: 1;
            background: var(--card);
            border-radius: 12px;
            padding: 1.4rem 1.5rem;
            border: 1px solid rgba(201, 169, 110, 0.1);
            color: var(--text-card);
            transition: transform 0.2s;
          }

          .job-wrap:hover .job-card {
            transform: translateY(-2px);
          }

          .job-title {
            font-family: var(--font-head);
            font-size: 1rem;
            color: #fff;
            margin-bottom: 0.3rem;
          }

          .job-company {
            font-size: 0.8rem;
            color: var(--accent);
            margin-bottom: 0.7rem;
          }

          .job-meta {
            display: flex;
            gap: 0.6rem;
            flex-wrap: wrap;
            margin-bottom: 1rem;
          }

          .tag {
            background: rgba(201, 169, 110, 0.1);
            border: 1px solid rgba(201, 169, 110, 0.2);
            color: rgba(232, 226, 217, 0.6);
            font-size: 0.7rem;
            font-weight: 500;
            padding: 0.2rem 0.6rem;
            border-radius: 4px;
          }

          .btn-apply {
            background: var(--accent);
            color: #0C0C0C;
            border: none;
            border-radius: 6px;
            padding: 0.5rem 1.2rem;
            font-family: var(--font-body);
            font-size: 0.8rem;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
          }

          .btn-apply:hover {
            background: #d4b07a;
          }

          /* Logout button */
          .btn-logout {
            background: transparent;
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(232, 226, 217, 0.4);
            font-size: 0.78rem;
            font-family: var(--font-body);
            padding: 0.4rem 0.8rem;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 0.5rem;
            transition: border-color 0.2s, color 0.2s;
            width: 100%;
            text-align: left;
          }

          .btn-logout:hover {
            border-color: #e55;
            color: #e55;
          }

          /* ─── GENERIC PAGE CARDS ─── */
          .page-card {
            background: var(--card);
            border-radius: 12px;
            padding: 1.5rem;
            border: 1px solid rgba(201, 169, 110, 0.1);
            color: var(--text-card);
            margin-bottom: 1.2rem;
          }

          .page-title-small {
            font-family: var(--font-head);
            font-size: 1.4rem;
            margin-bottom: 1rem;
            color: var(--accent);
          }

          .page-list {
            list-style: none;
            padding: 0;
          }

          .page-list li {
            padding: 0.8rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
          }

          .page-list li:last-child {
            border-bottom: none;
          }

          .tag-pill {
            display: inline-block;
            padding: 0.3rem 0.7rem;
            font-size: 0.7rem;
            border-radius: 5px;
            background: rgba(201, 169, 110, 0.1);
            color: var(--accent);
            margin-left: 0.5rem;
          }
        </style>
      </head>

      <body>

        <!-- ─── SIDEBAR ────────────────────────────── -->
        <aside class="sidebar">
          <div class="sidebar-logo">Job<span>Finder</span> Pro</div>
          <a class="nav-item <%= currentPage.equals(" dashboard") ? "active" : "" %>" href="?page=dashboard">🏠
            Dashboard</a>

          <a class="nav-item <%= currentPage.equals(" jobs") ? "active" : "" %>" href="?page=jobs">💼 Browse Jobs</a>

          <a class="nav-item <%= currentPage.equals(" applications") ? "active" : "" %>" href="?page=applications">📄 My
            Applications</a>

          <a class="nav-item <%= currentPage.equals(" resume") ? "active" : "" %>" href="?page=resume">📎 Resume</a>

          <a class="nav-item <%= currentPage.equals(" messages") ? "active" : "" %>" href="?page=messages">💬
            Messages</a>

          <a class="nav-item <%= currentPage.equals(" saved") ? "active" : "" %>" href="?page=saved">🔖 Saved Jobs</a>

          <a class="nav-item <%= currentPage.equals(" settings") ? "active" : "" %>" href="?page=settings">⚙️
            Settings</a>

          <div class="sidebar-user">
            <div class="user-name">
              <%= user.getName() %>
            </div>
            <div class="user-role">
              <%= user.getRole().substring(0,1).toUpperCase() + user.getRole().substring(1) %>
            </div>
            <form action="<%= request.getContextPath() %>/logout" method="post" style="margin-top:0.5rem">
              <button class="btn-logout" type="submit">← Logout</button>
            </form>
          </div>
        </aside>

        <!-- ─── MAIN CONTENT ───────────────────────── -->
        <main class="main">

          <% if (currentPage.equals("dashboard")) { %>

            <div class="page-title">Good morning, <%= user.getName().split(" ")[0] %>.</div>
                    <div class=" page-sub">Here's what's happening with your job search today.</div>

            <div class="stats-row">
              <div class="stat-wrap">
                <div class="stat-card">
                  <div class="stat-card-val">12</div>
                  <div class="stat-card-label">Jobs Applied</div>
                </div>
              </div>
              <div class="stat-wrap">
                <div class="stat-card">
                  <div class="stat-card-val">4</div>
                  <div class="stat-card-label">Interviews Scheduled</div>
                </div>
              </div>
              <div class="stat-wrap">
                <div class="stat-card">
                  <div class="stat-card-val">78</div>
                  <div class="stat-card-label">Resume Score</div>
                </div>
              </div>
              <div class="stat-wrap">
                <div class="stat-card">
                  <div class="stat-card-val">
                    <%= user.getStreak() %>🔥
                  </div>
                  <div class="stat-card-label">Login Streak</div>
                </div>
              </div>
            </div>

            <!-- Chart Card (added to fix missing canvas) -->
            <div class="chart-wrap">
              <div class="chart-card">
                <div class="chart-title">📈 Application Activity</div>
                <canvas id="activityChart" width="400" height="200" style="max-width:100%; height:auto;"></canvas>
              </div>
            </div>

            <% } else if (currentPage.equals("jobs")) { %>

              <div class="page-card">
                <div class="page-title-small">💼 Browse Jobs</div>
                <ul class="page-list">
                  <li>Java Developer <span class="tag-pill">₹20L</span> <span class="tag-pill">Bangalore</span></li>
                  <li>Frontend Engineer <span class="tag-pill">₹18L</span> <span class="tag-pill">Remote</span></li>
                  <li>Data Scientist <span class="tag-pill">₹25L</span> <span class="tag-pill">Delhi</span></li>
                </ul>
              </div>

              <% } else if (currentPage.equals("applications")) { %>

                <div class="page-card">
                  <div class="page-title-small">📄 My Applications</div>
                  <ul class="page-list">
                    <li>Google — Software Engineer <span class="tag-pill">Applied</span></li>
                    <li>Amazon — Backend Developer <span class="tag-pill">Interview</span></li>
                    <li>Flipkart — Data Analyst <span class="tag-pill">Rejected</span></li>
                  </ul>
                </div>

                <% } else if (currentPage.equals("resume")) { %>

                  <div class="page-card">
                    <div class="page-title-small">📎 Resume</div>
                    <p>Your resume score: <b style="color:var(--accent)">78/100</b></p>
                    <p style="margin-top:10px; color: var(--muted);">
                      Improve keywords and add more project experience.
                    </p>
                  </div>

                  <% } else if (currentPage.equals("messages")) { %>

                    <div class="page-card">
                      <div class="page-title-small">💬 Messages</div>
                      <ul class="page-list">
                        <li>HR — Google: "We liked your profile"</li>
                        <li>Recruiter — Amazon: "Schedule interview"</li>
                      </ul>
                    </div>

                    <% } else if (currentPage.equals("saved")) { %>

                      <div class="page-card">
                        <div class="page-title-small">🔖 Saved Jobs</div>
                        <ul class="page-list">
                          <li>Microsoft — SDE <span class="tag-pill">₹30L</span></li>
                          <li>Adobe — Frontend Dev <span class="tag-pill">₹28L</span></li>
                        </ul>
                      </div>

                      <% } else if (currentPage.equals("settings")) { %>

                        <div class="page-card">
                          <div class="page-title-small">⚙️ Settings</div>
                          <p>Name: <b>
                              <%= user.getName() %>
                            </b></p>
                          <p>Email: example@email.com</p>
                          <button style="
                margin-top: 10px;
                padding: 8px 12px;
                background: var(--accent);
                border: none;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;">
                            Update Profile
                          </button>
                        </div>

                        <% } %>

        </main>

        <script>
          // ─── Chart.js — Application Activity ────────
          const canvas = document.getElementById('activityChart');
          if (canvas) {
            const ctx = canvas.getContext('2d');
            new Chart(ctx, {
              type: 'line',
              data: {
                labels: ['Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'],
                datasets: [{
                  label: 'Applications',
                  data: [2, 5, 3, 8, 6, 12],
                  borderColor: '#C9A96E',
                  backgroundColor: 'rgba(201,169,110,0.08)',
                  fill: true,
                  tension: 0.4
                }]
              }
            });
          }

          // ─── Apply for a job (kept for reference) ───
          function applyJob(jobId, title) {
            fetch('<%= request.getContextPath() %>/apply', {
              method: 'POST',
              headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
              body: 'jobId=' + jobId
            })
              .then(r => r.json())
              .then(data => {
                alert(data.success ? '✅ Applied for: ' + title : '⚠️ ' + data.message);
              });
          }
        </script>
      </body>

      </html>