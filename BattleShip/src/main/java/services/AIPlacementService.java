package services;

import models.Board;
import models.Ship;
import models.ShipFactory;

import java.util.List;
import java.util.Random;

public class AIPlacementService {
    private static final Random random = new Random();

    public static void placeShipsRandomly(Board board, List<Ship> ships) {
        System.out.println("=== BẮT ĐẦU AUTO-PLACEMENT CHIẾN HẠM ===");

        for(Ship ship : ships) {
            boolean placed = false;
            int attempts = 0;
            int maxAttempts = 100;

            System.out.println("\n[*] Đang tìm vị trí cho tàu: " + ship.getName() + " (Độ dài: " + ship.getSize() + ")");

            while(!placed && attempts < maxAttempts) {
                boolean horizontal = random.nextBoolean();
                int length = ship.getSize();

                int maxRow = horizontal ? 10 : 10 - length + 1;
                int maxCol = horizontal ? 10 - length + 1 : 10;

                int row = random.nextInt(maxRow);
                int col = random.nextInt(maxCol);

                String orientation = horizontal ? "Ngang" : "Dọc";

                // Log chi tiết từng lần thử tọa độ
                System.out.printf("   -> Thử lần %d/%d: Tọa độ (%d, %d), Hướng %s ... ",
                        attempts + 1, maxAttempts, row, col, orientation);

                placed = board.placeShip(ship, row, col, horizontal);

                if (placed) {
                    System.out.println("THÀNH CÔNG");
                } else {
                    System.out.println("THẤT BẠI (Vướng tàu khác)");
                }

                attempts++;
            }

            // Cảnh báo đỏ nếu hết maxAttempts mà vẫn chưa đặt được
            if (!placed) {
                System.err.println("[!] LỖI NGHIÊM TRỌNG: Bỏ cuộc! Không thể đặt " + ship.getName() + " sau " + maxAttempts + " lần thử.");
            }
        }
        System.out.println("\n=== HOÀN TẤT AUTO-PLACEMENT ===");
    }

    public static Board generateRandomBoard() {
        System.out.println("Đang khởi tạo bàn cờ mới...");
        Board board = new Board();
        List<Ship> ships = ShipFactory.defaultShips();

        placeShipsRandomly(board, ships);

        System.out.println("Trả về bàn cờ đã được sắp xếp.\n");
        return board;
    }
}