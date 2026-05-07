package socket;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import models.RoomManager;

@ServerEndpoint("/game")
public class GameSocketServer {

    // =========================================================
    // CONNECT
    // =========================================================

    @OnOpen
    public void onOpen(Session session) {

        System.out.println(
                "Connected: " + session.getId()
        );
    }


    // =========================================================
    // MESSAGE
    // =========================================================

    @OnMessage
    public void onMessage(
            String message,
            Session session
    ) {

        try {

            System.out.println(
                    "RAW MESSAGE: " + message
            );

            String[] parts =
                    message.split("\\|");

            String action = parts[0];

            switch (action) {

                // =================================================
                // JOIN ROOM
                // =================================================

                case "JOIN_ROOM":

                    handleJoinRoom(parts, session);

                    break;


                // =================================================
                // TOGGLE READY
                // =================================================

                case "TOGGLE_READY":

                    handleToggleReady(parts);

                    break;


                // =================================================
                // START GAME
                // =================================================

                case "START_GAME":

                    handleStartGame(parts);

                    break;


                // =================================================
                // UNKNOWN
                // =================================================

                default:

                    send(
                            session,
                            "ERROR|Unknown action"
                    );
            }

        } catch (Exception e) {

            e.printStackTrace();

            send(
                    session,
                    "ERROR|Server error"
            );
        }
    }


    // =========================================================
    // JOIN ROOM
    // =========================================================

    private void handleJoinRoom(
            String[] parts,
            Session session
    ) {

        if (parts.length < 3) {

            send(
                    session,
                    "ERROR|Invalid JOIN_ROOM packet"
            );

            return;
        }

        String username = parts[1];
        String roomId = parts[2];

        boolean success =
                RoomManager.joinRoom(
                        roomId,
                        username,
                        session
                );

        if (!success) {
            return;
        }

        System.out.println(
                username +
                        " joined room " +
                        roomId
        );
    }


    // =========================================================
    // TOGGLE READY
    // =========================================================

    private void handleToggleReady(
            String[] parts
    ) {

        if (parts.length < 3) {
            return;
        }

        String roomId = parts[1];
        String username = parts[2];

        RoomManager.toggleReady(
                roomId,
                username
        );

        System.out.println(
                username +
                        " toggled ready"
        );
    }


    // =========================================================
    // START GAME
    // =========================================================

    private void handleStartGame(
            String[] parts
    ) {

        if (parts.length < 3) {
            return;
        }

        String roomId = parts[1];
        String username = parts[2];

        RoomManager.startGame(
                roomId,
                username
        );

        System.out.println(
                username +
                        " started game"
        );
    }


    // =========================================================
    // DISCONNECT
    // =========================================================

    @OnClose
    public void onClose(Session session) {

        System.out.println(
                "Disconnected: " +
                        session.getId()
        );

        RoomManager.removeSession(session);
    }


    // =========================================================
    // SEND
    // =========================================================

    private void send(
            Session session,
            String msg
    ) {

        try {

            if (session != null
                    && session.isOpen()) {

                session.getBasicRemote()
                        .sendText(msg);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }
    }
}