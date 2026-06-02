package controllers;

import com.google.gson.Gson;
import dto.StartGameRequest;
import dto.ShipDTO;
import dto.CellDTO;
import dto.StartGameResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.websocket.Session;
import models.*;
import models.ai.*;
import services.AIPlacementService;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;

@WebServlet("/ship-placement-pve")
public class ShipPlacementPveController extends HttpServlet {

    private final Gson gson = new Gson();

    // =========================
    // LOAD PAGE
    // =========================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/layout/ship-placement-pve.jsp"
        ).forward(request, response);
    }

    // =========================
    // START GAME
    // =========================
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        StartGameRequest req =
                gson.fromJson(
                        readBody(request),
                        StartGameRequest.class
                );

        // =========================
        // HUMAN
        // =========================
        Player human =
                new Player("Player", (Session) null);

        Board humanBoard =
                buildHumanBoard(req.ships);

        human.setBoard(humanBoard);

        // =========================
        // AI
        // =========================
        // =========================
        // AI Theo option
        // =========================
        HttpSession session = request.getSession();
        AIStrategy strategy =   null;
        String difficult = (String) session.getAttribute("aiDifficulty").toString();
        if(difficult == null){
            difficult = "easy";
        }
        switch (difficult) {
            case "easy":
                strategy =  new RandomAI();
                break;
            case "normal":
                strategy =  new HuntTargetAI();
                break;
            case "hard":
                strategy = new ProbabilityAI();
                break;
            default:
                System.out.println("Invalid AiDifficulty");

        }


        Player ai = new Player("BOT", strategy);

        Board aiBoard =
                AIPlacementService.generateRandomBoard();

        ai.setBoard(aiBoard);

        // =========================
        // GAME SESSION
        // =========================
        GameSession game =
                new GameSession(human, ai);

        String gameId =
                GameManager.create(game);

        // =========================
        // RESPONSE
        // =========================
        response.setContentType("application/json");

        response.getWriter().write(
                gson.toJson(
                        new StartGameResponse(true, gameId)
                )
        );
    }

    // =========================
    // BUILD HUMAN BOARD
    // =========================
    private Board buildHumanBoard(
            List<ShipDTO> ships
    ) {

        Board board = new Board();

        for (ShipDTO s : ships) {

            Ship ship =
                    new Ship(
                            s.name,
                            s.size
                    );

            for (CellDTO c : s.cells) {

                ship.getCells().add(
                        new Position(c.r, c.c)
                );
            }

            board.getShips().add(ship);
        }

        board.rebuildGrid();

        return board;
    }

    // =========================
    // READ BODY
    // =========================
    private String readBody(
            HttpServletRequest request
    ) throws IOException {

        StringBuilder sb =
                new StringBuilder();

        BufferedReader reader =
                request.getReader();

        String line;

        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        return sb.toString();
    }
}