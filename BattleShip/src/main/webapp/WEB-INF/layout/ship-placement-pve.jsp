<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tactical Deployment PvE - BattleShip</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>

<!-- KHUNG BAO HAI CỘT ĐỒNG BỘ VỚI HỆ THỐNG PLACEMENT -->
<div class="placement-container">

    <!-- ================= SIDEBAR: TRẠM ĐIỀU KHIỂN HẠM ĐỘI (BÊN TRÁI) ================= -->
    <aside class="placement-sidebar">

        <div class="sidebar-header">
            <h1 class="sidebar-title">⚓ DEPLOYMENT</h1>
            <p class="sidebar-subtitle monospace-data">// STRATEGIC_FLEET_POSITIONING</p>
        </div>

        <!-- THÔNG TIN PHÂN KHU TÁC CHIẾN PVE -->
        <div class="room-telemetry-box monospace-data">
            <div class="telemetry-row">
                <span class="label">MODE:</span>
                <span class="value highlighted-orange">🤖 PVE_BATTLE</span>
            </div>
            <div class="telemetry-row">
                <span class="label">ENEMY:</span>
                <span class="value highlighted-orange">AI_BOT_v4.2</span>
            </div>
        </div>

        <!-- PHÂN KHU CHỌN CHIẾN HẠM (SHIP PANEL) -->
        <div class="ship-selection-panel">
            <h3 class="panel-section-title monospace-data">// AVAILABLE_WARSHIPS</h3>

            <div class="ship-list-container">
                <!-- Carrier (5) -->
                <div class="ship-item-card" data-size="5">
                    <div class="ship-blueprint-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/ship_4_ngang.png" alt="Carrier"/>
                    </div>
                    <div class="ship-meta monospace-data">
                        <span class="ship-name">Carrier</span>
                        <span class="ship-size-badge">SIZE: 5</span>
                    </div>
                </div>

                <!-- Battleship (4) -->
                <div class="ship-item-card" data-size="4">
                    <div class="ship-blueprint-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/ship_3_ngang.png" alt="Battleship"/>
                    </div>
                    <div class="ship-meta monospace-data">
                        <span class="ship-name">Battleship</span>
                        <span class="ship-size-badge">SIZE: 4</span>
                    </div>
                </div>

                <!-- Submarine (3) -->
                <div class="ship-item-card" data-size="3">
                    <div class="ship-blueprint-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/ship_2_ngang.png" alt="Submarine"/>
                    </div>
                    <div class="ship-meta monospace-data">
                        <span class="ship-name">Submarine</span>
                        <span class="ship-size-badge">SIZE: 3</span>
                    </div>
                </div>

                <!-- Destroyer (2) -->
                <div class="ship-item-card" data-size="2">
                    <div class="ship-blueprint-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/ship_1_ngang.png" alt="Destroyer"/>
                    </div>
                    <div class="ship-meta monospace-data">
                        <span class="ship-name">Destroyer</span>
                        <span class="ship-size-badge">SIZE: 2</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- HỆ THỐNG NÚT LỆNH ĐIỀU KHIỂN (CONTROLS) -->
        <div class="action-controls-grid">
            <button class="tech-btn btn-rotate monospace-data" onclick="rotateShip()">
                <i class="bi bi-arrow-repeat"></i> ROTATE
            </button>
            <button class="tech-btn btn-reset monospace-data" onclick="resetBoard()">
                <i class="bi bi-trash3"></i> RESET
            </button>
            <button class="tech-btn btn-launch monospace-data" onclick="confirmPlacement()">
                🚀 START BATTLE
            </button>
            <button class="tech-btn btn-back" onclick="window.history.back()" title="Quay lại">
                <i class="bi bi-arrow-return-left"></i>
            </button>
        </div>

    </aside>

    <!-- ================= MAIN AREA: THỦY TRÌNH QUÉT RADAR (BÊN PHẢI) ================= -->
    <main class="placement-main-arena">

        <!-- BANNER CHỈ THỊ TRẠNG THÁI -->
        <div id="placementStatus" class="placement-status-hud alert-blink monospace-data">
            📡 SYSTEM_READY: PLACE YOUR SHIPS ON THE MATRIX
        </div>

        <!-- KHUNG CHỨA BÀN CỜ ĐẶT TÀU CHÍNH -->
        <div class="matrix-radar-wrapper alert-zone-pve">
            <div id="board" class="board grid-tactical-matrix">
                <!-- Hàm createBoard() sẽ tự động sinh lưới 10x10 tại đây -->
            </div>
        </div>

    </main>

</div>

<!-- LỚP NỀN ĐẠI DƯƠNG ĐỒNG BỘ TOÀN HỆ THỐNG -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<!-- DATA INTERCHANGE LAYER -->
<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>

<!-- SYSTEM CORE SCRIPTS -->
<script src="${pageContext.request.contextPath}/assets/js/board.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/shipdraw.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/pve/placement-pve.js"></script>

<!-- INITIALIZATION -->
<script>
    createBoard(10, 10, "board");
</script>

</body>
</html>