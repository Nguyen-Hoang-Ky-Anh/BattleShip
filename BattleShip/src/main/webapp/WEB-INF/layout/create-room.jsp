<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Initialize Tactical Room</title>

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
<div class="room-creation-wrapper">
    <div class="form-container">

        <%-- [UC-07 - Create PvP Room][Step 2]
             System hiển thị màn hình cấu hình (gọi UC-07.1) --%>
        <h1 class="terminal-title">⚓ INITIALIZE ROOM</h1>
        <div class="terminal-subtitle monospace-data">NET_CMD: CONFIG_BATTLEFIELD_MATRIX</div>

        <div class="terminal-separator"></div>

        <%-- =========================================
             [UC-07.1 - Configure Room]
             Step 2: User nhập thông tin cấu hình
           ========================================= --%>
        <form action="${pageContext.request.contextPath}/create-room" method="post" class="tactical-form">

            <!-- KHỐI NHẬP TÊN OPERATOR -->
            <div class="form-group">
                <label class="input-label monospace-data">HOST_SIGNATURE :</label>
                <%-- [UC-07.1][Step 2.1 - Input User ID] --%>
                <input type="text"
                       name="userId"
                       placeholder="DEPLOY IDENTITY ENCODING..."
                       required>
            </div>

            <!-- KHỐI CHỌN KÍCH THƯỚC CHIẾN TRƯỜNG -->
            <div class="form-group">
                <label class="input-label monospace-data">GRID_SECTOR_SIZE :</label>
                <div class="custom-select-wrapper">
                    <%-- [UC-07.1][Step 2.2 - Input Board Size] --%>
                    <select name="boardSize" class="tactical-select">
                        <option value="10x10">10 x 10 [CLASSIC SIMULATION]</option>
                        <option value="8x8">8 x 8 [QUICK ENCOUNTER]</option>
                        <option value="12x12">12 x 12 [HARD COMMAND]</option>
                    </select>
                    <span class="select-arrow">▼</span>
                </div>
            </div>

            <div class="terminal-separator"></div>

            <%-- [UC-07.1][Step 3 - Confirm Configuration]
                 User xác nhận cấu hình phòng --%>
            <button type="submit" class="btn-command-submit">ENGAGE SECTOR INITIALIZATION</button>

        </form>

        <!-- ĐƯỜNG DẪN QUAY LẠI LOBBY MẸ -->
        <div class="back-navigation-zone">
            <form action="${pageContext.request.contextPath}/pvp" method="get">
                <button type="submit" class="btn-terminal-sm">◀ ABORT CONFIGURATION</button>
            </form>
        </div>

    </div>
</div>

</body>
</html>