package services;

import controllers.PreGameController;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

public class PreGameControllerTest {
    PreGameController controller;
    HttpServletRequest request;
    HttpServletResponse response;
    HttpSession session;
    RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() {
        controller  = new PreGameController();
        request     = mock(HttpServletRequest.class);
        response    = mock(HttpServletResponse.class);
        session     = mock(HttpSession.class);
        dispatcher  = mock(RequestDispatcher.class);
    }

    // ✅ GET / → forward đến select-difficult.jsp
    @Test
    void doGet_noAction_forwardToSelectDifficult() throws Exception {
        when(request.getPathInfo()).thenReturn(null);
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);

        controller.doGet(request, response);

        verify(request).getRequestDispatcher("/WEB-INF/layout/select-difficult.jsp");
        verify(dispatcher).forward(request, response);
    }

    // ✅ GET /easy → set session + redirect
    @Test
    void doGet_easyAction_setsSessionAndRedirects() throws Exception {
        when(request.getPathInfo()).thenReturn("/easy");
        when(request.getSession()).thenReturn(session);
        when(request.getContextPath()).thenReturn("/battleship");

        controller.doGet(request, response);

        verify(session).setAttribute("aiDifficulty", "easy");
        verify(response).sendRedirect("/battleship/ship-placement-pve");
    }

    // ✅ GET /normal
    @Test
    void doGet_normalAction_setsSessionAndRedirects() throws Exception {
        when(request.getPathInfo()).thenReturn("/normal");
        when(request.getSession()).thenReturn(session);
        when(request.getContextPath()).thenReturn("/battleship");

        controller.doGet(request, response);

        verify(session).setAttribute("aiDifficulty", "normal");
        verify(response).sendRedirect("/battleship/ship-placement-pve");
    }

    // ✅ GET /hard
    @Test
    void doGet_hardAction_setsSessionAndRedirects() throws Exception {
        when(request.getPathInfo()).thenReturn("/hard");
        when(request.getSession()).thenReturn(session);
        when(request.getContextPath()).thenReturn("/battleship");

        controller.doGet(request, response);

        verify(session).setAttribute("aiDifficulty", "hard");
        verify(response).sendRedirect("/battleship/ship-placement-pve");
    }

    // ✅ GET /unknown → 404
    @Test
    void doGet_unknownAction_sends404() throws Exception {
        when(request.getPathInfo()).thenReturn("/unknown");

        controller.doGet(request, response);

        verify(response).sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    // ✅ POST → 400
    @Test
    void doPost_returns400() throws Exception {
        controller.doPost(request, response);

        verify(response).sendError(
                eq(HttpServletResponse.SC_BAD_REQUEST),
                anyString()
        );
    }
}
