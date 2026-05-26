<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Combat Logs - BattleShip</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>
<body>

<!-- KHUNG BAO TOÀN DIỆN TRANG LỊCH SỬ TÁC CHIẾN -->
<div class="history-page-container">

    <!-- ================= CONTROL NAVIGATION (THANH ĐIỀU HƯỚNG SƠ CẤP) ================= -->
    <nav class="tactical-nav-bar">
        <a href="${pageContext.request.contextPath}/" class="nav-btn btn-home">🏠 HOME</a>
        <a href="${pageContext.request.contextPath}/leaderboard" class="nav-btn btn-leader">🏆 LEADERBOARD</a>
    </nav>

    <!-- ================= HEADER TITLE (TIÊU ĐỀ TRẠM DỮ LIỆU) ================= -->
    <header class="history-header">
        <h1 class="history-title">📜 COMBAT LOGS</h1>
        <p class="history-subtitle monospace-data">
            <c:choose>
                <c:when test="${viewingUsername != null}">
                    DECRYPTING ENTRIES FOR OPERATOR: <span class="operator-highlight">${viewingUsername}</span>
                </c:when>
                <c:otherwise>HỆ THỐNG GHI NHẬN TOÀN BỘ LỊCH SỬ TÁC CHIẾN</c:otherwise>
            </c:choose>
        </p>
    </header>

    <!-- ================= TELEMETRY STATS BAR (KHỐI THỐNG KÊ CHIẾN LƯỢC) ================= -->
    <c:if test="${viewingUsername != null}">
        <c:set var="winCount" value="0"/>
        <c:forEach var="m" items="${matches}">
            <c:if test="${m.winner == viewingUsername}">
                <c:set var="winCount" value="${winCount + 1}"/>
            </c:if>
        </c:forEach>

        <div class="telemetry-stats-grid monospace-data">
            <div class="stat-card total-card">
                <div class="num num-total">${matches.size()}</div>
                <div class="lbl">// TOTAL_ENGAGED</div>
            </div>
            <div class="stat-card win-card">
                <div class="num num-win">${winCount}</div>
                <div class="lbl">// VICTORIES</div>
            </div>
            <div class="stat-card loss-card">
                <div class="num num-loss">${matches.size() - winCount}</div>
                <div class="lbl">// DEFEATS</div>
            </div>
        </div>
    </c:if>

    <!-- ================= DATA TABLE AREA (PHÂN KHU MA TRẬN LỊCH SỬ) ================= -->
    <main class="table-data-wrapper">
        <c:choose>
        <c:when test="${isLocked}">
            <div class="locked-container" style="text-align: center; padding: 60px 20px; background: #16213e; color: #fff;">
                <div class="lock-icon" style="font-size: 3.5rem; margin-bottom: 15px; filter: drop-shadow(0 0 10px rgba(0, 170, 255, 0.3));">🔒</div>
                <h2 style="font-size: 1.5rem; margin-bottom: 10px; font-weight: 600; color: #fff;">Login Required</h2>
                <p style="color: #888; font-size: 0.95rem; margin-bottom: 24px; max-width: 400px; margin-left: auto; margin-right: auto;">Please log in to view your personal match history!</p>
                <a href="${pageContext.request.contextPath}/login" class="login-btn" style="display: inline-block; padding: 10px 24px; background: #0f3460; color: #fff; text-decoration: none; border-radius: 6px; font-weight: bold; border: 1px solid #3c97bf; transition: all 0.3s;" onmouseover="this.style.background='#3c97bf'" onmouseout="this.style.background='#0f3460'">Login Now</a>
            </div>
        </c:when>
        <c:otherwise>
        <c:choose>
            <c:when test="${empty matches}">
                <div class="empty-log-state monospace-data alert-blink">
                    ⚠️ NO DATA ENTRIES FOUND IN THIS SECTOR.
                </div>
            </c:when>
            <c:otherwise>
                <table id="history-table" class="cyber-data-table">
                    <thead>
                    <tr>
                        <th style="width: 60px;">INDEX</th>
                        <th>VICTOR</th>
                        <th>DEFEATED</th>
                        <th style="text-align: center;">SHOTS</th>
                        <th style="text-align: center;">OUTCOME</th>
                        <th style="text-align: right;">TIMESTAMP</th>
                    </tr>
                    </thead>
                    <tbody class="monospace-data">
                    <c:forEach var="match" items="${matches}" varStatus="s">
                        <tr class="table-row-interactive">
                            <td class="td-muted">#${s.index + 1}</td>
                            <td class="td-winner-name">${match.winner}</td>
                            <td class="td-loser-name">${match.loser}</td>
                            <td style="text-align: center;" class="td-shots-count">${match.totalShots}</td>
                            <td style="text-align: center;">
                                <c:choose>
                                    <c:when test="${viewingUsername != null && match.winner == viewingUsername}">
                                        <span class="badge badge-win">VICTORY</span>
                                    </c:when>
                                    <c:when test="${viewingUsername != null}">
                                        <span class="badge badge-loss">DEFEATED</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-neutral-win">${match.winner} WIN</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align: right;" class="td-muted">${match.formattedTime}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
        </c:otherwise>
        </c:choose>
    </main>

</div>

<!-- LỚP NỀN ĐẠI DƯƠNG ĐỒNG BỘ HIỆU ỨNG -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
>>>>>>> origin/main
</div>

</body>
</html>