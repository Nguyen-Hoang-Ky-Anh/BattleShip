package dto;

import java.util.ArrayList;
import java.util.List;

public class AttackResponse {
    public String playerResult;
    public List<AiMoveDTO> aiMoves = new ArrayList<>();
    public boolean gameOver;
    public String winner;
    public String nextTurn;
    public String sunkShipName;

    public AttackResponse(String playerResult, String sunkShipName, List<AiMoveDTO> aiMoves,
                          boolean gameOver, String winner, String nextTurn) {
        this.playerResult = playerResult;
        this.sunkShipName = sunkShipName;
        this.aiMoves = aiMoves;
        this.gameOver = gameOver;
        this.winner = winner;
        this.nextTurn = nextTurn;
    }
}