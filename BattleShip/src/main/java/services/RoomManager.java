package services;

import enums.GamePhase;
import enums.PlayerRole;
import jakarta.websocket.Session;
import models.BattleState;
import models.Player;
import models.Room;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class RoomManager {

    // ================= ROOM STORAGE =================

    private static final Map<String, Room> rooms =
            new ConcurrentHashMap<>();

    // session -> username
    private static final Map<Session, String> sessionUserMap =
            new ConcurrentHashMap<>();

    // session -> roomId
    private static final Map<Session, String> sessionRoomMap =
            new ConcurrentHashMap<>();


    // =========================================================
    // CREATE ROOM
    // =========================================================

    public static synchronized String createRoom(
            String hostUsername,
            int rows,
            int cols
    ) {

        // [UC-07 - Create Room][Step 1]
        // System generate roomId
        String roomId =
                "ROOM_" + System.currentTimeMillis();

        // [UC-07][Step 2]
        // Khởi tạo Room với host
        Room room =
                new Room(roomId, hostUsername, rows, cols);

        // [UC-07][Step 3]
        // Set trạng thái ban đầu
        room.setPhase(GamePhase.WAITING);
        room.setBattleState(new BattleState());

        // [UC-07][Step 4]
        // Lưu room vào hệ thống
        rooms.put(roomId, room);

        // [UC-07][Step 5]
        // Trả roomId cho client (để share/invite)
        return roomId;
    }


    // =========================================================
    // JOIN ROOM
    // =========================================================

    public static synchronized boolean joinRoom(
            String roomId,
            String username,
            Session session
    ) {

        // [UC-08][Step 2]
        Room room = rooms.get(roomId);

        // [UC-08][Exception - Room Not Found]
        if (room == null) {

            send(session,
                    "ERROR|Room not found");

            return false;
        }

        // [UC-08][Exception - Already Joined]
        if (sessionRoomMap.containsKey(session)) {

            send(session,
                    "ERROR|Already joined room");

            return false;
        }

        username = username.trim();

        // [UC-08][Exception - Invalid Username]
        if (username.length() < 2
                || username.length() > 20) {

            send(session,
                    "ERROR|Invalid username");

            return false;
        }

        Player existingPlayer =
                room.getPlayers().get(username);

        // =================================================
        // [UC-08.4 - Reconnect] (EXTEND)
        // =================================================
        if(existingPlayer != null) {

            System.out.println("RECONNECT: " + username
                    + " old session: " + existingPlayer.getSession().getId()
                    + " new session: " + session.getId());

            // [Extend Flow]
            existingPlayer.setSession(session);
            existingPlayer.setConnected(true);
            room.getSessions().put(username, session);

            sessionUserMap.put(session, username);
            sessionRoomMap.put(session, roomId);

            // [UC-08][Step - Sync state]
            broadcastRoomState(roomId);

            return true;
        }

        // [UC-08][Exception - Room Full]
        if (room.getPlayers().size() >= 2) {

            send(session,
                    "ERROR|Room is full");

            return false;
        }

        // =================================================
        // [UC-08][Step 3 - Assign Role]
        // =================================================
        PlayerRole role =
                room.getPlayers().isEmpty()
                        ? PlayerRole.HOST
                        : PlayerRole.PLAYER;

        // =================================================
        // [UC-08][Step 4 - Create Player]
        // =================================================
        Player player =
                new Player(
                        username,
                        role,
                        false
                );

        player.setSession(session);
        player.setConnected(true);

        // =================================================
        // [UC-08][Step 5 - Add Player]
        // =================================================
        room.addPlayer(player, session);

        // =================================================
        // [UC-08][Step 6 - Map Session]
        // =================================================
        sessionUserMap.put(session, username);
        sessionRoomMap.put(session, roomId);

        // =================================================
        // [UC-08][Step 7 - Notify All Players]
        // =================================================
        broadcastRoomState(roomId);

        return true;
    }


    // =========================================================
    // TOGGLE READY
    // =========================================================

    public static synchronized void toggleReady(
            String roomId,
            String username
    ) {
        // [UC-08.1 - Toggle Ready][Step 1]
        Room room = rooms.get(roomId);

        if (room == null) return;

        Player player =
                room.getPlayers().get(username);

        if (player == null) return;

        // [UC-08.1][Business Rule]
        // Host không được ready
        if (player.getRole() == PlayerRole.HOST) {
            return;
        }

        // [UC-08.1][Step 2]
        // Toggle trạng thái ready
        player.setReady(!player.isReady());

        // [UC-08.1][Step 3]
        // Broadcast trạng thái mới
        broadcastRoomState(roomId);
    }


    // =========================================================
    // START GAME
    // =========================================================

    public static synchronized void startGame(
            String roomId,
            String username
    ) {

        // [UC-08.2 - Start Game][Step 1]
        Room room = rooms.get(roomId);

        if (room == null) return;

        Player host =
                room.getPlayers().get(username);

        // [UC-08.2][Business Rule - Only Host]
        if (host == null
                || host.getRole() != PlayerRole.HOST) {

            return;
        }

        // [UC-08.2][Exception - Not Enough Players]
        if (room.getPlayers().size() < 2) {

            send(
                    host.getSession(),
                    "ERROR|Need 2 players"
            );

            return;
        }

        // [UC-08.2][Exception - Opponent Not Ready]
        for (Player p : room.getPlayers().values()) {

            if (p.getRole() != PlayerRole.HOST
                    && !p.isReady()) {

                send(
                        host.getSession(),
                        "ERROR|Opponent not ready"
                );

                return;
            }
        }

        // [UC-08.2][Step 2]
        // Chuyển sang phase đặt tàu
        room.setPhase(GamePhase.PLACING);

        // [UC-08.2][Step 3]
        // Broadcast game started
        broadcast(roomId, "GAME_STARTED");
    }


    // =========================================================
    // REMOVE SESSION
    // =========================================================

    public static synchronized void removeSession(
            Session session
    ) {

        // [UC-08.3 - Leave Room][Step 1]
        String roomId =
                sessionRoomMap.get(session);

        String username =
                sessionUserMap.get(session);

        if(roomId == null || username == null) {
            return;
        }

        Room room = rooms.get(roomId);

        if(room == null) {
            return;
        }

        // [UC-08.3][Step 2]
        // Đánh dấu player disconnected
        Player player =
                room.getPlayers().get(username);

        if(player != null) {

            player.setConnected(false);

            System.out.println(
                    username +
                            " disconnected from " +
                            roomId
            );
        }

        // [UC-08.3][Step 3]
        // Remove mapping
        sessionRoomMap.remove(session);
        sessionUserMap.remove(session);

        // [UC-08.3][Step 4]
        // Broadcast update
        broadcastRoomState(roomId);
    }


    // =========================================================
    // BROADCAST ROOM STATE
    // =========================================================

    // [INCLUDED USE CASE - Notify Players]
    public static void broadcastRoomState(
            String roomId
    ) {

        Room room = rooms.get(roomId);

        if (room == null) return;

        StringBuilder sb =
                new StringBuilder();

        sb.append("ROOM_STATE|");

        for (Player p : room.getPlayers().values()) {

            sb.append(p.getUsername())
                    .append(",")
                    .append(p.getRole())
                    .append(",")
                    .append(p.isReady())
                    .append(";");
        }

        broadcast(roomId, sb.toString());
    }


    // =========================================================
    // BROADCAST
    // =========================================================

    public static void broadcast(
            String roomId,
            String msg
    ) {

        Room room = rooms.get(roomId);

        if(room == null) return;

        var players =
                new ArrayList<>(
                        room.getPlayers().values()
                );

        for(Player player : players) {
            System.out.println("BROADCAST to: " + player.getUsername()
                    + " session: " + player.getSession().getId()
                    + " isOpen: " + player.getSession().isOpen());
            send(player.getSession(), msg);
        }
    }


    // =========================================================
    // SEND
    // =========================================================

    // [INCLUDED USE CASE - Send Message]
    private static void send(
            Session session,
            String msg
    ) {

        if(session == null) {
            return;
        }

        try {

            synchronized (session) {

                if(session.isOpen()) {

                    session.getBasicRemote()
                            .sendText(msg);
                }
            }

        } catch (IllegalStateException e) {

            System.out.println(
                    "Skip closed session"
            );

        } catch (IOException e) {

            e.printStackTrace();
        }
    }


    // =========================================================
    // GETTERS
    // =========================================================

    public static boolean exists(String roomId) {

        return rooms.containsKey(roomId);
    }

    public static Room getRoom(String roomId) {

        return rooms.get(roomId);
    }

    public static Map<String, Room> getRooms() {
        return rooms;
    }
}