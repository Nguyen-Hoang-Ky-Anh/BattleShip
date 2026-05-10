package controllers;

import com.google.gson.Gson;
import dto.AttackRequest;
import dto.AttackResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.GameManager;
import models.GameSession;
import services.BattlePveService;
import services.BattleService;

import java.io.IOException;
import java.io.BufferedReader;

@WebServlet("/battle-pve")
public class BattlePveController extends HttpServlet {

    private final Gson gson = new Gson();
    private final BattlePveService battlePVEService = new BattlePveService();

    // =========================
    // LOAD PAGE
    // =========================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/layout/battle-pve.jsp"
        ).forward(request, response);
    }

    // =========================
    // ATTACK API
    // =========================
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        AttackRequest req = gson.fromJson(
                readBody(request),
                AttackRequest.class
        );

        GameSession game = GameManager.get(req.gameId);

        if (game == null) {
            response.sendError(404, "Game not found");
            return;
        }

        AttackResponse result =
                battlePVEService.playerAttack(
                        game,
                        req.row,
                        req.col
                );

        writeJson(response, result);
    }

    // =========================
    // UTIL
    // =========================
    private void writeJson(HttpServletResponse response,
                           Object data) throws IOException {

        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(data));
    }

    private String readBody(HttpServletRequest request)
            throws IOException {

        StringBuilder sb = new StringBuilder();
        BufferedReader br = request.getReader();

        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }

        return sb.toString();
    }
}