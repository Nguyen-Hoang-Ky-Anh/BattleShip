package dao;

import config.DatabaseConfig;
import models.PlayerStats;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object cho bảng `player_stats`.
 * Chịu trách nhiệm đọc/cập nhật thống kê người chơi.
 */
public class PlayerStatsDao {

    // =========================================================
    // UPSERT — Cập nhật thống kê sau mỗi trận (INSERT hoặc UPDATE)
    // =========================================================

    /**
     * Cập nhật thống kê của người chơi sau khi trận kết thúc.
     * Nếu người chơi chưa có record → INSERT mới.
     * Nếu đã có → UPDATE (cộng dồn).
     *
     * @param username  Tên người chơi
     * @param isWinner  true nếu người này thắng
     * @param shots     Số lượt bắn của người này trong trận
     */
    public void updateStats(String username, boolean isWinner, int shots) {

        // MySQL ON DUPLICATE KEY UPDATE: nếu username đã tồn tại thì cộng dồn
        String sql = """
            INSERT INTO player_stats (username, wins, losses, total_shots, updated_at) VALUES (?, ?, ?, ?, NOW()) ON DUPLICATE KEY UPDATE
                wins = wins + VALUES(wins),
                losses = losses + VALUES(losses),
                total_shots = total_shots + VALUES(total_shots),
                updated_at  = NOW()
            """;

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setInt   (2, isWinner ? 1 : 0);
            ps.setInt   (3, isWinner ? 0 : 1);
            ps.setInt   (4, shots);

            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("[PlayerStatsDao] updateStats thất bại: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // =========================================================
    // SELECT — Lấy bảng xếp hạng top N người chơi
    // =========================================================

    /**
     * Lấy top N người chơi sắp xếp theo số lần thắng giảm dần.
     * Cùng số thắng thì ưu tiên tỷ lệ thắng cao hơn.
     *
     * @param limit số lượng người tối đa muốn lấy (VD: 10)
     */
    public List<PlayerStats> getLeaderboard(int limit) {

        String sql = """
            SELECT username, wins, losses, total_shots, updated_at
            FROM player_stats
            ORDER BY wins DESC,
                     (wins / (wins + losses + 0.0001)) DESC
            LIMIT ?
            """;

        List<PlayerStats> list = new ArrayList<>();

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("[PlayerStatsDao] getLeaderboard thất bại: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return list;
    }

    // =========================================================
    // SELECT — Lấy thống kê của 1 người chơi cụ thể
    // =========================================================

    public PlayerStats getStatsByUsername(String username) {

        String sql = """
            SELECT username, wins, losses, total_shots, updated_at
            FROM player_stats
            WHERE username = ?
            """;

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("[PlayerStatsDao] getStatsByUsername thất bại: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        // Nếu chưa có record trong DB, trả về stats mặc định
        return new PlayerStats(username);
    }

    // =========================================================
    // Helper — Map ResultSet row sang PlayerStats object
    // =========================================================

    private PlayerStats mapRow(ResultSet rs) throws SQLException {
        PlayerStats s = new PlayerStats();
        s.setUsername   (rs.getString("username"));
        s.setWins       (rs.getInt   ("wins"));
        s.setLosses     (rs.getInt   ("losses"));
        s.setTotalShots (rs.getInt   ("total_shots"));

        Timestamp ts = rs.getTimestamp("updated_at");
        if (ts != null) {
            s.setUpdatedAt(ts.toLocalDateTime());
        }

        return s;
    }
}
