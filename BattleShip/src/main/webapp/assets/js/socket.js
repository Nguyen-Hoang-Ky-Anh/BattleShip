let socket;

let currentTurn = null;

let canAttack = false;

// =========================================================
// CONNECT SOCKET
// =========================================================

function connectSocket() {

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

        console.log("Connected");

        // ================================================
        // JOIN ROOM
        // ================================================

        socket.send(
            "JOIN_ROOM|" +
            userId + "|" +
            roomId
        );

        // ================================================
        // INIT BATTLE STATE
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

            // =============================================
            // ROOM STATE
            // =============================================

            case "ROOM_STATE":

                handleRoomState(parts);

                break;

            // =============================================
            // GAME STARTED
            // =============================================

            case "GAME_STARTED":

                handleGameStarted();

                break;

            // =============================================
            // PLAYER PLACED
            // =============================================

            case "PLAYER_PLACED":

                handlePlayerPlaced(parts);

                break;

            // =============================================
            // BATTLE READY
            // =============================================

            case "BATTLE_READY":

                handleBattleReady();

                break;

            // =============================================
            // BATTLE STARTED
            // =============================================

            case "BATTLE_STARTED":

                handleBattleStarted(parts);

                break;

            // =============================================
            // TURN CHANGED
            // =============================================

            case "TURN_CHANGED":

                handleTurnChanged(parts);

                break;

            // =============================================
            // SHOT RESULT
            // =============================================

            case "SHOT_RESULT":

                handleShotResult(parts);

                break;

            // =============================================
            // GAME OVER
            // =============================================

            case "GAME_OVER":

                handleGameOver(parts);

                break;

            // =============================================
            // INIT BATTLE STATE
            // =============================================

            case "INIT_BATTLE_STATE":

                handleInitBattleState(parts);

                break;

            // =============================================
            // ERROR
            // =============================================

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

    safeSetText(
        "roomStatus",
        "🔥 Game Started"
    );

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

    safeSetText(
        "placementStatus",
        "🔥 Battle starting..."
    );

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

    currentTurn = parts[1];

    updateTurnUI();
}

// =========================================================
// SHOT RESULT
// =========================================================

function handleShotResult(parts) {

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

    const winner = parts[1];

    if (winner === userId) {

        alert("🎉 You win!");

    } else {

        alert("💀 You lose!");
    }

    window.location.href =
        contextPath + "/pvp";
}

// =========================================================
// ERROR
// =========================================================

function handleError(parts) {

    canAttack = true;

    alert(parts[1]);
}

// =========================================================
// UPDATE TURN UI
// =========================================================

function updateTurnUI() {

    const el =
        document.getElementById(
            "battleStatus"
        );

    if (!el) return;

    canAttack =
        currentTurn === userId;

    if (canAttack) {

        el.textContent =
            "🔥 Your turn";

    } else {

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