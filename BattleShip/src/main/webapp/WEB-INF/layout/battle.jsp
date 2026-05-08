<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String roomId = request.getParameter("roomId");
    String userId = request.getParameter("userId");

    if(roomId == null) roomId = "";
    if(userId == null) userId = "";
%>

<!DOCTYPE html>
<html>
<head>

    <title>Battle</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/battle.css">

</head>

<body>

<div class="page">

    <!-- ================= TOP BAR ================= -->

    <div class="top-bar">

        <h1>⚔ Battle</h1>

        <div>
            Room:
            <span><%= roomId %></span>
        </div>

        <div>
            User:
            <span><%= userId %></span>
        </div>

    </div>

    <!-- ================= STATUS ================= -->

    <div id="battleStatus" class="battle-status">
        Waiting battle...
    </div>

    <!-- ================= BOARDS ================= -->

    <div class="boards-container">

        <!-- MY BOARD -->

        <div class="board-wrapper">

            <h2>Your Board</h2>

            <div id="myBoard" class="board"></div>

        </div>

        <!-- ENEMY BOARD -->

        <div class="board-wrapper">

            <h2>Enemy Board</h2>

            <div id="enemyBoard" class="board"></div>

        </div>

    </div>

    <!-- ================= LOG ================= -->

    <div id="log" class="log"></div>

</div>

<script>
    const roomId = "<%= roomId %>";
    const userId = "<%= userId %>";
    const contextPath = "${pageContext.request.contextPath}";
</script>

<script src="${pageContext.request.contextPath}/assets/js/board.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/ui.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/socket.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/battle.js"></script>

<script>
    createBattleBoards();
    renderMyShips();
    connectSocket();
    initAttackBoard();
</script>

</body>
</html>