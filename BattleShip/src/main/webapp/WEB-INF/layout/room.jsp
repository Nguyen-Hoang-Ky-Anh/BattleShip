<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Battleship Room</title>

    <%-- [UC-08][UI Rendering]
         Load CSS cho giao diện phòng chờ --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/room.css">
</head>

<body>

<div class="container">

    <%-- =========================================
         [UC-08 - Lobby Screen]
         Sidebar hiển thị thông tin phòng
       ========================================= --%>
    <div class="sidebar">

        <%-- [UC-08][Display Room ID]
             Step: Show roomId sau khi join thành công --%>
        <div class="room-id-box">
            <span id="roomIdText">${roomId}</span>

            <%-- [UC-08][Optional Action - Copy Room ID] --%>
            <button onclick="copyRoomId()">📋</button>
        </div>

        <%-- [UC-08][Display Board Info] --%>
        <div class="info">Board: ${rows} x ${cols}</div>

        <%-- [UC-08][Display Current User] --%>
        <div class="info">You: <b>${userId}</b></div>

        <%-- [UC-08][Display Player List] --%>
        <h3>👥 Players</h3>
        <ul id="playerList"></ul>

        <%-- =========================================
             [UC-08 - Room Actions]
           ========================================= --%>
        <div class="room-actions">

            <%-- [UC-08.1 - Toggle Ready]
                 User action → gửi WS: TOGGLE_READY --%>
            <button id="readyBtn"
                    onclick="toggleReady()">
                READY
            </button>

            <%-- [UC-08.2 - Start Game]
                 Chỉ host thấy → WS: START_GAME --%>
            <button id="startBtn"
                    onclick="startGame()"
                    style="display:none">
                START GAME
            </button>

            <%-- [UC-08.3 - Leave Room]
                 WS: LEAVE_ROOM hoặc close socket --%>
            <button id="leaveBtn"
                    onclick="leaveRoom()"
                    style="display:none">
                LEAVE ROOM
            </button>

        </div>
    </div>

    <%-- =========================================
         [UC-08][Main Lobby Display]
       ========================================= --%>
    <div class="main">

        <%-- [UI Static Title] --%>
        <div class="title">⚓ BATTLESHIP ⚓</div>

        <%-- [UC-08][System Status Display]
             VD: Waiting / Enough players / Starting... --%>
        <div id="roomStatus">⏳ Waiting for players...</div>

        <%-- [UC-08][Optional Preview Grid / Placeholder] --%>
        <div class="grid" id="grid"></div>
    </div>

</div>

<%-- =========================================
     [UC-08][Init Client State]
     Data được inject từ RoomController
   ========================================= --%>
<script>
    // [UC-08][Step 5 - Client Init]
    const roomId = "${roomId}";
    const userId = "${userId}";
    const rows = ${rows};
    const cols = ${cols};

    // [System Config]
    const contextPath = "${pageContext.request.contextPath}";
</script>

<%-- =========================================
     [UC-08 → UC-10][Frontend Modules]
   ========================================= --%>

<%-- [UI Handling Layer]
     Render player list, status, button state --%>
<script src="${pageContext.request.contextPath}/assets/js/ui.js"></script>

<%-- [CORE - WebSocket Layer]
     - connect()
     - send message
     - receive event
     - dispatch UI update
     => QUAN TRỌNG cho Sequence Diagram --%>
<script src="${pageContext.request.contextPath}/assets/js/socket.js"></script>

<%-- [Board Logic]
     Chuẩn bị cho UC-09 (placement) và UC-10 (battle) --%>
<script src="${pageContext.request.contextPath}/assets/js/board.js"></script>

<%-- [Main Entry]
     - bind events
     - init socket
     - start flow UC-08 --%>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

</body>
</html>