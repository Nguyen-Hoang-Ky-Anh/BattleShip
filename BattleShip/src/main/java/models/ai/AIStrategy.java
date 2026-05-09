package models.ai;

import models.Board;
import models.Position;

public interface AIStrategy {
    Position nextMove(Board enemyBoard);
    void onShotResult(
            Position pos,
            String result
    );
}
