package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Room;
import models.RoomManager;

import java.io.IOException;

@WebServlet("/ship-placement")
public class ShipPlacementController extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        String roomId =
                req.getParameter("roomId");

        String userId =
                req.getParameter("userId");

        if (roomId == null || userId == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/pvp"
            );

            return;
        }

        Room room =
                RoomManager.getRoom(roomId);

        if (room == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/pvp"
            );

            return;
        }

        req.setAttribute("roomId", roomId);
        req.setAttribute("userId", userId);

        req.setAttribute(
                "rows",
                room.getRows()
        );

        req.setAttribute(
                "cols",
                room.getCols()
        );

        req.getRequestDispatcher(
                "/WEB-INF/layout/ship-placement.jsp"
        ).forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy session hiện tại
        jakarta.servlet.http.HttpSession session = req.getSession();
        
        // Lấy bàn cờ từ session (nếu chưa có thì tạo mới)
        models.Board board = (models.Board) session.getAttribute("playerBoard");
        if (board == null) {
            board = new models.Board();
        }

        try {
            // Nhận dữ liệu do giao diện (JSP/JS) gửi lên
            String shipId = req.getParameter("shipId");
            int size = Integer.parseInt(req.getParameter("size"));
            int row = Integer.parseInt(req.getParameter("row"));
            int col = Integer.parseInt(req.getParameter("col"));
            boolean isHorizontal = Boolean.parseBoolean(req.getParameter("horizontal"));

            // Tạo tàu và gọi hàm đặt tàu của UC-09
            models.Ship ship = new models.Ship(shipId, size);
            boolean success = board.placeShip(ship, row, col, isHorizontal);

            if (success) {
                // Đặt thành công -> Lưu lại bàn cờ vào session
                session.setAttribute("playerBoard", board);
                resp.getWriter().write("SUCCESS");
            } else {
                // Đặt thất bại (bị đè hoặc tràn viền)
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("INVALID_PLACEMENT");
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("ERROR: " + e.getMessage());
        }
    }
}