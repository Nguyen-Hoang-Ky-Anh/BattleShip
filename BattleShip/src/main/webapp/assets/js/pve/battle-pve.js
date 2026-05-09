// =========================
// PVE BATTLE
// =========================

const gameId = window.GAME_ID;

console.log("[INIT] GAME_ID =", gameId);

if (!gameId) {
    console.error("❌ GAME_ID is missing from JSP");
}

let playerTurn = true;
let gameFinished = false;
let currentTurn = "PLAYER";

// =========================
// INIT
// =========================

window.addEventListener("DOMContentLoaded", () => {

    log("DOM loaded");

    if (typeof createBoardForBattle !== "function") {
        console.error("❌ createBoardForBattle not found. board.js missing?");
        return;
    }

    createBattleBoards();
    renderPlayerBoard();
    initEnemyBoard();

    setStatus("🎯 Your turn");
});

// =========================
// BOARD INIT
// =========================

function createBattleBoards() {

    log("Creating battle boards...");

    const my = document.getElementById("myBoard");
    const enemy = document.getElementById("enemyBoard");

    if (!my || !enemy) {
        console.error("❌ Board containers missing");
        return;
    }

    createBoardForBattle("myBoard");
    createBoardForBattle("enemyBoard");

    log("Boards created");
}

// =========================
// PLAYER BOARD RENDER
// =========================

function renderPlayerBoard() {

    log("Rendering player board");

    const data = localStorage.getItem("playerBoard");

    if (!data) {
        log("No playerBoard found in localStorage");
        return;
    }

    const ships = JSON.parse(data);

    ships.forEach(ship => {
        ship.cells.forEach(cell => {

            const el = document.querySelector(
                `#myBoard .cell[data-row="${cell.r}"][data-col="${cell.c}"]`
            );

            if (el) {
                el.classList.add("ship");
            } else {
                log(`Missing cell r=${cell.r}, c=${cell.c}`);
            }
        });
    });

    log("Player board rendered");
}

// =========================
// ENEMY BOARD
// =========================

function initEnemyBoard() {

    log("Init enemy board clicks");

    const cells = document.querySelectorAll("#enemyBoard .cell");

    if (!cells.length) {
        console.error("❌ Enemy board has no cells");
        return;
    }

    log(`Enemy cells found: ${cells.length}`);

    cells.forEach(cell => {

        cell.addEventListener("click", async () => {

            log("Enemy cell clicked");

            if (gameFinished) {
                log("Game already finished");
                return;
            }

            if (!playerTurn) {
                log("Not player turn");
                return;
            }

            if (cell.classList.contains("hit") || cell.classList.contains("miss")) {
                log("Cell already attacked");
                return;
            }

            const row = Number(cell.dataset.row);
            const col = Number(cell.dataset.col);

            log(`Attack -> (${row}, ${col})`);

            await attack(row, col);
        });
    });
}

// =========================
// ATTACK
// =========================

async function attack(row, col) {

    if (currentTurn !== "PLAYER") {
        log("Not player turn");
        return;
    }

    try {

        setStatus("🚀 Attacking...");
        log("Player attack:", row, col);

        const response = await fetch(contextPath + "/battle-pve", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify({
                action: "attack",
                gameId,
                row,
                col
            })
        });

        const data = await response.json();

        handleAttackResult(row, col, data.playerResult);

        // =========================
        // 🔥 TURN RULE FIX HERE
        // =========================

        if (data.gameOver) {
            finishGame(data.winner);
            return;
        }

        if (data.playerResult === "HIT" || data.playerResult === "SUNK") {

            log("🎯 HIT → Player plays again");
            setStatus("🎯 Hit! Play again");

            currentTurn = "PLAYER"; // keep turn
            return;
        }

        // MISS → AI turn
        log("💨 MISS → AI turn");

        currentTurn = "AI";
        setStatus("🤖 AI thinking...");

        await aiTurn(data.aiMove);

    } catch (e) {
        console.error(e);
        setStatus("❌ Error");
    }
}

async function aiTurn(initialMove) {

    let move = initialMove;

    while (currentTurn === "AI" && !gameFinished) {

        if (move) {
            handleAIShot(move);
        }

        if (!move) break;

        if (move.result === "HIT" || move.result === "SUNK") {

            log("🤖 AI HIT → AI plays again");

            move = await requestAIMove(); // backend call
            continue;
        }

        // MISS → back to player
        log("🤖 AI MISS → Player turn");

        currentTurn = "PLAYER";
        setStatus("🎯 Your turn");

        break;
    }
}

async function requestAIMove() {

    const res = await fetch(contextPath + "/battle-pve", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({
            action: "ai-move",
            gameId
        })
    });

    const data = await res.json();

    return data.aiMove;
}

// =========================
// UI UPDATE
// =========================

function handleAttackResult(row, col, result) {

    const cell = document.querySelector(
        `#enemyBoard .cell[data-row="${row}"][data-col="${col}"]`
    );

    if (!cell) {
        log("Enemy cell not found");
        return;
    }

    if (result === "HIT" || result === "SUNK") {
        cell.classList.add("hit");
        addLog(`🎯 HIT at (${row}, ${col})`);
    } else {
        cell.classList.add("miss");
        addLog(`💨 MISS at (${row}, ${col})`);
    }
}

function setTurnUI() {
    document.body.dataset.turn = currentTurn;
}

// =========================
// AI MOVE
// =========================

function handleAIShot(aiMove) {

    if (!aiMove) {
        log("No AI move");
        return;
    }

    const cell = document.querySelector(
        `#myBoard .cell[data-row="${aiMove.row}"][data-col="${aiMove.col}"]`
    );

    if (!cell) {
        log("AI target cell not found");
        return;
    }

    if (aiMove.result === "HIT" || aiMove.result === "SUNK") {
        cell.classList.add("hit");
        addLog(`🤖 AI HIT (${aiMove.row}, ${aiMove.col})`);
    } else {
        cell.classList.add("miss");
        addLog(`🤖 AI MISS (${aiMove.row}, ${aiMove.col})`);
    }
}

// =========================
// GAME OVER
// =========================

function finishGame(winner) {

    gameFinished = true;

    if (winner === "PLAYER") {
        setStatus("🏆 You Win!");
        addLog("GAME OVER: PLAYER WIN");
        window.location.href = contextPath + "/home";
    } else {
        setStatus("💀 AI Wins!");
        addLog("GAME OVER: AI WIN");
        window.location.href = contextPath + "/home";
    }
}

// =========================
// STATUS
// =========================

function setStatus(message) {

    const el = document.getElementById("battleStatus");

    if (el) el.textContent = message;

    log("STATUS: " + message);
}

// =========================
// LOG SYSTEM (IMPORTANT)
// =========================

function addLog(msg) {

    const logBox = document.getElementById("log");

    console.log("[LOG]", msg);

    if (!logBox) return;

    const div = document.createElement("div");
    div.textContent = msg;

    logBox.appendChild(div);
    logBox.scrollTop = logBox.scrollHeight;
}

function log(msg, obj) {
    if (obj !== undefined) {
        console.log("[DEBUG]", msg, obj);
    } else {
        console.log("[DEBUG]", msg);
    }
}