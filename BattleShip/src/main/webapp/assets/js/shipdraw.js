// ========== SHIP DEFINITIONS ==========
const SHIP_CATALOG = [
    {
        name: "Carrier",
        size: 5,
        placed: false,
        cells: [],
        direction: "horizontal",
        images: {
            horizontal: "ship_4_ngang.png",
            vertical:   "ship_4_doc.png"
        }
    },
    {
        name: "Battleship",
        size: 4,
        placed: false,
        cells: [],
        direction: "horizontal",
        images: {
            horizontal: "ship_3_ngang.png",
            vertical:   "ship_3_doc.png"
        }
    },
    {
        name: "Submarine",
        size: 3,
        placed: false,
        cells: [],
        direction: "horizontal",
        images: {
            horizontal: "ship_2_ngang.png",
            vertical:   "ship_2_doc.png"
        }
    },
    {
        name: "Destroyer",
        size: 2,
        placed: false,
        cells: [],
        direction: "horizontal",
        images: {
            horizontal: "ship_1_ngang.png",
            vertical:   "ship_1_doc.png"
        }
    }
];

// ========== STATE ==========
let isHorizontal = true;
let placedShips  = []; // ship objects đã đặt
let occupiedCells = new Set(); // "r,c"
let ghost = null;
let draggingFromPanel = false;
let draggingShip = null; // ship object đang kéo

const CELL_SIZE = 45;

// ========== HELPERS ==========
function getContextPath() {
    return document.querySelector("script[src*='placement.js']")
        ?.src.split("/assets")[0] || "";
}

function getImageUrl(ship) {
    const dir = ship.direction === "horizontal" ? "horizontal" : "vertical";
    return `${getContextPath()}/assets/images/${ship.images[dir]}`;
}

function getCell(r, c) {
    return document.querySelector(`.cell[data-row="${r}"][data-col="${c}"]`);
}

function getCells(r, c, size, horizontal) {
    const cells = [];
    for (let i = 0; i < size; i++) {
        cells.push(horizontal ? { r, c: c + i } : { r: r + i, c });
    }
    return cells;
}

function isValidPlacement(cells) {
    return cells.every(({ r, c }) =>
        r >= 0 && r < 10 && c >= 0 && c < 10 && !occupiedCells.has(`${r},${c}`)
    );
}

// ========== INIT PANEL ==========
document.querySelectorAll(".ship-item").forEach(item => {
    item.addEventListener("mousedown", (e) => {
        e.preventDefault();
        const size = parseInt(item.dataset.size);
        const ship = SHIP_CATALOG.find(s => s.size === size && !s.placed);
        if (!ship) return;
        startDragFromPanel(e, ship, item);
    });
});

// ========== ROTATE ==========
function rotateShip() {
    isHorizontal = !isHorizontal;
    document.getElementById("placementStatus").textContent =
        `Direction: ${isHorizontal ? "Horizontal →" : "Vertical ↓"}`;

    if (ghost && draggingShip) {
        // Cập nhật direction trên ship tạm thời
        draggingShip.direction = isHorizontal ? "horizontal" : "vertical";

        ghost.style.width  = isHorizontal ? `${draggingShip.size * CELL_SIZE}px` : `${CELL_SIZE}px`;
        ghost.style.height = isHorizontal ? `${CELL_SIZE}px` : `${draggingShip.size * CELL_SIZE}px`;

        const img = ghost.querySelector("img");
        if (img) img.src = getImageUrl(draggingShip);
    }
}

// ========== RESET ==========
function resetBoard() {
    placedShips = [];
    occupiedCells.clear();

    // Reset tất cả ship trong catalog
    SHIP_CATALOG.forEach(ship => {
        ship.placed    = false;
        ship.cells     = [];
        ship.direction = "horizontal";
    });

    document.querySelectorAll(".cell").forEach(cell => {
        cell.classList.remove("occupied", "preview-valid", "preview-invalid");
        cell.innerHTML = "";
    });

    document.querySelectorAll(".ship-item").forEach(item => {
        item.style.visibility = "visible";
    });

    isHorizontal = true;
    document.getElementById("placementStatus").textContent = "Place your ships";
}

