<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hướng dẫn chơi Battleship</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/how-to-play.css">
</head>
<body>

<div class="container">
    <h1>🚢 Hướng dẫn chơi Battleship (Bắn thuyền)</h1>

    <section>
        <h2>📌 Mục tiêu trò chơi</h2>
        <p>
            Battleship là trò chơi chiến thuật nơi bạn phải tìm và đánh chìm toàn bộ tàu của đối thủ trước khi họ làm điều đó với bạn.
        </p>
    </section>

    <section>
        <h2>⚙️ Cách chơi</h2>
        <ul>
            <li>Mỗi người chơi có một bảng 10x10.</li>
            <li>Người chơi đặt các tàu lên bảng của mình.</li>
            <li>Các tàu không được chồng lên nhau.</li>
            <li>Lần lượt đoán vị trí tàu của đối thủ.</li>
        </ul>
    </section>

    <section>
        <h2>🚀 Luật bắn</h2>
        <ul>
            <li>Chọn một tọa độ (ví dụ: A5).</li>
            <li>Nếu trúng tàu: báo "Hit".</li>
            <li>Nếu trượt: báo "Miss".</li>
            <li>Đánh chìm toàn bộ tàu để thắng.</li>
        </ul>
    </section>

    <section>
        <h2>🏆 Điều kiện thắng</h2>
        <p>
            Người chơi thắng khi đánh chìm toàn bộ tàu của đối thủ trước.
        </p>
    </section>

    <a href="${pageContext.request.contextPath}/home" class="btn">⬅ Quay lại trang chính</a>
</div>

</body>
</html>