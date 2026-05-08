package models;

import java.util.ArrayList;
import java.util.List;

public class Ship {

    private String name;

    private int size;

    private int health;

    private String direction;

    private List<Position> cells =
            new ArrayList<>();


    // =====================================================
    // CONSTRUCTORS
    // =====================================================

    public Ship() {
    }

    public Ship(
            String name,
            int size
    ) {

        this.name = name;
        this.size = size;
        this.health = size;
    }


    // =====================================================
    // GAME LOGIC
    // =====================================================

    public void initializeHealth() {

        this.health = this.size;
    }

    public void decreaseHealth() {

        if (health > 0) {
            health--;
        }
    }

    public boolean isSunk() {

        return health <= 0;
    }


    // =====================================================
    // GETTERS / SETTERS
    // =====================================================

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {

        this.size = size;

        this.health = size;
    }

    public int getHealth() {
        return health;
    }

    public void setHealth(int health) {
        this.health = health;
    }

    public String getDirection() {
        return direction;
    }

    public void setDirection(
            String direction
    ) {
        this.direction = direction;
    }

    public List<Position> getCells() {
        return cells;
    }

    public void setCells(
            List<Position> cells
    ) {
        this.cells = cells;
    }
}