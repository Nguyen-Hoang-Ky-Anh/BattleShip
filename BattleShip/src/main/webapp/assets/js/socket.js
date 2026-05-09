let socket;

let currentTurn = null;

let canAttack = false;

// =========================================================
// CONNECT SOCKET
// =========================================================

function connectSocket() {

    // [UC-08 - Join Room][Step 0 - Establish Connection]
    socket = new WebSocket(
        "ws://" +
        window.location.host +
        contextPath +
        "/game"
    );

    // =====================================================
    // OPEN
    // =====================================================

    socket.onopen = () => {
        // [UC-08][Step 1 - Connect thành công]
        console.log("Connected");

        // ================================================
        // [UC-08][Step 2 - Send JOIN_ROOM]
        // ================================================
        socket.send(
            "JOIN_ROOM|" +
            userId + "|" +
            roomId
        );

        // ================================================
        // [UC-08.4 - Reconnect / UC-09 Sync]
        // ================================================

        if (
            window.location.pathname.includes("/battle")
        ) {

            console.log(
                "INIT_BATTLE_STATE"
            );

            socket.send(
                "INIT_BATTLE_STATE|" +
                roomId + "|" +
                userId
            );
        }
    };

    // =====================================================
    // MESSAGE
    // =====================================================

    // [SYSTEM - Receive Event from Server]
    socket.onmessage = (event) => {

        console.log(
            "RAW:",
            event.data
        );

        const parts =
            event.data.split("|", 5);

        console.log(
            "PARSED:",
            parts
        );

        const action = parts[0];

        switch (action) {

            // [UC-08][Update Room State]

            case "ROOM_STATE":

                handleRoomState(parts);

                break;

            // [UC-08.2][Game Started]

            case "GAME_STARTED":

                handleGameStarted();

                break;

            // [UC-09][Placement Confirm]

            case "PLAYER_PLACED":

                handlePlayerPlaced(parts);

                break;

            // [UC-09][All ready → Battle]

            case "BATTLE_READY":

                handleBattleReady();

                break;

            // [UC-10][Init Turn]

            case "BATTLE_STARTED":

                handleBattleStarted(parts);

                break;

            // [UC-10][Turn Switch]
            case "TURN_CHANGED":

                handleTurnChanged(parts);

                break;

            // [UC-10][Attack Result]

            case "SHOT_RESULT":

                handleShotResult(parts);

                break;

            // [UC-10][End Game]
            case "GAME_OVER":

                handleGameOver(parts);

                break;

            // [UC-09][Sync Board - Reconnect]

            case "INIT_BATTLE_STATE":

                handleInitBattleState(parts);

                break;

            // [Exception Flow]
            case "ERROR":

                handleError(parts);

                break;

            // =============================================
            // UNKNOWN
            // =============================================

            default:

                console.warn(
                    "Unknown action:",
                    action
                );
        }
    };

    // =====================================================
    // CLOSE
    // =====================================================

    socket.onclose = () => {

        console.log("Disconnected");
    };

    // =====================================================
    // ERROR
    // =====================================================

    socket.onerror = (err) => {

        console.error(
            "Socket error:",
            err
        );
    };
}

// =========================================================
// ROOM STATE
// =========================================================

function handleRoomState(parts) {
    // [UC-08][Step - Sync UI player list]
    parseRoomState(parts[1]);

    if (
        document.getElementById("playerList")
    ) {

        renderPlayers();
    }
}

// =========================================================
// GAME STARTED
// =========================================================

function handleGameStarted() {
    // [UC-08.2][Step - Notify UI]
    safeSetText(
        "roomStatus",
        "🔥 Game Started"
    );
    // [UC-09][Transition - Navigate to Placement]
    setTimeout(() => {

        window.location.href =
            contextPath +
            "/ship-placement" +
            "?roomId=" +
            roomId +
            "&userId=" +
            userId;

    }, 1000);
}

// =========================================================
// PLAYER PLACED
// =========================================================

function handlePlayerPlaced(parts) {
    // [UC-09][Step - Notify placement]
    safeSetText(
        "placementStatus",
        parts[1] +
        " confirmed placement"
    );
}

// =========================================================
// BATTLE READY
// =========================================================

function handleBattleReady() {
    // [UC-09][All players placed ships]
    safeSetText(
        "placementStatus",
        "🔥 Battle starting..."
    );
    // [UC-10][Transition - Enter battle screen]
    setTimeout(() => {

        window.location.href =
            contextPath +
            "/battle" +
            "?roomId=" +
            roomId +
            "&userId=" +
            userId;

    }, 1000);
}

