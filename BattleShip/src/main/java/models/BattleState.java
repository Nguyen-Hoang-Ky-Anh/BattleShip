package models;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class BattleState {
    private boolean isStarted;
    private String currentTurn;
    private String winner;
    private Map<String, Board> playerBoards = new ConcurrentHashMap<>();
    private List<String> shotHistory =
            new ArrayList<>();

    public boolean isStarted() {
        return isStarted;
    }

    public void setStarted(boolean started) {
        isStarted = started;
    }

    public String getCurrentTurn() {
        return currentTurn;
    }

    public void setCurrentTurn(String currentTurn) {
        this.currentTurn = currentTurn;
    }

    public String getWinner() {
        return winner;
    }

    public void setWinner(String winner) {
        this.winner = winner;
    }

    public Map<String, Board> getPlayerBoards() {
        return playerBoards;
    }

    public void setPlayerBoards(Map<String, Board> playerBoards) {
        this.playerBoards = playerBoards;
    }

    public List<String> getShotHistory() {
        return shotHistory;
    }

    public void setShotHistory(List<String> shotHistory) {
        this.shotHistory = shotHistory;
    }
}
