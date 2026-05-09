package services;

import dto.AiMoveDTO;
import dto.AttackResponse;
import models.Board;
import models.GameSession;
import models.Player;
import models.Position;
import models.ai.AIStrategy;

public class BattlePveService {
    public AttackResponse playerAttack(GameSession game, int row, int col) {

        Player human = game.getPlayer1();
        Player ai = game.getPlayer2();

        Board aiBoard = ai.getBoard();
        Board humanBoard = human.getBoard();

        // ======================
        // PLAYER ATTACK
        // ======================
        String playerResult = aiBoard.handleShot(row, col);

        // WIN CHECK
        if (aiBoard.isAllSunk()) {
            return new AttackResponse(
                    playerResult,
                    null,
                    true,
                    "PLAYER",
                    "NONE"
            );
        }

        // ======================
        // TURN LOGIC
        // ======================

        // HIT → player plays again
        if (!playerResult.equals("MISS")) {
            return new AttackResponse(
                    playerResult,
                    null,
                    false,
                    null,
                    "PLAYER"
            );
        }

        // ======================
        // AI TURN (ONLY IF MISS)
        // ======================
        AiMoveDTO aiMove = executeAITurn(game);

        if (humanBoard.isAllSunk()) {
            return new AttackResponse(
                    playerResult,
                    aiMove,
                    true,
                    "AI",
                    "NONE"
            );
        }

        return new AttackResponse(
                playerResult,
                aiMove,
                false,
                null,
                "PLAYER"
        );
    }

    private AiMoveDTO executeAITurn(GameSession game) {

        Player human = game.getPlayer1();
        Player ai = game.getPlayer2();

        Board humanBoard = human.getBoard();
        AIStrategy strategy = ai.getAiStrategy();

        AiMoveDTO lastMove = null;

        while (true) {

            Position pos = strategy.nextMove(humanBoard);

            String result = humanBoard.handleShot(pos.getR(), pos.getC());

            strategy.onShotResult(pos, result);

            lastMove = new AiMoveDTO();
            lastMove.row = pos.getR();
            lastMove.col = pos.getC();
            lastMove.result = result;

            // ======================
            // STOP CONDITION
            // ======================

            // MISS → end AI turn
            if ("MISS".equals(result)) {
                break;
            }

            // AI WON → stop immediately
            if (humanBoard.isAllSunk()) {
                break;
            }

            // else HIT/SUNK → continue loop
        }

        return lastMove;
    }
}
