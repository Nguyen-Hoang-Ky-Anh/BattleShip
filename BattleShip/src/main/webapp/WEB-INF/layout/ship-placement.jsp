<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Tactical Deployment PvP</title>

    <!-- CORE CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- ICON -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>

<body class="battle-page">

<!-- =========================================================
     GLOBAL DEPLOYMENT LAYOUT (GIỐNG PvE)
========================================================= -->
<div class="battle-layout-shell deployment-layout-shell">

    <!-- =====================================================
         TOP BAR
    ====================================================== -->
    <header class="battle-topbar">

        <div class="battle-brand">
            ⚓ DEPLOYMENT SECTOR
        </div>

        <div class="battle-topbar-info monospace-data">

            <div class="telemetry-node">
                <span class="telemetry-label">MODE</span>
                <span class="telemetry-value highlighted-cyan">
                    PVP
                </span>
            </div>

            <div class="telemetry-node">
                <span class="telemetry-label">ROOM</span>
                <span class="telemetry-value highlighted-mint">
                    ${roomId}
                </span>
            </div>

        </div>

    </header>

    <!-- =====================================================
         GLOBAL STATUS
    ====================================================== -->
    <section class="battle-global-status">

        <div class="status-indicator-dot"></div>

        <div id="placementStatus"
             class="battle-status-text monospace-data">

            WAITING FOR DEPLOYMENT...

        </div>

    </section>

    <!-- =====================================================
         MAIN LAYOUT
    ====================================================== -->
    <main class="battle-main-layout">

        <!-- =================================================
             LEFT: SHIP PANEL
        ================================================== -->
        <aside class="battle-log-panel deployment-sidebar">

            <div class="deployment-ship-list">

                <!-- CARRIER -->
                <div class="ship-item-card" data-size="5">
                    <div class="ship-visual-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/ship_4_ngang.png">
                    </div>
                    <div class="ship-meta monospace-data">
                        <span class="ship-name">CARRIER</span>
                        <span class="ship-size-indicator">SIZE: 5</span>
                    </div>
                </div>

                <!-- BATTLESHIP -->
                <div class="ship-item-card" data-size="4">
                    <div class="ship-visual-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/ship_3_ngang.png">
                    </div>
                    <div class="ship-meta monospace-data">
                        <span class="ship-name">BATTLESHIP</span>
                        <span class="ship-size-indicator">SIZE: 4</span>
                    </div>
                </div>

                <!-- SUBMARINE -->
                <div class="ship-item-card" data-size="3">
                    <div class="ship-visual-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/ship_2_ngang.png">
                    </div>
                    <div class="ship-meta monospace-data">
                        <span class="ship-name">SUBMARINE</span>
                        <span class="ship-size-indicator">SIZE: 3</span>
                    </div>
                </div>

                <!-- DESTROYER -->
                <div class="ship-item-card" data-size="2">
                    <div class="ship-visual-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/images/ship_1_ngang.png">
                    </div>
                    <div class="ship-meta monospace-data">
                        <span class="ship-name">DESTROYER</span>
                        <span class="ship-size-indicator">SIZE: 2</span>
                    </div>
                </div>

            </div>

            <!-- ACTIONS -->
            <div class="deployment-control-grid">

                <button class="btn-action-tech"
                        onclick="rotateShip()">
                    <i class="bi bi-arrow-repeat"></i>
                    ROTATE
                </button>

                <button class="btn-action-tech"
                        onclick="resetBoard()">
                    <i class="bi bi-arrow-counterclockwise"></i>
                    RESET
                </button>

                <button class="btn-confirm"
                        onclick="confirmPlacement()">
                    <i class="bi bi-send-fill"></i>
                    CONFIRM PLACEMENT
                </button>

                <button class="btn-back-control"
                        onclick="window.history.back()">
                    <i class="bi bi-arrow-return-left"></i>
                </button>

            </div>

        </aside>

        <!-- =================================================
             CENTER: BOARD
        ================================================== -->
        <section class="battle-combat-sector">

            <div class="enemy-board-shell">

                <div class="enemy-board-frame deployment-board-frame">

                    <div id="board"
                         class="board-matrix board-matrix--enemy">
                    </div>

                </div>

            </div>

        </section>

        <!-- =================================================
             RIGHT: INFO PANEL
        ================================================== -->
        <aside class="battle-radar-panel">

            <div class="radar-info-stack">

                <div class="radar-info-card">
                    <span class="info-key">GRID</span>
                    <span class="info-value highlighted-cyan">
                        10 x 10
                    </span>
                </div>

                <div class="radar-info-card">
                    <span class="info-key">PLAYER</span>
                    <span class="info-value highlighted-mint">
                        ${userId}
                    </span>
                </div>

                <div class="radar-info-card">
                    <span class="info-key">STATUS</span>
                    <span class="info-value highlighted-orange">
                        DEPLOYING
                    </span>
                </div>

            </div>

            <!-- MINI RADAR -->
            <div class="deployment-mini-radar">
                <div class="mini-radar-circle"></div>
                <div class="mini-radar-circle mini-radar-circle-2"></div>
                <div class="mini-radar-line"></div>
            </div>

        </aside>

    </main>

</div>

<!-- BACKGROUND -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<!-- CONFIG -->
<script>
    const contextPath = "${pageContext.request.contextPath}";
    const roomId = "${roomId}";
    const userId = "${userId}";
</script>

<!-- SCRIPTS -->
<script src="${pageContext.request.contextPath}/assets/js/socket.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/board.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/shipdraw.js"></script>

<!-- INIT -->
<script>
    document.addEventListener("DOMContentLoaded", () => {
        createBoard(10,10,"board");
        initFleetPanel();
        connectSocket();
    });
</script>

</body>
</html>