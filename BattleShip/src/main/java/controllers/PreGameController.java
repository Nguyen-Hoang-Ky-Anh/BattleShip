package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Room;
import models.RoomManager;

import java.io.IOException;

@WebServlet("/pre-game/*")
public class PreGameController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo();
        if (action == null || action.isEmpty()) {
            request.getRequestDispatcher("/WEB-INF/layout/select-difficult.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "/easy":
                request.getRequestDispatcher("/WEB-INF/layout/ship-placement.jsp").forward(request, response);
                break;
            case "/normal":
                request.getRequestDispatcher("/WEB-INF/layout/ship-placement.jsp").forward(request, response);
                break;
            case "/hard":
                request.getRequestDispatcher("/WEB-INF/layout/ship-placement.jsp").forward(request, response);
                break;
            case "/back":
                response.sendRedirect(request.getContextPath()+"/index.jsp");
                break;
            default:
                System.out.println("Error DoGet" + action);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        switch (action) {
            case "":

            default:
                System.out.println("Error DoGet" + action);
        }
    }
}