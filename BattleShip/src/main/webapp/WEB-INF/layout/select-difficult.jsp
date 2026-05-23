<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Core Configuration - BattleShip</title>

    <!-- CSS CORE SYSTEM -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Bootstrap Icons & Bootstrap Core -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<!-- ================= SYSTEM TOP NAVIGATION HEADER ================= -->
<!-- TOP COMMAND BAR -->
<div class="top-command-bar">

    <!-- LEFT AUTH ZONE -->
    <div class="auth-telemetry-zone">

        <form action="${pageContext.request.contextPath}/login"
              method="get"
              class="inline-form">

            <button type="submit"
                    class="btn-terminal-sm">

                LOG IN

            </button>

        </form>

        <form action="${pageContext.request.contextPath}/register"
              method="get"
              class="inline-form">

            <button type="submit"
                    class="btn-terminal-sm accent-mint-border">

                REGISTER

            </button>

        </form>

    </div>

    <!-- RIGHT CONTROL ZONE -->
    <div class="control-telemetry-zone">

        <!-- MUSIC -->
        <button class="btn-utility"
                onclick="toggleMusic()"
                id="musicToggleBtn">

            🔊

        </button>

        <!-- DROPDOWN -->
        <div class="navigation-dropdown-wrapper">

            <div class="hamburger-menu-trigger"
                 onclick="toggleMenu()">

                SYSTEM MENU ☰

            </div>

            <div id="dropdown"
                 class="dropdown-content-panel">

                <form action="${pageContext.request.contextPath}/history"
                      method="get">

                    <button type="submit"
                            class="btn-dropdown-item">

                        📜 COMBAT LOGS

                    </button>

                </form>

            </div>

        </div>

    </div>

</div>

<!-- ================= MAIN CORE DIFFICULTY SELECTION ================= -->
<div class="main-hub-container">

    <!-- CENTRAL GLASS PANEL -->
    <div class="tactical-glass-panel">

        <!-- BRAND / TITLE -->
        <h1 class="main-tactical-title">⚓ BATTLESHIP</h1>
        <div class="title-sub-text monospace-data alert-blink">CHOOSE_AI_THREAT_LEVEL</div>
        <div class="terminal-separator"></div>

        <!-- TACTICAL MENU OPTIONS -->
        <div class="tactical-menu-grid">

            <!-- Cấp độ Dễ (Easy) -->
            <a href="${pageContext.request.contextPath}/pre-game/easy"
               class="btn-command-large difficulty-easy">
                <span class="btn-icon">🟢</span>
                EASY CORE
                <span class="btn-sub-label">Low detection matrix</span>
            </a>

            <!-- Cấp độ Thường (Normal) -->
            <a href="${pageContext.request.contextPath}/pre-game/normal"
               class="btn-command-large difficulty-normal">
                <span class="btn-icon">🟡</span>
                NORMAL CORE
                <span class="btn-sub-label">Standard predictive radar</span>
            </a>

            <!-- Cấp độ Khó (Hard) -->
            <a href="${pageContext.request.contextPath}/pre-game/hard"
               class="btn-command-large difficulty-hard">
                <span class="btn-icon">🔴</span>
                HARD CORE
                <span class="btn-sub-label">Advanced tactical targeting</span>
            </a>

            <!-- Nút quay lại (Back Button) -->
            <a href="${pageContext.request.contextPath}/home"
               class="btn-command-large accent-crimson-border btn-back-control">
                <span class="btn-icon">↩</span>
                RETURN TO BASE
                <span class="btn-sub-label">Return to command sector</span>
            </a>

        </div>

    </div>

</div>

<!-- ================= INTERACTIVE FOOTER HUD CONTROLS ================= -->
<!-- SYSTEM METRICS FOOTER -->
<div class="system-footer">

    <div class="system-status-indicator monospace-data">
        SECURE CONNECTION // STATUS: ACTIVE
    </div>

    <div class="version-badge monospace-data">
        SYS_VER: v1.0.0
    </div>

</div>

<!-- DYNAMIC OCEAN BACKGROUND COMPONENT -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<!-- AUDIO AUDIO DATA INTERCHANGE LAYER -->
<audio id="bgMusic" loop>
    <source src="${pageContext.request.contextPath}/assets/audio/home.mp3" type="audio/mpeg">
</audio>

<!-- GLOBAL CONTEXT PATH EXPORT -->
<script>
    const ctx = "${pageContext.request.contextPath}";
</script>

<!-- SYSTEM APPLICATION JS NODES -->
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>