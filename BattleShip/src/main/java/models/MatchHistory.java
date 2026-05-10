package models;

import java.time.LocalDateTime;

public class MatchHistory {
    private int id;
    private String roomId;
    private String winner;
    private String loser;
    private int totalShots;
    private java.time.LocalDateTime playedAt;

    public MatchHistory() {}

    public MatchHistory(String roomId, String winner, String loser, int totalShots) {
        this.roomId= roomId;
        this.winner= winner;
        this.loser= loser;
        this.totalShots= totalShots;
        this.playedAt= LocalDateTime.now();
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public String getWinner() {
        return winner;
    }

    public void setWinner(String winner) {
        this.winner = winner;
    }

    public String getLoser() {
        return loser;
    }

    public void setLoser(String loser) {
        this.loser = loser;
    }

    public int getTotalShots() {
        return totalShots;
    }

    public void setTotalShots(int totalShots) {
        this.totalShots = totalShots;
    }

    public LocalDateTime getPlayedAt() {
        return playedAt;
    }

    public void setPlayedAt(LocalDateTime playedAt) {
        this.playedAt = playedAt;
    }
}
