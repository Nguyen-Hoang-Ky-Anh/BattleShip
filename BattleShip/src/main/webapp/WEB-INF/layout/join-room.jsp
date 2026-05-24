<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Intercept Tactical Room</title>

    <!-- CSS CORE SYSTEM -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>
<body>

<!-- ATMOSPHERIC BACKGROUND -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<!-- MAIN CONTAINER -->
<div class="room-join-wrapper">
    <div class="form-container">

        <%-- [UC-08][Entry Flow - Join Room][Display Title] --%>
        <h1 class="terminal-title">⚓ INTERCEPT ROOM</h1>
        <div class="terminal-subtitle monospace-data">NET_CMD: SCAN_QUANTUM_COORDINATES</div>

        <div class="terminal-separator"></div>

        <%-- [UC-08][Alternative Flow A2.1 - Room Invalid]
             Hiển thị khối cảnh báo lỗi nếu room không tồn tại hoặc không hợp lệ --%>
        <c:if test="${not empty error}">
            <div class="alert-terminal-error monospace-data">
                <span class="alert-blink">⚠️ [CRITICAL_ERROR] :</span> ${error}
            </div>
        </c:if>

            <%-- ======================================================
                LẤY THÔNG TIN USER ĐANG ĐĂNG NHẬP TỪ SESSION
            ====================================================== --%>
            <%@ page import="models.User" %>

            <%
                User currentUser = (User) session.getAttribute("user");
                String username = "";

                if(currentUser != null){
                    username = currentUser.getUsername();
                }
            %>

        <%-- =========================================
             [UC-08 - Entry Flow (Join)]
             Step A2.1: User nhập thông tin
           ========================================= --%>
        <form action="${pageContext.request.contextPath}/join-room" method="post" class="tactical-form">

            <!-- KHỐI NHẬP TÊN OPERATOR -->
            <div class="form-group">
                <label class="input-label monospace-data">GUEST_SIGNATURE :</label>
                <%-- [UC-08][Step A2.1.1 - Input User ID] --%>
                <input type="text"
                       name="userId"
                       value="<%= username %>"
                       placeholder="DEPLOY IDENTITY ENCODING..."
                       required>
            </div>

            <!-- KHỐI NHẬP MÃ PHÒNG ĐẤU -->
            <div class="form-group">
                <label class="input-label monospace-data">TARGET_ROOM_ID :</label>
                <%-- [UC-08][Step A2.1.2 - Input Room ID] --%>
                <input type="text"
                       name="roomId"
                       placeholder="ENTER QUANTUM ROOM ID..."
                       required>
            </div>

            <div class="terminal-separator"></div>

            <%-- [UC-08][Step A2.2 - Submit Join Request] --%>
            <button type="submit" class="btn-command-submit-cyan">ESTABLISH QUANTUM LINK</button>

        </form>

        <!-- ĐƯỜNG DẪN QUAY LẠI LOBBY MẸ -->
        <div class="back-navigation-zone">
            <form action="${pageContext.request.contextPath}/pvp" method="get">
                <button type="submit" class="btn-terminal-sm">◀ ABORT INTERCEPTION</button>
            </form>
        </div>

    </div>
</div>

</body>
</html>