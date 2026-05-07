<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ship Placement</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/ship-placement.css">
</head>

<body>

<div class="container">

    <!-- ================= LEFT PANEL ================= -->
    <div class="sidebar">

        <div class="title">
            ⚓ SHIP PLACEMENT
        </div>

        <div class="room-info">
            <div>Room: <b>${roomId}</b></div>
            <div>Player: <b>${userId}</b></div>
        </div>

        <div class="ship-panel">

            <h3>🚢 Ships</h3>

            <div class="ship-item selected"
                 data-size="5">
                Carrier (5)
            </div>

            <div class="ship-item"
                 data-size="4">
                Battleship (4)
            </div>

            <div class="ship-item"
                 data-size="3">
                Cruiser (3)
            </div>

            <div class="ship-item"
                 data-size="3">
                Submarine (3)
            </div>

            <div class="ship-item"
                 data-size="2">
                Destroyer (2)
            </div>

        </div>

        <div class="controls">

            <button onclick="rotateShip()">
                🔄 Rotate
            </button>

            <button onclick="resetBoard()">
                ♻ Reset
            </button>

            <button onclick="confirmPlacement()">
                ✅ Confirm
            </button>

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

<script>

    const rows = ${rows};
    const cols = ${cols};

</script>

<script src="${pageContext.request.contextPath}/assets/js/placement.js"></script>

</body>
</html>