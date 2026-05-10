package models;

import java.util.List;

public class ShipFactory {

    public static List<Ship> defaultShips() {

        return List.of(
                new Ship("Carrier", 5),
                new Ship("Battleship", 4),
                new Ship("Submarine", 3),
                new Ship("Destroyer", 2)
        );
    }
}
