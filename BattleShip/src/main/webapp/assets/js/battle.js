// =========================================================
// BATTLE INITIALIZATION & UI
// =========================================================
let attackBoardInitialized = false;

function initAttackBoard() {

    if (attackBoardInitialized) return;

    attackBoardInitialized = true;

    const enemyBoard = document.getElementById("enemyBoard");

    if (!enemyBoard) return;

    enemyBoard.addEventListener("click", (e) => {

        const cell = e.target.closest(".cell");

        if (!cell) return;

        if (
            cell.classList.contains("hit") ||
            cell.classList.contains("miss")
        ) {
            return;
        }

        onEnemyCellClick?.(
            cell.dataset.row,
            cell.dataset.col
        );

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