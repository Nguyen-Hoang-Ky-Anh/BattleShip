package dto;

public class AttackResponse {
    public String playerResult;
    public AiMoveDTO aiMove;
    public boolean gameOver;
    public String winner;
    public String nextTurn;

    public AttackResponse(String playerResult, AiMoveDTO aiMove,
                          boolean gameOver, String winner, String nextTurn) {
        this.playerResult = playerResult;
        this.aiMove = aiMove;
        this.gameOver = gameOver;
        this.winner = winner;
        this.nextTurn = nextTurn;
    }
}