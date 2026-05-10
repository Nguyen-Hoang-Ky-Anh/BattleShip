package services;

import dto.AiMoveDTO;
import dto.AttackResponse;
import models.Board;
import models.GameSession;
import models.Player;
import models.Position;
import models.ai.AIStrategy;

import java.util.ArrayList;
import java.util.List;

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

        if (playerResult.equals("ALREADY_SHOT") || playerResult.equals("INVALID")) {
            throw new IllegalArgumentException("Invalid shot: " + playerResult);
        }

        // Lấy tên tàu nếu Player bắn chìm tàu địch
        String playerSunkShipName = null;
        if ("SUNK".equals(playerResult)) {
            playerSunkShipName = aiBoard.getShipNameAt(row, col);
        }

        // WIN CHECK
        if (aiBoard.isAllSunk()) {
            return new AttackResponse(
                    playerResult,
                    playerSunkShipName, // Truyền tên tàu bị chìm
                    null,
                    true,
                    "PLAYER",
                    "NONE"
            );
        }

        // ======================
        // TURN LOGIC
        // ======================

        if (playerResult.equals("HIT") || playerResult.equals("SUNK")) {
            return new AttackResponse(
                    playerResult,
                    playerSunkShipName, // Truyền tên tàu bị chìm
                    null,
                    false,
                    null,
                    "PLAYER"
            );
        }

        // ======================
        // AI TURN (ONLY IF MISS)
        // ======================

        List<AiMoveDTO> aiMoves = executeAITurn(game);

        if (humanBoard.isAllSunk()) {
            return new AttackResponse(
                    playerResult,
                    playerSunkShipName,
                    aiMoves,
                    true,
                    "AI",
                    "NONE"
            );
        }

        return new AttackResponse(
                playerResult,
                playerSunkShipName,
                aiMoves,
                false,
                null,
                "PLAYER"
        );
    }

    private List<AiMoveDTO> executeAITurn(GameSession game) {

        Player human = game.getPlayer1();
        Player ai = game.getPlayer2();

        Board humanBoard = human.getBoard();
        AIStrategy strategy = ai.getAiStrategy();

        List<AiMoveDTO> movesHistory = new ArrayList<>();

        while (true) {

            Position pos = strategy.nextMove(humanBoard);
            String result = humanBoard.handleShot(pos.getR(), pos.getC());
            strategy.onShotResult(pos, result);

            AiMoveDTO currentMove = new AiMoveDTO();
            currentMove.row = pos.getR();
            currentMove.col = pos.getC();
            currentMove.result = result;

            // Nếu AI bắn chìm tàu của người chơi, lấy tên tàu đó
            if ("SUNK".equals(result)) {
                currentMove.sunkShipName = humanBoard.getShipNameAt(pos.getR(), pos.getC());
            }

            movesHistory.add(currentMove);

            // ======================
            // STOP CONDITION
            // ======================

            if ("MISS".equals(result)) {
                break;
            }

            if (humanBoard.isAllSunk()) {
                break;
            }
        }

        return movesHistory;
    }
}