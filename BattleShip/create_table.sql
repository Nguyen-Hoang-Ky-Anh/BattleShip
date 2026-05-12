-- Bảng lưu lịch sử từng trận
CREATE TABLE match_history (
                               id          INT AUTO_INCREMENT PRIMARY KEY,
                               room_id     VARCHAR(50)  NOT NULL,
                               winner      VARCHAR(50)  NOT NULL,
                               loser       VARCHAR(50)  NOT NULL,
                               total_shots INT          NOT NULL,
                               played_at   DATETIME     DEFAULT CURRENT_TIMESTAMP
);

-- Bảng thống kê người chơi (cho leaderboard)
CREATE TABLE player_stats (
                              username    VARCHAR(50)  PRIMARY KEY,
                              wins        INT          DEFAULT 0,
                              losses      INT          DEFAULT 0,
                              total_shots INT          DEFAULT 0,
                              updated_at  DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
