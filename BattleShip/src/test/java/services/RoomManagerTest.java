package services;

import enums.GamePhase;
import enums.PlayerRole;
import jakarta.websocket.RemoteEndpoint;
import jakarta.websocket.Session;
import models.Room;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class RoomManagerTest {

    private Session mockSession1;
    private Session mockSession2;
    private Session mockSession3;
    private RemoteEndpoint.Basic mockRemote;

    @BeforeEach
    public void setUp() throws IOException {
        // Clear sạch các phòng cũ trong Map static trước mỗi ca test (Nếu có hàm clear, hoặc reset qua reflection)
        RoomManager.getRooms().clear();

        // Tạo Mock cho các WebSocket Session độc lập
        mockSession1 = mock(Session.class);
        mockSession2 = mock(Session.class);
        mockSession3 = mock(Session.class);
        mockRemote = mock(RemoteEndpoint.Basic.class);

        // Cấu hình mock để không bị lỗi NullPointer khi hệ thống gọi gửi tin nhắn realtime
        when(mockSession1.getId()).thenReturn("SESSION_HOST");
        when(mockSession1.isOpen()).thenReturn(true);
        when(mockSession1.getBasicRemote()).thenReturn(mockRemote);

        when(mockSession2.getId()).thenReturn("SESSION_PLAYER");
        when(mockSession2.isOpen()).thenReturn(true);
        when(mockSession2.getBasicRemote()).thenReturn(mockRemote);

        when(mockSession3.getId()).thenReturn("SESSION_FULL");
        when(mockSession3.isOpen()).thenReturn(true);
        when(mockSession3.getBasicRemote()).thenReturn(mockRemote);
    }

    @Test
    public void testCreateRoom_Success_UC07() {
        String roomId = RoomManager.createRoom("Kỳ Anh Host", 10, 10);

        assertNotNull(roomId, "Room ID không được rỗng");
        assertTrue(RoomManager.exists(roomId), "Room phải tồn tại trong bộ nhớ");

        Room room = RoomManager.getRoom(roomId);
        assertEquals(GamePhase.WAITING, room.getPhase(), "Trạng thái khởi tạo phải là WAITING");
    }

    @Test
    public void testJoinRoom_Success_AssignHostAndPlayer_UC08() {
        String roomId = RoomManager.createRoom("Kỳ Anh Host", 10, 10);

        // Người 1 tham gia -> Trở thành Host
        boolean join1 = RoomManager.joinRoom(roomId, "Kỳ Anh Host", mockSession1);
        assertTrue(join1);
        assertEquals(PlayerRole.HOST, RoomManager.getRoom(roomId).getPlayers().get("Kỳ Anh Host").getRole());

        // Người 2 tham gia -> Trở thành PLAYER thông thường
        boolean join2 = RoomManager.joinRoom(roomId, "Player2", mockSession2);
        assertTrue(join2);
        assertEquals(PlayerRole.PLAYER, RoomManager.getRoom(roomId).getPlayers().get("Player2").getRole());
    }

    @Test
    public void testJoinRoom_Failed_WhenRoomFull_UC08_Exception() throws IOException {
        String roomId = RoomManager.createRoom("HostUser", 10, 10);

        // Cho 2 người join đầy phòng
        RoomManager.joinRoom(roomId, "HostUser", mockSession1);
        RoomManager.joinRoom(roomId, "Player2", mockSession2);

        // Người thứ 3 cố tình vào phòng đầy
        boolean join3 = RoomManager.joinRoom(roomId, "Player3", mockSession3);

        assertFalse(join3, "Không cho phép join khi phòng đã đủ 2 người");
        // Kiểm tra xem hệ thống có bắn thông báo lỗi về client thông qua websocket hay không
        verify(mockRemote, atLeastOnce()).sendText("ERROR|Room is full");
    }

    @Test
    public void testGetAvailableRooms_FilterCorrectly_UC15_PreRequisite() {
        // Tạo phòng 1: Đang chờ (Hợp lệ cho Quick Join)
        String r1 = RoomManager.createRoom("User1", 10, 10);
        RoomManager.joinRoom(r1, "User1", mockSession1);

        // Tạo phòng 2: Đã chuyển sang giai đoạn chơi (Không hợp lệ cho Quick Join)
        String r2 = RoomManager.createRoom("User2", 10, 10);
        RoomManager.getRoom(r2).setPhase(GamePhase.PLACING);

        var available = RoomManager.getAvailableRooms();

        assertEquals(1, available.size(), "Chỉ được tìm thấy 1 phòng hợp lệ");
        assertEquals(r1, available.get(0).getRoomId(), "Phòng tìm thấy phải là phòng r1");
    }
}