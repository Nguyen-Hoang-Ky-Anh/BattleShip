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

    setStatus("🎯 Lượt của bạn");
});

// =========================
// BOARD INIT & RENDER
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
            if (el) el.classList.add("ship");
        });
    });

    log("Player board rendered");
}

function initEnemyBoard() {
    const cells = document.querySelectorAll("#enemyBoard .cell");
    if (!cells.length) return;

    cells.forEach(cell => {
        cell.addEventListener("click", async () => {
            if (gameFinished || currentTurn !== "PLAYER") return;

            if (cell.classList.contains("hit") || cell.classList.contains("miss") || cell.classList.contains("sunk")) {
                log("Cell already attacked");
                return;
            }

            const row = Number(cell.dataset.row);
            const col = Number(cell.dataset.col);
            await attack(row, col);
        });
    });
}

// =========================
// ATTACK LOGIC
// =========================

async function attack(row, col) {
    if (currentTurn !== "PLAYER") return;

    try {
        setStatus("🚀 Đang bắn...");
        const response = await fetch(contextPath + "/battle-pve", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify({ action: "attack", gameId, row, col })
        });

        const data = await response.json();
        console.log("[SERVER RESPONSE]", data);

        // 1. Xử lý cú bắn của người chơi (Truyền thêm tên tàu bị chìm)
        handleAttackResult(row, col, data.playerResult, data.sunkShipName);

        const isGameFinished = data.gameOver === true || data.isGameOver === true;

        // 2. Kiểm tra xem Người Chơi có thắng ngay lập tức không
        if (isGameFinished && data.winner === "PLAYER") {
            finishGame("PLAYER");
            return;
        }

        // 3. Nếu bắn TRÚNG hoặc CHÌM -> Tiếp tục lượt
        if (data.playerResult === "HIT" || data.playerResult === "SUNK") {
            setStatus("🎯 Bắn chuẩn lắm! Được bắn tiếp.");
            currentTurn = "PLAYER";
            return;
        }

        // 4. Nếu bắn TRƯỢT -> Lượt của AI
        log("💨 MISS → AI turn");
        currentTurn = "AI";
        setStatus("🤖 Địch đang nã pháo...");

        // Xử lý một loạt các combo hành động của AI (Do backend gộp trả về 1 lần)
        if (data.aiMoves && data.aiMoves.length > 0) {
            await processAIMoves(data.aiMoves);
        }

        // 5. Sau khi AI bắn xong combo, kiểm tra xem AI có thắng không
        if (isGameFinished && data.winner === "AI") {
            finishGame("AI");
            return;
        }

        // 6. Nếu game chưa kết thúc, trả lại lượt cho người chơi
        if (!gameFinished) {
            currentTurn = "PLAYER";
            setStatus("🎯 Lượt của bạn");
        }

    } catch (e) {
        console.error(e);
        setStatus("❌ Lỗi kết nối server");
    }
}

// Xử lý mảng hành động của AI với độ trễ (delay)
async function processAIMoves(moves) {
    for (let move of moves) {
        if (gameFinished) break;

        // Nghỉ 1 giây giữa các phát đạn để Player kịp nhìn
        await new Promise(resolve => setTimeout(resolve, 1000));

        handleAIShot(move);
    }
}

// =========================
// UI UPDATE
// =========================

function handleAttackResult(row, col, result, sunkShipName) {
    const cell = document.querySelector(`#enemyBoard .cell[data-row="${row}"][data-col="${col}"]`);
    if (!cell) return;

    if (result === "SUNK") {
        cell.classList.add("hit", "sunk");
        addLog(`💥 BẮN CHÌM! Bạn đã tiêu diệt tàu [${sunkShipName}] của địch!`);
    } else if (result === "HIT") {
        cell.classList.add("hit");
        addLog(`🎯 TRÚNG ĐÍCH tại (${row}, ${col})`);
    } else {
        cell.classList.add("miss");
        addLog(`💨 TRƯỢT tại (${row}, ${col})`);
    }
}

function handleAIShot(aiMove) {
    if (!aiMove) return;
    const cell = document.querySelector(`#myBoard .cell[data-row="${aiMove.row}"][data-col="${aiMove.col}"]`);
    if (!cell) return;

    if (aiMove.result === "SUNK") {
        cell.classList.add("hit", "sunk");
        addLog(`💀 CẢNH BÁO: Tàu [${aiMove.sunkShipName}] của bạn đã bị địch bắn chìm!`);
    } else if (aiMove.result === "HIT") {
        cell.classList.add("hit");
        addLog(`🤖 Địch TRÚNG ĐÍCH tại (${aiMove.row}, ${aiMove.col})`);
    } else {
        cell.classList.add("miss");
        addLog(`🤖 Địch TRƯỢT tại (${aiMove.row}, ${aiMove.col})`);
    }
}

// =========================
// GAME OVER & UTILS
// =========================

function finishGame(winner) {
    gameFinished = true;

    if (winner === "PLAYER") {
        setStatus("🏆 CHIẾN THẮNG! Trò chơi kết thúc.");
        addLog("GAME OVER: YOU WIN");
    } else {
        setStatus("💀 THẤT BẠI! AI đã chiến thắng.");
        addLog("GAME OVER: AI WIN");
    }

    // Đợi 3.5 giây để người chơi đọc thông báo rồi mới về trang chủ
    setTimeout(() => {
        window.location.href = contextPath + "/home";
    }, 3500);
}

function setStatus(message) {
    const el = document.getElementById("battleStatus");
    if (el) el.textContent = message;
}

function addLog(msg) {
    const logBox = document.getElementById("log");
    if (!logBox) return;

    const div = document.createElement("div");
    div.textContent = msg;

    // Highlight các log quan trọng
    if (msg.includes("BẮN CHÌM") || msg.includes("CHIẾN THẮNG")) div.style.color = "lime";
    if (msg.includes("CẢNH BÁO") || msg.includes("THẤT BẠI")) div.style.color = "red";

    logBox.appendChild(div);
    logBox.scrollTop = logBox.scrollHeight; // Tự động cuộn xuống dưới cùng
}

function log(msg, obj) {
    if (obj !== undefined) {
        console.log("[DEBUG]", msg, obj);
    } else {
        console.log("[DEBUG]", msg);
    }
}