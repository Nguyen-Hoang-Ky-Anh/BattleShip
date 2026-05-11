// =========================================================
// GAME STATE & CONSTANTS
// =========================================================
const GameState = {
    socket: null,
    currentTurn: null,
    canAttack: false,
    isSyncing: false,

    prevMyBoard: null,
    prevEnemyBoard: null
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
    SYNC: "SYNC",
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

    GameState.socket.onclose = () =>{
        console.log("Disconnected from server");
        startSyncPolling();
    }
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
        case ACTIONS.SYNC:
            return handleSync(parts);
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

    const isMe = attacker === userId;
    const pos = `${String.fromCharCode(65 + row)}${col + 1}`; // A1, B5...

// attack log
    addLog(
        `${isMe ? "🟢 You" : "🔴 Enemy"} attacked <b>${pos}</b>`,
        "turn"
    );

// result log
    if (result === "HIT") {
        addLog(`💥 ${isMe ? "You hit a ship!" : "Your ship was hit!"}`, "hit");
    } else if (result === "MISS") {
        addLog(`💨 Missed shot`, "miss");
    } else if (result === "SUNK") {
        addLog(`🔥 ${isMe ? "You sunk a ship!" : "Your ship was sunk!"}`, "sunk");
    }

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
    GameState.canAttack = true;
    alert(parts[1]);
    document.querySelectorAll(".pending").forEach(c => {
        c.classList.remove("pending");
    });
}

// =========================================================
// ACTIONS & LOGIC
// =========================================================

function onEnemyCellClick(row, col) {
    if (!GameState.canAttack) return;

    const cell = document.querySelector(`#enemyBoard .cell[data-row="${row}"][data-col="${col}"]`);

    if (!cell || cell.classList.contains("hit") || cell.classList.contains("miss")) {
        return;
    }

    GameState.canAttack = false;
    cell.classList.add("pending");

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
        cell.classList.remove("ship", "hit", "miss", "pending");
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

function addLog(message, type = "info") {
    const log = document.getElementById("log");
    if (!log) return;

    const entry = document.createElement("div");
    entry.classList.add("log-entry");

    // type: hit | miss | sunk | turn | info
    entry.classList.add(`log-${type}`);

    const time = new Date().toLocaleTimeString();

    entry.innerHTML = `<span class="log-time">[${time}]</span> ${message}`;

    log.appendChild(entry);

    // auto scroll xuống dưới
    log.scrollTop = log.scrollHeight;

    // giới hạn 50 dòng
    if (log.children.length > 50) {
        log.removeChild(log.firstChild);
    }
}

function safeSetText(id, text) {
    const el = document.getElementById(id);
    if (el) el.textContent = text;
}

function handleSync(parts) {
    if (parts.length < 4) return;

    const turn = parts[1];

    let myBoard = JSON.parse(parts[2]);
    let enemyBoard = JSON.parse(parts[3]);

    detectBoardChanges("myBoard", GameState.prevMyBoard, myBoard, false);
    detectBoardChanges("enemyBoard", GameState.prevEnemyBoard, enemyBoard, true);

    GameState.prevMyBoard = myBoard;
    GameState.prevEnemyBoard = enemyBoard;

    GameState.currentTurn = turn;
    updateTurnUI();

    applyBoard("myBoard", myBoard);
    applyBoard("enemyBoard", enemyBoard);
}

function applyBoard(boardId, data) {
    data.forEach((row, r) => {
        row.forEach((cell, c) => {
            const el = document.querySelector(
                `#${boardId} .cell[data-row="${r}"][data-col="${c}"]`
            );

            if (!el) return;

            el.classList.remove("hit", "miss");
            el.textContent = "";

            if (cell === "HIT") {
                el.classList.add("hit");
                el.textContent = "💥";
            } else if (cell === "MISS") {
                el.classList.add("miss");
                el.textContent = "•";
            }
        });
    });
}

// =========================================================
// AJAX SYNC (Fallback + Reconnect)
// =========================================================

async function syncBattleState() {
    if (GameState.isSyncing) return;

    GameState.isSyncing = true;

    try {
        const res = await fetch(`${contextPath}/battle-sync?roomId=${roomId}&userId=${userId}`);

        if (!res.ok) throw new Error("Sync failed");

        const data = await res.json();

        applyBattleState(data);

    } catch (err) {
        console.error("Sync error:", err);
    } finally {
        GameState.isSyncing = false;
    }
}

function applyBattleState(data) {

    // ===== TURN =====
    if (data.turn) {
        GameState.currentTurn = data.turn;
        updateTurnUI();
    }

    // ===== BOARD (RENDER FULL) =====
    if (data.myBoard) {
        applyBoard("myBoard", data.myBoard);

        data.myBoard.forEach((row, r) => {
            row.forEach((cell, c) => {
                const el = document.querySelector(`#myBoard .cell[data-row="${r}"][data-col="${c}"]`);
                if (!el) return;

                if (cell === "SHIP") {
                    el.classList.add("ship");
                    el.textContent = "🚢";
                } else if (cell === "HIT") {
                    el.classList.add("hit");
                    el.textContent = "💥";
                } else if (cell === "MISS") {
                    el.classList.add("miss");
                    el.textContent = "•";
                }
            });
        });
    }

    if (data.enemyBoard) {
        applyBoard("enemyBoard", data.enemyBoard);

        data.enemyBoard.forEach((row, r) => {
            row.forEach((cell, c) => {
                const el = document.querySelector(`#enemyBoard .cell[data-row="${r}"][data-col="${c}"]`);
                if (!el) return;

                if (cell === "HIT") {
                    el.classList.add("hit");
                    el.textContent = "💥";
                } else if (cell === "MISS") {
                    el.classList.add("miss");
                    el.textContent = "•";
                }
            });
        });
    }

    // ===== LOG =====
    if (data.log && data.log.length > 0) {
        data.log.forEach(m => addLog(m));
    }

    // ===== GAME OVER =====
    if (data.gameOver) {
        GameState.canAttack = false;
        setTimeout(() => {
            alert(data.winner === userId ? "🎉 You win!" : "💀 You lose!");
            window.location.href = `${contextPath}/pvp`;
        }, 500);
    }
}

function startSyncPolling() {
    setInterval(() => {

        // chỉ sync khi socket lỗi hoặc chưa có turn
        if (
            !GameState.socket ||
            GameState.socket.readyState !== WebSocket.OPEN
        ) {
            syncBattleState();
        }

    }, 2000);
}

function detectBoardChanges(boardId, oldBoard, newBoard, isEnemyBoard) {
    if (!oldBoard) return; // lần đầu

    newBoard.forEach((row, r) => {
        row.forEach((cell, c) => {
            const prev = oldBoard[r][c];

            if (prev === cell) return;

            const pos = `${String.fromCharCode(65 + r)}${c + 1}`;

            // 🔥 detect event
            if (cell === "HIT") {
                addLog(
                    `${isEnemyBoard ? "🟢 You hit enemy" : "🔴 Enemy hit you"} at <b>${pos}</b> 💥`,
                    "hit"
                );
            } else if (cell === "MISS") {
                addLog(
                    `${isEnemyBoard ? "🟢 You missed" : "🔴 Enemy missed"} at <b>${pos}</b> 💨`,
                    "miss"
                );
            }
        });
    });
}