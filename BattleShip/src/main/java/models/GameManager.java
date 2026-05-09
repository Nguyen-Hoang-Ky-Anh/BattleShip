package models;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class GameManager {

    private static final Map<String, GameSession>
            games = new ConcurrentHashMap<>();

    public static String create(
            GameSession game
    ) {

        games.put(
                game.getGameId(),
                game
        );

        return game.getGameId();
    }

    public static GameSession get(
            String gameId
    ) {

        return games.get(gameId);
    }

    public static void remove(
            String gameId
    ) {

        games.remove(gameId);
    }
}