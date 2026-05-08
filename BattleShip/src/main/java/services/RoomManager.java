package services;

import enums.GamePhase;
import enums.PlayerRole;
import jakarta.websocket.Session;
import models.BattleState;
import models.Player;
import models.Room;

import java.io.IOException;
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

        String roomId =
                "ROOM_" + System.currentTimeMillis();

        Room room =
                new Room(roomId, hostUsername, rows, cols);

        room.setPhase(GamePhase.WAITING);
        room.setBattleState(new BattleState());

        rooms.put(roomId, room);

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

        Room room = rooms.get(roomId);

        // room not found
        if (room == null) {

            send(session,
                    "ERROR|Room not found");

            return false;
        }

        // already joined
        if (sessionRoomMap.containsKey(session)) {

            send(session,
                    "ERROR|Already joined room");

            return false;
        }

        username = username.trim();

        // invalid username
        if (username.length() < 2
                || username.length() > 20) {

            send(session,
                    "ERROR|Invalid username");

            return false;
        }

        Player existingPlayer =
                room.getPlayers().get(username);

        // =====================================
        // RECONNECT
        // =====================================

        if(existingPlayer != null) {

            existingPlayer.setSession(session);

            existingPlayer.setConnected(true);

            sessionUserMap.put(session, username);

            sessionRoomMap.put(session, roomId);

            broadcastRoomState(roomId);

            System.out.println(
                    username + " reconnected"
            );

            return true;
        }

        // room full
        if (room.getPlayers().size() >= 2) {

            send(session,
                    "ERROR|Room is full");

            return false;
        }

        // ================= ROLE =================

        PlayerRole role =
                room.getPlayers().isEmpty()
                        ? PlayerRole.HOST
                        : PlayerRole.PLAYER;

        // ================= CREATE PLAYER =================

        Player player =
                new Player(
                        username,
                        role,
                        false
                );

        player.setSession(session);

        player.setConnected(true);

        // ================= ADD PLAYER =================

        room.addPlayer(player, session);

        // ================= STORE SESSION =================

        sessionUserMap.put(session, username);

        sessionRoomMap.put(session, roomId);

        // ================= BROADCAST =================

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

        Room room = rooms.get(roomId);

        if (room == null) return;

        Player player =
                room.getPlayers().get(username);

        if (player == null) return;

        // host cannot ready
        if (player.getRole() == PlayerRole.HOST) {
            return;
        }

        player.setReady(!player.isReady());

        broadcastRoomState(roomId);
    }


    // =========================================================
    // START GAME
    // =========================================================

    public static synchronized void startGame(
            String roomId,
            String username
    ) {

        Room room = rooms.get(roomId);

        if (room == null) return;

        Player host =
                room.getPlayers().get(username);

        // only host can start
        if (host == null
                || host.getRole() != PlayerRole.HOST) {

            return;
        }

        // must have 2 players
        if (room.getPlayers().size() < 2) {

            send(
                    room.getSessions().get(username),
                    "ERROR|Need 2 players"
            );

            return;
        }

        // all non-host must ready
        for (Player p : room.getPlayers().values()) {

            if (p.getRole() != PlayerRole.HOST
                    && !p.isReady()) {

                send(
                        room.getSessions().get(username),
                        "ERROR|Opponent not ready"
                );

                return;
            }
        }
        room.setPhase(GamePhase.PLACING);
        broadcast(roomId, "GAME_STARTED");
    }


    // =========================================================
    // REMOVE SESSION
    // =========================================================

    public static synchronized void removeSession(
            Session session
    ) {

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

        Player player =
                room.getPlayers().get(username);

        if(player != null) {

            player.setConnected(false);

            player.setSession(null);

            System.out.println(
                    username +
                            " disconnected from " +
                            roomId
            );
        }

        sessionRoomMap.remove(session);

        sessionUserMap.remove(session);

        broadcastRoomState(roomId);
    }


    // =========================================================
    // BROADCAST ROOM STATE
    // =========================================================

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

        for(Player player :
                room.getPlayers().values()) {

            Session session =
                    player.getSession();

            send(session, msg);
        }
    }


    // =========================================================
    // SEND
    // =========================================================

    private static void send(
            Session session,
            String msg
    ) {

        try {

            if (session != null
                    && session.isOpen()) {

                session.getBasicRemote()
                        .sendText(msg);
            }

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