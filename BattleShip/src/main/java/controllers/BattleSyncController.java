package controllers;

import com.google.gson.Gson;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.BattleState;
import models.Player;
import models.Room;
import services.BattleService;
import services.RoomManager;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/battle-sync")
public class BattleSyncController extends HttpServlet {
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String roomId = req.getParameter("roomId");
        String username = req.getParameter("userId");

        if (roomId == null || username == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Room room = RoomManager.getRoom(roomId);

        if (room == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        BattleState battle = room.getBattleState();

        if (battle == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String enemy = BattleService.getOpponent(room, username);

        if (enemy == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Map<String, Object> result = new HashMap<>();

        result.put("myBoard",
                battle.getPlayerBoards().get(username).toSimpleGrid());

        result.put("enemyBoard",
                battle.getPlayerBoards().get(enemy).toFogGrid());

        result.put("turn", battle.getCurrentTurn());

        resp.setContentType("application/json");
        resp.getWriter().write(gson.toJson(result));
    }
}
