package models;

import enums.PlayerRole;
import jakarta.websocket.Session;
import models.ai.AIStrategy;

import java.util.List;

public class Player {
    private String username;
    private PlayerRole role;
    private boolean isReady;
    private Board board;
    private boolean placementConfirmed;
    private Session session;
    private boolean connected = true;
    private AIStrategy aiStrategy;

    public Player(String username, PlayerRole role, boolean isReady) {
        this.username = username;
        this.role = role;
        this.isReady = isReady;
    }

    public Player(String username, AIStrategy aiStrategy) {
        this.username = username;
        this.role = PlayerRole.AI;
        this.aiStrategy = aiStrategy;
    }

    public Player(String username, Session session) {
        this.username = username;
        this.role = PlayerRole.HUMAN;
        this.session = session;
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

    public AIStrategy getAiStrategy() {
        return aiStrategy;
    }

    public void setAiStrategy(AIStrategy aiStrategy) {
        this.aiStrategy = aiStrategy;
    }

    public boolean isAI() {
        return role == PlayerRole.AI;
    }

    public boolean isHuman() {
        return role == PlayerRole.HUMAN;
    }

    public String getBoardJson() {
        if (board == null || board.getShips() == null) {
            return "[]";
        }

        StringBuilder sb = new StringBuilder("[");

        List<Ship> ships = board.getShips();

        for (int i = 0; i < ships.size(); i++) {
            Ship ship = ships.get(i);

            sb.append("{\"cells\":[");

            List<Position> cells = ship.getCells();

            for (int j = 0; j < cells.size(); j++) {
                Position cell = cells.get(j);

                sb.append("{\"r\":")
                        .append(cell.getR())
                        .append(",\"c\":")
                        .append(cell.getC())
                        .append("}");

                if (j < cells.size() - 1) sb.append(",");
            }

            sb.append("]}");

            if (i < ships.size() - 1) sb.append(",");
        }

        sb.append("]");

        return sb.toString();
    }
}
