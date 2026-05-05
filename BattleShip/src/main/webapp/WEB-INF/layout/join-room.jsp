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

    <div class="card">
        <input type="text" id="userId" placeholder="Enter your name">
        <input type="text" id="roomId" placeholder="Enter Room ID">
        <button onclick="joinRoom()">Join Room</button>
    </div>
</div>

<script>
    function joinRoom() {
        let userId = document.getElementById("userId").value;
        let roomId = document.getElementById("roomId").value;

        if (!userId || !roomId) {
            alert("Please fill all fields!");
            return;
        }

        window.location.href = "room.jsp?roomId=" + roomId + "&userId=" + userId;
    }
</script>

</body>
</html>