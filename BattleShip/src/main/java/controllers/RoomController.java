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

        String roomId = req.getParameter("roomId");
        String userId = req.getParameter("userId");

        if (roomId == null || userId == null ||
                roomId.isEmpty() || userId.isEmpty()) {

            resp.sendRedirect(req.getContextPath() + "/create-room");
            return;
        }

         if (!RoomManager.exists(roomId)) {
             resp.sendRedirect(req.getContextPath() + "/create-room");
             return;
         }

        Room room = RoomManager.getRoom(roomId);

        req.setAttribute("roomId", roomId);
        req.setAttribute("userId", userId);

        req.setAttribute("rows", room.getRows());
        req.setAttribute("cols", room.getCols());

        RequestDispatcher dispatcher =
                req.getRequestDispatcher("/WEB-INF/layout/room.jsp");

        dispatcher.forward(req, resp);
    }
}