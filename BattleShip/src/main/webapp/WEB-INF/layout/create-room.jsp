<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Room</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<div class="container">
    <h1 class="title">⚓ CREATE ROOM</h1>

    <div class="card">
        <input type="text" id="userId" placeholder="Enter your name">
        <button onclick="createRoom()">Create Room</button>
    </div>
</div>

<script>
    function createRoom() {
        let userId = document.getElementById("userId").value;

        if (!userId) {
            alert("Please enter your name!");
            return;
        }

        fetch("create-room", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: "userId=" + userId
        })
            .then(res => res.text())
            .then(roomId => {
                window.location.href = "room.jsp?roomId=" + roomId + "&userId=" + userId;
            });
    }
</script>

</body>
</html>