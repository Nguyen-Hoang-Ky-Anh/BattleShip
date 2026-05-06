package models;

import jakarta.websocket.Session;

import java.util.HashMap;
import java.util.Map;

public class Room {
    private String roomId;
    private String hostId;
    private Map<String, Session> players = new HashMap<>();
    private int rows;
    private int cols;

    public Room(String roomId, String hostId, int rows, int cols) {
        this.roomId = roomId;
        this.hostId = hostId;
        this.rows = rows;
        this.cols = cols;
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

    public int getRows() {
        return rows;
    }

    public void setRows(int rows) {
        this.rows = rows;
    }

    public int getCols() {
        return cols;
    }

    public void setCols(int cols) {
        this.cols = cols;
    }
}
