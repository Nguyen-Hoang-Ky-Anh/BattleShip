<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String gameId = request.getParameter("gameId");
    if(gameId == null) gameId = "";
%>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Battle Simulation PvE</title>

    <!-- CORE CSS SYSTEM (Dùng chung hệ thống CSS của PvP) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- ICON SYSTEM -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>

<body class="battle-page">

<!-- =========================================================
     GLOBAL TACTICAL LAYOUT (Đồng bộ cấu trúc vỏ bọc PvP)
========================================================= -->
<div class="battle-layout-shell">

    <!-- =====================================================
         TOP TELEMETRY BAR (Thanh thông tin đỉnh trận đấu)
    ====================================================== -->
    <header class="battle-topbar">
        <div class="battle-brand">
            ⚔ PVE SIMULATION
        </div>

        <div class="battle-topbar-info monospace-data">
            <div class="telemetry-node">
                <span class="telemetry-label">SIM_ID</span>
                <span class="telemetry-value highlighted-cyan">
                    <%= gameId %>
                </span>
            </div>

            <div class="telemetry-node">
                <span class="telemetry-label">OPPONENT</span>
                <span class="telemetry-value highlighted-orange">
                    🤖 AI_BOT_v4.2
                </span>
            </div>
        </div>
    </header>

    <!-- =====================================================
         GLOBAL STATUS BAR (Thanh trạng thái lượt đấu)
    ====================================================== -->
    <section class="battle-global-status">
        <div class="status-indicator-dot"></div>
        <div id="battleStatus" class="battle-status-text monospace-data alert-blink">
            🎯 YOUR TURN - WEAPONS ENGAGED
        </div>
    </section>

    <!-- =====================================================
         MAIN BATTLEFIELD (Layout 3 cột chuẩn chỉ của PvP)
    ====================================================== -->
    <main class="battle-main-layout">

        <!-- =================================================
             LEFT TELEMETRY LOG (Cột trái: Nhật ký chiến sự)
        ================================================== -->
        <aside class="battle-log-panel">
            <div id="log" class="battle-log-stream monospace-data">
                <!-- Vùng sinh luồng log chiến sự PvE tự động -->
            </div>
        </aside>

        <!-- =================================================
             CENTER COMBAT SECTOR (Cột giữa: Bàn cờ địch lớn)
        ================================================== -->
        <section class="battle-combat-sector">
            <div class="enemy-board-shell alert-zone-ai">
                <div class="enemy-board-frame">
                    <div id="enemyBoard" class="board-matrix board-matrix--enemy">
                        <!-- Sinh lưới tấn công tự động bằng file JS -->
                    </div>
                </div>
            </div>
        </section>

        <!-- =================================================
             RIGHT RADAR HUD (Cột phải: Bản đồ Radar của ta)
        ================================================== -->
        <aside class="battle-radar-panel">
            <!-- MINI BOARD MA TRẬN PHÒNG THỦ -->
            <div class="radar-board-shell">
                <div id="myBoard" class="board-matrix board-matrix--mini">
                    <!-- Sinh lưới phòng thủ tự động bằng file JS -->
                </div>
            </div>

            <!-- EXTRA INFO TRẠNG THÁI HỆ THỐNG -->
            <div class="radar-info-stack">
                <div class="radar-info-card">
                    <span class="info-key">MODE</span>
                    <span class="info-value highlighted-orange">PVE_CORE</span>
                </div>

                <div class="radar-info-card">
                    <span class="info-key">STATUS</span>
                    <span class="info-value highlighted-mint">SIMULATING</span>
                </div>
            </div>
        </aside>

    </main>

</div>

<!-- =========================================================
     OCEAN FX (Đồng bộ hiệu ứng sóng nền đại dương)
========================================================= -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<!-- =========================================================
     DATA INTERCHANGE LAYER
========================================================= -->
<script>
    const contextPath = "${pageContext.request.contextPath}";
    window.GAME_ID = "<%= gameId %>";
</script>

<!-- =========================================================
     SYSTEM CORE SCRIPTS (Giữ nguyên logic điều khiển PvE)
========================================================= -->
<script src="${pageContext.request.contextPath}/assets/js/board.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/pve/battle-pve.js"></script>
</body>
</html>