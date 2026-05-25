<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BattleShip Game - Tactical Command</title>

    <!-- CSS CORE -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>

<body>

<!-- TOP COMMAND BAR (HEADER REFACTOR) -->
<div class="top-command-bar">
    <div class="auth-telemetry-zone">

        <%-- =========================================
             [UC-01 - Chơi game với tư cách Guest]
        ========================================= --%>
        <%-- [UC-01][Step 1.1.0 - Check Guest Session] --%>
        <% if(session.getAttribute("user") == null){ %>

        <!-- TRẠNG THÁI: CHƯA KẾT NỐI (GUEST) -->
        <%-- =========================================
             [UC-03 - Đăng nhập]
        ========================================= --%>
        <%-- [UC-03][Step 3.1.0 - Người dùng ở màn hình “Đăng nhập”] --%>
        <form action="${pageContext.request.contextPath}/login" method="get" class="inline-form">
            <%-- [UC-03][Step 3.1.1 - Người dùng nhập thông tin đăng nhập] --%>
            <input type="hidden" name="mode" value="login">
                <%-- [UC-03][Step 3.1.2 - Người dùng nhấn nút "Đăng nhập"] --%>
            <button type="submit" class="btn-terminal-sm">LOG IN</button>
        </form>

        <%-- =========================================
             [UC-02 - Đăng ký tài khoản]
        ========================================= --%>
        <%-- [UC-02][Step 2.1.0 - Guest ở màn hình “Đăng ký”] --%>
        <form action="${pageContext.request.contextPath}/login" method="get" class="inline-form">
            <%-- [UC-02][Step 2.1.1 - Hệ thống hiển thị form đăng ký: username, email, password] --%>
            <input type="hidden" name="mode" value="register">
            <%-- [UC-02][Step 2.1.2 - Guest nhập thông tin và gửi form] --%>
            <button type="submit" class="btn-terminal-sm accent-mint-border">REGISTER</button>
        </form>
        <% } else { %>

        <!-- TRẠNG THÁI: ĐÃ ĐĂNG NHẬP (OPERATOR) -->
        <%-- [UC-03][Step 3.1.5 - Hệ thống khởi tạo phiên làm việc cho User] --%>
        <% models.User user = (models.User) session.getAttribute("user"); %>

        <%-- [UC-03][Step 3.1.6 - Hệ thống chuyển hướng người dùng về màn hình chính] --%>
        <div class="operator-badge">
            <span class="status-indicator-online"></span>
            <span class="monospace-data">OP: <%= user.getUsername() %></span>
        </div>

        <%-- =========================================
             [UC-04 - Đăng xuất]
        ========================================= --%>
        <%-- [UC-04][Step 4.1.0 - User ở màn hình chính] --%>
        <form action="${pageContext.request.contextPath}/logout" method="post" class="inline-form"

              <%-- [UC-04][Step 4.1.2 - Hệ thống hiển thị hộp thoại xác nhận] --%>
              onsubmit="return confirm('Bạn có chắc chắn muốn đăng xuất không?');">

            <%-- [UC-04][Step 4.1.1 - User nhấn chọn nút "Đăng xuất"] --%>
            <button type="submit" class="btn-terminal-sm accent-crimson-border">LOGOUT</button>
        </form>
        <% } %>
    </div>

    <!-- CONTROL TELEMETRY (MENU THẢ XUỐNG & TIỆN ÍCH) -->
    <div class="control-telemetry-zone">
        <!-- NÚT BẬT/TẮT NHẠC NỀN -->
        <button class="btn-utility" onclick="toggleMusic()" id="musicToggleBtn" title="Toggle Audio Grid">🔊</button>

        <!-- HỆ THỐNG MENU ĐIỀU HƯỚNG PHỤ -->
        <div class="navigation-dropdown-wrapper">
            <div class="hamburger-menu-trigger" onclick="toggleMenu()">SYSTEM MENU ☰</div>
            <div id="dropdown" class="dropdown-content-panel">
                <form action="${pageContext.request.contextPath}/history" method="get">
                    <button type="submit" class="btn-dropdown-item">📜 MISSION HISTORY</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- MAIN HUB CONTAINER -->
<div class="main-hub-container">
    <div class="tactical-glass-panel">
        <!-- LOGO CHIẾN HẠM CÔNG NGHỆ -->
        <h1 class="main-tactical-title">⚓ BATTLESHIP</h1>
        <div class="title-sub-text monospace-data">TACTICAL SIMULATION NETWORK</div>

        <div class="terminal-separator"></div>

        <!-- MENU CHỌN CHẾ ĐỘ CHƠI -->
        <div class="tactical-menu-grid">
            <form action="${pageContext.request.contextPath}/pre-game" method="get">
                <button type="submit" class="btn-command-large">
                    <span class="btn-icon">🤖</span> PVE ARCHETYPE <span class="btn-sub-label">Vs Core Intelligence</span>
                </button>
            </form>

            <form action="${pageContext.request.contextPath}/pvp" method="get">
                <button type="submit" class="btn-command-large">
                    <span class="btn-icon">🧑‍🤝‍🧑</span> PVP ENCOUNTER <span class="btn-sub-label">Realtime Fleet Combat</span>
                </button>
            </form>

            <form action="${pageContext.request.contextPath}/leaderboard" method="get">
                <button type="submit" class="btn-command-large">
                    <span class="btn-icon">🏆</span> LEADERBOARD <span class="btn-sub-label">Global Fleet Rankings</span>
                </button>
            </form>

            <form action="${pageContext.request.contextPath}/how-to-play" method="get">
                <button type="submit" class="btn-command-large">
                    <span class="btn-icon">📘</span> TACTICAL MANUAL <span class="btn-sub-label">Rules of Engagement</span>
                </button>
            </form>
        </div>
    </div>
</div>

<!-- SYSTEM METRICS FOOTER -->
<div class="system-footer">
    <div class="system-status-indicator monospace-data">
        SECURE CONNECTION // STATUS: ACTIVE
    </div>
    <div class="version-badge monospace-data">
        SYS_VER: v1.0.0
    </div>
</div>

<!-- ATMOSPHERIC BACKGROUND -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<!-- AUDIO INFRASTRUCTURE -->
<audio id="bgMusic" loop>
    <source src="${pageContext.request.contextPath}/assets/audio/home.mp3" type="audio/mpeg">
</audio>

<script>
    const ctx = "${pageContext.request.contextPath}";
</script>

<!-- CORE SCRIPT -->
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>