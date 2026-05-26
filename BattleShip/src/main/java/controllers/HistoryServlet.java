package controllers;

import dao.MatchDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.MatchHistory;
import models.User;

import java.io.IOException;
import java.util.List;

/**
 * Servlet xử lý trang "Lịch sử trận đấu".
 * URL: /history
 */
@WebServlet(name = "HistoryServlet", value = "/history")
public class HistoryServlet extends HttpServlet {

    private final MatchDao matchDao = new MatchDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy user từ session
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            request.setAttribute("isLocked", true);
        } else {
            request.setAttribute("isLocked", false);
            List<MatchHistory> matches = matchDao.getMatchesByPlayer(currentUser.getUsername());
            request.setAttribute("viewingUsername", currentUser.getUsername());
            request.setAttribute("matches", matches);
        }

        request.getRequestDispatcher(
                "/WEB-INF/layout/history.jsp"
        ).forward(request, response);
    }
}
