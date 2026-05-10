<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html>

<head>

    <title>Ship Placement PvE</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/ship-placement.css">

    <!-- Bootstrap Icons -->

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body>

<div class="container">

    <!-- ================= SIDEBAR ================= -->

    <div class="sidebar">

        <div class="title">

            ⚓ SHIP PLACEMENT

        </div>

        <div class="room-info">

            <div>
                Mode:
                <b>🤖 PvE Battle</b>
            </div>

            <div>
                Enemy:
                <b>AI BOT</b>
            </div>

        </div>

        <!-- ================= SHIPS ================= -->

        <div class="ship-panel">

            <h3>🚢 Ships</h3>

            <!-- Carrier -->

            <div class="ship-item"
                 data-size="5">

                <img
                        src="${pageContext.request.contextPath}/assets/images/ship_4_ngang.png"
                        width="150"
                        height="50"
                        alt="Carrier"/>

                <div>Carrier (5)</div>

            </div>

            <!-- Battleship -->

            <div class="ship-item"
                 data-size="4">

                <img
                        src="${pageContext.request.contextPath}/assets/images/ship_3_ngang.png"
                        width="150"
                        height="50"
                        alt="Battleship"/>

                <div>Battleship (4)</div>

            </div>

            <!-- Submarine -->

            <div class="ship-item"
                 data-size="3">

                <img
                        src="${pageContext.request.contextPath}/assets/images/ship_2_ngang.png"
                        width="150"
                        height="50"
                        alt="Submarine"/>

                <div>Submarine (3)</div>

            </div>

            <!-- Destroyer -->

            <div class="ship-item"
                 data-size="2">

                <img
                        src="${pageContext.request.contextPath}/assets/images/ship_1_ngang.png"
                        width="150"
                        height="50"
                        alt="Destroyer"/>

                <div>Destroyer (2)</div>

            </div>

        </div>

        <!-- ================= CONTROLS ================= -->

        <div class="controls">

            <button onclick="rotateShip()">
                🔄 Rotate
            </button>

            <button onclick="resetBoard()">
                ♻ Reset
            </button>

            <button onclick="confirmPlacement()">
                🚀 Start Battle
            </button>

            <button onclick="window.history.back()">

                <i class="bi bi-arrow-return-left"
                   style="font-size:24px"></i>

            </button>

        </div>

    </div>

    <!-- ================= MAIN BOARD ================= -->

    <div class="main">

        <div id="placementStatus"
             class="status">

            Place your ships

        </div>

        <div id="board"
             class="board"></div>

    </div>

</div>

<script>

    const contextPath =
        "${pageContext.request.contextPath}";

</script>

<script src="${pageContext.request.contextPath}/assets/js/board.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/shipdraw.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/pve/placement-pve.js"></script>

<script>

    createBoard(
        10,
        10,
        "board"
    );

</script>

</body>

</html>
