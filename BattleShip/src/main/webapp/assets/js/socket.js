let socket;

function connectSocket() {
    socket = new WebSocket(
        "ws://" + window.location.host + contextPath + "/game"
    );

    socket.onopen = () => {
        console.log("Connected");
        socket.send("JOIN_ROOM|" + userId + "|" + roomId);
    };

    socket.onmessage = (event) => {
        console.log("RAW:", event.data);
        const parts = event.data.split("|");
        console.log("PARSED:", parts);

        switch (parts[0]) {

            case "ROOM_STATE":
                players = parts[1] ? parts[1].split(",") : [];
                renderPlayers();
                break;

            case "USER_JOINED":
                if (!players.includes(parts[1])) {
                    players.push(parts[1]);
                }
                renderPlayers();
                break;

            case "ERROR":
                alert(parts[1]);
                break;
        }
    };

    socket.onclose = () => {
        console.log("Disconnected");
    };
}