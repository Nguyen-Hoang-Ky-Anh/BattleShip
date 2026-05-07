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
}