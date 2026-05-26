<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Training Manual - BattleShip</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>
<body>

<!-- KHUNG BAO TOÀN DIỆN TRANG HƯỚNG DẪN CHIẾN THUẬT -->
<div class="manual-page-container">

    <!-- ================= BACK TO HOME INTERACTION ================= -->
    <nav class="tactical-nav-bar">
        <a href="${pageContext.request.contextPath}/" class="nav-btn btn-home">⬅ RETURNING_TO_BASE</a>
    </nav>

    <!-- ================= MANUAL HEADER ================= -->
    <header class="manual-header">
        <h1 class="manual-title">🚢 TRAINING MANUAL</h1>
        <p class="manual-subtitle monospace-data">// OPERATIONAL_GUIDELINES_FOR_NEW_RECRUITS</p>
    </header>

    <!-- ================= STRATEGIC OBJECTIVE ================= -->
    <section class="manual-section objective-section">
        <h2 class="section-tech-title monospace-data">[01] MỤC TIÊU TRÒ CHƠI</h2>
        <div class="section-body-card">
            <p>
                <strong>Battleship</strong> là trò chơi chiến thuật quân sự đỉnh cao, nơi bạn phải vận dụng khả năng phán đoán để **tìm và đánh chìm toàn bộ hạm đội tàu của đối thủ** trước khi chúng kịp định vị và tiêu diệt các chiến hạm của bạn.
            </p>
        </div>
    </section>

    <!-- ================= DEPLOYMENT STEPS (SEQUENCE) ================= -->
    <section class="manual-section rules-section">
        <h2 class="section-tech-title monospace-data">[02] QUY TRÌNH TRIỂN KHAI PHÒNG THỦ</h2>

        <div class="manual-step-list monospace-data">
            <div class="manual-step-item">
                <div class="step-badge">STAGE 01</div>
                <div class="step-content">Mỗi người chơi được cấp một tọa độ hải đồ kích thước tiêu chuẩn **10x10**.</div>
            </div>
            <div class="manual-step-item">
                <div class="step-badge">STAGE 02</div>
                <div class="step-content">Người chơi tiến hành bài trí hạm đội mật chiến lên bảng của mình ở giai đoạn chuẩn bị.</div>
            </div>
            <div class="manual-step-item">
                <div class="step-badge">STAGE 03</div>
                <div class="step-content">Các tàu chiến phải đặt nằm trọn trong hải đồ và **không được phép chồng lấn tọa độ** lên nhau.</div>
            </div>
            <div class="manual-step-item">
                <div class="step-badge">STAGE 04</div>
                <div class="step-content">Hai bên luân phiên khai hỏa bách phát bằng cách dự đoán vị trí neo đậu của đối phương.</div>
            </div>
        </div>
    </section>

    <!-- ================= FIRE CONTROL SYSTEM ================= -->
    <section class="manual-section fire-control-section">
        <h2 class="section-tech-title monospace-data">[03] HỆ THỐNG KIỂM SOÁT HỎA LỰC</h2>
        <div class="grid-rules-two-columns">
            <div class="rule-sub-card border-cyan">
                <h3 class="card-mini-title monospace-data">// ĐỊNH VỊ TỌA ĐỘ</h3>
                <p>Chọn một tọa độ mục tiêu cụ thể trên bảng rada kích hoạt oanh tạc (Ví dụ: <strong>A5</strong>).</p>
            </div>
            <div class="rule-sub-card border-mint">
                <h3 class="card-mini-title monospace-data">// KHAI HỎA TRÚNG ĐÍCH</h3>
                <p>Nếu vị trí có tàu địch: Hệ thống báo <span class="badge badge-win">HIT</span>. Bạn nhận thêm lượt bắn.</p>
            </div>
            <div class="rule-sub-card border-gray">
                <h3 class="card-mini-title monospace-data">// KHAI HỎA TRỆCH HƯỚNG</h3>
                <p>Nếu ô trống: Hệ thống báo <span class="badge badge-neutral">MISS</span>. Lượt bắn chuyển sang đối thủ.</p>
            </div>
            <div class="rule-sub-card border-orange">
                <h3 class="card-mini-title monospace-data">// ĐIỀU KIỆN THẮNG</h3>
                <p>Hủy diệt hoàn toàn toàn bộ linh hồn các tàu của phe địch để giành **VICTORY** tuyệt đối.</p>
            </div>
        </div>
    </section>

</div>

<!-- LỚP NỀN ĐẠI DƯƠNG ĐỒNG BỘ HIỆU ỨNG -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

</body>
</html>