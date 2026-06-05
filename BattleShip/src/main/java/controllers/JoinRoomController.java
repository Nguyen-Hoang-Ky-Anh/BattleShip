package controllers;

import dto.RoomPreview;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import services.RoomManager;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

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

        String roomId = req.getParameter("roomId");

        if (roomId != null && RoomManager.canJoin(roomId)) {

            String userId =
                    (String) req.getSession().getAttribute("userId");

            if (userId == null || userId.isBlank()) {
                userId = "Guest-" + UUID.randomUUID().toString().substring(0, 8);
                req.getSession().setAttribute("userId", userId);
            }

            resp.sendRedirect(
                    req.getContextPath()
                            + "/room?roomId="
                            + roomId
                            + "&userId="
                            + userId
            );
            return;
        }

        req.setAttribute(
                "availableRooms",
                RoomManager.getAvailableRooms()
        );

        req.getRequestDispatcher("/WEB-INF/layout/join-room.jsp")
                .forward(req, resp);
    }
}