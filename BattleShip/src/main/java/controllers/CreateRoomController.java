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

        String roomId = RoomManager.createRoom(hostId);

        resp.setContentType("text/plain");
        resp.getWriter().write(roomId);
    }
}