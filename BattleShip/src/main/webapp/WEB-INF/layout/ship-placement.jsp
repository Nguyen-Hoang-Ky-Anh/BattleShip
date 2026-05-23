<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="vi">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Strategic Ship Placement</title>

    <!-- CORE CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- ICON SYSTEM -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body class="main-hub-container">

<!-- =========================================================
     DEPLOYMENT WORKSPACE
========================================================= -->
<div class="deployment-workspace">

    <!-- =====================================================
         SIDEBAR CONTROL PANEL
    ====================================================== -->
    <aside class="tactical-sidebar-panel">

        <!-- HEADER -->
        <div class="deployment-header-zone">

            <h2 class="sidebar-title">
                ⚓ DEPLOYMENT SECTOR
            </h2>

            <div class="operator-badge monospace-data">

                OPERATOR:
                <span class="highlight-text">
                    ${userId}
                </span>

            </div>

        </div>

        <div class="terminal-separator"></div>

        <!-- =====================================================
             FLEET LIST
        ====================================================== -->
        <section class="fleet-management-zone">

            <h3 class="panel-section-title monospace-data">

                // AVAILABLE_FLEET

            </h3>

            <div class="ship-fleet-list">

                <!-- CARRIER -->
                <div class="ship-item-card"
                     data-size="5">

                    <div class="ship-visual-wrapper">

                        <img
                                src="${pageContext.request.contextPath}/assets/images/ship_4_ngang.png"
                                alt="Carrier">

                    </div>

                    <div class="ship-meta monospace-data">

                        <span class="ship-name">
                            CARRIER
                        </span>

                        <span class="ship-size-indicator">
                            [SIZE: 5]
                        </span>

                    </div>

                </div>

                <!-- BATTLESHIP -->
                <div class="ship-item-card"
                     data-size="4">

                    <div class="ship-visual-wrapper">

                        <img
                                src="${pageContext.request.contextPath}/assets/images/ship_3_ngang.png"
                                alt="Battleship">

                    </div>

                    <div class="ship-meta monospace-data">

                        <span class="ship-name">
                            BATTLESHIP
                        </span>

                        <span class="ship-size-indicator">
                            [SIZE: 4]
                        </span>

                    </div>

                </div>

                <!-- SUBMARINE -->
                <div class="ship-item-card"
                     data-size="3">

                    <div class="ship-visual-wrapper">

                        <img
                                src="${pageContext.request.contextPath}/assets/images/ship_2_ngang.png"
                                alt="Submarine">

                    </div>

                    <div class="ship-meta monospace-data">

                        <span class="ship-name">
                            SUBMARINE
                        </span>

                        <span class="ship-size-indicator">
                            [SIZE: 3]
                        </span>

                    </div>

                </div>

                <!-- DESTROYER -->
                <div class="ship-item-card"
                     data-size="2">

                    <div class="ship-visual-wrapper">

                        <img
                                src="${pageContext.request.contextPath}/assets/images/ship_1_ngang.png"
                                alt="Destroyer">

                    </div>

                    <div class="ship-meta monospace-data">

                        <span class="ship-name">
                            DESTROYER
                        </span>

                        <span class="ship-size-indicator">
                            [SIZE: 2]
                        </span>

                    </div>

                </div>

            </div>

        </section>

        <div class="terminal-separator"></div>

        <!-- =====================================================
             ACTION PANEL
        ====================================================== -->
        <section class="tactical-control-grid">

            <button class="btn-action-tech btn-rotate"
                    onclick="rotateShip()">

                <i class="bi bi-arrow-repeat"></i>

                ROTATE

            </button>

            <button class="btn-action-tech btn-reset"
                    onclick="resetBoard()">

                <i class="bi bi-arrow-counterclockwise"></i>

                RESET

            </button>

            <button class="btn-action-tech btn-confirm"
                    onclick="confirmPlacement()">

                <i class="bi bi-shield-check"></i>

                ENGAGE

            </button>

            <button class="btn-action-tech btn-return"
                    onclick="window.history.back()">

                <i class="bi bi-arrow-return-left"></i>

            </button>

        </section>

    </aside>

    <!-- =====================================================
         MAIN BOARD SECTOR
    ====================================================== -->
    <main class="tactical-main-board-sector">

        <!-- STATUS BAR -->
        <div class="status-telemetry-bar monospace-data"
             id="placementStatus">

            <span class="status-pulse-dot"></span>

            SYSTEM_READY:
            PLACE YOUR SHIPS ON THE MATRIX

        </div>

        <!-- =================================================
             BOARD AREA
        ================================================== -->
        <section class="ocean-matrix-container">

            <div class="board-grid-frame">

                <!-- BOARD -->
                <div id="board"
                     class="board-matrix board-matrix--enemy">

                    <!-- Dynamic Board Render -->

                </div>

            </div>

        </section>

    </main>

</div>

<!-- =========================================================
     BACKGROUND EFFECTS
========================================================= -->
<div class="ocean">

    <div class="wave"></div>

    <div class="wave wave2"></div>

</div>

<!-- =========================================================
     CLIENT CONFIG
========================================================= -->
<script>

    const contextPath =
        "${pageContext.request.contextPath}";

    const roomId =
        "${roomId}";

    const userId =
        "${userId}";

</script>

<!-- =========================================================
     CORE SCRIPTS
========================================================= -->
<script src="${pageContext.request.contextPath}/assets/js/socket.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/board.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/shipdraw.js"></script>

<!-- =========================================================
     INITIALIZATION
========================================================= -->
<script>

    createBoard(
        10,
        10,
        "board"
    );

    connectSocket();

</script>

</body>
</html>