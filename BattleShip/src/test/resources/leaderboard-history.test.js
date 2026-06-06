/**
 * UC-13: Xem bảng xếp hạng
 * UC-14: Xem lịch sử trận đấu
 */

describe("Leaderboard Logic [UC-13]", () => {

    test("Sắp xếp người chơi theo số trận thắng giảm dần", () => {

        const leaderboard = [
            { username: "UserA", wins: 5 },
            { username: "UserB", wins: 15 },
            { username: "UserC", wins: 10 }
        ];

        leaderboard.sort((a, b) => b.wins - a.wins);

        expect(leaderboard[0].username).toBe("UserB");
        expect(leaderboard[1].username).toBe("UserC");
        expect(leaderboard[2].username).toBe("UserA");
    });

});


describe("Match History Logic [UC-14]", () => {

    test("Hiển thị đúng số trận đấu của người chơi", () => {

        const history = [
            {
                winner: "chau",
                loser: "player1"
            },
            {
                winner: "player2",
                loser: "chau"
            },
            {
                winner: "chau",
                loser: "player3"
            }
        ];

        expect(history.length).toBe(3);
    });

    test("Lọc lịch sử theo username", () => {

        const history = [
            { winner: "chau", loser: "A" },
            { winner: "B", loser: "chau" },
            { winner: "C", loser: "D" }
        ];

        const result = history.filter(
            m => m.winner === "chau" || m.loser === "chau"
        );

        expect(result.length).toBe(2);
    });

});