<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String gameId = request.getParameter("gameId");

    if(gameId == null) gameId = "";
%>

<!DOCTYPE html>
<html>

<head>

    <title>Battle PvE</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/battle.css">

</head>

<body>

<div class="page">

    <!-- ================= TOP BAR ================= -->

    <div class="top-bar">

        <h1>⚔ Battle vs AI</h1>

        <div>
            Game:
            <span><%= gameId %></span>
        </div>

        <div>
            Enemy:
            <span>🤖 AI BOT</span>
        </div>

    </div>

    <!-- ================= STATUS ================= -->

    <div id="battleStatus"
         class="battle-status">

        🎯 Your turn

    </div>

    <!-- ================= BOARDS ================= -->

    <div class="battle-layout">

        <!-- MAIN ENEMY BOARD -->

        <div class="enemy-section">

            <h2>🎯 Enemy Waters</h2>

            <div id="enemyBoard"
                 class="board enemy-board"></div>

        </div>

        <!-- MINI PLAYER BOARD -->

        <div class="my-board-mini">

            <h3>🚢 Your Fleet</h3>

            <div id="myBoard"
                 class="mini-board"></div>

        </div>

    </div>

    <!-- ================= LOG ================= -->

    <div id="log" class="log"></div>

</div>

<script>

    const contextPath =
        "${pageContext.request.contextPath}";

    window.GAME_ID = "<%= request.getParameter("gameId") %>";

</script>

<script src="${pageContext.request.contextPath}/assets/js/board.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/pve/battle-pve.js"></script>

</body>

</html>
