package controllers;

import dao.PlayerStatsDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.PlayerStats;
import models.User;

import java.io.IOException;
import java.util.List;

/**
 * Servlet xử lý trang "Bảng xếp hạng".
 * URL: /leaderboard
 *
 * GET /leaderboard          → Top 10 người chơi
 * GET /leaderboard?limit=20 → Top N người chơi (tuỳ chỉnh)
 */
@WebServlet(name = "LeaderboardServlet", value = "/leaderboard")
public class LeaderboardServlet extends HttpServlet {

    private static final int DEFAULT_LIMIT = 10;
    private final PlayerStatsDao playerStatsDao = new PlayerStatsDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            request.setAttribute("isLocked", true);
        } else {
            request.setAttribute("isLocked", false);
        }

        int limit = DEFAULT_LIMIT;
        String limitParam = request.getParameter("limit");
        if (limitParam != null) {
            try {
                int parsed = Integer.parseInt(limitParam);
                if (parsed > 0 && parsed <= 100) {
                    limit = parsed;
                }
            } catch (NumberFormatException ignored) {
            }
        }

        List<PlayerStats> leaderboard = playerStatsDao.getLeaderboard(limit);

        request.setAttribute("leaderboard", leaderboard);
        request.setAttribute("limit", limit);

        request.getRequestDispatcher(
                "/WEB-INF/layout/leaderboard.jsp"
        ).forward(request, response);
    }
}
