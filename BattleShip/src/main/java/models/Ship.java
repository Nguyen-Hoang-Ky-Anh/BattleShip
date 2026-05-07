package models;

public class Ship {
	private String id;
	private int size;
	private int health;

	public Ship(String id, int size) {
		this.id = id;
		this.size = size;
		this.health = size;
	}

	public void decreaseHealth() {
		if (health > 0)
			health--;
	}

	public boolean isSunk() {
		return health <= 0;
	}

	public int getSize() {
		return size;
	}

	public String getId() {
		return id;
	}
}