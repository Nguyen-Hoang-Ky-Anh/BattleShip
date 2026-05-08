
/**
 * Tạo lưới bàn chơi
 * @param {number} rows
 * @param {number} cols
 */
function createBoard(rows, cols,idBroad) {

    // reset board
    const board = document.getElementById(idBroad);
    board.innerHTML = "";

    // tạo grid css động
    board.style.gridTemplateColumns = `repeat(${cols}, 45px)`;
    board.style.gridTemplateRows = `repeat(${rows}, 45px)`;

    // tạo từng ô
    for (let r = 0; r < rows; r++) {

        for (let c = 0; c < cols; c++) {

            const cell = document.createElement("div");

            cell.classList.add("cell");

            // lưu vị trí
            cell.dataset.row = r;
            cell.dataset.col = c;

            // hiển thị tọa độ (debug)
            // cell.innerText = `${r},${c}`;

            // click event
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
