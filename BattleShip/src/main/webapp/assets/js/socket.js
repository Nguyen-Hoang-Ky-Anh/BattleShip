// =========================================================
// GAME STATE & CONSTANTS
// =========================================================
const GameState = {
    socket: null,
    currentTurn: null,
    canAttack: false
};

const ACTIONS = {
    JOIN_ROOM: "JOIN_ROOM",
    INIT_BATTLE_STATE: "INIT_BATTLE_STATE",
    ROOM_STATE: "ROOM_STATE",
    GAME_STARTED: "GAME_STARTED",
    PLAYER_PLACED: "PLAYER_PLACED",
    BATTLE_READY: "BATTLE_READY",
    BATTLE_STARTED: "BATTLE_STARTED",
    BATTLE_UPDATE: "BATTLE_UPDATE",
    ATTACK: "ATTACK",
    ERROR: "ERROR",
    CONFIRM_PLACEMENT: "CONFIRM_PLACEMENT",
    TOGGLE_READY: "TOGGLE_READY",
    START_GAME: "START_GAME",
};

// =========================================================
// SOCKET CONNECTION & ROUTER
// =========================================================
function connectSocket() {
    console.trace("connectSocket called");

    if (GameState.socket?.readyState === WebSocket.OPEN) {
        console.warn("Socket already connected, skip!");
        return;
    }

    const protocol = window.location.protocol === "https:" ? "wss:" : "ws:";
    const socketUrl = `${protocol}//${window.location.host}${contextPath}/game`;

    GameState.socket = new WebSocket(socketUrl);

    GameState.socket.onopen = () => {
        console.log("Connected to game server");
        // [UC-08 - Join Room][Step 0 - Establish Connection]
        // [UC-08][Step 1 - Connect thành công]
        // ================================================
        // [UC-08][Step 2 - Send JOIN_ROOM]
        // ================================================
        GameState.socket.send(`${ACTIONS.JOIN_ROOM}|${userId}|${roomId}`);

        // ================================================
        // [UC-08.4 - Reconnect / UC-09 Sync]
        // ================================================
        if (window.location.pathname.includes("/battle")) {
            console.log("Delaying INIT_BATTLE_STATE request...");
            setTimeout(() => {
                GameState.socket.send(`${ACTIONS.INIT_BATTLE_STATE}|${roomId}|${userId}`);
            }, 500);
        }
    };

    GameState.socket.onmessage = (event) => {
        console.log("RAW:", event.data);
        const parts = event.data.split("|");
        routeMessage(parts[0], parts);
    };

    GameState.socket.onclose = () => console.log("Disconnected from server");
    GameState.socket.onerror = (err) => console.error("Socket error:", err);
}

// =========================================================
// MESSAGE DISPATCHER
// =========================================================
function routeMessage(action, parts) {
    switch (action) {
        case ACTIONS.ROOM_STATE:
            // [UC-08][Update Room State]
            return handleRoomState(parts);
        case ACTIONS.GAME_STARTED:
            // [UC-08.2][Game Started]
            return handleGameStarted();
        case ACTIONS.PLAYER_PLACED:
            // [UC-09][Placement Confirm]
            return handlePlayerPlaced(parts);
        case ACTIONS.BATTLE_READY:
            // [UC-09][All ready → Battle]
            return handleBattleReady();
        case ACTIONS.BATTLE_STARTED:
            // [UC-10][Init Turn]
            return handleBattleStarted(parts);
        case ACTIONS.BATTLE_UPDATE:
            // [UC-10][Init Turn/Attack Result/End Game]
            return handleBattleUpdate(parts);
        case ACTIONS.INIT_BATTLE_STATE:
            // [UC-09][Sync Board - Reconnect]
            return handleInitBattleState(parts);
        case ACTIONS.ERROR:
            // [Exception Flow]
            return handleError(parts);
        default:
            console.warn("Unknown action:", action);
    }
}

// =========================================================
// EVENT HANDLERS
// =========================================================

function handleRoomState(parts) {
    parseRoomState(parts[1]);
    if (document.getElementById("playerList")) renderPlayers();
}

function handleGameStarted() {
    safeSetText("roomStatus", "🔥 Game Started");
    setTimeout(() => {
        window.location.href = `${contextPath}/ship-placement?roomId=${roomId}&userId=${userId}`;
    }, 1000);
}

function handlePlayerPlaced(parts) {
    safeSetText("placementStatus", `${parts[1]} confirmed placement`);
}

