package models;

import jakarta.websocket.Session;

import java.util.HashMap;
import java.util.Map;

public class Room {
    private String roomId;
    private String hostId;
    private Map<String, Session> players = new HashMap<>();

    public Room(String roomId, String hostId) {
        this.roomId = roomId;
        this.hostId = hostId;
    }

    public String getRoomId() {
        return roomId;
    }

    public String getHostId() {
        return hostId;
    }

    public Map<String, Session> getPlayers() {
        return players;
    }

    public void addPlayer(String userId, Session session) {
        players.put(userId, session);
    }

    public void removePlayer(String userId) {
        players.remove(userId);
    }
}
