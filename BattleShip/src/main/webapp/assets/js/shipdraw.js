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
            vertical: "ship_4_doc.png"
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
            vertical: "ship_3_doc.png"
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
            vertical: "ship_2_doc.png"
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
            vertical: "ship_1_doc.png"
        }
    }
];

// ========== STATE SYSTEM ==========
let isLocked = false;
let isHorizontal = true;
let placedShips = [];          // Chứa các đối tượng tàu đã nằm trên bảng
let occupiedCells = new Set();  // Quản lý chuỗi tọa độ định dạng "r,c"
let ghost = null;
let draggingFromPanel = false;
let draggingShip = null;        // Thực thể tàu đang trong trạng thái di chuyển

// Hằng số kích thước ô cơ sở (Khớp với gridTemplate của board.js)
const CELL_SIZE = 45;

// ========== SYSTEM HELPERS ==========
function getContextPath() {
    // Sửa lỗi tìm sai file: Quét cả shipdraw.js hoặc fallback về biến contextPath toàn cục từ JSP
    if (typeof contextPath !== "undefined" && contextPath !== "") return contextPath;
    return document.querySelector("script[src*='shipdraw.js']")
        ?.src.split("/assets")[0] || "";
}

function getImageUrl(ship) {
    const dir = ship.direction === "horizontal" ? "horizontal" : "vertical";
    const base = getContextPath();
    return base + `/assets/images/${ship.images[dir]}`;
}

function getCell(r, c) {
    return document.querySelector(`.cell[data-row="${r}"][data-col="${c}"]`);
}

function getCells(r, c, size, horizontal) {
    const cells = [];
    for (let i = 0; i < size; i++) {
        cells.push(horizontal ? {r, c: c + i} : {r: r + i, c});
    }
    return cells;
}

function isValidPlacement(cells) {
    return cells.every(({r, c}) =>
        r >= 0 && r < 10 && c >= 0 && c < 10 && !occupiedCells.has(`${r},${c}`)
    );
}

// ========== INITIALIZE INTERACTIVE FLEET PANEL ==========
// Đổi từ bộ chọn cũ '.ship-item' thành '.ship-item-card' để khớp DOM Cyberpunk
function initFleetPanel() {
    document.querySelectorAll(".ship-item-card").forEach(item => {
        // Gỡ bỏ sự kiện cũ nếu có để tránh lặp trùng lặp lắng nghe
        item.removeAttribute("draggable");

        item.addEventListener("mousedown", (e) => {
            if (isLocked) return;
            // Chỉ bắt chuột trái (button == 0)
            if (e.button !== 0) return;

            e.preventDefault();
            const size = parseInt(item.dataset.size);
            const ship = SHIP_CATALOG.find(s => s.size === size && !s.placed);
            if (!ship) return;

            startDragFromPanel(e, ship, item);
        });
    });
}

// ========== STRATEGIC ROTATE ==========
function rotateShip() {
    if (isLocked) return;
    isHorizontal = !isHorizontal;

    document.getElementById("placementStatus").textContent =
        `📡 DIRECTION: ${isHorizontal ? "HORIZONTAL [→]" : "VERTICAL [↓]"}`;

    if (ghost && draggingShip) {
        // Cập nhật ngay lập tức hướng xoay của bóng ma đang kéo
        draggingShip.direction = isHorizontal ? "horizontal" : "vertical";

        ghost.style.width = isHorizontal ? `${draggingShip.size * CELL_SIZE}px` : `${CELL_SIZE}px`;
        ghost.style.height = isHorizontal ? `${CELL_SIZE}px` : `${draggingShip.size * CELL_SIZE}px`;

        const img = ghost.querySelector("img");
        if (img) img.src = getImageUrl(draggingShip);
    }
}

