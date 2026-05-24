<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leaderboard - BattleShip</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>
<body>

<!-- KHUNG BAO TOÀN DIỆN TRANG BẢNG XẾP HẠNG -->
<div class="leaderboard-page-container">

    <!-- ================= CONTROL NAVIGATION (THANH ĐIỀU HƯỚNG SƠ CẤP) ================= -->
    <nav class="tactical-nav-bar">
        <a href="${pageContext.request.contextPath}/" class="nav-btn btn-home">🏠 TRANG CHỦ</a>
        <a href="${pageContext.request.contextPath}/history" class="nav-btn btn-history">📜 LỊCH SỬ TRẬN ĐẤU</a>
    </nav>

    <!-- ================= HEADER TITLE (TIÊU ĐỀ TRẠM VINH DANH) ================= -->
    <header class="leaderboard-header">
        <h1 class="leaderboard-title">🏆 LEADERBOARD</h1>
        <p class="leaderboard-subtitle monospace-data">TOP ${limit} OPERATORS WITH HIGHEST COMBAT EFFICIENCY</p>
    </header>

    <!-- ================= DATA TABLE AREA (MA TRẬN HIỆU NĂNG) ================= -->
    <main class="table-data-wrapper">
        <c:choose>
            <c:when test="${empty leaderboard}">
                <div class="empty-log-state monospace-data alert-blink">
                    ⚠️ DATABASE EMPTY. DEPLOY YOUR FLEET AND CLAIM THE FIRST VICTORIES!
                </div>
            </c:when>
            <c:otherwise>
                <table id="leaderboard-table" class="cyber-data-table">
                    <thead>
                    <tr>
                        <th style="width: 80px; text-align: center;">RANK</th>
                        <th>OPERATOR</th>
                        <th style="width: 100px;">VICTORIES</th>
                        <th style="width: 100px;">DEFEATS</th>
                        <th style="width: 120px;">TOTAL_GAMES</th>
                        <th>WIN_RATE_INDEX</th>
                    </tr>
                    </thead>
                    <tbody class="monospace-data">
                    <c:forEach var="stats" items="${leaderboard}" varStatus="s">
                        <tr class="table-row-interactive rank-row-${s.index + 1}">
                            <td style="text-align: center;">
                                <c:choose>
                                    <c:when test="${s.index == 0}"><span class="rank-badge pod-1">🥇</span></c:when>
                                    <c:when test="${s.index == 1}"><span class="rank-badge pod-2">🥈</span></c:when>
                                    <c:when test="${s.index == 2}"><span class="rank-badge pod-3">🥉</span></c:when>
                                    <c:otherwise><span class="rank-number">#${s.index + 1}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="td-operator-name">${stats.username}</td>
                            <td class="td-wins-count">${stats.wins}</td>
                            <td class="td-losses-count">${stats.losses}</td>
                            <td class="td-muted">${stats.totalGames}</td>
                            <td>
                                <!-- THÀNH PHẦN THANH ĐỒ THỊ TIẾN TRÌNH CYBER -->
                                <div class="cyber-progress-container">
                                    <div class="progress-track-bg">
                                        <div class="progress-fill-bar" style="width: ${stats.winRate}%"></div>
                                    </div>
                                    <span class="progress-percentage-label">${stats.winRateFormatted}</span>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </main>

</div>

<!-- LỚP NỀN ĐẠI DƯƠNG ĐỒNG BỘ HIỆU ỨNG -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

</body>
</html>