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
    <button onclick="goLogin()">Login</button>
    <button onclick="goRegister()">Register</button>

    <!-- HAMBURGER -->
    <div class="hamburger" onclick="toggleMenu()">☰</div>

    <!-- DROPDOWN MENU -->
    <div id="dropdown" class="dropdown">
        <div onclick="goHistory()">📜 History</div>
    </div>
</div>

<!-- MAIN -->
<div class="container">
    <div class="title">⚓ BATTLESHIP</div>

    <div class="menu">
        <button onclick="goPVE()">🤖 PVE Mode</button>
        <button onclick="goPVP()">🧑‍🤝‍🧑 PVP Mode</button>
        <button onclick="goHowToPlay()">📘 How To Play</button>
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

<!-- JS -->
<script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

</body>
</html>