// ========== EMERGENCY RESET ==========
function resetBoard() {
    isLocked = false;
    placedShips = [];
    occupiedCells.clear();

    // Khôi phục mảng gốc
    SHIP_CATALOG.forEach(ship => {
        ship.placed = false;
        ship.cells = [];
        ship.direction = "horizontal";
    });

    // Xóa sạch trạng thái ô cờ
    document.querySelectorAll(".cell").forEach(cell => {
        cell.classList.remove("occupied", "preview-valid", "preview-invalid");
        cell.innerHTML = "";
        cell.style.position = "";
        cell.style.overflow = "";
    });

    // Hiển thị lại toàn bộ các thẻ chọn tàu trong panel (.ship-item-card)
    document.querySelectorAll(".ship-item-card").forEach(item => {
        item.style.visibility = "visible";
        item.style.opacity = "1";
    });

    isHorizontal = true;
    document.getElementById("placementStatus").textContent = "📡 SYSTEM_READY: PLACE YOUR SHIPS ON THE MATRIX";
}

// ========== NETWORK CONFIRMATION ==========
function confirmPlacement() {
    const allPlaced = SHIP_CATALOG.every(s => s.placed);

    if (!allPlaced) {
        document.getElementById("placementStatus").textContent = "⚠️ DEPLOYMENT_INCOMPLETE: PLACE ALL SHIPS FIRST!";
        return;
    }

    isLocked = true;
    const shipData = getPlacementData();

    // Kiểm tra tính sẵn sàng của biến GameState từ file socket.js
    if (typeof GameState !== "undefined" && GameState.socket && GameState.socket.readyState === WebSocket.OPEN) {
        const payload = `${ACTIONS.CONFIRM_PLACEMENT}|${roomId}|${userId}|${JSON.stringify(shipData)}`;
        GameState.socket.send(payload);
        localStorage.setItem("playerBoard", JSON.stringify(shipData));
        document.getElementById("placementStatus").textContent = "⏳ TRANSMITTING TELEMETRY... WAITING FOR OPPONENT.";
    } else {
        // Chế độ dự phòng tự động (Fallback cho chế độ PvE không sử dụng WebSocket mạng)
        console.warn("Socket offline or PvE routing environment detected.");
        localStorage.setItem("playerBoard", JSON.stringify(shipData));
        document.getElementById("placementStatus").textContent = "🚀 FLEET DEPLOYED SUCCESSFULLY. READY TO ENGAGE!";

        // Nếu có hàm callback xác nhận của PvE, hệ thống sẽ kích hoạt tự động tại đây
        if (typeof window.confirmPlacementPvE === "function") {
            window.confirmPlacementPvE(shipData);
        }
    }
}

// ========== DRAG ENGINE: FROM PANEL ==========
function startDragFromPanel(e, ship, panelItem) {
    draggingFromPanel = true;
    draggingShip = {...ship};
    draggingShip.direction = isHorizontal ? "horizontal" : "vertical";

    panelItem.style.visibility = "hidden";
    createGhost(e, draggingShip);

    function onMouseMove(ev) {
        moveGhost(ev);
        highlightCells(ev);
    }

    function onMouseUp(ev) {
        document.removeEventListener("mousemove", onMouseMove);
        document.removeEventListener("mouseup", onMouseUp);

        const dropped = tryDrop(ev, draggingShip);
        if (!dropped) {
            panelItem.style.visibility = "visible";
        }

        removeGhost();
        clearPreview();
        draggingShip = null;
    }

    document.addEventListener("mousemove", onMouseMove);
    document.addEventListener("mouseup", onMouseUp);
}

