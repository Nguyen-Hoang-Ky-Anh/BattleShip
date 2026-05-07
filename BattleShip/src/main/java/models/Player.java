package models;

import enums.PlayerRole;

public class Player {
    private String username;
    private PlayerRole role;
    private boolean isReady;

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
}
