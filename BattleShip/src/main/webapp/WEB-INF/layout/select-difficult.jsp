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
<header class="tactical-top-header">
    <div class="auth-action-group">
        <form action="${pageContext.request.contextPath}/login" method="get">
            <button type="submit" class="auth-btn btn-login-tech">⚡ LOGIN</button>
        </form>

        <form action="${pageContext.request.contextPath}/register" method="get">
            <button type="submit" class="auth-btn btn-register-tech">🔑 REGISTER</button>
        </form>
    </div>

    <!-- HAMBURGER CONTROL AND DROPDOWN FOR TELEMETRY HISTORY -->
    <div class="hud-dropdown-wrapper">
        <div class="hamburger-menu-btn" onclick="toggleMenu()" aria-label="Toggle Tactical Menu">☰</div>
        <div id="dropdown" class="dropdown-tech-panel">
            <form action="${pageContext.request.contextPath}/history" method="get">
                <button type="submit" class="dropdown-item-btn monospace-data">📜 COMBAT LOGS</button>
            </form>
        </div>
    </div>
</header>

<!-- ================= MAIN CORE DIFFICULTY SELECTION ================= -->
<main class="difficulty-selection-container">

    <!-- CENTRAL CORE TITLE -->
    <div class="system-brand-panel">
        <h1 class="main-cyber-title">⚓ BATTLESHIP</h1>
        <p class="system-status-indicator monospace-data alert-blink">// CHOOSE_AI_THREAT_LEVEL</p>
    </div>

    <!-- TACTICAL MENU OPTIONS -->
    <nav class="tactical-vertical-menu">
        <!-- Cấp độ Dễ (Easy) -->
        <a href="${pageContext.request.contextPath}/pre-game/easy" class="menu-item-link difficulty-easy monospace-data">
            <span class="status-dot dot-green"></span>
            <span class="link-text">EASY_CORE</span>
            <span class="sub-text">// Low detection matrix</span>
        </a>

        <!-- Cấp độ Thường (Normal) -->
        <a href="${pageContext.request.contextPath}/pre-game/normal" class="menu-item-link difficulty-normal monospace-data">
            <span class="status-dot dot-yellow"></span>
            <span class="link-text">NORMAL_CORE</span>
            <span class="sub-text">// Standard predictive radar</span>
        </a>

        <!-- Cấp độ Khó (Hard) -->
        <a href="${pageContext.request.contextPath}/pre-game/hard" class="menu-item-link difficulty-hard monospace-data">
            <span class="status-dot dot-red"></span>
            <span class="link-text">HARD_CORE</span>
            <span class="sub-text">// Advanced tactical targeting</span>
        </a>

        <!-- Nút quay lại (Back Button) -->
        <a href="${pageContext.request.contextPath}/pre-game/back" class="menu-item-link btn-back-control" title="Quay lại phân khu chính">
            <i class="bi bi-arrow-return-left fs-4"></i>
            <span class="monospace-data text-uppercase ms-2" style="font-size: 12px; letter-spacing: 1px;">Return to base</span>
        </a>
    </nav>
</main>

<!-- ================= INTERACTIVE FOOTER HUD CONTROLS ================= -->
<footer class="hud-footer-controls">
    <!-- MUSIC INTERACTION -->
    <div class="music-controller-node">
        <button onclick="toggleMusic()" class="music-toggle-btn" aria-label="Toggle Audio Streams">🔊</button>
    </div>

    <!-- TELEMETRY SYSTEM VERSION -->
    <div class="system-version-tag monospace-data">
        SYS_VER: v1.0.0
    </div>
</footer>

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