<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Choose Difficult</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/select-difficult.css">

<%--    BootStrap icon--%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<%--    BootStrap lib--%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" >
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
            <a href="${pageContext.request.contextPath}/pre-game/easy">🟢 Easy</a>
            <a href="${pageContext.request.contextPath}/pre-game/normal">🟡 Normal</a>
            <a href="${pageContext.request.contextPath}/pre-game/hard">🔴 Hard</a>
            <a href="${pageContext.request.contextPath}/pre-game/back"> <i class="bi bi-arrow-return-left fs-4"></i> </a>
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
<%--BootStrap --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" ></script>
</body>
</html>