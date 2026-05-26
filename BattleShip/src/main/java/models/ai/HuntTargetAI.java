package models.ai;

import models.Board;
import models.Position;

import java.util.*;

public class HuntTargetAI implements AIStrategy{

    private final Random random = new Random();
    private final Queue<Position> targetQueue = new LinkedList<>();
    private static final int SIZE = 10;

    // Track thông tin để xác định hướng
    private Position firstHit = null;      // Ô HIT đầu tiên
    private Position lastHit = null;       // Ô HIT gần nhất
    private boolean directionFound = false; // Đã xác định hướng chưa

    @Override
    public Position nextMove(Board enemyBoard) {
        while (!targetQueue.isEmpty()) {
            Position pos = targetQueue.poll();
            int r = pos.getR();
            int c = pos.getC();
            if (isValid(r, c) && !enemyBoard.wasShot(r, c)) {
                return pos;
            }
        }

        // HUNT MODE
        while (true) {
            int r = random.nextInt(SIZE);
            int c = random.nextInt(SIZE);

            if ((r + c) % 2 != 0) continue;

            if (!enemyBoard.wasShot(r, c)) {
                return new Position(r, c);
            }
        }
    }

    @Override
    public void onShotResult(Position pos, String result) {
        if (result.equals("HIT")) {
            if (firstHit == null) {
                // HIT đầu tiên → thêm 4 hướng bình thường
                firstHit = pos;
                lastHit = pos;
                directionFound = false;
                addAllDirections(pos);

            } else {
                // HIT thứ 2 trở đi → đã biết hướng
                // Xác định hướng từ firstHit → pos
                int dr = pos.getR() - lastHit.getR();
                int dc = pos.getC() - lastHit.getC();
                lastHit = pos;
                directionFound = true;

                // Chỉ thêm 2 ô đầu/cuối theo đúng hướng, clear hướng khác
                targetQueue.clear();

                // Tiếp tục theo hướng hiện tại
                addTarget(pos.getR() + dr, pos.getC() + dc);

                // Hướng ngược lại từ firstHit (phòng trường hợp bắn từ giữa)
                int oppDr = firstHit.getR() - dr;
                int oppDc = firstHit.getC() - dc;
                addTarget(oppDr, oppDc);
            }

        } else if (result.equals("SUNK")) {
            // Reset toàn bộ khi đánh chìm
            targetQueue.clear();
            firstHit = null;
            lastHit = null;
            directionFound = false;
        }
    }
    private void addAllDirections(Position pos) {
        int r = pos.getR();
        int c = pos.getC();
        addTarget(r - 1, c);
        addTarget(r + 1, c);
        addTarget(r, c - 1);
        addTarget(r, c + 1);
    }
    private void addTarget(int r, int c) {
        if (isValid(r, c)) {
            targetQueue.offer(new Position(r, c));
        }
    }

    private boolean isValid(int r, int c) {
        return r >= 0 && r < SIZE && c >= 0 && c < SIZE;
    }
    }

