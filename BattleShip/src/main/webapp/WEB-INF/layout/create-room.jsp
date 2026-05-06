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
        <form action="${pageContext.request.contextPath}/create-room" method="post">
            <input type="text" name="userId" placeholder="Enter your name" required>
            <select name="boardSize">
                <option value="10x10">10x10 (Classic)</option>
                <option value="8x8">8x8 (Quick)</option>
                <option value="12x12">12x12 (Hard)</option>
            </select>
            <button type="submit">Create Room</button>
        </form>
    </div>
</div>

</body>
</html>