package socket;

import com.google.gson.Gson;
import enums.GamePhase;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import models.BattleState;
import models.Board;
import models.Player;
import models.Room;
import services.BattleService;
import services.RoomManager;

import java.util.List;

@ServerEndpoint("/game")
public class GameSocketServer {

    // =========================================================
    // CONNECT
    // =========================================================

    @OnOpen
    public void onOpen(Session session) {

        // [UC-08 - Join Room][Pre-Step]
        // Client establish WebSocket connection
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

            // [SYSTEM - Dispatcher]
            // Nhận message từ client (protocol dạng: ACTION|param1|param2...)
            System.out.println(
                    "RAW MESSAGE: " + message
            );

            String[] parts =
                    message.split("\\|", 5);

            String action = parts[0];

            switch (action) {

                // =================================================
                // JOIN ROOM
                // =================================================
                // [UC-08]
                case "JOIN_ROOM":

                    handleJoinRoom(parts, session);

                    break;


                // =================================================
                // TOGGLE READY
                // =================================================
                // [UC-08.1]
                case "TOGGLE_READY":

                    handleToggleReady(parts);

                    break;


                // =================================================
                // START GAME
                // =================================================
                // [UC-08.2]
                case "START_GAME":

                    handleStartGame(parts);

                    break;

                // =================================================
                // CONFIRM PLACEMENT
                // =================================================
                // [UC-09 - Place Ships]
                case "CONFIRM_PLACEMENT":
                    handleConfirmPlacement(parts);
                    break;

                // =================================================
                // INIT BATTLE STATE
                // =================================================
                // [UC-09][Reconnect / Sync]
                case "INIT_BATTLE_STATE":
                    handleInitBattleState(parts, session);
                    break;

                // =================================================
                // START GAME
                // =================================================
                // [UC-10 - Attack Turn-Based]
                case "ATTACK":
                    handleAttack(parts);
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
        // [UC-08][Step 1 - Validate Packet]
        if (parts.length < 3) {

            send(
                    session,
                    "ERROR|Invalid JOIN_ROOM packet"
            );

            return;
        }

        String username = parts[1];
        String roomId = parts[2];

        System.out.println("JOIN ROOM:");
        System.out.println("roomId = " + roomId);

        System.out.println(
                "ALL ROOMS = " +
                        RoomManager.getRooms().keySet()
        );

        // [UC-08][Step 2 - Call Service Layer]
        boolean success =
                RoomManager.joinRoom(
                        roomId,
                        username,
                        session
                );

        // [UC-08][Exception Flow handled in RoomManager]
        if (!success) {
            return;
        }

        // [UC-08][Step 3 - Join Success]
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

        // [UC-08.1][Step 1 - Validate]
        if (parts.length < 3) {
            return;
        }

        String roomId = parts[1];
        String username = parts[2];

        // [UC-08.1][Step 2 - Toggle]
        RoomManager.toggleReady(
                roomId,
                username
        );

        // [UC-08.1][Step 3 - Broadcast handled in service]
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

        // [UC-08.2][Step 1 - Validate]
        if (parts.length < 3) {
            return;
        }

        String roomId = parts[1];
        String username = parts[2];

        // [UC-08.2][Step 2 - Start]
        RoomManager.startGame(
                roomId,
                username
        );

        // [UC-08.2][Step 3 - Broadcast GAME_STARTED]
        System.out.println(
                username +
                        " started game"
        );
    }

    // =========================================================
    // CONFIRM PLACEMENT
    // =========================================================

    private void handleConfirmPlacement(
            String[] parts
    ) {

        // [UC-09 - Place Ships][Step 1 - Validate]
        if(parts.length < 4) {
            return;
        }

        String roomId = parts[1];
        String username = parts[2];

        String boardJson = parts[3];

        // [UC-09][Step 2 - Parse Board]
        Board board =
                BattleService.parseBoard(boardJson);

        // [UC-09][Step 3 - Confirm Placement]
        BattleService.confirmPlacement(
                roomId,
                username,
                board
        );

        // System sẽ chuyển state:
        // WAITING → PLACING → (ready) → BATTLE
    }

    // =========================================================
    // INIT BATTLE STATE
    // =========================================================

    private void handleInitBattleState(
            String[] parts,
            Session session
    ) {

        if (parts.length < 3) {
            return;
        }

        String roomId = parts[1];
        String username = parts[2];

        Room room =
                RoomManager.getRoom(roomId);

        if (room == null) {

            send(
                    session,
                    "ERROR|Room not found"
            );

            return;
        }

        Player player =
                room.getPlayers().get(username);

        if (player == null) {

            send(
                    session,
                    "ERROR|Player not found"
            );

            return;
        }

        String shipsJson = player.getBoardJson();

        if (shipsJson == null) {
            shipsJson = "[]";
        }

        // =========================================
        // RESTORE SESSION
        // =========================================

        player.setSession(session);

        player.setConnected(true);

        room.getSessions().put(username, session);

        // =========================================
        // SEND BATTLE STATE
        // =========================================

        BattleState battleState =
                room.getBattleState();

        if (battleState == null) {

            send(
                    session,
                    "ERROR|Battle not started"
            );

            return;
        }

        send(session, "INIT_BATTLE_STATE|" + roomId + "|" + username
                + "|" + shipsJson
                + "|" + toShotsJson(battleState.getShotHistory()));

        send(
                session,
                "BATTLE_STARTED|"
                        + battleState.getCurrentTurn()
        );
    }

    // =========================================================
    // ATTACK
    // =========================================================

    private void handleAttack(String[] parts) {

        try {

            if(parts.length < 5) {
                return;
            }

            String roomId = parts[1];

            String attacker = parts[2];

            int row =
                    Integer.parseInt(parts[3]);

            int col =
                    Integer.parseInt(parts[4]);

            Room room =
                    RoomManager.getRoom(roomId);

            if(room == null) {
                return;
            }

            // =====================================
            // MUST BE BATTLE PHASE
            // =====================================

            if(room.getPhase() != GamePhase.BATTLE) {

                RoomManager.broadcast(
                        roomId,
                        "ERROR|Game is not in battle phase"
                );

                return;
            }

            // =====================================
            // PROCESS ATTACK
            // =====================================

            BattleService.attack(
                    roomId,
                    attacker,
                    row,
                    col
            );

        } catch (Exception e) {

            e.printStackTrace();
        }
    }

    // =========================================================
    // DISCONNECT
    // =========================================================

    @OnClose
    public void onClose(Session session) {

        // [UC-08.3 - Leave Room]
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

//    private void syncBattleState(String roomId) {
//        // [INCLUDED USE CASE - Sync Game State]
//        Room room =
//                RoomManager.getRoom(roomId);
//
//        if(room == null) {
//            return;
//        }
//
//        BattleState battle =
//                room.getBattleState();
//
//        if(battle == null) {
//            return;
//        }
//
//        Gson gson = new Gson();
//
//        // =====================================
//        // [Loop - Send state to each player]
//        // =====================================
//        for(Player player :
//                room.getPlayers().values()) {
//
//            Board board =
//                    battle.getPlayerBoards()
//                            .get(player.getUsername());
//
//            if(board == null) {
//                continue;
//            }
//
//            String boardJson =
//                    gson.toJson(board.getShips());
//
//            try {
//
//                Session session =
//                        player.getSession();
//
//                if(session != null
//                        && session.isOpen()) {
//
//                    // [UC-10][Step - Update client state]
//                    session.getBasicRemote()
//                            .sendText(
//                                    "INIT_BATTLE_STATE|"
//                                            + roomId + "|"
//                                            + player.getUsername()
//                                            + "|"
//                                            + boardJson
//                            );
//                }
//
//            } catch (Exception e) {
//
//                e.printStackTrace();
//            }
//        }
//    }

    private String toShotsJson(List<String> shotHistory) {
        if (shotHistory == null || shotHistory.isEmpty()) {
            return "[]";
        }

        StringBuilder sb = new StringBuilder("[");

        for (int i = 0; i < shotHistory.size(); i++) {
            // Mỗi shot có dạng: "userA|2|3|HIT"
            String[] p = shotHistory.get(i).split("\\|");

            if (p.length < 4) continue;

            sb.append("{")
                    .append("\"attacker\":\"").append(p[0]).append("\",")
                    .append("\"row\":").append(p[1]).append(",")
                    .append("\"col\":").append(p[2]).append(",")
                    .append("\"result\":\"").append(p[3]).append("\"")
                    .append("}");

            if (i < shotHistory.size() - 1) sb.append(",");
        }

        sb.append("]");

        return sb.toString();
    }
}