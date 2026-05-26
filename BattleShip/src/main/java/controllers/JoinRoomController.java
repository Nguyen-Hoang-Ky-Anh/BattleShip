package controllers;

import dto.RoomPreview;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import services.RoomManager;

import java.io.IOException;
import java.util.List;

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

        if (!RoomManager.canJoin(roomId)) {

            req.setAttribute(
                    "error",
                    "Room unavailable"
            );

            List<RoomPreview> availableRooms =
                    RoomManager.getAvailableRooms();

            req.setAttribute(
                    "availableRooms",
                    availableRooms
            );

            req.getRequestDispatcher(
                    "/WEB-INF/layout/join-room.jsp"
            ).forward(req, resp);

            return;
        }

        req.getSession().setAttribute("userId", userId);

        resp.sendRedirect(
                req.getContextPath() +
                        "/room?roomId=" + roomId + "&userId=" + userId
        );
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<RoomPreview> availableRooms = RoomManager.getAvailableRooms();
        req.setAttribute("availableRooms", availableRooms);

        req.getRequestDispatcher("/WEB-INF/layout/join-room.jsp")
                .forward(req, resp);
    }
}