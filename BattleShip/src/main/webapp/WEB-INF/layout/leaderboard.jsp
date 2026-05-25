<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leaderboard - BattleShip</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/leaderboard.css">
</head>
<body>

<h1>🏆 Leaderboard</h1>
<p class="subtitle">Top ${limit} Best Players</p>

<div class="nav">
    <a href="${pageContext.request.contextPath}/">🏠 Home</a>
    <a href="${pageContext.request.contextPath}/history">📜 Match History</a>
</div>

<div class="table-wrap">
    <c:choose>
        <c:when test="${isLocked}">
            <div class="locked-container" style="text-align: center; padding: 60px 20px; background: #16213e; color: #fff;">
                <div class="lock-icon" style="font-size: 3.5rem; margin-bottom: 15px; filter: drop-shadow(0 0 10px rgba(0, 170, 255, 0.3));">🔒</div>
                <h2 style="font-size: 1.5rem; margin-bottom: 10px; font-weight: 600; color: #fff;">Login Required</h2>
                <p style="color: #888; font-size: 0.95rem; margin-bottom: 24px; max-width: 400px; margin-left: auto; margin-right: auto;">Please log in to view the leaderboard and compete with other players!</p>
                <a href="${pageContext.request.contextPath}/login" class="login-btn" style="display: inline-block; padding: 10px 24px; background: #0f3460; color: #fff; text-decoration: none; border-radius: 6px; font-weight: bold; border: 1px solid #3c97bf; transition: all 0.3s;" onmouseover="this.style.background='#3c97bf'" onmouseout="this.style.background='#0f3460'">Login Now</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:choose>
                <c:when test="${empty leaderboard}">
                    <div class="empty">No data available. Play your first match!</div>
                </c:when>
                <c:otherwise>
                    <table id="leaderboard-table">
                        <thead>
                        <tr>
                            <th>Rank</th>
                            <th>Player</th>
                            <th>Wins</th>
                            <th>Losses</th>
                            <th>Total Matches</th>
                            <th>Win Rate</th>
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
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