function handleBattleReady() {
    safeSetText("placementStatus", "🔥 Battle starting...");
    setTimeout(() => {
        window.location.href = `${contextPath}/battle?roomId=${roomId}&userId=${userId}`;
    }, 1000);
}

function handleBattleStarted(parts) {
    GameState.currentTurn = parts[1];
    console.log("CURRENT TURN:", GameState.currentTurn);
    updateTurnUI();
}

function handleBattleUpdate(parts) {
    const [_, attacker, rowStr, colStr, result, nextTurn, isGameOverStr] = parts;
    const row = parseInt(rowStr);
    const col = parseInt(colStr);
    const isGameOver = isGameOverStr === "true";

    // 1. Cập nhật bảng
    const boardId = attacker === userId ? "enemyBoard" : "myBoard";
    const cell = document.querySelector(`#${boardId} .cell[data-row="${row}"][data-col="${col}"]`);

    if (cell && !cell.classList.contains("hit") && !cell.classList.contains("miss")) {
        cell.classList.add(result === "HIT" || result === "SUNK" ? "hit" : "miss");
        cell.textContent = result === "SUNK" ? "💀" : (result === "HIT" ? "💥" : "•");
    }

    addLog(`${attacker} attacked [${row},${col}] => ${result}`);

    // 2. Cập nhật trạng thái lượt
    GameState.currentTurn = nextTurn;
    updateTurnUI();

    // 3. Xử lý kết thúc game
    if (isGameOver) {
        GameState.canAttack = false;
        setTimeout(() => {
            alert(attacker === userId ? "🎉 You win!" : "💀 You lose!");
            window.location.href = `${contextPath}/pvp`;
        }, 500);
    }
}

function handleInitBattleState(parts) {
    console.log("INIT_BATTLE_STATE parts:", parts);
    const boardJson = parts[3];
    const shotsJson = parts[4];

    if (boardJson) {
        clearBoard("myBoard");
        renderPlacedShips(JSON.parse(boardJson));
    }

    if (shotsJson) {
        clearBoard("enemyBoard");
        replayShots(JSON.parse(shotsJson));
    }
}

function handleError(parts) {
    GameState.canAttack = true; // Rollback trạng thái lock nếu có lỗi
    alert(parts[1]);
}

// =========================================================
// ACTIONS & LOGIC
// =========================================================

function onEnemyCellClick(row, col) {
    if (!GameState.canAttack) return;

    // Khóa tức thì (Optimistic Lock)
    GameState.canAttack = false;
    safeSetText("battleStatus", "⏳ Processing...");

    GameState.socket.send(`${ACTIONS.ATTACK}|${roomId}|${userId}|${row}|${col}`);
}

function updateTurnUI() {
    const el = document.getElementById("battleStatus");
    if (!el) return;

    GameState.canAttack = (GameState.currentTurn === userId);
    el.textContent = GameState.canAttack ? "🔥 Your turn" : "⏳ Opponent turn";
}

// =========================================================
// UI HELPERS & PARSERS
// =========================================================

function renderPlacedShips(ships) {
    ships.forEach(ship => {
        ship.cells.forEach(cell => {
            const el = document.querySelector(`#myBoard .cell[data-row="${cell.r}"][data-col="${cell.c}"]`);
            if (el) {
                el.classList.add("ship");
                el.textContent = "🚢";
            }
        });
    });
}

function replayShots(shots) {
    shots.forEach(({ attacker, row, col, result }) => {
        const boardId = attacker === userId ? "enemyBoard" : "myBoard";
        const cell = document.querySelector(`#${boardId} .cell[data-row="${row}"][data-col="${col}"]`);

        if (!cell) return;

        if (result === "HIT" || result === "SUNK") {
            cell.classList.add("hit");
            cell.textContent = result === "SUNK" ? "💀" : "💥";
        } else {
            cell.classList.add("miss");
            cell.textContent = "•";
        }
    });
}

function clearBoard(boardId) {
    document.querySelectorAll(`#${boardId} .cell`).forEach(cell => {
        cell.classList.remove("ship", "hit", "miss");
        cell.textContent = "";
    });
}

function parseRoomState(data) {
    players = [];
    if (!data) return;

    data.split(";").forEach(p => {
        if (!p) return;
        const info = p.split(",");
        players.push({
            username: info[0],
            role: info[1],
            ready: info[2] === "true"
        });
    });
}

function addLog(message) {
    const log = document.getElementById("log");
    if (!log) return;

    const div = document.createElement("div");
    div.textContent = message;
    log.prepend(div);
}

function safeSetText(id, text) {
    const el = document.getElementById(id);
    if (el) el.textContent = text;
}