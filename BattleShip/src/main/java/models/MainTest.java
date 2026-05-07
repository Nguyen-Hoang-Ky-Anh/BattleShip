package models;

public class MainTest {
    public static void main(String[] args) {
        Board myBoard = new Board();
        Ship patrolBoat = new Ship("Patrol", 2);

        // Test UC-09: Đặt tàu ngang tại (0,0)
        boolean p1 = myBoard.placeShip(patrolBoat, 0, 0, true);
        System.out.println("Place Ship (0,0) Horizontal: " + (p1 ? "PASS" : "FAIL"));

        // Test UC-10/11: Bắn tàu
        System.out.println("Shot at (0,0): " + myBoard.handleShot(0, 0)); // HIT
        System.out.println("Shot at (0,1): " + myBoard.handleShot(0, 1)); // SUNK (vì size=2)
        System.out.println("Shot at (5,5): " + myBoard.handleShot(5, 5)); // MISS
        
        System.out.println("Game Over? " + myBoard.isAllSunk()); // TRUE
    }
}