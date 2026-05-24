<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ship Placement</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ship-placement.css">
    <%--    BootStrap lib--%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body>

<div class="container">

    <!-- ================= LEFT PANEL ================= -->
    <div class="sidebar">

        <div class="title">
            ⚓ SHIP PLACEMENT
        </div>

        <div class="room-info">
            <div>Player: <b>${userId}</b></div>
        </div>

        <div class="ship-panel">

            <h3>🚢 Ships</h3>
<%--            selected--%>
            <div class="ship-item "
                 data-size="5">
                <img id="ship-battle-4" src="${pageContext.request.contextPath}/assets/images/ship_4_ngang.png" width="150" height="50" alt="Đây là ship 4"/>
                <div> Carrier (5)</div>
            </div>

            <div class="ship-item"
                 data-size="4">
                <img src="${pageContext.request.contextPath}/assets/images/ship_3_ngang.png" width="150" height="50" alt="Đây là ship 4"/>
                <div> Battleship (4)</div>
            </div>

            <div class="ship-item"
                 data-size="3">
                <img src="${pageContext.request.contextPath}/assets/images/ship_2_ngang.png" width="150" height="50" alt="Đây là ship 4"/>
               <div> Submarine (3)</div>
            </div>

            <div class="ship-item"
                 data-size="2">
                <div class="img_ship" draggable="true">
                <img src="${pageContext.request.contextPath}/assets/images/ship_1_ngang.png" width="150" height="50" alt="Đây là ship 4"/>
                </div>
                <div>Destroyer (2)</div>
            </div>

        </div>

        <div class="controls">
<%--        --%>
            <button onclick="rotateShip()">
                🔄 Rotate
            </button>

            <button onclick="resetBoard()">
                ♻ Reset
            </button>
    <%--   UCS-05.5: Khóa bố cục   --%>
            <button onclick="confirmPlacement()">
                ✅ Confirm
            </button>
            <button  onclick="returnLobby()"><i class="bi bi-arrow-return-left " ></i></button>
        </div>

    </div>


    <!-- ================= MAIN BOARD ================= -->
    <div class="main">

        <div class="status"
             id="placementStatus">

            Place your ships

        </div>

        <div class="board"
             id="board">

        </div>

    </div>

</div>

<%--<script>--%>
<%--    const rows = ${rows};--%>
<%--    const cols = ${cols};--%>
<%--</script>--%>

<script>
    const contextPath = "${pageContext.request.contextPath}"

    const roomId =
        "${roomId}";

    const userId =
        "${userId}";

</script>

<script src="${pageContext.request.contextPath}/assets/js/socket.js"></script>
<script  src="${pageContext.request.contextPath}/assets/js/board.js"></script>
<script  src="${pageContext.request.contextPath}/assets/js/shipdraw.js"></script>

<script>
    <%--    Khởi tạo lưới game--%>
    createBoard(10, 10, "board");
    connectSocket()
</script>
</body>
</html>