<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Battleship Tactical Room</title>

    <!-- CORE CSS SYSTEM -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/main.css">
</head>

<body class="main-hub-container">

<div class="room-lobby-layout">

    <!-- =========================================================
         SIDEBAR COMMAND PANEL
    ========================================================== -->
    <aside class="room-sidebar-panel glass-panel-prime">

        <!-- ROOM IDENTIFICATION -->
        <div class="room-sidebar-header">

            <div class="room-code-panel neon-panel-cyan">

                <div class="room-code-meta">
                    <span class="room-code-label">
                        SECURE ROOM CODE
                    </span>

                    <span id="roomIdText"
                          class="room-code-value neon-text-cyan">
                        ${roomId}
                    </span>
                </div>

                <button class="copy-room-btn"
                        onclick="copyRoomId(this)"
                        title="Copy Room ID">
                    📋
                </button>

            </div>

            <div class="sidebar-divider"></div>

            <!-- ROOM TELEMETRY -->
            <div class="room-telemetry-list">

                <div class="telemetry-row">
                    <span class="telemetry-key">
                        MATRIX_SIZE
                    </span>

                    <span class="telemetry-data">
                        ${rows} x ${cols}
                    </span>
                </div>

                <div class="telemetry-row">
                    <span class="telemetry-key">
                        OPERATOR
                    </span>

                    <span class="telemetry-data highlighted-cyan">
                        ${userId}
                    </span>
                </div>

                <div class="telemetry-row">
                    <span class="telemetry-key">
                        GAME_MODE
                    </span>

                    <span class="telemetry-data">
                        PVP_STANDARD
                    </span>
                </div>

                <div class="telemetry-row">
                    <span class="telemetry-key">
                        NETWORK
                    </span>

                    <span class="telemetry-data highlighted-mint">
                        SYNCHRONIZED
                    </span>
                </div>

            </div>

        </div>

        <!-- =========================================================
             PLAYER LIST
        ========================================================== -->
        <section class="fleet-operator-section">

            <div class="section-title monospace-data">
                👥 CONNECTED OPERATORS
            </div>

            <ul id="playerList" class="operator-list">
                <!-- Dynamic render -->
            </ul>

        </section>

        <!-- =========================================================
             ROOM ACTIONS
        ========================================================== -->
        <div class="room-action-panel">

            <button id="readyBtn"
                    class="lobby-action-btn btn-ready"
                    onclick="toggleReady()">

                READY SYSTEM
            </button>

            <button id="startBtn"
                    class="lobby-action-btn btn-start"
                    onclick="startGame()"
                    style="display:none;">

                INITIATE BATTLE
            </button>

            <button id="leaveBtn"
                    class="lobby-action-btn btn-leave"
                    onclick="leaveRoom()">

                LEAVE ROOM
            </button>

        </div>

    </aside>

    <!-- =========================================================
         MAIN COMMAND CENTER
    ========================================================== -->
    <main class="room-command-workspace">

        <!-- MAIN TITLE -->
        <header class="room-command-header">

            <h1 class="battle-command-title neon-text-cyan">
                ⚓ BATTLESHIP COMMAND ⚓
            </h1>

            <div id="roomStatus"
                 class="room-sync-status monospace-data">

                ⏳ SYNCHRONIZING COMMAND LINK...
            </div>

        </header>

        <!-- =========================================================
             CENTRAL COMMAND CENTER
        ========================================================== -->
        <section class="room-command-center glass-panel-prime scan-active">

            <!-- =========================================================
                 LIVE RADAR SYSTEM
            ========================================================= -->
            <div class="command-radar-panel">

                <!-- Radar Sweep -->
                <div class="radar-sweep"></div>

                <!-- Radar Rings -->
                <div class="radar-ring radar-ring-1"></div>
                <div class="radar-ring radar-ring-2"></div>
                <div class="radar-ring radar-ring-3"></div>

                <!-- Radar Grid -->
                <div class="radar-grid-cross horizontal"></div>
                <div class="radar-grid-cross vertical"></div>

                <!-- CENTER CORE -->
                <div class="radar-core"></div>

                <!-- PLAYER DOTS -->
                <div id="radarPlayersLayer"
                     class="radar-players-layer">
                </div>

            </div>

            <!-- TELEMETRY GRID -->
            <div class="command-telemetry-grid">

                <div class="telemetry-card">
                    <span class="telemetry-card-label">
                        MATCH_MODE
                    </span>

                    <span class="telemetry-card-value">
                        PVP_STANDARD
                    </span>
                </div>

                <div class="telemetry-card">
                    <span class="telemetry-card-label">
                        BATTLEFIELD
                    </span>

                    <span class="telemetry-card-value">
                        ${rows} x ${cols}
                    </span>
                </div>

                <div class="telemetry-card">
                    <span class="telemetry-card-label">
                        PLAYERS
                    </span>

                    <span class="telemetry-card-value"
                          id="playerCounter">
                        1 / 2
                    </span>
                </div>

                <div class="telemetry-card">
                    <span class="telemetry-card-label">
                        STATUS
                    </span>

                    <span class="telemetry-card-value highlighted-mint">
                        WAITING
                    </span>
                </div>

            </div>

            <!-- ROOM STATUS -->
            <div class="room-central-status monospace-data">

                WAITING FOR ALL OPERATORS TO CONFIRM DEPLOYMENT...

            </div>

        </section>

    </main>

</div>

<!-- =========================================================
     OCEAN BACKGROUND EFFECT
========================================================= -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<!-- =========================================================
     CLIENT CONFIGURATION
========================================================= -->
<script>

    const roomId = "${roomId}";
    const userId = "${userId}";
    const rows = ${rows};
    const cols = ${cols};

    const contextPath =
        "${pageContext.request.contextPath}";

</script>

<!-- =========================================================
     CORE SCRIPTS
========================================================= -->
<script src="${pageContext.request.contextPath}/assets/js/ui.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/socket.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

</body>
</html>