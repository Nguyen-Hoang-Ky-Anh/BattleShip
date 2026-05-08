package controllers;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import models.User;
import services.UserService;

import java.io.IOException;

@WebServlet(name = "LoginController", value = "/login")
public class LoginController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mode = request.getParameter("mode");

        if(mode == null){
            mode = "login";
        }

        request.setAttribute("mode", mode);

        request.getRequestDispatcher("/WEB-INF/layout/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action =
                request.getParameter("action");

        // ================= REGISTER =================
        if(action.equals("register")){

            String username =
                    request.getParameter("username");

            String email =
                    request.getParameter("email");

            String password =
                    request.getParameter("password");

            User user = new User(
                    1,
                    username,
                    email,
                    password
            );

            boolean success =
                    userService.register(user);

            if(success){

                request.setAttribute(
                        "message",
                        "Register success!"
                );

                request.setAttribute(
                        "mode",
                        "login"
                );

            }else{

                request.setAttribute(
                        "message",
                        "Email already exists!"
                );

                request.setAttribute(
                        "mode",
                        "register"
                );
            }

            request.getRequestDispatcher(
                    "/WEB-INF/layout/login.jsp"
            ).forward(request, response);
        }

        // ================= LOGIN =================
        else if(action.equals("login")){

            String email =
                    request.getParameter("email");

            String password =
                    request.getParameter("password");

            User user =
                    userService.authenticate(
                            email,
                            password
                    );

            if(user != null){

                HttpSession session =
                        request.getSession();

                session.setAttribute(
                        "user",
                        user
                );

                response.sendRedirect(
                        request.getContextPath()
                                + "/home"
                );

            }else{

                request.setAttribute(
                        "message",
                        "Wrong email or password!"
                );

                request.setAttribute(
                        "mode",
                        "login"
                );

                request.getRequestDispatcher(
                        "/WEB-INF/layout/login.jsp"
                ).forward(request, response);
            }
        }
    }
}