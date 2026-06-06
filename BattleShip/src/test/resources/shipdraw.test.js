/**
 * @jest-environment jsdom
 */

const {
    getCells,
    isValidPlacement,
    allShipsPlaced,
    getPlacementData,
    occupiedCells,
    placedShips,
    SHIP_CATALOG
} = require("../../main/webapp/assets/js/shipdraw");

// Mock DOM
beforeEach(() => {
    document.body.innerHTML = `
        <div id="placementStatus"></div>
        ${Array.from({length: 100}, (_, i) => {
        const r = Math.floor(i / 10), c = i % 10;
        return `<div class="cell" data-row="${r}" data-col="${c}"></div>`;
    }).join("")}
        <div class="ship-item-card" data-size="5"></div>
        <div class="ship-item-card" data-size="4"></div>
        <div class="ship-item-card" data-size="3"></div>
        <div class="ship-item-card" data-size="2"></div>
    `;
    occupiedCells.clear();
    placedShips.length = 0;
    SHIP_CATALOG.forEach(s => { s.placed = false; s.cells = []; });
});

// getCells
describe("getCells", () => {
    test("horizontal size=3 từ (0,0)", () => {
        expect(getCells(0, 0, 3, true)).toEqual([
            {r:0,c:0}, {r:0,c:1}, {r:0,c:2}
        ]);
    });
    test("vertical size=3 từ (0,0)", () => {
        expect(getCells(0, 0, 3, false)).toEqual([
            {r:0,c:0}, {r:1,c:0}, {r:2,c:0}
        ]);
    });
});

// isValidPlacement
describe("isValidPlacement", () => {
    test("vị trí trống hợp lệ", () => {
        expect(isValidPlacement([{r:0,c:0},{r:0,c:1}])).toBe(true);
    });
    test("ô đã bị chiếm → false", () => {
        occupiedCells.add("0,0");
        expect(isValidPlacement([{r:0,c:0}])).toBe(false);
    });
    test("vượt biên col=10 → false", () => {
        expect(isValidPlacement([{r:0,c:10}])).toBe(false);
    });
    test("vượt biên row=10 → false", () => {
        expect(isValidPlacement([{r:10,c:0}])).toBe(false);
    });
});

// allShipsPlaced
describe("allShipsPlaced", () => {
    test("chưa đặt tàu nào → false", () => {
        expect(allShipsPlaced()).toBe(false);
    });
    test("đặt đủ hết → true", () => {
        SHIP_CATALOG.forEach(s => s.placed = true);
        expect(allShipsPlaced()).toBe(true);
    });
});

// getPlacementData
describe("getPlacementData", () => {
    test("trả về đúng format", () => {
        placedShips.push({
            name: "Destroyer", size: 2,
            direction: "horizontal",
            cells: [{r:0,c:0},{r:0,c:1}]
        });
        const data = getPlacementData();
        expect(data).toHaveLength(1);
        expect(data[0]).toMatchObject({
            name: "Destroyer",
            size: 2,
            direction: "horizontal"
        });
    });
});