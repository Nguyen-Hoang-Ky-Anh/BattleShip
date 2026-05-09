<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>PvP Menu</title>

    <%-- [System Entry UI - PvP Mode]
         Màn hình chọn Use Case chính của hệ thống PvP --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pvp.css">
</head>

<body>

<div class="container">

    <%-- [UI Title] --%>
    <h1>⚓ BATTLESHIP PvP ⚓</h1>

    <div class="menu">

        <%-- =========================================
             [UC-07 - Create PvP Room]
             Step 1: User chọn "Create PvP Room"
             → Điều hướng tới màn hình cấu hình (UC-07.1)
           ========================================= --%>
        <form action="${pageContext.request.contextPath}/create-room" method="get">
            <button type="submit">🚀 Create Room</button>
        </form>

        <%-- =========================================
             [UC-08 - Room / Lobby - Entry (Join Flow)]
             Step A2: User chọn "Join Room"
             → Điều hướng tới màn hình nhập Room ID
           ========================================= --%>
        <form action="${pageContext.request.contextPath}/join-room" method="get">
            <button type="submit">🔍 Join Room</button>
        </form>

    </div>
</div>

</body>
</html>