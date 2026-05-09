package dto;

public class StartGameResponse {
    boolean success;
    String gameId;

    public StartGameResponse(
            boolean success,
            String gameId
    ) {
        this.success = success;
        this.gameId = gameId;
    }
}
