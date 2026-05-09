package controllers;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Room;
import services.RoomManager;

import java.io.IOException;

@WebServlet("/room")
public class RoomController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // [UC-08] Join PvP Room
        // [UC-08][Step 2] User thực hiện UC-08.1 (Provide Room Info)

        String roomId = req.getParameter("roomId");
        String userId = req.getParameter("userId");

        // [UC-08.1][Step 3] System nhận thông tin Room ID / userId
        // [UC-08.1][Alt 3.1] Invalid Format → thiếu hoặc rỗng dữ liệu
        if (roomId == null || userId == null ||
                roomId.isEmpty() || userId.isEmpty()) {

            // [UC-08][Alt 7.1] Room Not Found / Input invalid
            // → redirect về bước nhập lại (Create/Join UI)
            resp.sendRedirect(req.getContextPath() + "/create-room");
            return;
        }

        // [UC-08][Step 3] System kiểm tra room (tồn tại)
        if (!RoomManager.exists(roomId)) {

            // [UC-08][Alt 7.1] Room Not Found
            resp.sendRedirect(req.getContextPath() + "/create-room");
            return;
        }

        // [UC-08.2][Step 1] System kiểm tra room hợp lệ
        Room room = RoomManager.getRoom(roomId);

        // [UC-08.2][Step 2] Chuẩn bị thêm user vào room (context data)
        req.setAttribute("roomId", roomId);
        req.setAttribute("userId", userId);

        // [UC-08][Step 5] System đồng bộ trạng thái phòng (board size)
        req.setAttribute("rows", room.getRows());
        req.setAttribute("cols", room.getCols());

        RequestDispatcher dispatcher =
                req.getRequestDispatcher("/WEB-INF/layout/room.jsp");

        // [UC-08][Postconditions]
        // - User vào phòng thành công
        // - Trạng thái phòng được hiển thị
        dispatcher.forward(req, resp);
    }
}