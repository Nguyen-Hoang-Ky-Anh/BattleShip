package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.RoomManager;

import java.io.IOException;

@WebServlet("/join-room")
public class JoinRoomController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String userId = req.getParameter("userId");
        String roomId = req.getParameter("roomId");

        if (userId == null || roomId == null) {
            resp.sendRedirect(req.getContextPath() + "/join-room");
            return;
        }

        userId = userId.trim();
        roomId = roomId.trim();

        if (userId.isEmpty() || roomId.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/join-room");
            return;
        }

        if (!RoomManager.exists(roomId)) {
            req.setAttribute("error", "Room not found");
            req.getRequestDispatcher("/WEB-INF/layout/join-room.jsp")
                    .forward(req, resp);
            return;
        }

        resp.sendRedirect(
                req.getContextPath() +
                        "/room?roomId=" + roomId + "&userId=" + userId
        );
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/layout/join-room.jsp")
                .forward(req, resp);
    }
}