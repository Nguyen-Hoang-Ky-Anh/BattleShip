<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Match History - BattleShip</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/history.css">
</head>
<body>

<h1>📜 Match History</h1>
<p class="subtitle">
    <c:choose>
        <c:when test="${viewingUsername != null}">Matches of <strong style="color:#fff">${viewingUsername}</strong></c:when>
        <c:otherwise>All Match History</c:otherwise>
    </c:choose>
</p>

<div class="nav">
    <a href="${pageContext.request.contextPath}/">🏠 Home</a>
    <a href="${pageContext.request.contextPath}/leaderboard">🏆 LeaderBoard</a>
</div>

<%-- Stats bar (chỉ hiện khi đã đăng nhập) --%>
<c:if test="${viewingUsername != null}">
    <c:set var="winCount" value="0"/>
    <c:forEach var="m" items="${matches}">
        <c:if test="${m.winner == viewingUsername}">
            <c:set var="winCount" value="${winCount + 1}"/>
        </c:if>
    </c:forEach>
    <div class="stats">
        <div class="stat"><div class="num num-total">${matches.size()}</div><div class="lbl">Total Matches</div></div>
        <div class="stat"><div class="num num-win">${winCount}</div><div class="lbl">Wins</div></div>
        <div class="stat"><div class="num num-loss">${matches.size() - winCount}</div><div class="lbl">Losses</div></div>
    </div>
</c:if>

<div class="table-wrap">
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
                    <div class="empty">No matches recorded yet.</div>
                </c:when>
                <c:otherwise>
                    <table id="history-table">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Winner</th>
                            <th>Loser</th>
                            <th>Total Shots</th>
                            <th>Result</th>
                            <th>Time</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="match" items="${matches}" varStatus="s">
                            <tr>
                                <td class="muted">${s.index + 1}</td>
                                <td class="win">${match.winner}</td>
                                <td class="loss">${match.loser}</td>
                                <td>${match.totalShots}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${viewingUsername != null && match.winner == viewingUsername}">
                                            <span class="badge badge-win">WIN</span>
                                        </c:when>
                                        <c:when test="${viewingUsername != null}">
                                            <span class="badge badge-loss">LOSS</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-win">${match.winner} won</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="muted">${match.formattedTime}</td>
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
