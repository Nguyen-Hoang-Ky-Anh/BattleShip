package models.ai;

import models.Board;
import models.Position;

import java.util.*;

public class ProbabilityAI implements AIStrategy {

    private static final int SIZE = 10;

    private final Set<String> attackedPositions = new HashSet<>();
    private final List<Position> hitPositions = new ArrayList<>();

    @Override
    public Position nextMove(Board enemyBoard) {

        if (!hitPositions.isEmpty()) {
            Position target = chooseTargetMode(enemyBoard);

            if (target != null) {
                return target;
            }
        }

        return chooseProbabilityMove(enemyBoard);
    }

    @Override
    public void onShotResult(Position pos, String result) {

        attackedPositions.add(
                key(pos.getR(), pos.getC())
        );

        if ("HIT".equals(result)) {

            hitPositions.add(pos);

        } else if ("SUNK".equals(result)) {

            hitPositions.clear();
        }
    }

    private Position chooseProbabilityMove(Board board) {

        int bestScore = -1;
        Position bestPos = null;

        for (int r = 0; r < SIZE; r++) {

            for (int c = 0; c < SIZE; c++) {

                if (board.wasShot(r, c))
                    continue;

                int score = countAvailableNeighbors(board, r, c);

                if (score > bestScore) {

                    bestScore = score;
                    bestPos = new Position(r, c);
                }
            }
        }

        return bestPos;
    }

    private Position chooseTargetMode(Board board) {

        Position bestPos = null;
        int bestScore = -1;

        for (Position hit : hitPositions) {

            int r = hit.getR();
            int c = hit.getC();

            int[][] dirs = {
                    {-1,0},
                    {1,0},
                    {0,-1},
                    {0,1}
            };

            for (int[] d : dirs) {

                int nr = r + d[0];
                int nc = c + d[1];

                if (!isValid(nr,nc))
                    continue;

                if (board.wasShot(nr,nc))
                    continue;

                int score =
                        countDirection(board,nr,nc,d[0],d[1]);

                if(score > bestScore){

                    bestScore = score;
                    bestPos = new Position(nr,nc);
                }
            }
        }

        return bestPos;
    }

    private int countAvailableNeighbors(
            Board board,
            int r,
            int c
    ) {

        int score = 0;

        int[][] dirs = {
                {-1,0},
                {1,0},
                {0,-1},
                {0,1}
        };

        for (int[] d : dirs) {

            int nr = r + d[0];
            int nc = c + d[1];

            if (isValid(nr,nc)
                    && !board.wasShot(nr,nc)) {

                score++;
            }
        }

        return score;
    }

    private int countDirection(
            Board board,
            int r,
            int c,
            int dr,
            int dc
    ) {

        int score = 0;

        while (isValid(r,c)
                && !board.wasShot(r,c)) {

            score++;

            r += dr;
            c += dc;
        }

        return score;
    }

    private boolean isValid(int r,int c){

        return r >= 0
                && r < SIZE
                && c >= 0
                && c < SIZE;
    }

    private String key(int r,int c){

        return r + "-" + c;
    }
}