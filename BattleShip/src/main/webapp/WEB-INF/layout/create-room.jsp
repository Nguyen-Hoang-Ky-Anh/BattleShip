<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Room</title>

    <%-- [UC-07.1 - Configure Room][Step 1 - UI Rendering]
         System hiển thị form cấu hình phòng PvP --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<%-- [UI Decoration - Non-functional] --%>
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

<div class="container">

    <%-- [UC-07 - Create PvP Room][Step 2]
         System hiển thị màn hình cấu hình (gọi UC-07.1) --%>
    <h1 class="title">⚓ CREATE ROOM</h1>

    <div class="card">

        <%-- =========================================
             [UC-07.1 - Configure Room]
             Step 2: User nhập thông tin cấu hình
           ========================================= --%>
        <form action="${pageContext.request.contextPath}/create-room" method="post">

            <%-- [UC-07.1][Step 2.1 - Input User ID]
                 Host nhập tên người chơi --%>
            <input type="text"
                   name="userId"
                   placeholder="Enter your name"
                   required>

            <%-- [UC-07.1][Step 2.2 - Input Board Size]
                 User chọn kích thước board (thuộc cấu hình phòng) --%>
            <select name="boardSize">
                <option value="10x10">10x10 (Classic)</option>
                <option value="8x8">8x8 (Quick)</option>
                <option value="12x12">12x12 (Hard)</option>
            </select>

            <%-- [UC-07.1][Step 3 - Confirm Configuration]
                 User xác nhận cấu hình phòng --%>
            <button type="submit">Create Room</button>

        </form>
    </div>
</div>

</body>
</html>