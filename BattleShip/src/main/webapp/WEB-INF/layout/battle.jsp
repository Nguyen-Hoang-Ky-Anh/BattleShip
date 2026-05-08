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

    <div class="top-bar">

        <h1>Battle</h1>

        <div>
            Room:
            <span id="roomId"><%= roomId %></span>
        </div>

        <div>
            User:
            <span id="username"><%= userId %></span>
        </div>

        <button id="confirmBtn">
            Confirm Placement
        </button>

    </div>

    <div class="boards-container">

        <div class="board-wrapper">

            <h2>Your Board</h2>

            <div id="myBoard" class="board"></div>

        </div>

        <div class="board-wrapper">

            <h2>Enemy Board</h2>

            <div id="enemyBoard" class="board"></div>

        </div>

    </div>

    <div id="log" class="log"></div>

</div>

</body>
</html>