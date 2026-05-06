<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>PvP Menu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pvp.css">
</head>

<body>

<div class="container">
    <h1>⚓ BATTLESHIP PvP ⚓</h1>

    <div class="menu">

        <form action="${pageContext.request.contextPath}/create-room" method="get">
            <button type="submit">🚀 Create Room</button>
        </form>

        <form action="${pageContext.request.contextPath}/join-room" method="get">
            <button type="submit">🔍 Join Room</button>
        </form>

    </div>
</div>

</body>
</html>