// ========== DRAG ENGINE: FROM BOARD DIRECTLY ==========
function startDragFromBoard(e, ship) {
    if (isLocked) return;
    if (e.button !== 0) return; // Chỉ cho phép chuột trái

    e.preventDefault();
    e.stopPropagation(); // Ngăn chặn sự kiện nổi bọt gây kích hoạt click ô cờ bên dưới

    draggingFromPanel = false;
    draggingShip = ship;

    const oldCells = [...ship.cells];
    const oldDirection = ship.direction;

    isHorizontal = ship.direction === "horizontal";
    removePlacedShip(ship);
    createGhost(e, ship);

    function onMouseMove(ev) {
        moveGhost(ev);
        highlightCells(ev);
    }

    function onMouseUp(ev) {
        document.removeEventListener("mousemove", onMouseMove);
        document.removeEventListener("mouseup", onMouseUp);

        const dropped = tryDrop(ev, draggingShip);
        if (!dropped) {
            // Rollback trạng thái nguyên bản của hạm đội nếu thả sai vùng nước cực
            draggingShip.direction = oldDirection;
            draggingShip.cells = oldCells;
            isHorizontal = oldDirection === "horizontal";

            const original = SHIP_CATALOG.find(s => s.name === draggingShip.name);
            if (original) {
                original.direction = oldDirection;
                original.cells = oldCells;
                original.placed = true;
            }

            oldCells.forEach(({r, c}) => occupiedCells.add(`${r},${c}`));
            placedShips.push(draggingShip);
            placeShipOnBoard(draggingShip);
        }

        removeGhost();
        clearPreview();
        draggingShip = null;
    }

    document.addEventListener("mousemove", onMouseMove);
    document.addEventListener("mouseup", onMouseUp);
}

// ========== RADAR GHOST RENDERING ==========
function createGhost(e, ship) {
    removeGhost(); // Dọn dẹp rác bộ nhớ trước khi tạo mới

    ghost = document.createElement("div");
    ghost.className = "ship-ghost";
    ghost.style.position = "fixed";
    ghost.style.pointerEvents = "none";
    ghost.style.zIndex = "9999";
    ghost.style.opacity = "0.65";
    ghost.style.filter = "drop-shadow(0 0 8px var(--accent-cyan))";

    const h = ship.direction === "horizontal";
    ghost.style.width = h ? `${ship.size * CELL_SIZE}px` : `${CELL_SIZE}px`;
    ghost.style.height = h ? `${CELL_SIZE}px` : `${ship.size * CELL_SIZE}px`;

    const img = document.createElement("img");
    img.src = getImageUrl(ship);
    img.style.width = "100%";
    img.style.height = "100%";
    ghost.appendChild(img);

    document.body.appendChild(ghost);
    moveGhost(e);
}

function moveGhost(e) {
    if (!ghost) return;
    const w = parseInt(ghost.style.width);
    const h = parseInt(ghost.style.height);
    // Căn chuẩn tâm kéo thả nằm chính giữa ảnh tàu
    ghost.style.left = `${e.clientX - w / 2}px`;
    ghost.style.top = `${e.clientY - h / 2}px`;
}

function removeGhost() {
    if (ghost) {
        ghost.remove();
        ghost = null;
    }
}

// ========== TACTICAL PREVIEW MATRIX ==========
function highlightCells(e) {
    clearPreview();
    const elements = document.elementsFromPoint(e.clientX, e.clientY);
    const target = elements.find(el => el.classList.contains("cell"));
    if (!target || !draggingShip) return;

    const h = draggingShip.direction === "horizontal";
    const r = parseInt(target.dataset.row);
    const c = parseInt(target.dataset.col);
    const cells = getCells(r, c, draggingShip.size, h);

    const valid = isValidPlacement(cells);
    cells.forEach(({r, c}) => {
        if (r < 0 || r >= 10 || c < 0 || c >= 10) return;
        const cell = getCell(r, c);
        if (cell) {
            cell.classList.add(valid ? "preview-valid" : "preview-invalid");
        }
    });
}

function clearPreview() {
    document.querySelectorAll(".cell").forEach(cell => {
        cell.classList.remove("preview-valid", "preview-invalid");
    });
}

