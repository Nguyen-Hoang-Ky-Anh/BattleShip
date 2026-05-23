
/**
 * Tạo lưới bàn chơi
 * @param {number} rows
 * @param {number} cols
 */
function createBoard(rows, cols, idBoard) {
    const board = document.getElementById(idBoard);
    board.innerHTML = "";

    // Nên dùng '1fr' để ô tự chia đều không gian theo cấu trúc CSS Grid của hệ thống layout
    board.style.gridTemplateColumns = `repeat(${cols}, 1fr)`;
    board.style.gridTemplateRows = `repeat(${rows}, 1fr)`;

    for (let r = 0; r < rows; r++) {
        for (let c = 0; c < cols; c++) {
            const cell = document.createElement("div");
            cell.classList.add("cell");
            cell.dataset.row = r;
            cell.dataset.col = c;

            cell.addEventListener("click", () => {
                console.log(`Row: ${r}, Col: ${c}`);
            });

            board.appendChild(cell);
        }
    }
}

function createGrid(rows, cols) {

    const grid =
        document.getElementById("grid");

    grid.innerHTML = "";

    grid.style.gridTemplateColumns =
        `repeat(${cols}, 40px)`;

    for (let i = 0; i < rows * cols; i++) {

        const cell =
            document.createElement("div");

        cell.className = "cell";

        grid.appendChild(cell);
    }
}

function createBoardForBattle(boardId) {

    const board =
        document.getElementById(boardId);

    board.innerHTML = "";

    for(let r = 0; r < 10; r++) {

        for(let c = 0; c < 10; c++) {

            const cell =
                document.createElement("div");

            cell.className = "cell";

            cell.dataset.row = r;
            cell.dataset.col = c;

            board.appendChild(cell);
        }
    }
}
