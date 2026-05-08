package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Room;
import services.RoomManager;

import java.io.IOException;

@WebServlet("/battle")
public class BattleController extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        String roomId = req.getParameter("roomId");
        String userId = req.getParameter("userId");

        Room room = RoomManager.getRoom(roomId);

        if (room == null) {
            resp.sendRedirect(req.getContextPath() + "/pvp");
            return;
        }

        req.setAttribute("roomId", roomId);
        req.setAttribute("userId", userId);

        req.getRequestDispatcher(
                "/WEB-INF/layout/battle.jsp"
        ).forward(req, resp);
    }
}
