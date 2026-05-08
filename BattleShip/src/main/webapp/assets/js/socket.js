let socket;
let currentTurn = null;

function connectSocket() {

    socket = new WebSocket(
        "ws://" + window.location.host + contextPath + "/game"
    );

    socket.onopen = () => {

        console.log("Connected");

        socket.send(
            "JOIN_ROOM|" +
            userId + "|" +
            roomId
        );
    };

    socket.onmessage = (event) => {

        console.log("RAW:", event.data);

        const parts = event.data.split("|");

        console.log("PARSED:", parts);

        switch (parts[0]) {

            // =====================================================
            // ROOM STATE
            // =====================================================

            case "ROOM_STATE":

                parseRoomState(parts[1]);

                renderPlayers();

                break;

            // =====================================================
            // GAME STARTED
            // =====================================================

            case "GAME_STARTED":

                document.getElementById("roomStatus")
                    .innerText = "🔥 Game Started";

                setTimeout(() => {

                    window.location.href =
                        contextPath +
                        "/ship-placement" +
                        "?roomId=" + roomId +
                        "&userId=" + userId;

                }, 1000);

                break;

            // =====================================================
            // PLAYER PLACED
            // =====================================================

            case "PLAYER_PLACED":

                document.getElementById(
                    "placementStatus"
                ).textContent =
                    parts[1] + " confirmed placement";

                break;

            // =====================================================
            // BATTLE STARTED
            // =====================================================

            case "BATTLE_STARTED":

                currentTurn = parts[1];

                document.getElementById("battleStatus")
                    .innerText =
                    "Battle Started - Turn: " + currentTurn;

                break;


            case "BATTLE_READY":

                document.getElementById(
                    "placementStatus"
                ).textContent =
                    "🔥 Battle starting...";

                setTimeout(() => {

                    window.location.href =
                        contextPath +
                        "/battle" +
                        "?roomId=" + roomId +
                        "&userId=" + userId;

                }, 1000);

                break;

            // =====================================================
            // TURN CHANGED
            // =====================================================

            case "TURN_CHANGED":

                currentTurn = parts[1];

                updateTurnUI();

                break;

            // =====================================================
            // SHOT RESULT
            // =====================================================

            case "SHOT_RESULT":

                handleShotResult(parts);

                break;

            // =====================================================
            // GAME OVER
            // =====================================================

            case "GAME_OVER":

                alert("Winner: " + parts[1]);

                break;

            // =====================================================
            // ERROR
            // =====================================================

            case "ERROR":

                alert(parts[1]);

                break;
        }
    };

    socket.onclose = () => {
        console.log("Disconnected");
    };
}

// =========================================================
// PARSE ROOM STATE
// =========================================================

function parseRoomState(data) {

    players = [];

    if (!data) return;

    /*
        FORMAT:

        ROOM_STATE|
        user1,HOST,true;
        user2,PLAYER,false
    */

    const arr = data.split(";");

    arr.forEach(p => {

        if (!p) return;

        const info = p.split(",");

        players.push({
            username: info[0],
            role: info[1],
            ready: info[2] === "true"
        });
    });
}