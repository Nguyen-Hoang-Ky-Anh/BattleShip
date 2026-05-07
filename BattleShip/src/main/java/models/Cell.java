package models;

public class Cell {
	private int row;
	private int col;
	private int state; // 0: EMPTY, 1: SHIP, 2: MISS, 3: HIT
	private Ship ship;

	public Cell(int row, int col) {
		this.row = row;
		this.col = col;
		this.state = 0;
	}

	public boolean hasShip() {
		return ship != null;
	}

	public void updateState(int newState) {
		this.state = newState;
	}

	public void setShip(Ship ship) {
		this.ship = ship;
		this.state = 1;
	}

	public Ship getShip() {
		return ship;
	}

	public int getState() {
		return state;
	}
}