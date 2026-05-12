package dao;

import config.DatabaseConfig;
import models.MatchHistory;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object cho bảng `match_history`.
 * Chịu trách nhiệm đọc/ghi lịch sử trận đấu vào DB.
 */
public class MatchDao {

    // =========================================================
    // INSERT — Lưu một trận đấu mới vào DB
    // =========================================================

    /**
     * Lưu kết quả trận đấu sau khi game kết thúc.
     * Gọi từ MatchHistoryService.saveMatchResult()
     */
    public void saveMatch(MatchHistory match) {

        String sql = """
            INSERT INTO match_history (room_id, winner, loser, total_shots, played_at)
            VALUES (?, ?, ?, ?, ?)
            """;

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, match.getRoomId());
            ps.setString(2, match.getWinner());
            ps.setString(3, match.getLoser());
            ps.setInt   (4, match.getTotalShots());
            ps.setTimestamp(5, Timestamp.valueOf(
                    match.getPlayedAt() != null ? match.getPlayedAt() : LocalDateTime.now()
            ));

            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("[MatchDao] saveMatch thất bại: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // =========================================================
    // SELECT — Lấy lịch sử của một người chơi
    // =========================================================

    /**
     * Lấy tất cả trận đấu có sự tham gia của username (cả thắng lẫn thua).
     * Sắp xếp mới nhất lên đầu.
     */
    public List<MatchHistory> getMatchesByPlayer(String username) {

        String sql = """
            SELECT id, room_id, winner, loser, total_shots, played_at FROM match_history WHERE winner = ? OR loser = ? ORDER BY played_at DESC""";

        List<MatchHistory> list = new ArrayList<>();

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, username);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("[MatchDao] getMatchesByPlayer thất bại: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return list;
    }

    // =========================================================
    // SELECT — Lấy toàn bộ lịch sử (dùng cho admin hoặc debug)
    // =========================================================

    public List<MatchHistory> getAllMatches() {

        String sql = """
            SELECT id, room_id, winner, loser, total_shots, played_at
            FROM match_history
            ORDER BY played_at DESC
            """;

        List<MatchHistory> list = new ArrayList<>();

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            System.err.println("[MatchDao] getAllMatches thất bại: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return list;
    }

    // =========================================================
    // Helper — Map một ResultSet row sang MatchHistory object
    // =========================================================

    private MatchHistory mapRow(ResultSet rs) throws SQLException {
        MatchHistory m = new MatchHistory();
        m.setId         (rs.getInt      ("id"));
        m.setRoomId     (rs.getString   ("room_id"));
        m.setWinner     (rs.getString   ("winner"));
        m.setLoser      (rs.getString   ("loser"));
        m.setTotalShots (rs.getInt      ("total_shots"));

        Timestamp ts = rs.getTimestamp("played_at");
        if (ts != null) {
            m.setPlayedAt(ts.toLocalDateTime());
        }

        return m;
    }
}
