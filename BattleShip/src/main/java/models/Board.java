package models;

import java.util.ArrayList;
import java.util.List;

public class Board {
	private Cell[][] grid;
	private List<Ship> ships;
	private final int SIZE = 10;

	public Board() {
		grid = new Cell[SIZE][SIZE];
		ships = new ArrayList<>();
		for (int i = 0; i < SIZE; i++) {
			for (int j = 0; j < SIZE; j++) {
				grid[i][j] = new Cell(i, j);
			}
		}
	}

	// UC-09: Kiểm tra và đặt tàu
	public boolean placeShip(Ship ship, int row, int col, boolean isHorizontal) {
		int length = ship.getSize();
		if (isHorizontal) {
			if (col + length > SIZE)
				return false;
			for (int i = 0; i < length; i++)
				if (grid[row][col + i].hasShip())
					return false;
			for (int i = 0; i < length; i++)
				grid[row][col + i].setShip(ship);
		} else {
			if (row + length > SIZE)
				return false;
			for (int i = 0; i < length; i++)
				if (grid[row + i][col].hasShip())
					return false;
			for (int i = 0; i < length; i++)
				grid[row + i][col].setShip(ship);
		}
		ships.add(ship);
		return true;
	}

	// UC-10 & UC-11: Xử lý bắn và trả về kết quả
	public String handleShot(int row, int col) {
		if (row < 0 || row >= SIZE || col < 0 || col >= SIZE)
			return "INVALID";
		Cell cell = grid[row][col];
		if (cell.getState() > 1)
			return "ALREADY_SHOT";

		if (cell.hasShip()) {
            cell.updateState(Cell.HIT); // HIT
			Ship s = cell.getShip();
			s.decreaseHealth();
			return s.isSunk() ? "SUNK" : "HIT";
		} else {
			cell.updateState(Cell.MISS); // MISS
			return "MISS";
		}
	}

    public boolean isAllSunk() {
        if (ships == null || ships.isEmpty()) return false;
        return ships.stream().allMatch(Ship::isSunk);
    }

	public Cell[][] getGrid() {
		return grid;
	}

    public List<Ship> getShips() {
        return ships;
    }

    public void setShips(List<Ship> ships) {
        this.ships = ships;
    }

    public void rebuildGrid() {

        // reset grid
        grid = new Cell[SIZE][SIZE];

        for(int r = 0; r < SIZE; r++) {

            for(int c = 0; c < SIZE; c++) {

                grid[r][c] =
                        new Cell(r, c);
            }
        }

        // place ships into grid
        for(Ship ship : ships) {

            for(Position pos : ship.getCells()) {

                int r = pos.getR();
                int c = pos.getC();

                grid[r][c].setShip(ship);
            }
        }
    }

    public boolean wasShot(int row, int col) {

        Cell cell = grid[row][col];

        return cell.getState() == Cell.HIT
                || cell.getState() == Cell.MISS;
    }

    public String getShipNameAt(int r, int c) {
        Ship ship = this.getShipAt(r, c);
        if (ship != null) {
            return ship.getName();
        }
        return "Unknown Ship";
    }

    private Ship getShipAt(int r, int c) {
        for(Ship ship : ships) {
            List<Position> positions = ship.getCells();
            for (Position pos : positions) {
                if (pos.getR() == r && pos.getC() == c) {
                    return ship;
                }
            }
        }
        return null;
    }
}