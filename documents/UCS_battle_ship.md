# 📘 Use Case Specification (UCS)  
## 🎮 Dự án: Game “Bắn Thuyền Tuổi Thơ” trên nền tảng Web  

---

## 📑 Mục lục
1. [Giới thiệu](#1-giới-thiệu)  
2. [Actor](#2-actor)  
3. [Danh sách Use Case](#3-danh-sách-use-case)  
4. [Use Case Chi tiết](#4-use-case-chi-tiết)  
5. [Quan hệ Use Case](#5-quan-hệ-use-case)  

---

## 1. Giới thiệu  

### 1.1 Mục đích  
Tài liệu này mô tả các Use Case chính của hệ thống game “Bắn Thuyền Tuổi Thơ”.

### 1.2 Phạm vi  
Bao gồm các chức năng:
- Chơi game  
- Quản lý tài khoản  
- Multiplayer  
- Theo dõi kết quả  

### 1.3 Định nghĩa  
- **Use Case**: Mô tả tương tác giữa actor và hệ thống  
- **Actor**: Thực thể bên ngoài hệ thống  

---

## 2. Actor  

| Actor     | Mô tả |
|----------|------|
| Guest    | Người chơi chưa đăng nhập |
| User     | Người chơi đã đăng nhập |
| System   | Hệ thống game |
| Opponent | Người chơi khác |

**Quan hệ:** User kế thừa Guest  

---

## 3. Danh sách Use Case  

| ID    | Tên Use Case                     | Actor        |
|-------|----------------------------------|-------------|
| UC-01 | Chơi game với tư cách Guest      | Guest       |
| UC-02 | Đăng ký tài khoản                | Guest       |
| UC-03 | Đăng nhập                        | Guest       |
| UC-04 | Đăng xuất                        | User        |
| UC-05 | Bắt đầu game PvE                 | User/Guest  |
| UC-06 | Bắt đầu game PvP Local           | User/Guest  |
| UC-07 | Tạo phòng PvP Online             | User        |
| UC-08 | Tham gia phòng PvP               | User        |
| UC-09 | Đặt tàu                          | User/Guest  |
| UC-10 | Thực hiện lượt bắn               | User/Guest  |
| UC-11 | Xem kết quả lượt bắn             | System      |
| UC-12 | Kết thúc game                    | System      |
| UC-13 | Xem bảng xếp hạng               | User        |
| UC-14 | Xem lịch sử trận đấu             | User        |

---

## 4. Use Case Chi tiết  

### UC-01: Chơi game với tư cách Guest  
**Actor:** Guest  
**Mô tả:** Chơi game không cần đăng nhập  

**Luồng chính:**
1. Truy cập website  
2. Chọn “Chơi ngay”  
3. Hiển thị chế độ chơi  
4. Chọn mode  
5. Bắt đầu game  

**Luồng thay thế:**
- Mất kết nối → báo lỗi  

---

### UC-02: Đăng ký tài khoản  
**Actor:** Guest  

**Luồng chính:**
1. Nhập thông tin  
2. Kiểm tra hợp lệ  
3. Tạo tài khoản  
4. Thông báo thành công  

**Luồng thay thế:**
- Username tồn tại → lỗi  

---

### UC-03: Đăng nhập  
**Actor:** Guest  

**Luồng chính:**
1. Nhập thông tin  
2. Xác thực  
3. Thành công  

**Luồng thay thế:**
- Sai thông tin → lỗi  

---

### UC-04: Đăng xuất  
**Actor:** User  

**Luồng chính:**
1. Chọn logout  
2. Huỷ session  

---

### UC-05: Bắt đầu game PvE  
**Actor:** User/Guest  

**Luồng chính:**
1. Chọn PvE  
2. Chọn độ khó  
3. Tạo game AI  
4. Vào trận  

---

### UC-06: Bắt đầu game PvP Local  
**Actor:** User/Guest  

**Luồng chính:**
1. Chọn PvP Local  
2. Hai người chơi thay phiên  
3. Game bắt đầu  

---

### UC-07: Tạo phòng PvP Online  
**Actor:** User  

**Luồng chính:**
1. Chọn tạo phòng  
2. Sinh Room ID  
3. Chia sẻ link  

---

### UC-08: Tham gia phòng PvP  
**Actor:** User  

**Luồng chính:**
1. Nhập Room ID  
2. Kiểm tra  
3. Tham gia  

**Luồng thay thế:**
- Room không tồn tại → lỗi  

---

### UC-09: Đặt tàu  
**Actor:** User/Guest  

**Luồng chính:**
1. Chọn vị trí  
2. Chọn hướng  
3. Validate  
4. Hiển thị  

**Luồng thay thế:**
- Không hợp lệ → đặt lại  

---

### UC-10: Thực hiện lượt bắn  
**Actor:** User/Guest  

**Luồng chính:**
1. Chọn ô  
2. Gửi lệnh  
3. Xử lý  

---

### UC-11: Xem kết quả lượt bắn  
**Actor:** System  

**Luồng chính:**
1. Kiểm tra  
2. Cập nhật  
3. Hiển thị  

---

### UC-12: Kết thúc game  
**Actor:** System  

**Luồng chính:**
1. Kiểm tra tàu  
2. Xác định thắng  
3. Hiển thị  

---

### UC-13: Xem bảng xếp hạng  
**Actor:** User  

**Luồng chính:**
1. Mở leaderboard  
2. Hiển thị  

---

### UC-14: Xem lịch sử trận đấu  
**Actor:** User  

**Luồng chính:**
1. Vào profile  
2. Chọn lịch sử  
3. Hiển thị  

---

## 5. Quan hệ Use Case  

### <<include>>
- UC-10 → UC-11  
- UC-09 → Validate Placement  

### <<extend>>
- UC-12 extends UC-10  

### Generalization
- User kế thừa Guest  

---
