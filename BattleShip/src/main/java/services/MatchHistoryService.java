package services;

import dao.MatchDao;
import dao.PlayerStatsDao;
import models.MatchHistory;
import models.Room;

/**
 * Service điều phối việc lưu kết quả trận đấu vào database.
 * Được gọi từ BattleService khi game kết thúc (GAME_OVER).
 */
public class MatchHistoryService {

    private static final MatchDao matchDao       = new MatchDao();
    private static final PlayerStatsDao playerStatsDao = new PlayerStatsDao();
    // Lưu kết quả trận đấu — gọi từ BattleService

    //lưu lịch sử trận đấu
    public static void saveMatchResult(Room room, String winner, String loser) {

        try {
            // Đếm tổng số lượt bắn trong trận
            int totalShots = 0;
            if (room.getBattleState() != null
                    && room.getBattleState().getShotHistory() != null) {
                totalShots = room.getBattleState().getShotHistory().size();
            }

            //Lưu vào match_history
            MatchHistory match = new MatchHistory(room.getRoomId(),winner, loser, totalShots);
            matchDao.saveMatch(match);

            //Sau đó cập nhật player_stats cho winner
            // shots của winner ≈ tổng shots / 2 (xấp xỉ)
            int winnerShots = (int) Math.ceil(totalShots / 2.0);
            int loserShots  = totalShots - winnerShots;

            playerStatsDao.updateStats(winner, true,  winnerShots);
            playerStatsDao.updateStats(loser,  false, loserShots);

            System.out.println(
                    "[MatchHistoryService] Đã lưu trận: " +
                            winner + " thắng " + loser +
                            " (" + totalShots + " shots)"
            );

        } catch (Exception e) {
            // Không để lỗi DB làm crash game
            System.err.println("[MatchHistoryService] Lỗi khi lưu kết quả: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