// ========== CONFIRM ==========
function confirmPlacement() {
    const allPlaced = SHIP_CATALOG.every(s => s.placed);
    if (!allPlaced) {
        document.getElementById("placementStatus").textContent = "⚠ Place all ships first!";
        return;
    }

    const shipData = placedShips.map(s => ({
        name:      s.name,
        size:      s.size,
        direction: s.direction,
        cells:     s.cells
    }));

    console.log("Confirmed:", shipData);
    document.getElementById("placementStatus").textContent = "✅ Confirmed!";
    // TODO: gửi lên server
}

// ========== DRAG FROM PANEL ==========
function startDragFromPanel(e, ship, panelItem) {
    draggingFromPanel = true;
    draggingShip = { ...ship }; // clone để không sửa catalog gốc khi đang kéo
    draggingShip.direction = isHorizontal ? "horizontal" : "vertical";

    panelItem.style.visibility = "hidden";
    createGhost(e, draggingShip);

    function onMouseMove(ev) { moveGhost(ev); highlightCells(ev); }

    function onMouseUp(ev) {
        document.removeEventListener("mousemove", onMouseMove);
        document.removeEventListener("mouseup", onMouseUp);

        const dropped = tryDrop(ev, draggingShip);
        if (!dropped) panelItem.style.visibility = "visible";

        removeGhost();
        clearPreview();
        draggingShip = null;
    }

    document.addEventListener("mousemove", onMouseMove);
    document.addEventListener("mouseup", onMouseUp);
}

// ========== DRAG FROM BOARD ==========
function startDragFromBoard(e, ship) {
    e.preventDefault();
    draggingFromPanel = false;
    draggingShip = ship;

    // Sync isHorizontal theo hướng ship đang kéo
    isHorizontal = ship.direction === "horizontal";

    removePlacedShip(ship);
    createGhost(e, ship);

    function onMouseMove(ev) { moveGhost(ev); highlightCells(ev); }

    function onMouseUp(ev) {
        document.removeEventListener("mousemove", onMouseMove);
        document.removeEventListener("mouseup", onMouseUp);

        const dropped = tryDrop(ev, draggingShip);
        if (!dropped) {
            // Trả về vị trí cũ với direction cũ
            draggingShip.direction = ship.direction;
            isHorizontal = ship.direction === "horizontal";
            placeShipOnBoard(ship);
        }

        removeGhost();
        clearPreview();
        draggingShip = null;
    }

    document.addEventListener("mousemove", onMouseMove);
    document.addEventListener("mouseup", onMouseUp);
}

// ========== GHOST ==========
function createGhost(e, ship) {
    ghost = document.createElement("div");
    ghost.className = "ship-ghost";
    ghost.dataset.size = ship.size;

    const h = ship.direction === "horizontal";
    ghost.style.width    = h ? `${ship.size * CELL_SIZE}px` : `${CELL_SIZE}px`;
    ghost.style.height   = h ? `${CELL_SIZE}px` : `${ship.size * CELL_SIZE}px`;
    ghost.style.position = "fixed";
    ghost.style.pointerEvents = "none";
    ghost.style.zIndex   = "9999";
    ghost.style.opacity  = "0.75";

    const img = document.createElement("img");
    img.src = getImageUrl(ship);
    img.style.width  = "100%";
    img.style.height = "100%";
    ghost.appendChild(img);

    document.body.appendChild(ghost);
    moveGhost(e);
}

function moveGhost(e) {
    if (!ghost) return;
    const w = parseInt(ghost.style.width);
    const h = parseInt(ghost.style.height);
    ghost.style.left = `${e.clientX - w / 2}px`;
    ghost.style.top  = `${e.clientY - h / 2}px`;
}

