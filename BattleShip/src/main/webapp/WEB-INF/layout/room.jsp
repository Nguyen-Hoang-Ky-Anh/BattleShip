<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Battleship Room</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/room.css">
</head>

<body>

<div class="container">

    <div class="sidebar">
        <div class="room-id-box">
            <span id="roomIdText">${roomId}</span>
            <button onclick="copyRoomId()">📋</button>
        </div>

        <div class="info">Board: ${rows} x ${cols}</div>
        <div class="info">You: <b>${userId}</b></div>

        <h3>👥 Players</h3>
        <ul id="playerList"></ul>

        <div class="room-actions">

            <button id="readyBtn"
                    onclick="toggleReady()">

                READY
            </button>

            <button id="startBtn"
                    onclick="startGame()"
                    style="display:none">

                START GAME
            </button>

            <button id="leaveBtn"
                    onclick="leaveRoom()"
                    style="display:none">

                LEAVE ROOM
            </button>

        </div>
    </div>

    <div class="main">
        <div class="title">⚓ BATTLESHIP ⚓</div>
        <div id="roomStatus">⏳ Waiting for players...</div>
        <div class="grid" id="grid"></div>
    </div>

</div>

<script>
    const roomId = "${roomId}";
    const userId = "${userId}";
    const rows = ${rows};
    const cols = ${cols};
    const contextPath = "${pageContext.request.contextPath}";
</script>

<script src="${pageContext.request.contextPath}/assets/js/ui.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/socket.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/board.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

</body>
</html>