package services;

import models.BattleState;
import models.Room;
import org.junit.jupiter.api.Test;

import java.util.Arrays;

import static org.mockito.Mockito.*;

/**
 * UC-12: Kết thúc game và lưu kết quả trận đấu
 */
public class MatchHistoryServiceTest {

    @Test
    public void testSaveMatchResult_Success_UC12() {

        Room room = mock(Room.class);
        BattleState battleState = mock(BattleState.class);

        when(room.getRoomId()).thenReturn("ROOM_TEST");
        when(room.getBattleState()).thenReturn(battleState);

        when(battleState.getShotHistory()).thenReturn(
                Arrays.asList("A1", "B2", "C3", "D4", "E5")
        );

        MatchHistoryService.saveMatchResult(
                room,
                "WinnerUser",
                "LoserUser"
        );

        verify(room, atLeastOnce()).getRoomId();
    }

    @Test
    public void testSaveMatchResult_BattleStateNull_UC12() {

        Room room = mock(Room.class);

        when(room.getRoomId()).thenReturn("ROOM_NULL");
        when(room.getBattleState()).thenReturn(null);

        MatchHistoryService.saveMatchResult(
                room,
                "WinnerUser",
                "LoserUser"
        );

        verify(room, atLeastOnce()).getBattleState();
    }
}