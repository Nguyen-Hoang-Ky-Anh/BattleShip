package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/pre-game/*")
public class PreGameController extends HttpServlet {

    // =========================
    // SELECT DIFFICULTY PAGE
    // =========================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String action =
                request.getPathInfo();

        if (action == null) {

            request.getRequestDispatcher(
                    "/WEB-INF/layout/select-difficult.jsp"
            ).forward(request, response);

            return;
        }

        switch (action) {

            case "/easy":
            case "/normal":
            case "/hard":

                HttpSession session =
                        request.getSession();

                session.setAttribute(
                        "aiDifficulty",
                        action.substring(1)
                );

                response.sendRedirect(
                        request.getContextPath()
                                + "/ship-placement-pve"
                );

                break;

            default:

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND
                );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {
        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Use /ship-placement-pve instead"
        );
    }
}