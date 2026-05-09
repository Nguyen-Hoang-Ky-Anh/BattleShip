package models.ai;

import models.Board;
import models.Cell;
import models.Position;

import java.util.HashSet;
import java.util.Random;
import java.util.Set;

public class RandomAI implements AIStrategy {

    private final Random random = new Random();
    private final Set<String> attackedPositions = new HashSet<>();
    private Position lastHit;

    @Override
    public Position nextMove(Board enemyBoard) {

        int row;
        int col;

        Cell[][] grid = enemyBoard.getGrid();

        do {

            row = random.nextInt(grid.length);

            col = random.nextInt(grid[0].length);

        } while(attackedPositions.contains(key(row, col)));

        return new Position(row, col);
    }

    @Override
    public void onShotResult(Position pos, String result) {

        // đánh dấu đã bắn
        attackedPositions.add(
                key(pos.getR(), pos.getC())
        );

        // lưu hit gần nhất
        if("HIT".equals(result) || "SUNK".equals(result)) {

            lastHit = pos;

        } else {

            lastHit = null;
        }
    }

    private String key(int row, int col) {

        return row + "-" + col;
    }

    public Position getLastHit() {

        return lastHit;
    }
}