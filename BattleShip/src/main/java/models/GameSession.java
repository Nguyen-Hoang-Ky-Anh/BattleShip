package models;

import java.util.UUID;

public class GameSession {

    private final String gameId;

    private final Player player1;

    private final Player player2;

    private Player currentTurn;

    private boolean finished;

    public GameSession(
            Player player1,
            Player player2
    ) {

        this.gameId =
                UUID.randomUUID().toString();

        this.player1 = player1;

        this.player2 = player2;

        this.currentTurn = player1;
    }

    public String getGameId() {
        return gameId;
    }

    public Player getPlayer1() {
        return player1;
    }

    public Player getPlayer2() {
        return player2;
    }

    public Player getCurrentTurn() {
        return currentTurn;
    }

    public void switchTurn() {

        currentTurn =
                currentTurn == player1
                        ? player2
                        : player1;
    }

    public boolean isFinished() {
        return finished;
    }

    public void setFinished(boolean finished) {
        this.finished = finished;
    }
}