// =========================================================
// BATTLE STARTED
// =========================================================

function handleBattleStarted(parts) {
    // [UC-10][Step 1 - Set current turn]
    currentTurn = parts[1];

    console.log(
        "CURRENT TURN:",
        currentTurn
    );

    updateTurnUI();
}

// =========================================================
// TURN CHANGED
// =========================================================

function handleTurnChanged(parts) {
    // [UC-10][Loop - Turn Switching]
    currentTurn = parts[1];

    updateTurnUI();
}

// =========================================================
// SHOT RESULT
// =========================================================

function handleShotResult(parts) {
    // [UC-10][Step 2 - Receive attack result]
    const attacker = parts[1];

    const row =
        parseInt(parts[2]);

    const col =
        parseInt(parts[3]);

    const result =
        parts[4];

    let boardId;

    if (attacker === userId) {

        boardId = "enemyBoard";

    } else {

        boardId = "myBoard";
    }

    const cell =
        document.querySelector(
            `#${boardId} .cell[data-row="${row}"][data-col="${col}"]`
        );

    if (!cell) return;

    // =========================================
    // [UC-10][alt - HIT / MISS / SUNK]
    // =========================================

    if (
        result === "HIT" ||
        result === "SUNK"
    ) {

        if (
            cell.classList.contains("hit")
            || cell.classList.contains("miss")
        ) {
            return;
        }

        cell.classList.add("hit");

        cell.textContent =
            result === "SUNK"
                ? "💀"
                : "💥";

    } else {

        cell.classList.add("miss");

        cell.textContent = "•";
    }

    // [UC-10][Step 3 - Log action]
    addLog(
        attacker +
        " attacked [" +
        row +
        "," +
        col +
        "] => " +
        result
    );
}

// =========================================================
// GAME OVER
// =========================================================

function handleGameOver(parts) {

    // [UC-10][End Condition]
    const winner = parts[1];

    if (winner === userId) {

        alert("🎉 You win!");

    } else {

        alert("💀 You lose!");
    }

    // [UC-10][Exit Flow]
    window.location.href =
        contextPath + "/pvp";
}

// =========================================================
// ERROR
// =========================================================

function handleError(parts) {

    // [Exception Flow]
    canAttack = true;

    alert(parts[1]);
}

// =========================================================
// UPDATE TURN UI
// =========================================================

function updateTurnUI() {

    // [UC-10][Business Rule - Turn Control]
    const el =
        document.getElementById(
            "battleStatus"
        );

    if (!el) return;

    canAttack =
        currentTurn === userId;

    if (canAttack) {
        // [Player Turn]
        el.textContent =
            "🔥 Your turn";

    } else {
        // [Opponent Turn]
        el.textContent =
            "⏳ Opponent turn";
    }
}

// =========================================================
// PARSE ROOM STATE
// =========================================================

function parseRoomState(data) {

    players = [];

    if (!data) return;

    const arr =
        data.split(";");

    arr.forEach(p => {

        if (!p) return;

        const info =
            p.split(",");

        players.push({

            username: info[0],

            role: info[1],

            ready:
                info[2] === "true"
        });
    });
}

// =========================================================
// ADD LOG
// =========================================================

function addLog(message) {

    const log =
        document.getElementById("log");

    if (!log) return;

    const div =
        document.createElement("div");

    div.textContent = message;

    log.prepend(div);
}

// =========================================================
// SAFE TEXT
// =========================================================

function safeSetText(id, text) {

    const el =
        document.getElementById(id);

    if (el) {

        el.textContent = text;
    }
}

function handleInitBattleState(parts) {

    // [UC-09][Reconnect - Restore board]
    const boardJson = parts[3];

    if(!boardJson) {
        return;
    }

    const ships =
        JSON.parse(boardJson);

    renderPlacedShips(ships);
}

function renderPlacedShips(ships) {

    clearBoard("myBoard");

    ships.forEach(ship => {

        ship.cells.forEach(cell => {

            const el =
                document.querySelector(
                    `#myBoard .cell[data-row="${cell.r}"][data-col="${cell.c}"]`
                );

            if(el) {

                el.classList.add("ship");

                el.textContent = "🚢";
            }
        });
    });
}

function clearBoard(boardId) {

    document
        .querySelectorAll(
            `#${boardId} .cell`
        )
        .forEach(cell => {

            cell.classList.remove(
                "ship",
                "hit",
                "miss"
            );

            cell.textContent = "";
        });
}