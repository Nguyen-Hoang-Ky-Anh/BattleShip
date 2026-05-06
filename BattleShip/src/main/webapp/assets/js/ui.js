let players = [];

function renderPlayers() {
    const list = document.getElementById("playerList");
    list.innerHTML = "";

    players.forEach(p => {
        const li = document.createElement("li");
        li.className = "player";
        li.innerText = "🚢 " + p;
        list.appendChild(li);

        if (p === userId) {
            li.style.borderLeft = "4px solid #00ffcc";
        }
    });

    updateRoomStatus();
}

function updateRoomStatus() {
    const status = document.getElementById("roomStatus");

    if (players.length <= 1) {
        status.innerText = "⏳ Waiting for opponent...";
        status.style.background = "rgba(255,255,255,0.1)";
    } else {
        status.innerText = "🔥 Ready to battle!";
        status.style.background = "rgba(0,255,150,0.2)";
    }
}

function createGrid(rows, cols) {
    const grid = document.getElementById("grid");

    grid.innerHTML = "";
    grid.style.gridTemplateColumns = `repeat(${cols}, 40px)`;

    for (let i = 0; i < rows * cols; i++) {
        const cell = document.createElement("div");
        cell.className = "cell";
        grid.appendChild(cell);
    }
}

function copyRoomId() {
    const text = document.getElementById("roomIdText").innerText;

    navigator.clipboard.writeText(text).then(() => {
        const btn = document.querySelector(".room-id-box button");
        btn.innerText = "✔";
        setTimeout(() => btn.innerText = "📋", 1500);
    });
}