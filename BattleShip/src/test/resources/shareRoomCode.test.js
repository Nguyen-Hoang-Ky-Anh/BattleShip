// Thiết lập giả lập môi trường Global (Mocking Context từ JSP)
global.contextPath = "/battleship";
global.roomId = "ROOM_123456";
global.alert = jest.fn(); // Mock hàm alert() của trình duyệt

describe("Kiểm thử logic Hàm Share Room Code [UC-07.3]", () => {

    beforeEach(() => {
        jest.clearAllMocks();
        // Giả lập Window Location
        delete global.window;
        global.window = { location: { origin: "http://localhost:8080" } };
    });

    test("Trường hợp 1: Thiết bị hỗ trợ Web Share API -> Phải gọi navigator.share", () => {
        // Mock API navigator.share thành công
        const mockShare = jest.fn(() => Promise.resolve());
        global.navigator.share = mockShare;

        // Tiến hành chạy hàm cần test
        shareRoomCode();

        // Kiểm tra xem hàm share có được kích hoạt đúng tham số không
        expect(mockShare).toHaveBeenCalledWith({
            title: 'Battleship Tactical Command',
            text: `Commander, I need backup! Join my Battleship room [ROOM_123456]`,
            url: "http://localhost:8080/battleship/join?room=ROOM_123456"
        });
    });

    test("Trường hợp 2: Trình duyệt cũ không có Web Share API -> Ghi link vào Clipboard và Alert", async () => {
        // Tắt tính năng share API đi
        delete global.navigator.share;

        // Mock Clipboard API thay thế
        const mockWriteText = jest.fn(() => Promise.resolve());
        global.navigator.clipboard = { writeText: mockWriteText };

        // Chạy hàm test
        shareRoomCode();

        // Kiểm tra xem link có được nạp vào bộ nhớ tạm không
        expect(mockWriteText).toHaveBeenCalledWith("http://localhost:8080/battleship/join?room=ROOM_123456");

        // Đợi tiến trình Promise chạy xong và kiểm tra Alert hiển thị thông báo thành công
        await Promise.resolve();
        expect(global.alert).toHaveBeenCalledWith(
            expect.stringContaining("Invite Link copied to clipboard")
        );
    });
});

// Định nghĩa lại hàm shareRoomCode gọn gàng để Jest có thể biên dịch độc lập
function shareRoomCode() {
    const joinUrl = `${window.location.origin}${contextPath}/join?room=${roomId}`;
    const shareData = {
        title: 'Battleship Tactical Command',
        text: `Commander, I need backup! Join my Battleship room [${roomId}]`,
        url: joinUrl
    };

    if (navigator.share) {
        navigator.share(shareData)
            .then(() => console.log('Mission shared successfully!'))
            .catch((error) => console.log('Error sharing mission', error));
    } else {
        navigator.clipboard.writeText(joinUrl).then(() => {
            alert("🔗 Invite Link copied to clipboard! Send it to your backup operator.");
        }).catch(err => {
            console.error('Failed to copy: ', err);
        });
    }
}