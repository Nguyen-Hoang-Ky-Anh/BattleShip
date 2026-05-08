package models;

import enums.GamePhase;
import jakarta.websocket.Session;

import java.util.HashMap;
import java.util.Map;

public class Room {

    private String roomId;

    private String hostUsername;

    private Map<String, Player> players = new HashMap<>();

    private Map<String, Session> sessions = new HashMap<>();

    private int rows;
    private int columns;

    private BattleState battleState;
    private GamePhase phase;

    public Room(String roomId, String hostUsername, int rows, int columns) {
        this.roomId = roomId;
        this.hostUsername = hostUsername;
        this.rows = rows;
        this.columns = columns;

        this.phase = GamePhase.WAITING;
        this.battleState = new BattleState();
    }

    public int getRows() {
        return rows;
    }

    public void setRows(int rows) {
        this.rows = rows;
    }

    public int getCols() {
        return columns;
    }

    public void setColumns(int columns) {
        this.columns = columns;
    }

    public String getRoomId() {
        return roomId;
    }

    public Map<String, Player> getPlayers() {
        return players;
    }

    public Map<String, Session> getSessions() {
        return sessions;
    }

    public void addPlayer(Player player, Session session) {
        players.put(player.getUsername(), player);
        sessions.put(player.getUsername(), session);
    }

    public void removePlayer(String username) {
        players.remove(username);
        sessions.remove(username);
    }

    public BattleState getBattleState() {
        return battleState;
    }

    public void setBattleState(BattleState battleState) {
        this.battleState = battleState;
    }

    public GamePhase getPhase() {
        return phase;
    }

    public void setPhase(GamePhase phase) {
        this.phase = phase;
    }
}