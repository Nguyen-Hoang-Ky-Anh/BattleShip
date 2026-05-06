package controllers;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.RoomManager;

import java.io.IOException;

@WebServlet("/create-room")
public class CreateRoomController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/layout/create-room.jsp");
        dispatcher.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String hostId = req.getParameter("userId");

        if (hostId == null || hostId.trim().isEmpty()) {
            resp.sendRedirect("create-room");
            return;
        }

        String boardSize = req.getParameter("boardSize");
        if (boardSize == null || !boardSize.matches("\\d+x\\d+")) {
            boardSize = "10x10";
        }

        String[] parts = boardSize.split("x");
        int rows = Integer.parseInt(parts[0]);
        int cols = Integer.parseInt(parts[1]);

        if (rows < 5 || cols < 5 || rows > 15 || cols > 15) {
            rows = 10;
            cols = 10;
        }

        req.setAttribute("rows", rows);
        req.setAttribute("cols", cols);

        String roomId = RoomManager.createRoom(hostId, rows, cols);

        resp.sendRedirect(
                req.getContextPath() +
                        "/room?roomId=" + roomId + "&userId=" + hostId
        );
    }
}