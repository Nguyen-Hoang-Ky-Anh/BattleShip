document.addEventListener("DOMContentLoaded", () => {
    console.log("DOM loaded. Initializing game...");

    // 1. Kiểm tra và khởi tạo lưới (Grid)
    if (typeof createGrid === "function") {
        createGrid(rows, cols);
    } else {
        console.warn("createGrid function not found!");
    }

    // 2. Khởi tạo kết nối Socket
    if (typeof connectSocket === "function") {
        connectSocket(); // Hàm setup GameState.socket
    } else {
        console.error("connectSocket function not found! Check socket.js import.");
    }
});