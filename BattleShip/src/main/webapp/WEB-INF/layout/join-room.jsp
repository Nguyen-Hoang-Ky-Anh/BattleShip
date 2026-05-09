<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Join Room</title>

    <%-- [UC-08 - Room/Lobby][UI Rendering]
         Entry screen cho Join Flow --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<%-- [UI Decoration - Non-functional] --%>
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<div class="container">

    <%-- [UC-08][Entry Flow - Join Room][Display Title] --%>
    <h1 class="title">🌊 JOIN ROOM</h1>

    <%-- [UC-08][Alternative Flow A2.1 - Room Invalid]
         Hiển thị lỗi nếu room không tồn tại hoặc không hợp lệ --%>
    <p style="color:red">${error}</p>

    <div class="card">

        <%-- =========================================
             [UC-08 - Entry Flow (Join)]
             Step A2.1: User nhập thông tin
           ========================================= --%>
        <form action="${pageContext.request.contextPath}/join-room" method="post">

            <%-- [UC-08][Step A2.1.1 - Input User ID] --%>
            <input type="text"
                   name="userId"
                   placeholder="Enter your name"
                   required>

            <%-- [UC-08][Step A2.1.2 - Input Room ID] --%>
            <input type="text"
                   name="roomId"
                   placeholder="Enter Room ID"
                   required>

            <%-- [UC-08][Step A2.2 - Submit Join Request]
                 → JoinRoomController.doPost() --%>
            <button type="submit">Join Room</button>

        </form>
    </div>
</div>

</body>
</html>