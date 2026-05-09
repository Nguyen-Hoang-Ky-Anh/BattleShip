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
    <% if(session.getAttribute("user") == null){ %>

    <!-- CHƯA LOGIN -->
    <form action="${pageContext.request.contextPath}/login" method="get">
        <input type="hidden" name="mode" value="login">
        <button type="submit">Login</button>
    </form>

    <form action="${pageContext.request.contextPath}/login" method="get">
        <input type="hidden" name="mode" value="register">
        <button type="submit">Register</button>
    </form>

    <% } else { %>

    <!-- ĐÃ LOGIN -->
    <% models.User user =
            (models.User) session.getAttribute("user"); %>

    <button>
        <%= user.getUsername() %>
    </button>

    <form action="${pageContext.request.contextPath}/logout" method="post">
        <button type="submit">Logout</button>
    </form>

    <% } %>

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
        <form action="${pageContext.request.contextPath}/pre-game" method="get">
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