// ========== DATA MATRIX DROP EXECUTOR ==========
function tryDrop(e, ship) {
    const elements = document.elementsFromPoint(e.clientX, e.clientY);
    const target = elements.find(el => el.classList.contains("cell"));
    if (!target) return false;

    const h = ship.direction === "horizontal";
    const r = parseInt(target.dataset.row);
    const c = parseInt(target.dataset.col);
    const cells = getCells(r, c, ship.size, h);

    if (!isValidPlacement(cells)) return false;

    ship.cells = cells;
    ship.placed = true;

    // Đồng bộ ngược lại catalog quản lý tổng
    const original = SHIP_CATALOG.find(s => s.name === ship.name);
    if (original) {
        original.placed = true;
        original.cells = cells;
        original.direction = ship.direction;
    }

    placeShipOnBoard(ship);
    placedShips.push(ship);
    cells.forEach(({r, c}) => occupiedCells.add(`${r},${c}`));

    // Ẩn vĩnh viễn thẻ chọn ở panel khi đã kéo xuống nước thành công
    const panelItem = document.querySelector(`.ship-item-card[data-size="${ship.size}"]`);
    if (panelItem) {
        panelItem.style.visibility = "hidden";
    }

    return true;
}

// ========== DRAW SHIP GRAPHIC ON THE MATRIC BOARD ==========
function placeShipOnBoard(ship) {
    const {cells, direction, size} = ship;

    cells.forEach(({r, c}) => {
        const cell = getCell(r, c);
        if (cell) cell.classList.add("occupied");
    });

    const firstCell = getCell(cells[0].r, cells[0].c);
    if (!firstCell) return;

    const h = direction === "horizontal";
    const img = document.createElement("img");
    img.src = getImageUrl(ship);
    img.className = "deployed-ship-sprite";
    img.style.position = "absolute";
    img.style.width = h ? `${size * CELL_SIZE}px` : `${CELL_SIZE}px`;
    img.style.height = h ? `${CELL_SIZE}px` : `${size * CELL_SIZE}px`;
    img.style.top = "0";
    img.style.left = "0";
    img.style.zIndex = "10";
    img.style.pointerEvents = "auto"; // Cho phép nhận sự kiện mousedown để nhấc tàu lên lại
    img.style.cursor = "grab";

    firstCell.style.position = "relative";
    firstCell.style.overflow = "visible";
    firstCell.appendChild(img);

    // Bắt sự kiện nhấc tàu ngược từ dưới bảng cờ lên
    img.addEventListener("mousedown", (e) => {
        if (isLocked) return;
        const found = placedShips.find(s => s.cells[0].r === cells[0].r && s.cells[0].c === cells[0].c);
        if (found) {
            startDragFromBoard(e, found);
        }
    });
}

// ========== DISMANTLE SHIP FROM MATRIX ==========
function removePlacedShip(ship) {
    ship.cells.forEach(({r, c}) => {
        occupiedCells.delete(`${r},${c}`);
        const cell = getCell(r, c);
        if (cell) {
            cell.classList.remove("occupied");
            cell.innerHTML = "";
        }
    });

    placedShips = placedShips.filter(s => s !== ship);
    ship.placed = false;
    ship.cells = [];

    const original = SHIP_CATALOG.find(s => s.name === ship.name);
    if (original) {
        original.placed = false;
        original.cells = [];
    }
}

// ========== OUTPUT API SYSTEM ==========
function getPlacementData() {
    return placedShips.map(s => ({
        name: s.name,
        size: s.size,
        direction: s.direction,
        cells: s.cells
    }));
}

function allShipsPlaced() {
    return SHIP_CATALOG.every(s => s.placed);
}

// Tự động kích hoạt lắng nghe panel sau khi DOM cây thư mục sẵn sàng
document.addEventListener("DOMContentLoaded", () => {
    initFleetPanel();
});

if (typeof module !== "undefined") {
    module.exports = {
        getCells,
        isValidPlacement,
        allShipsPlaced,
        getPlacementData,
        resetBoard,
        occupiedCells,
        placedShips,
        SHIP_CATALOG
    };
}