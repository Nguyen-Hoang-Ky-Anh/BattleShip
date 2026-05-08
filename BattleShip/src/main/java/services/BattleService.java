package services;

import com.google.gson.Gson;
import enums.GamePhase;
import jakarta.websocket.Session;
import models.*;

import java.io.IOException;
import java.util.List;
import com.google.gson.reflect.TypeToken;
import models.Board;
import models.Ship;

import java.lang.reflect.Type;

public class BattleService {

    public static void confirmPlacement(
            String roomId,
            String username,
            Board board
    ) {

        Room room =
                RoomManager.getRoom(roomId);

        if(room == null) {
            return;
        }

        Player player =
                room.getPlayers().get(username);

        if(player == null) {
            return;
        }

        player.setBoard(board);

        player.setPlacementConfirmed(true);

        RoomManager.broadcast(
                roomId,
                "PLAYER_PLACED|" + username
        );

        boolean allPlaced =
                room.getPlayers()
                        .values()
                        .stream()
                        .allMatch(Player::isPlacementConfirmed);

        if(allPlaced) {

            startBattle(roomId);

            RoomManager.broadcast(
                    roomId,
                    "BATTLE_READY"
            );
        }
    }

    public static synchronized void startBattle(
            String roomId
    ) {
        Room room = RoomManager.getRoom(roomId);

        if (room == null) return;

        room.setPhase(GamePhase.BATTLE);

        BattleState battleState = new BattleState();

        battleState.setStarted(true);

        String firstTurn = room.getPlayers()
                .values()
                .iterator()
                .next()
                .getUsername();

        battleState.setCurrentTurn(firstTurn);

        for (Player p : room.getPlayers().values()) {

            battleState.getPlayerBoards()
                    .put(
                            p.getUsername(),
                            p.getBoard()
                    );
        }

        room.setBattleState(battleState);

        broadcast(
                roomId,
                "BATTLE_STARTED|" + firstTurn
        );
    }

    public static synchronized void attack(
            String roomId,
            String attacker,
            int row,
            int col
    ) {

        Room room = RoomManager.getRoom(roomId);

        if (room == null) return;

        if (room.getPhase() != GamePhase.BATTLE) {
            return;
        }

        BattleState battle =
                room.getBattleState();

        if (!battle.getCurrentTurn()
                .equals(attacker)) {

            send(
                    room.getSessions().get(attacker),
                    "ERROR|Not your turn"
            );

            return;
        }

        String opponent =
                getOpponent(room, attacker);

        Board enemyBoard =
                battle.getPlayerBoards()
                        .get(opponent);

        String result =
                enemyBoard.handleShot(row, col);

        broadcast(
                roomId,
                "SHOT_RESULT|"
                        + attacker + "|"
                        + row + "|"
                        + col + "|"
                        + result
        );

        // ================= GAME OVER =================

        if (enemyBoard.isAllSunk()) {

            battle.setWinner(attacker);

            room.setPhase(GamePhase.FINISHED);

            broadcast(
                    roomId,
                    "GAME_OVER|" + attacker
            );

            return;
        }

        // ================= SWITCH TURN =================

        battle.setCurrentTurn(opponent);

        broadcast(
                roomId,
                "TURN_CHANGED|" + opponent
        );
    }

    // =========================================================
    // BROADCAST
    // =========================================================

    public static void broadcast(
            String roomId,
            String msg
    ) {

        Room room = RoomManager.getRoom(roomId);

        if (room == null) return;

        for (Session session :
                room.getSessions().values()) {

            send(session, msg);
        }
    }

    // =========================================================
    // SEND
    // =========================================================

    private static void send(
            Session session,
            String msg
    ) {

        try {

            if (session != null
                    && session.isOpen()) {

                session.getBasicRemote()
                        .sendText(msg);
            }

        } catch (IOException e) {

            e.printStackTrace();
        }
    }

    // =========================================================
    // GETTER
    // =========================================================

    private static String getOpponent(
            Room room,
            String username
    ) {

        for (String player :
                room.getPlayers().keySet()) {

            if (!player.equals(username)) {
                return player;
            }
        }

        return null;
    }

    public static Board parseBoard(String json) {

        Gson gson = new Gson();

        Type shipListType =
                new TypeToken<List<Ship>>() {}.getType();

        List<Ship> ships =
                gson.fromJson(json, shipListType);

        Board board = new Board();

        board.setShips(ships);

        return board;
    }
}
