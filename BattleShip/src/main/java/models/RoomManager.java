package models;

import jakarta.websocket.Session;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class RoomManager {
    private static final Map<String, Room> rooms = new HashMap<>();
    private static final Map<Session, String> sessionUserMap = new HashMap<>();
    private static final Map<Session, String> sessionRoomMap = new HashMap<>();

    public static synchronized String createRoom(String hostId) {
        String roomId = "ROOM_" + System.currentTimeMillis();

        Room room = new Room(roomId, hostId);
        rooms.put(roomId, room);

        return roomId;
    }

    public static synchronized boolean joinRoom(String roomId, String userId, Session session) {
        Room room = rooms.get(roomId);

        if (room == null) return false;

        room.addPlayer(userId, session);

        sessionUserMap.put(session, userId);
        sessionRoomMap.put(session, roomId);

        broadcast(roomId, "USER_JOINED|" + userId);

        return true;
    }

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

    public static void broadcast(String roomId, String msg) {
        Room room = rooms.get(roomId);

        if (room == null) return;

        for (Session session : room.getPlayers().values()) {
            try {
                session.getBasicRemote().sendText(msg);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
