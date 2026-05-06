<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>BattleShip Game</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>

<body>

<!-- HEADER -->
<div class="header">
    <form action="${pageContext.request.contextPath}/login" method="get">
        <button type="submit">Login</button>
    </form>

    <form action="${pageContext.request.contextPath}/register" method="get">
        <button type="submit">Register</button>
    </form>

    <!-- HAMBURGER -->
    <div class="hamburger" onclick="toggleMenu()">☰</div>

    <!-- DROPDOWN MENU -->
    <div id="dropdown" class="dropdown">
        <form action="${pageContext.request.contextPath}/history" method="get">
            <button type="submit">📜 History</button>
        </form>
    </div>
</div>

<!-- MAIN -->
<div class="container">
    <div class="title">⚓ BATTLESHIP</div>

    <div class="menu">
        <form action="${pageContext.request.contextPath}/pve" method="get">
            <button type="submit">🤖 PVE Mode</button>
        </form>

        <form action="${pageContext.request.contextPath}/pvp" method="get">
            <button type="submit">🧑‍🤝‍🧑 PVP Mode</button>
        </form>

        <form action="${pageContext.request.contextPath}/how-to-play" method="get">
            <button type="submit">📘 How To Play</button>
        </form>
    </div>
</div>

<!-- MUSIC -->
<div class="music-btn">
    <button onclick="toggleMusic()">🔊</button>
</div>

<!-- VERSION -->
<div class="version">
    v1.0.0
</div>

<!-- WAVES -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<!-- AUDIO -->
<audio id="bgMusic" loop>
    <source src="${pageContext.request.contextPath}/assets/audio/home.mp3" type="audio/mpeg">
</audio>

<script>
    const ctx = "${pageContext.request.contextPath}";
</script>

<!-- JS -->
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>