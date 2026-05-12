<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Trận Đấu - BattleShip</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/history.css">
</head>
<body>

<h1>📜 Lịch Sử Trận Đấu</h1>
<p class="subtitle">
    <c:choose>
        <c:when test="${viewingUsername != null}">Trận đấu của <strong style="color:#fff">${viewingUsername}</strong></c:when>
        <c:otherwise>Toàn bộ lịch sử trận đấu</c:otherwise>
    </c:choose>
</p>

<div class="nav">
    <a href="${pageContext.request.contextPath}/">🏠 Trang Chủ</a>
    <a href="${pageContext.request.contextPath}/leaderboard">🏆 Bảng Xếp Hạng</a>
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
        <div class="stat"><div class="num num-total">${matches.size()}</div><div class="lbl">Tổng Trận</div></div>
        <div class="stat"><div class="num num-win">${winCount}</div><div class="lbl">Thắng</div></div>
        <div class="stat"><div class="num num-loss">${matches.size() - winCount}</div><div class="lbl">Thua</div></div>
    </div>
</c:if>

<div class="table-wrap">
    <c:choose>
        <c:when test="${empty matches}">
            <div class="empty">Chưa có trận đấu nào được ghi lại.</div>
        </c:when>
        <c:otherwise>
            <table id="history-table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Người Thắng</th>
                    <th>Người Thua</th>
                    <th>Lượt Bắn</th>
                    <th>Kết Quả</th>
                    <th>Thời Gian</th>
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
                                    <span class="badge badge-win">THẮNG</span>
                                </c:when>
                                <c:when test="${viewingUsername != null}">
                                    <span class="badge badge-loss">THUA</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-win">${match.winner} thắng</span>
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
</div>

</body>
</html>
