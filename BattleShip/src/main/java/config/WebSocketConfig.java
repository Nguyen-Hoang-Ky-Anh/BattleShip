package config;

import jakarta.websocket.server.ServerContainer;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import socket.GameSocketServer;

@WebListener
public class WebSocketConfig implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            ServerContainer container =
                    (ServerContainer) sce.getServletContext()
                            .getAttribute("jakarta.websocket.server.ServerContainer");

            container.addEndpoint(GameSocketServer.class);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
