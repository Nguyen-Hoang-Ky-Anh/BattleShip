function initAttackBoard() {

    const cells =
        document.querySelectorAll(
            "#enemyBoard .cell"
        );

    cells.forEach(cell => {

        cell.addEventListener(
            "click",
            () => {

                if(!canAttack) {
                    return;
                }

                if(
                    cell.classList.contains("hit")
                    || cell.classList.contains("miss")
                ) {
                    return;
                }

                const row =
                    cell.dataset.row;

                const col =
                    cell.dataset.col;

                socket.send("ATTACK|" + roomId + "|" + userId + "|" + row + "|" + col);
                canAttack = false;
            }
        );
    });
}

function createBattleBoards() {

    createBoardForBattle("myBoard");

    createBoardForBattle("enemyBoard");
}

function renderMyShips() {

    const data =
        localStorage.getItem(
            "playerBoard"
        );

    if(!data) return;

    const ships =
        JSON.parse(data);

    ships.forEach(ship => {

        ship.cells.forEach(pos => {

            const cell =
                document.querySelector(
                    `#myBoard .cell[data-row="${pos.r}"][data-col="${pos.c}"]`
                );

            if(cell) {

                cell.classList.add("ship");

                cell.textContent = "🚢";
            }
        });
    });
}