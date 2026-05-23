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
        // Tạo bàn cờ địch trước
        createBoardForBattle("enemyBoard");

        // Tạo bàn cờ của ta, sau khi tạo xong xuôi thì kích hoạt render tàu luôn
        createBoardForBattle("myBoard", () => {
            console.log("⚓ Bàn cờ phòng thủ đã sẵn sàng. Bắt đầu đặt tàu...");
            renderMyShips(); // Gọi hàm render trực tiếp tại đây!
        });
    } else {
        console.warn("createBoardForBattle function not found!");
    }
}

function renderMyShips() {
    renderPlayerBoard();
    document.querySelectorAll("#myBoard .cell.ship").forEach(el => {
        el.textContent = "🚢";
    });
}