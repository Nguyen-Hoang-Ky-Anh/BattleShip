package models;

import enums.PlayerRole;
import jakarta.websocket.Session;

public class Player {
    private String username;
    private PlayerRole role;
    private boolean isReady;
    private Board board;
    private boolean placementConfirmed;
    private Session session;
    private boolean connected = true;

    public Player(String username, PlayerRole role, boolean isReady) {
        this.username = username;
        this.role = role;
        this.isReady = isReady;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public PlayerRole getRole() {
        return role;
    }

    public void setRole(PlayerRole role) {
        this.role = role;
    }

    public boolean isReady() {
        return isReady;
    }

    public void setReady(boolean ready) {
        isReady = ready;
    }

    public Board getBoard() {
        return board;
    }

    public void setBoard(Board board) {
        this.board = board;
    }

    public boolean isPlacementConfirmed() {
        return placementConfirmed;
    }

    public void setPlacementConfirmed(boolean placementConfirmed) {
        this.placementConfirmed = placementConfirmed;
    }

    public Session getSession() {
        return session;
    }

    public void setSession(Session session) {
        this.session = session;
    }

    public boolean isConnected() {
        return connected;
    }

    public void setConnected(boolean connected) {
        this.connected = connected;
    }
}
