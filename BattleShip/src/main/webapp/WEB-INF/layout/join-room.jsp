<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Intercept Tactical Room</title>

    <!-- CSS CORE SYSTEM -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>
<body>

<!-- ATMOSPHERIC BACKGROUND -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<%@ page import="models.User" %>

<%
    User currentUser = (User) session.getAttribute("user");

    String username = "";

    if(currentUser != null){
        username = currentUser.getUsername();
    }
%>

<div class="room-join-wrapper">

    <!-- MAIN GRID -->
    <div class="tactical-lobby-grid">

        <!-- ================================================= -->
        <!-- LEFT PANEL : MANUAL JOIN -->
        <!-- ================================================= -->
        <div class="terminal-panel">

            <h1 class="terminal-title">
                ⚓ INTERCEPT ROOM
            </h1>

            <div class="terminal-subtitle monospace-data">
                MANUAL ROOM ACCESS
            </div>

            <div class="terminal-separator"></div>

            <c:if test="${not empty error}">
                <div class="alert-terminal-error monospace-data">
                    <span class="alert-blink">
                        ⚠️ [CRITICAL_ERROR] :
                    </span>
                        ${error}
                </div>
            </c:if>

            <!-- MANUAL JOIN FORM -->
            <form action="${pageContext.request.contextPath}/join-room"
                  method="post"
                  class="tactical-form">

                <!-- USERNAME -->
                <div class="form-group">

                    <label class="input-label monospace-data">
                        OPERATOR_ID :
                    </label>

                    <input type="text"
                           name="userId"
                           value="<%= username %>"
                           placeholder="DEPLOY IDENTITY..."
                           required>

                </div>

                <!-- ROOM ID -->
                <div class="form-group">

                    <label class="input-label monospace-data">
                        TARGET_ROOM :
                    </label>

                    <input type="text"
                           name="roomId"
                           placeholder="ENTER ROOM CODE..."
                           required>

                </div>

                <div class="terminal-separator"></div>

                <button type="submit"
                        class="btn-command-submit-cyan">

                    ESTABLISH QUANTUM LINK

                </button>

            </form>

            <!-- BACK -->
            <div class="back-navigation-zone">

                <form action="${pageContext.request.contextPath}/pvp"
                      method="get">

                    <button type="submit"
                            class="btn-terminal-sm">

                        ◀ ABORT INTERCEPTION

                    </button>

                </form>

            </div>

        </div>

        <!-- ================================================= -->
        <!-- RIGHT PANEL : AVAILABLE ROOMS -->
        <!-- ================================================= -->
        <div class="terminal-panel">

            <h2 class="terminal-title">
                🛰 AVAILABLE ROOMS
            </h2>

            <div class="terminal-subtitle monospace-data">
                ACTIVE WAITING LOBBIES
            </div>

            <div class="terminal-separator"></div>

            <!-- EMPTY STATE -->
            <c:if test="${empty availableRooms}">

                <div class="empty-room-state monospace-data">

                    NO AVAILABLE ROOMS DETECTED

                </div>

            </c:if>

            <!-- ROOM LIST -->
            <div class="room-list-container">

                <c:forEach var="room"
                           items="${availableRooms}">

                    <div class="room-card">

                        <!-- ROOM HEADER -->
                        <div class="room-card-header">

                            <div class="room-id">
                                    ${room.roomId}
                            </div>

                            <div class="room-status waiting">
                                WAITING
                            </div>

                        </div>

                        <!-- ROOM INFO -->
                        <div class="room-card-body">

                            <div class="room-meta">
                                HOST :
                                    ${room.host}
                            </div>

                            <div class="room-meta">
                                PLAYERS :
                                    ${room.currentPlayers}/${room.maxPlayers}
                            </div>

                            <div class="room-meta">
                                GRID :
                                    ${room.rows} x ${room.cols}
                            </div>

                        </div>

                        <!-- QUICK JOIN -->
                        <form action="${pageContext.request.contextPath}/join-room"
                              method="post"
                              class="quick-join-form">

                            <!-- ROOM ID -->
                            <input type="hidden"
                                   name="roomId"
                                   value="${room.roomId}">

                            <!-- IF LOGGED IN -->
                            <c:choose>

                                <c:when test="<%= currentUser != null %>">

                                    <input type="text"
                                           name="userId"
                                           value="<%= username %>"
                                            <%= currentUser != null ? "readonly" : "" %>
                                           required>

                                </c:when>

                                <c:otherwise>

                                    <input type="text"
                                           name="userId"
                                           class="quick-join-input"
                                           placeholder="ENTER CALLSIGN..."
                                           required>

                                </c:otherwise>

                            </c:choose>

                            <button type="submit"
                                    class="btn-quick-join">

                                QUICK JOIN

                            </button>

                        </form>

                    </div>

                </c:forEach>

            </div>

        </div>

    </div>

</div>

</body>
</html>