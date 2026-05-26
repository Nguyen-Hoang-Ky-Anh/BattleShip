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
        if (room == null || room.getPhase() != GamePhase.BATTLE) return;

        Player player = room.getPlayers().get(attacker);
        if (player == null) return;

        BattleState battle = room.getBattleState();

        // 1. Kiểm tra lượt
        if (!battle.getCurrentTurn().equals(attacker)) {
            send(player.getSession(), "ERROR|Not your turn");
            return;
        }

        String opponent = getOpponent(room, attacker);
        Board enemyBoard = battle.getPlayerBoards().get(opponent);

        if(enemyBoard == null) return;

        if (enemyBoard.wasShot(row, col)) {
            send(player.getSession(), "ERROR|Already shot");
            return;
        }

        // 2. Lấy kết quả bắn
        String result = enemyBoard.handleShot(row, col);

        if (result.equals("INVALID") || result.equals("ALREADY_SHOT")) {
            send(player.getSession(), "ERROR|" + result);
            return;
        }

        //2: Lưu lịch sử.
        battle.getShotHistory().add(
                attacker + "|" + row + "|" + col + "|" + result
        );

        // 3. Xử lý Game Over & Đổi lượt
        boolean isGameOver = enemyBoard.isAllSunk();
        if (isGameOver) {
            battle.setWinner(attacker);
            room.setPhase(GamePhase.FINISHED);
            MatchHistoryService.saveMatchResult(room,attacker,opponent);
        } else {
            if (result.equals("MISS")) {
                battle.setCurrentTurn(opponent);
            } else {
                battle.setCurrentTurn(attacker);
            }
        }

        String nextTurn = battle.getCurrentTurn();

        // 4. BROADCAST
        String updateMsg = String.format("BATTLE_UPDATE|%s|%d|%d|%s|%s|%b",
                attacker, row, col, result, nextTurn, isGameOver);

        broadcast(roomId, updateMsg);
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

    public static String getOpponent(
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

        if (json == null || json.isBlank()) {
            Board empty = new Board();
            empty.setShips(List.of());
            return empty;
        }

        Gson gson = new Gson();

        Type shipListType =
                new TypeToken<List<Ship>>() {}.getType();

        List<Ship> ships =
                gson.fromJson(json, shipListType);

        if (ships == null) ships = List.of();

        for (Ship ship : ships) {
            ship.initializeHealth();
        }

        Board board = new Board();

        for (Ship ship : ships) {
            for (Position pos : ship.getCells()) {
                int row = pos.getR();
                int col = pos.getC();
                board.getGrid()[row][col].setShip(ship);
            }
        }

        board.setShips(ships);
        board.rebuildGrid();

        return board;
    }
}
