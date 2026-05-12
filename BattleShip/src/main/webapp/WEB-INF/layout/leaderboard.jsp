<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Xếp Hạng - BattleShip</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/leaderboard.css">
</head>
<body>

<h1>🏆 Bảng Xếp Hạng</h1>
<p class="subtitle">Top ${limit} người chơi xuất sắc nhất</p>

<div class="nav">
    <a href="${pageContext.request.contextPath}/">🏠 Trang Chủ</a>
    <a href="${pageContext.request.contextPath}/history">📜 Lịch Sử Trận Đấu</a>
</div>

<div class="table-wrap">
    <c:choose>
        <c:when test="${empty leaderboard}">
            <div class="empty">Chưa có dữ liệu. Hãy chơi trận đầu tiên!</div>
        </c:when>
        <c:otherwise>
            <table id="leaderboard-table">
                <thead>
                <tr>
                    <th>Hạng</th>
                    <th>Người Chơi</th>
                    <th>Thắng</th>
                    <th>Thua</th>
                    <th>Tổng Trận</th>
                    <th>Tỷ Lệ Thắng</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="stats" items="${leaderboard}" varStatus="s">
                    <tr>
                        <td>
                            <c:choose>
                                <c:when test="${s.index == 0}"><span class="rank r1">🥇</span></c:when>
                                <c:when test="${s.index == 1}"><span class="rank r2">🥈</span></c:when>
                                <c:when test="${s.index == 2}"><span class="rank r3">🥉</span></c:when>
                                <c:otherwise><span class="rank rn">${s.index + 1}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td style="font-weight:600">${stats.username}</td>
                        <td class="win">${stats.wins}</td>
                        <td class="loss">${stats.losses}</td>
                        <td class="muted">${stats.totalGames}</td>
                        <td>
                            <div class="bar-wrap">
                                <div class="bar-bg">
                                    <div class="bar-fill" style="width:${stats.winRate}%"></div>
                                </div>
                                <span class="bar-pct">${stats.winRateFormatted}</span>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
