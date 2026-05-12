package models;

import java.time.LocalDateTime;

public class PlayerStats {
    private String username;
    private int wins;
    private int losses;
    private int totalShots;
    private LocalDateTime updatedAt;

    public PlayerStats(){

    }

    public PlayerStats(String username){
        this.username=username;
        this.wins=0;
        this.losses=0;
        this.totalShots=0;
    }

    public int getTotalGame(){
        return wins+losses;
    }

    /*ti le thắng 0-100%
    *Trả về 0.0 nếu chưa chơi trận nào
    *
    */
    public double getWinRate(){
        int total=getTotalGame();
        if(total==0) return 0.0;
        return (double) wins/total*100.0;
    }

    //tỷ lệ thắng dạng %
    public String getWinRateFormatted() {
        return String.format("%.1f%%", getWinRate());
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public int getWins() { return wins; }
    public void setWins(int wins) { this.wins = wins; }

    public int getLosses() { return losses; }
    public void setLosses(int losses) { this.losses = losses; }

    public int getTotalShots() { return totalShots; }
    public void setTotalShots(int totalShots) { this.totalShots = totalShots; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
