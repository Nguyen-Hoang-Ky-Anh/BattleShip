let players = [];

// =========================================================
// RENDER UI
// =========================================================

function renderPlayers() {
    const list = document.getElementById("playerList");
    if (!list) return;

    list.innerHTML = "";

    let allReady = true;
    let isHost = false;

    players.forEach(p => {
        const li = document.createElement("li");
        li.className = "player";

        // Logic UI Role & Trạng thái
        const roleIcon = p.role === "HOST" ? "👑" : "🚢";
        const readyText = p.role === "HOST" ? "(HOST)" : (p.ready ? "✅ READY" : "❌ NOT READY");

        li.innerText = `${roleIcon} ${p.username} ${readyText}`;

        // Highlight User hiện tại
        if (p.username === userId) {
            li.style.borderLeft = "4px solid #00ffcc";
            if (p.role === "HOST") isHost = true;
        }

        // Kiểm tra xem tất cả player (trừ HOST) đã ready chưa
        if (p.role !== "HOST" && !p.ready) {
            allReady = false;
        }

        list.appendChild(li);
    });

    updateRoomStatus();
    setupRoomButtons(isHost, allReady, players.length);
}

function updateRoomStatus() {
    const status = document.getElementById("roomStatus");
    if (!status) return;

    if (players.length <= 1) {
        status.innerText = "⏳ Waiting for opponent...";
        status.style.background = "rgba(255,255,255,0.1)";
    } else {
        status.innerText = "🔥 Lobby Ready";
        status.style.background = "rgba(0,255,150,0.2)";
    }
}

// =========================================================
// SETUP BUTTONS
// =========================================================

function setupRoomButtons(isHost, allReady, totalPlayers) {
    const startBtn = document.getElementById("startBtn");
    const readyBtn = document.getElementById("readyBtn");
    const leaveBtn = document.getElementById("leaveBtn");

    if (isHost) {
        if (readyBtn) readyBtn.style.display = "none";
        if (leaveBtn) leaveBtn.style.display = "none";
        if (startBtn) {
            startBtn.style.display = "block";
            startBtn.disabled = !(allReady && totalPlayers >= 2);
        }
    } else {
        if (readyBtn) readyBtn.style.display = "block";
        if (leaveBtn) leaveBtn.style.display = "block";
        if (startBtn) startBtn.style.display = "none";
    }
}

// =========================================================
// USER ACTIONS (Kết nối với GameState.socket)
// =========================================================

function copyRoomId() {
    const text = document.getElementById("roomIdText")?.innerText;
    if (!text) return;

    navigator.clipboard.writeText(text).then(() => {
        const btn = document.querySelector(".room-id-box button");
        if (btn) {
            btn.innerText = "✔";
            setTimeout(() => btn.innerText = "📋", 1500);
        }
    });
}

function toggleReady() {
    if (GameState.socket && GameState.socket.readyState === WebSocket.OPEN) {
        GameState.socket.send(`${ACTIONS.TOGGLE_READY}|${roomId}|${userId}`);
    }
}

function startGame() {
    if (GameState.socket && GameState.socket.readyState === WebSocket.OPEN) {
        GameState.socket.send(`${ACTIONS.START_GAME}|${roomId}|${userId}`);
    }
}

function leaveRoom() {
    if (GameState.socket) {
        GameState.socket.close();
    }
    window.location.href = `${contextPath}/pvp`;
}