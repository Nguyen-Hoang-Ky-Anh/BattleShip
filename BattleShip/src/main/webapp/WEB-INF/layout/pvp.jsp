<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PvP Connection Hub</title>

    <!-- CSS CORE SYSTEM -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>

<body>

<!-- CONTAINER DIỀU KHIỂN TRUNG TÂM -->
<div class="pvp-hub-wrapper">
    <div class="tactical-glass-card">

        <!-- TIÊU ĐỀ HỆ THỐNG GIAO DIỆN PVP -->
        <h1 class="pvp-tactical-title">⚓ BATTLESHIP PvP ⚓</h1>
        <div class="network-status monospace-data">SIGNAL STATUS: READY // ENCRYPTED_TUNNEL</div>

        <div class="terminal-separator"></div>

        <!-- VÙNG TƯƠNG TÁC CHỌN CHẾ ĐỘ KẾT NỐI -->
        <div class="pvp-menu-grid">

            <%-- =========================================
                 [UC-07 - Create PvP Room]
                 Step 1: User chọn "Create PvP Room"
                 → Điều hướng tới màn hình cấu hình (UC-07.1)
               ========================================= --%>
            <form action="${pageContext.request.contextPath}/create-room" method="get">
                <button type="submit" class="btn-command-large neon-mint-hover">
                    <span class="btn-icon">🚀</span> INITIALIZE SERVER
                    <span class="btn-sub-label">Create PvP Room & Secure Coordinates</span>
                </button>
            </form>

            <%-- =========================================
                 [UC-08 - Room / Lobby - Entry (Join Flow)]
                 Step A2: User chọn "Join Room"
                 → Điều hướng tới màn hình nhập Room ID
               ========================================= --%>
            <form action="${pageContext.request.contextPath}/join-room" method="get">
                <button type="submit" class="btn-command-large neon-cyan-hover">
                    <span class="btn-icon">🔍</span> INTERCEPT SIGNAL
                    <span class="btn-sub-label">Join Room via Secure Quantum ID</span>
                </button>
            </form>

        </div>

        <!-- ĐƯỜNG DẪN QUAY LẠI HỆ THỐNG MẸ -->
        <div class="back-telemetry-zone">
            <form action="${pageContext.request.contextPath}/" method="get">
                <button type="submit" class="btn-terminal-sm">◀ RETURN TO MAIN COMMAND</button>
            </form>
        </div>

    </div>
</div>

<!-- LỚP NỀN ĐẠI DƯƠNG (GIỮ ĐỒNG BỘ HIỆU ỨNG) -->
<div class="ocean">
    <div class="wave"></div>
    <div class="wave wave2"></div>
</div>

</body>
</html>