package socket;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import models.RoomManager;

@ServerEndpoint("/game")
public class GameSocketServer {

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("Connected: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {

        String[] parts = message.split("\\|");

        switch (parts[0]) {

            case "JOIN_ROOM":
                String userId = parts[1];
                String roomId = parts[2];

                boolean success = RoomManager.joinRoom(roomId, userId, session);

                if (!success) {
                    send(session, "ERROR|Room not found");
                    return;
                }

                // 🔥 1. gửi toàn bộ state cho người vừa join
                String players = RoomManager.getPlayers(roomId); // "A,B,C"
                send(session, "ROOM_STATE|" + players);

                // 🔥 2. broadcast cho các user khác
                RoomManager.broadcast(roomId, "USER_JOINED|" + userId);

                break;
        }
    }

    @OnClose
    public void onClose(Session session) {
        RoomManager.removeSession(session);
    }

    private void send(Session session, String msg) {
        try {
            session.getBasicRemote().sendText(msg);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
