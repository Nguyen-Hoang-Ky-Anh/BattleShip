// =========================================================
// BATTLE INITIALIZATION & UI
// =========================================================

function initAttackBoard() {
    console.trace("initAttackBoard called");
    const enemyCells = document.querySelectorAll("#enemyBoard .cell");

    enemyCells.forEach(cell => {
        cell.addEventListener("click", () => {
            // 1. Nếu ô này đã bắn (có class hit/miss) thì chặn click luôn để khỏi mất công gọi hàm
            if (cell.classList.contains("hit") || cell.classList.contains("miss")) {
                return;
            }

            // 2. Lấy tọa độ
            const row = cell.dataset.row;
            const col = cell.dataset.col;

            // 3. Gọi hàm từ socket.js (Nơi chứa logic check lượt và gửi socket)
            if (typeof onEnemyCellClick === "function") {
                onEnemyCellClick(row, col);
            } else {
                console.error("onEnemyCellClick is not defined! Check socket.js");
            }
        });
    });
}

function createBattleBoards() {
    if (typeof createBoardForBattle === "function") {
        createBoardForBattle("myBoard");
        createBoardForBattle("enemyBoard");
    } else {
        console.warn("createBoardForBattle function not found!");
    }
}

function renderMyShips() {
    const data = localStorage.getItem("playerBoard");
    if (!data) return;

    try {
        const ships = JSON.parse(data);

        ships.forEach(ship => {
            ship.cells.forEach(pos => {
                const cell = document.querySelector(`#myBoard .cell[data-row="${pos.r}"][data-col="${pos.c}"]`);
                if (cell) {
                    cell.classList.add("ship");
                    cell.textContent = "🚢";
                }
            });
        });
    } catch (e) {
        console.error("Error parsing playerBoard data from localStorage:", e);
    }
}