package models;

import jakarta.websocket.Session;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class RoomManager {

    private static final Map<String, Room> rooms = new HashMap<>();
    private static final Map<Session, String> sessionUserMap = new HashMap<>();
    private static final Map<Session, String> sessionRoomMap = new HashMap<>();

    // ================= CREATE =================
    public static synchronized String createRoom(String hostId, int rows, int cols) {
        String roomId = "ROOM_" + System.currentTimeMillis();

        Room room = new Room(roomId, hostId, rows, cols);
        rooms.put(roomId, room);

        return roomId;
    }

    // ================= JOIN =================
    public static synchronized boolean joinRoom(String roomId, String userId, Session session) {
        Room room = rooms.get(roomId);

        if (room == null) {
            send(session, "ERROR|Room not found");
            return false;
        }

        if (sessionRoomMap.containsKey(session)) {
            return false;
        }

        userId = userId.trim();

        if (userId.length() < 2 || userId.length() > 20) {
            send(session, "ERROR|Invalid username");
            return false;
        }

        if (room.getPlayers().containsKey(userId)) {
            send(session, "ERROR|Username already taken");
            return false;
        }

        if (room.getPlayers().size() >= 2) {
            send(session, "ERROR|Room is full");
            return false;
        }

        room.addPlayer(userId, session);

        sessionUserMap.put(session, userId);
        sessionRoomMap.put(session, roomId);

        broadcast(roomId, "ROOM_STATE|" + String.join(",", room.getPlayers().keySet()));

        return true;
    }

    // ================= GET =================

    public static String getPlayers(String roomId) {
        Room room = rooms.get(roomId);
        if (room == null) return "";

        return String.join(",", room.getPlayers().keySet());
    }

    public static Room getRoom(String roomId) {
        return rooms.get(roomId);
    }

    // ================= REMOVE =================
    public static synchronized void removeSession(Session session) {
        String roomId = sessionRoomMap.get(session);
        String userId = sessionUserMap.get(session);

        if (roomId == null || userId == null) return;

        Room room = rooms.get(roomId);

        if (room != null) {
            room.removePlayer(userId);

            broadcast(roomId, "USER_LEFT|" + userId);

            if (room.getPlayers().isEmpty()) {
                rooms.remove(roomId);
            }
        }

        sessionRoomMap.remove(session);
        sessionUserMap.remove(session);
    }

    // ================= SEND =================
    private static void send(Session session, String msg) {
        try {
            if (session != null && session.isOpen()) {
                session.getBasicRemote().sendText(msg);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // ================= BROADCAST =================
    public static void broadcast(String roomId, String msg) {
        Room room = rooms.get(roomId);
        if (room == null) return;

        for (Session s : room.getPlayers().values()) {
            send(s, msg);
        }
    }

    public static void broadcastExcept(String roomId, Session exclude, String msg) {
        Room room = rooms.get(roomId);
        if (room == null) return;

        for (Session s : room.getPlayers().values()) {
            if (!s.equals(exclude)) {
                send(s, msg);
            }
        }
    }

    // ================= CHECK =================
    public static boolean exists(String roomId) {
        return rooms.containsKey(roomId);
    }
}