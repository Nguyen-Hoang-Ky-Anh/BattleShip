# 📘 Business Requirements Specification (BRS) 
## 🎮 Dự án: Game “Bắn Thuyền Tuổi Thơ” trên nền tảng Web

---

## 📑 Mục lục
1. [Giới thiệu](#1-giới-thiệu)  
2. [Mô tả tổng quan](#2-mô-tả-tổng-quan)  
3. [Yêu cầu nghiệp vụ](#3-yêu-cầu-nghiệp-vụ)  
4. [Yêu cầu phi chức năng](#4-yêu-cầu-phi-chức-năng)  
5. [Ràng buộc](#5-ràng-buộc)  
6. [Tiêu chí thành công](#6-tiêu-chí-thành-công)  
7. [Định hướng phát triển](#7-định-hướng-phát-triển)  
8. [Phê duyệt](#8-phê-duyệt)  

---

## 1. Giới thiệu  

### 1.1 Mục đích  
Tài liệu này mô tả các yêu cầu nghiệp vụ cho việc phát triển trò chơi “Bắn Thuyền Tuổi Thơ” (lấy cảm hứng từ game Battleship) trên nền tảng web.

### 1.2 Phạm vi  
Hệ thống cho phép người dùng chơi game trực tiếp trên trình duyệt web với các chức năng:
- Chơi với máy (AI)  
- Chơi với người khác (online/offline)  
- Lưu điểm và bảng xếp hạng  

### 1.3 Định nghĩa, từ viết tắt  
- **BRS**: Business Requirements Specification  
- **UI**: Giao diện người dùng  
- **UX**: Trải nghiệm người dùng  
- **AI**: Trí tuệ nhân tạo  
- **PvP**: Người chơi với người chơi  
- **PvE**: Người chơi với hệ thống  

### 1.4 Tài liệu tham chiếu  
- IEEE 830 / ISO/IEC/IEEE 29148  
- Game Battleship cổ điển  

---

## 2. Mô tả tổng quan  

### 2.1 Mục tiêu kinh doanh  
- Tái hiện game tuổi thơ trên nền tảng hiện đại  
- Thu hút người chơi trẻ và người chơi hoài niệm  
- Xây dựng nền tảng có khả năng mở rộng  

### 2.2 Các bên liên quan  
- Product Owner (Khách hàng)  
- Người chơi (End Users)  
- Nhóm phát triển (Developer, Designer, QA)  

### 2.3 Đặc điểm người dùng  
- Người dùng phổ thông  
- Độ tuổi: 10+  
- Sử dụng trình duyệt web trên PC hoặc mobile  

### 2.4 Giả định và phụ thuộc  
- Có kết nối Internet  
- Trình duyệt hỗ trợ công nghệ web hiện đại  
- Server hoạt động ổn định  

---

## 3. Yêu cầu nghiệp vụ  

### 3.1 Yêu cầu gameplay  

#### 3.1.1 Gameplay cốt lõi  
- Người chơi đặt tàu trên bản đồ dạng lưới  
- Hai bên lần lượt bắn  
- Hệ thống phản hồi: trúng / trượt / chìm  
- Người thắng là người phá hủy toàn bộ tàu đối phương  

#### 3.1.2 Chế độ chơi  
- PvE (chơi với AI)  
- PvP Local (2 người trên cùng thiết bị)  
- PvP Online  

#### 3.1.3 Độ khó AI  
- Easy: bắn ngẫu nhiên  
- Medium: có logic cơ bản  
- Hard: AI thông minh  

---

### 3.2 Quản lý người dùng  

#### 3.2.1 Khách (Guest)  
- Có thể chơi không cần đăng nhập  

#### 3.2.2 Tài khoản  
- Đăng ký  
- Đăng nhập / đăng xuất  
- Quản lý hồ sơ cơ bản  

#### 3.2.3 Theo dõi tiến trình  
- Lịch sử trận đấu  
- Điểm số  

---

### 3.3 Yêu cầu UI/UX  

#### 3.3.1 Giao diện  
- Đơn giản, dễ hiểu  
- Hiển thị rõ lưới và trạng thái game  

#### 3.3.2 Responsive  
- Hỗ trợ mobile và desktop  
- Không cần cài đặt  

#### 3.3.3 Phản hồi  
- Hiệu ứng khi bắn  
- Âm thanh (tuỳ chọn)  

---

### 3.4 Bảng xếp hạng & tính năng xã hội  

#### 3.4.1 Leaderboard  
- Xếp hạng theo điểm  
- Hiển thị top người chơi  

#### 3.4.2 Lịch sử trận đấu  
- Hiển thị các trận gần đây  

#### 3.4.3 Tương tác multiplayer  
- Mời bạn qua link  
- Ghép trận ngẫu nhiên  

---

### 3.5 Kiếm tiền (tuỳ chọn)  

#### 3.5.1 Quảng cáo  
- Quảng cáo nhẹ, không ảnh hưởng trải nghiệm  

#### 3.5.2 Vật phẩm trang trí  
- Skin tàu  
- Theme bản đồ  

---

## 4. Yêu cầu phi chức năng  

### 4.1 Hiệu năng  
- Thời gian tải < 3 giây  
- Độ trễ thấp khi chơi online  

### 4.2 Khả năng mở rộng  
- Hỗ trợ nhiều người chơi đồng thời  

### 4.3 Bảo mật  
- Bảo vệ dữ liệu người dùng  
- Chống gian lận  

### 4.4 Khả dụng  
- Dễ học, dễ chơi  
- Không cần hướng dẫn phức tạp  

### 4.5 Tương thích  
- Chrome, Edge, Firefox, Safari  
- Trình duyệt mobile  

---

## 5. Ràng buộc  

### 5.1 Kỹ thuật  
- Nền tảng web (HTML, CSS, JavaScript)  
- Backend: Node.js / Java / Python  

### 5.2 Ngân sách  
- Ưu tiên MVP trước  

### 5.3 Thời gian  
- MVP: 4–6 tuần  

---

## 6. Tiêu chí thành công  

### 6.1 Chức năng  
- Game chạy mượt  
- Multiplayer ổn định  

### 6.2 Người dùng  
- Dễ sử dụng  
- Hấp dẫn  

### 6.3 Kinh doanh  
- Tăng trưởng người dùng  
- Có thể mở rộng  

---

## 7. Định hướng phát triển  

- Chat trong game  
- Chế độ giải đấu  
- Phiên bản mobile app  
- AI nâng cao  

---

## 8. Phê duyệt  

Được phê duyệt bởi:
- Product Owner  
- Project Manager  
- Technical Lead  

---
