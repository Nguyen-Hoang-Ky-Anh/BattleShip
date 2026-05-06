<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Join Room</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<div class="container">
    <h1 class="title">🌊 JOIN ROOM</h1>
    <p style="color:red">${error}</p>
    <div class="card">
        <form action="${pageContext.request.contextPath}/join-room" method="post">
            <input type="text" name="userId" placeholder="Enter your name" required>
            <input type="text" name="roomId" placeholder="Enter Room ID" required>
            <button type="submit">Join Room</button>
        </form>
    </div>
</div>

</body>
</html>