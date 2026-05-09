package services;

import models.Board;
import models.Ship;
import models.ShipFactory;

import java.util.List;
import java.util.Random;

public class AIPlacementService {
    private static final Random random = new Random();

    public static void placeShipsRandomly(Board board, List<Ship> ships) {
        for(Ship ship : ships) {
            boolean placed = false;
            while(!placed) {
                int row = random.nextInt(10);
                int col = random.nextInt(10);
                boolean horizontal = random.nextBoolean();
                placed =
                        board.placeShip(
                                ship,
                                row,
                                col,
                                horizontal
                        );
            }
        }
    }

    public static Board generateRandomBoard() {

        Board board = new Board();

        List<Ship> ships = ShipFactory.defaultShips();

        placeShipsRandomly(
                board,
                ships
        );

        return board;
    }
}