function removeGhost() {
    if (ghost) { ghost.remove(); ghost = null; }
}

// ========== PREVIEW HIGHLIGHT ==========
function highlightCells(e) {
    clearPreview();
    const elements = document.elementsFromPoint(e.clientX, e.clientY);
    const target = elements.find(el => el.classList.contains("cell"));
    if (!target || !draggingShip) return;

    const h = draggingShip.direction === "horizontal";
    const size = draggingShip.size;
    const r = parseInt(target.dataset.row);
    const c = parseInt(target.dataset.col);
    const cells = getCells(r, c, size, h);
    const valid = isValidPlacement(cells);

    cells.forEach(({ r, c }) => {
        const cell = getCell(r, c);
        if (cell) cell.classList.add(valid ? "preview-valid" : "preview-invalid");
    });
}

function clearPreview() {
    document.querySelectorAll(".cell").forEach(cell => {
        cell.classList.remove("preview-valid", "preview-invalid");
    });
}

// ========== DROP ==========
function tryDrop(e, ship) {
    const elements = document.elementsFromPoint(e.clientX, e.clientY);
    const target = elements.find(el => el.classList.contains("cell"));
    if (!target) return false;

    const h = ship.direction === "horizontal";
    const r = parseInt(target.dataset.row);
    const c = parseInt(target.dataset.col);
    const cells = getCells(r, c, ship.size, h);

    if (!isValidPlacement(cells)) return false;

    // Cập nhật ship object
    ship.cells  = cells;
    ship.placed = true;

    // Cập nhật catalog gốc
    const original = SHIP_CATALOG.find(s => s.name === ship.name);
    if (original) {
        original.placed    = true;
        original.cells     = cells;
        original.direction = ship.direction;
    }

    placeShipOnBoard(ship);
    placedShips.push(ship);
    cells.forEach(({ r, c }) => occupiedCells.add(`${r},${c}`));

    if (draggingFromPanel) {
        const panelItem = document.querySelector(`.ship-item[data-size="${ship.size}"]`);
        if (panelItem) panelItem.style.visibility = "hidden";
    }

    return true;
}

// ========== PLACE ON BOARD ==========
function placeShipOnBoard(ship) {
    const { cells, direction, size } = ship;

    cells.forEach(({ r, c }) => {
        const cell = getCell(r, c);
        if (cell) cell.classList.add("occupied");
    });

    const first = getCell(cells[0].r, cells[0].c);
    if (!first) return;

    const h = direction === "horizontal";
    const img = document.createElement("img");
    img.src = getImageUrl(ship);
    img.style.position    = "absolute";
    img.style.pointerEvents = "none";
    img.style.width       = h ? `${size * CELL_SIZE}px` : `${CELL_SIZE}px`;
    img.style.height      = h ? `${CELL_SIZE}px` : `${size * CELL_SIZE}px`;
    img.style.top         = "0";
    img.style.left        = "0";
    img.style.zIndex      = "10";

    first.style.position = "relative";
    first.style.overflow = "visible";
    first.appendChild(img);

    first.addEventListener("mousedown", (e) => {
        const found = placedShips.find(s => s.cells[0].r === cells[0].r && s.cells[0].c === cells[0].c);
        if (found) startDragFromBoard(e, found);
    }, { once: true });
}

// ========== REMOVE FROM BOARD ==========
function removePlacedShip(ship) {
    ship.cells.forEach(({ r, c }) => {
        occupiedCells.delete(`${r},${c}`);
        const cell = getCell(r, c);
        if (cell) {
            cell.classList.remove("occupied");
            cell.innerHTML = "";
        }
    });

    placedShips = placedShips.filter(s => s !== ship);
    ship.placed = false;
    ship.cells  = [];

    const original = SHIP_CATALOG.find(s => s.name === ship.name);
    if (original) { original.placed = false; original.cells = []; }
}