let players = [];

function renderPlayers() {

    const list =
        document.getElementById("playerList");

    list.innerHTML = "";

    let allReady = true;
    let totalPlayers = players.length;
    let isHost = false;

    players.forEach(p => {

        const li =
            document.createElement("li");

        li.className = "player";

        // =====================================================
        // ROLE ICON
        // =====================================================

        let roleIcon =
            p.role === "HOST"
                ? "👑"
                : "🚢";

        // =====================================================
        // READY TEXT
        // =====================================================

        let readyText =
            p.role === "HOST"
                ? "(HOST)"
                : (p.ready ? "✅ READY" : "❌ NOT READY");

        li.innerText =
            roleIcon +
            " " +
            p.username +
            " " +
            readyText;

        // highlight current user
        if (p.username === userId) {

            li.style.borderLeft =
                "4px solid #00ffcc";
        }

        // detect host
        if (
            p.username === userId &&
            p.role === "HOST"
        ) {
            isHost = true;
        }

        // check ready
        if (
            p.role !== "HOST" &&
            !p.ready
        ) {
            allReady = false;
        }

        list.appendChild(li);
    });

    updateRoomStatus();

    setupRoomButtons(
        isHost,
        allReady,
        totalPlayers
    );
}

function updateRoomStatus() {

    const status =
        document.getElementById("roomStatus");

    if (players.length <= 1) {

        status.innerText =
            "⏳ Waiting for opponent...";

        status.style.background =
            "rgba(255,255,255,0.1)";

    } else {

        status.innerText =
            "🔥 Lobby Ready";

        status.style.background =
            "rgba(0,255,150,0.2)";
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

function copyRoomId() {

    const text =
        document.getElementById("roomIdText")
            .innerText;

    navigator.clipboard.writeText(text)
        .then(() => {

            const btn =
                document.querySelector(
                    ".room-id-box button"
                );

            btn.innerText = "✔";

            setTimeout(() => {

                btn.innerText = "📋";

            }, 1500);
        });
}

// =========================================================
// ROOM BUTTONS
// =========================================================

function setupRoomButtons(
    isHost,
    allReady,
    totalPlayers
) {

    const startBtn =
        document.getElementById("startBtn");

    const readyBtn =
        document.getElementById("readyBtn");

    const leaveBtn =
        document.getElementById("leaveBtn");

    // ================= HOST =================

    if (isHost) {

        readyBtn.style.display = "none";

        leaveBtn.style.display = "none";

        startBtn.style.display = "block";

        startBtn.disabled =
            !(allReady && totalPlayers >= 2);

    }

    // ================= PLAYER =================

    else {

        readyBtn.style.display = "block";

        leaveBtn.style.display = "block";

        startBtn.style.display = "none";
    }
}


// =========================================================
// TOGGLE READY
// =========================================================

function toggleReady() {

    socket.send(
        "TOGGLE_READY|" +
        roomId + "|" +
        userId
    );
}


// =========================================================
// START GAME
// =========================================================

function startGame() {

    socket.send(
        "START_GAME|" +
        roomId + "|" +
        userId
    );
}


// =========================================================
// LEAVE ROOM
// =========================================================

function leaveRoom() {

    socket.close();

    window.location.href =
        contextPath + "/pvp";
}