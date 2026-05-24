<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String roomId = request.getParameter("roomId");
    String userId = request.getParameter("userId");

    if(roomId == null) roomId = "";
    if(userId == null) userId = "";
%>

<!DOCTYPE html>
<html lang="vi">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Battleship Tactical Arena</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/main.css">

</head>

<body class="battle-page">

<!-- =========================================================
     GLOBAL TACTICAL LAYOUT
========================================================= -->
<div class="battle-layout-shell">

    <!-- =====================================================
         TOP TELEMETRY BAR
    ====================================================== -->
    <header class="battle-topbar">

        <div class="battle-brand">

            ⚔ BATTLE SECTOR

        </div>

        <div class="battle-topbar-info monospace-data">

            <div class="telemetry-node">

                <span class="telemetry-label">
                    NET_ROOM
                </span>

                <span class="telemetry-value highlighted-cyan">
                    <%= roomId %>
                </span>

            </div>

            <div class="telemetry-node">

                <span class="telemetry-label">
                    OPERATOR
                </span>

                <span class="telemetry-value highlighted-mint">
                    <%= userId %>
                </span>

            </div>

        </div>

    </header>

    <!-- =====================================================
         GLOBAL STATUS BAR
    ====================================================== -->
    <section class="battle-global-status">

        <div class="status-indicator-dot"></div>

        <div id="battleStatus"
             class="battle-status-text monospace-data">

            INITIALIZING SECURE BATTLE LINK...

        </div>

    </section>

    <!-- =====================================================
         MAIN BATTLEFIELD
    ====================================================== -->
    <main class="battle-main-layout">

        <!-- =================================================
             LEFT TELEMETRY LOG
        ================================================== -->
        <aside class="battle-log-panel">

            <div class="panel-header monospace-data">

                // LIVE_COMBAT_TELEMETRY

            </div>

            <div id="log"
                 class="battle-log-stream monospace-data">

            </div>

        </aside>

        <!-- =================================================
             CENTER COMBAT BOARD
        ================================================== -->
        <section class="battle-combat-sector">

            <div class="combat-sector-header">

                <span class="combat-sector-title monospace-data">

                    // TARGET_MATRIX

                </span>

            </div>

            <div class="enemy-board-shell">

                <div class="enemy-board-frame">

                    <div id="enemyBoard"
                         class="board-matrix board-matrix--enemy">

                    </div>

                </div>

            </div>

        </section>

        <!-- =================================================
             RIGHT RADAR HUD
        ================================================== -->
        <aside class="battle-radar-panel">

            <div class="panel-header monospace-data">

                // DEFENSE_RADAR

            </div>

            <!-- MINI BOARD -->
            <div class="radar-board-shell">

                <div id="myBoard"
                     class="board-matrix board-matrix--mini">

                </div>

            </div>

            <!-- EXTRA INFO -->
            <div class="radar-info-stack">

                <div class="radar-info-card">

                    <span class="info-key">
                        STATUS
                    </span>

                    <span class="info-value highlighted-mint">

                        ONLINE

                    </span>

                </div>

                <div class="radar-info-card">

                    <span class="info-key">
                        SYNC
                    </span>

                    <span class="info-value highlighted-cyan">

                        ACTIVE

                    </span>

                </div>

            </div>

        </aside>

    </main>

</div>

<!-- =========================================================
     OCEAN FX
========================================================= -->
<div class="ocean">

    <div class="wave"></div>

    <div class="wave wave2"></div>

</div>

<!-- =========================================================
     CLIENT DATA
========================================================= -->
<script>

    const roomId = "<%= roomId %>";

    const userId = "<%= userId %>";

    const contextPath =
        "${pageContext.request.contextPath}";

</script>

<!-- =========================================================
     CORE SCRIPTS
========================================================= -->
<script src="${pageContext.request.contextPath}/assets/js/board.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/ui.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/socket.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/battle.js"></script>

<script>

    createBattleBoards();

    connectSocket();

    initAttackBoard();

    startSyncPolling();

</script>

</body>

</html>