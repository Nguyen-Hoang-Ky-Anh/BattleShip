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

        // Lấy user từ session (nếu đã đăng nhập)
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        List<MatchHistory> matches;

        if (currentUser != null) {
            // Người dùng đã đăng nhập, lấy lịch sử của họ
            matches = matchDao.getMatchesByPlayer(currentUser.getUsername());
            request.setAttribute("viewingUsername", currentUser.getUsername());
        } else {
            // Chưa đăng nhập, lấy toàn bộ lịch sử
            matches = matchDao.getAllMatches();
            request.setAttribute("viewingUsername", null);
        }

        request.setAttribute("matches", matches);

        request.getRequestDispatcher(
                "/WEB-INF/component/history.jsp"
        ).forward(request, response);
    }
}
