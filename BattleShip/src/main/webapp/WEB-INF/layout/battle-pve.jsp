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
    <title>AI Battle Simulation</title>

    <!-- CSS CORE SYSTEM -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>

<body>

<!-- KHUNG BAO TOÀN DIỆN MÀN HÌNH CHIẾN TRƯỜNG PVE -->
<div class="battle-arena-wrapper">

    <!-- ================= SYSTEM TOP BAR (THANH THÔNG TIN BẢO MẬT) ================= -->
    <header class="battle-top-telemetry">
        <div class="telemetry-left">
            <h1 class="battle-main-title">⚔ PVE SIMULATION</h1>
        </div>

        <div class="telemetry-right monospace-data">
            <div class="info-node">
                <span class="label">SIM_ID:</span>
                <span class="value highlighted-cyan"><%= gameId %></span>
            </div>
            <div class="info-node">
                <span class="label">OPPONENT:</span>
                <span class="value highlighted-orange">🤖 AI_BOT_v4.2</span>
            </div>
        </div>
    </header>

    <!-- ================= BATTLE STATUS (CHỈ THỊ TRẠNG THÁI LƯỢT ĐẤU) ================= -->
    <div id="battleStatus" class="battle-status-banner alert-blink monospace-data">
        🎯 YOUR TURN - WEAPONS ENGAGED
    </div>

    <!-- ================= BATTLEFIELD LAYOUT (KHÔNG GIAN HAI BÀN CỜ) ================= -->
    <div class="battlefield-grid-layout">

        <!-- PHÂN KHU TẤN CÔNG CHÍNH: BÀN CỜ ĐỊCH (KÍCH THƯỚC LỚN) -->
        <section class="combat-zone enemy-fire-control">
            <h2 class="zone-subtitle monospace-data">// HOSTILE_WATERS (ENEMY_BOARD)</h2>
            <div class="matrix-glow-frame alert-zone-ai">
                <div id="enemyBoard" class="board enemy-board-matrix">
                    <!-- Sinh lưới tấn công tự động bằng file JS -->
                </div>
            </div>
        </section>

        <!-- PHÂN KHU PHÒNG THỦ TRẮC ĐỊA: BÀN CỜ CỦA TA (MINI RADAR MAP) -->
        <section class="combat-zone player-defense-radar">
            <h3 class="zone-subtitle monospace-data">// FRIENDLY_FLEET (YOUR_BOARD)</h3>
            <div class="mini-matrix-frame">
                <div id="myBoard" class="mini-board-matrix">
                    <!-- Sinh lưới phòng thủ tự động bằng file JS -->
                </div>
            </div>
        </section>

    </div>

    <!-- ================= TACTICAL LOGS (NHẬT KÝ CHIẾN SỰ HỆ THỐNG) ================= -->
    <footer class="tactical-log-console">
        <div class="log-header monospace-data">COMPILING MATRIX SIMULATION LOGS...</div>
        <div id="log" class="terminal-log-stream monospace-data">
            <!-- Luồng log chiến sự PvE cập nhật liên tục tại đây -->
        </div>
    </footer>

</div>

<!-- LỚP NỀN ĐẠI DƯƠNG ĐỒNG BỘ HIỆU ỨNG -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<!-- DATA INTERCHANGE LAYER -->
<script>
    const contextPath = "${pageContext.request.contextPath}";
    window.GAME_ID = "<%= request.getParameter("gameId") %>";
</script>

<!-- SYSTEM CORE SCRIPTS -->
<script src="${pageContext.request.contextPath}/assets/js/board.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/pve/battle-pve.js"></script>

</body>
</html>