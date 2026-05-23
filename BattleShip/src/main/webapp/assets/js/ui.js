let players = [];
const radarPositionMap = {};

// =========================================================
// RENDER UI
// =========================================================

function renderPlayers() {

    const radarLayer =
        document.getElementById("radarPlayersLayer");

    if (!radarLayer) return;

    radarLayer.innerHTML = "";

    let allReady = true;
    let isHost = false;

    players.forEach((p, index) => {

        // Random position nếu chưa có
        if (!radarPositionMap[p.username]) {

            const angle =
                Math.random() * Math.PI * 2;

            const radius =
                25 + Math.random() * 35;

            radarPositionMap[p.username] = {

                x: 50 + Math.cos(angle) * radius,

                y: 50 + Math.sin(angle) * radius
            };
        }

        const radarPos =
            radarPositionMap[p.username];

        // PLAYER CONTAINER
        const player =
            document.createElement("div");

        player.className =
            `radar-player ${p.ready ? "ready" : ""}`;

        player.style.left = `${radarPos.x}%`;
        player.style.top = `${radarPos.y}%`;

        // HOST ICON
        const roleIcon =
            p.role === "HOST"
                ? "👑"
                : "🚢";

        player.innerHTML = `
            <div class="radar-player-dot"></div>

            <div class="radar-player-name">
                ${roleIcon} ${p.username}
            </div>
        `;

        radarLayer.appendChild(player);

        // Current User
        if (p.username === userId &&
            p.role === "HOST") {

            isHost = true;
        }

        // Check Ready
        if (p.role !== "HOST" &&
            !p.ready) {

            allReady = false;
        }
    });

    Object.keys(radarPositionMap)
        .forEach(username => {

            const exists =
                players.some(
                    p => p.username === username
                );

            if (!exists) {

                delete radarPositionMap[username];
            }
        });

    updateRoomStatus();

    setupRoomButtons(
        isHost,
        allReady,
        players.length
    );

    updatePlayerCounter();
}

function updatePlayerCounter() {

    const counter =
        document.getElementById("playerCounter");

    if (!counter) return;

    counter.innerText =
        `${players.length} / 2`;
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