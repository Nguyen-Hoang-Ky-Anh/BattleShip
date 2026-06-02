# Use Case Specification Document
## Battleship Game System

---

## 1. Introduction

### 1.1 Purpose
Tài liệu này mô tả chi tiết các Use Case của hệ thống game Battleship, bao gồm các chức năng từ Guest, Authentication đến gameplay và PvP/PvE.

### 1.2 Scope
Hệ thống hỗ trợ:
- Chơi game với Guest/User
- Đăng ký, đăng nhập
- Chơi PvE, PvP
- Tạo và tham gia phòng PvP, chia sẻ phòng và tham gia nhanh
- Gameplay: đặt tàu, bắn, xử lý kết quả

---

## 2. Use Case List

| ID | Name |
|---|---|
| UC-01 | Chơi game với tư cách Guest |
| UC-02 | Đăng ký tài khoản Guest |
| UC-03 | Đăng nhập |
| UC-04 | Đăng xuất |
| UC-05 | Game PvE |
| UC-06 | Game PvP |
| UC-07 | Create PvP Room |
| UC-08 | Join PvP Room |
| UC-09 | Đặt tàu |
| UC-10 | Thực hiện lượt bắn |
| UC-11 | Xem kết quả lượt bắn |
| UC-12 | Kết thúc game |
| UC-13 | Xem bảng xếp hạng |
| UC-14 | Xem lịch sử trận đấu |
| UC-15 | Quick Join (Tham gia nhanh) |

---

## 3. Use Case Specifications

### 3.1 UC-01 – Chơi game với tư cách Guest

| Field | Detail |
|---|---|
| **Use Case ID** | UC-01 |
| **Use Case Name** | Chơi game với tư cách Guest |
| **Created By** | Lê Ngọc Châu |
| **Date Created** | 24/04/2026 |
| **Primary Actor** | Guest |
| **Secondary Actor** | Hệ thống |

**Description:**  
Guest có thể chơi trò chơi Battleship mà không cần đăng ký hay đăng nhập. Trận đấu sẽ được lưu tạm thời trong session hoặc memory và sẽ mất nếu Guest thoát mà không đăng ký.

**Preconditions:**  
1. Guest ở màn hình đăng nhập.  
2. Hệ thống sẵn sàng.  
3. Guest chưa đăng nhập hoặc không muốn đăng nhập.  

**Postconditions:**  
1. Trận đấu hoàn thành, dữ liệu tạm thời lưu trong session/memory.  
2. Nếu Guest đăng ký hoặc đăng nhập trong cùng phiên, dữ liệu trận đấu được merge vào tài khoản User.  
3. Nếu Guest thoát mà không đăng ký, dữ liệu trận đấu mất.  

**Main Flow:**  
1. Người dùng chọn nút "Chơi ngay" trên màn hình chính.  
2. Hệ thống khởi tạo một phiên chơi tạm thời cho Guest.  
3. Hệ thống tải dữ liệu trận đấu.  
4. Guest thực hiện lượt chơi.  
5. Trận đấu kết thúc, hệ thống tính toán kết quả.  
6. Hệ thống hiển thị bảng điểm và kết quả trận đấu, gợi ý "Đăng ký để lưu kết quả" cho người dùng.  

**Alternative Flows:**  
- *Guest đăng ký trước khi chơi:*  
  1. Guest chọn "Đăng ký".  
  2. Hệ thống tạo tài khoản mới và merge dữ liệu session.  
  3. Guest tiếp tục chơi và lưu dữ liệu.  
- *Guest thoát giữa trận đấu:*  
  1. Session bị hủy.  
  2. Dữ liệu trận đấu mất.  

---

### 3.2 UC-02 – Đăng ký tài khoản Guest

| Field | Detail |
|---|---|
| **Use Case ID** | UC-02 |
| **Use Case Name** | Đăng ký tài khoản Guest |
| **Created By** | Lê Ngọc Châu |
| **Date Created** | 24/04/2026 |
| **Primary Actor** | Guest |
| **Secondary Actor** | Hệ thống |

**Description:**  
Guest tạo tài khoản mới để trở thành User, từ đó có thể lưu kết quả trận đấu, điểm số, và lịch sử trận đấu. Nếu Guest đang chơi game, dữ liệu tạm thời sẽ được merge vào tài khoản mới.

**Preconditions:**  
1. Guest ở màn hình đăng nhập.  
2. Guest chưa có tài khoản.  
3. Hệ thống có khả năng tạo account mới.  

**Postconditions:**  
1. Guest trở thành User với account mới.  
2. Dữ liệu trận đấu tạm thời (nếu có) được merge vào User.  
3. User có thể lưu điểm số và lịch sử trận đấu.  

**Main Flow:**  
1. Guest chọn "Đăng ký".  
2. Hệ thống hiển thị form đăng ký: username, email, password.  
3. Guest nhập thông tin và gửi form.  
4. Hệ thống kiểm tra thông tin hợp lệ (username/email chưa tồn tại).  
5. Hệ thống tạo tài khoản mới.  
6. Nếu Guest đang chơi game, hệ thống merge dữ liệu trận đấu tạm thời vào User.  
7. Hệ thống xác nhận đăng ký thành công và đăng nhập User.  

**Alternative Flows:**  
- *Thông tin không hợp lệ hoặc trùng username/email:*  
  1. Hệ thống hiển thị lỗi.  
  2. Guest nhập lại thông tin.  
- *Guest từ chối merge dữ liệu trận đấu:*  
  1. Hệ thống tạo account mới nhưng không merge dữ liệu tạm thời.  

---

### 3.3 UC-03 – Đăng nhập

| Field | Detail |
|---|---|
| **Use Case ID** | UC-03 |
| **Use Case Name** | Đăng nhập |
| **Created By** | Lê Ngọc Châu |
| **Date Created** | 24/04/2026 |
| **Primary Actor** | User |
| **Secondary Actor** | Hệ thống |

**Description:**  
Cho phép người dùng đã có tài khoản truy cập vào hệ thống để quản lý hồ sơ cá nhân, xem lịch sử đấu, bảng xếp hạng và tiếp tục tiến trình chơi game.

**Preconditions:**  
1. Người dùng đã có tài khoản hợp lệ trên hệ thống.  
2. Đang ở màn hình Đăng nhập.  

**Postconditions:**  
1. Người dùng đăng nhập thành công và có quyền truy cập các tính năng dành cho User.  
2. Session (phiên làm việc) mới được khởi tạo.  
3. Nếu có dữ liệu chơi Guest trước đó, hệ thống sẽ gợi ý tạo tài khoản.  

**Main Flow:**  
1. Người dùng nhập thông tin đăng nhập (Username và Password).  
2. Người dùng nhấn nút "Đăng nhập".  
3. Hệ thống kiểm tra sự tồn tại của tài khoản trong CSDL.  
4. Hệ thống xác thực tính hợp lệ của mật khẩu.  
5. Hệ thống khởi tạo phiên làm việc cho User.  
6. Hệ thống chuyển hướng người dùng về màn hình chính.  

**Alternative Flows:**  
- *Sai thông tin đăng nhập:*  
  1. Hệ thống báo lỗi "Tên đăng nhập hoặc mật khẩu không đúng".  
  2. Người dùng nhập lại thông tin hoặc chọn "Quên mật khẩu".  
- *Đăng nhập khi đang có trận đấu Guest:*  
  1. Hệ thống nhận diện có dữ liệu trận đấu tạm thời.  
  2. Hệ thống hiển thị thông báo: "Bạn có muốn lưu kết quả trận đấu hiện tại vào tài khoản này không?"  
  3. Nếu User đồng ý, hệ thống merge dữ liệu và tiếp tục trận đấu.  

---

### 3.4 UC-04 – Đăng xuất

| Field | Detail |
|---|---|
| **Use Case ID** | UC-04 |
| **Use Case Name** | Đăng xuất |
| **Created By** | Lê Ngọc Châu |
| **Date Created** | 24/04/2026 |
| **Primary Actor** | User |
| **Secondary Actor** | Hệ thống |

**Description:**  
Kết thúc phiên làm việc hiện tại của User, xóa thông tin đăng nhập tạm thời trên thiết bị để đảm bảo an toàn tài khoản và đưa người dùng trở lại trạng thái Guest.

**Preconditions:**  
- Người dùng đang trong trạng thái đăng nhập.  

**Postconditions:**  
1. Phiên làm việc bị hủy bỏ trên máy chủ.  
2. Các thông tin cá nhân bị xóa khỏi bộ nhớ tạm của thiết bị.  
3. Người dùng được chuyển về màn hình đăng nhập.  

**Main Flow:**  
1. User chọn mục "Tài khoản" hoặc biểu tượng cài đặt.  
2. User nhấn chọn nút "Đăng xuất".  
3. Hệ thống hiển thị hộp thoại xác nhận: "Bạn có chắc chắn muốn đăng xuất?"  
4. User nhấn chọn "Đồng ý".  
5. Hệ thống xóa phiên hiện tại.  
6. Hệ thống hiển thị thông báo "Đăng xuất thành công" và chuyển về màn hình đăng nhập.  

**Alternative Flows:**  
- *User hủy đăng xuất:*  
  1. User nhấn "Hủy" hoặc đóng hộp thoại xác nhận.  
  2. Hệ thống giữ nguyên trạng thái đăng nhập, User tiếp tục sử dụng.  

---

### 3.5 UC-05 – Game PvE

| Field | Detail |
|---|---|
| **Use Case ID** | UC-05 |
| **Use Case Name** | Game PvE |
| **Created By** | Vi Văn Hiếu |
| **Date Created** | 22/04/2026 |
| **Primary Actor** | Player |
| **Secondary Actor** | AI |

**Description:**  
Cho phép người chơi khởi động chế độ PvE và thi đấu với AI theo mức độ khó đã chọn.

**Preconditions:**  
- Player đã load game và đang ở màn hình sảnh chính.  

**Postconditions:**  
- Chế độ PvE được khởi động, trận đấu giữa Player và AI bắt đầu.  

**Main Flow:**  
1. Player chọn chế độ PvE từ màn hình sảnh chính.  
2. Hệ thống hiển thị màn hình chọn độ khó với các mức: Dễ, Trung bình, Khó.  
3. Player chọn một mức độ khó mong muốn.  
4. Hệ thống khởi tạo AI tương ứng with độ khó đã chọn.  
5. Hệ thống chuyển sang giao diện sắp xếp thuyền, cho phép Player bố trí thuyền trên bảng của mình.  
6. Player hoàn thành sắp xếp và xác nhận (khóa bố cục).  
7. Hệ thống tự động tạo bố cục thuyền ngẫu nhiên cho AI.  
8. Hệ thống quyết định Player đi trước và thông báo cho Player.  
9. Trận đấu bắt đầu.  
10. Hệ thống thông báo kết thúc khi AI hoặc người chơi hết thuyền.  

**Alternative Flows:**  
- *3a – Đổi độ khó trước khi bắt đầu:* Ở bước 3, nếu Player muốn đổi lại độ khó sau khi đã chọn nhưng chưa xác nhận, hệ thống cho phép quay lại màn hình chọn độ khó.  
- *6a – Không hoàn thành sắp xếp thuyền trong thời gian giới hạn:* Ở bước 6, nếu Player không hoàn thành trước thời gian timeout, hệ thống tự động khóa bố cục hiện tại và tiếp tục sang bước 7.  
- *2a – Player hủy trước khi bắt đầu:* Ở bất kỳ bước nào từ 2–6, nếu Player nhấn Hủy hoặc Quay lại, hệ thống hủy phiên khởi tạo và đưa Player trở về sảnh chính.  

---

### 3.6 UC-06 – Game PvP

| Field | Detail |
|---|---|
| **Use Case ID** | UC-06 |
| **Use Case Name** | Game PvP |
| **Created By** | Vi Văn Hiếu |
| **Date Created** | 22/04/2026 |
| **Primary Actor** | Player |

**Description:**  
Cho phép hai người chơi thi đấu trực tiếp với nhau trong chế độ PvP sau khi đã tham gia phòng chơi thành công.

**Preconditions:**  
- Cả hai người chơi đã tham gia phòng chơi PvP và kết nối thành công.  

**Postconditions:**  
- Trận đấu kết thúc, người chơi chọn chơi lại hoặc trở về sảnh chính.  

**Main Flow:**  
1. Hệ thống khởi động chế độ PvP, hiển thị giao diện sắp xếp thuyền cho cả hai người chơi.  
2. Player 1 và Player 2 lần lượt sắp xếp thuyền trên bảng của mình.  
3. Khi mỗi người chơi hoàn thành, họ nhấn nút Khóa để xác nhận bố cục. Hệ thống không cho phép chỉnh sửa sau khi đã khóa.  
4. Sau khi cả hai người chơi đã khóa, hệ thống ngẫu nhiên chọn người đi trước và thông báo cho cả hai. Trận đấu bắt đầu.  
5. Đến lượt mình, người chơi chọn một ô trên bảng đối thủ để bắn.  
6. Hệ thống xử lý kết quả bắn: Trúng (Hit) – đánh dấu ô trúng, người chơi tiếp tục bắn; Trượt (Miss) – đánh dấu ô trượt, chuyển lượt sang đối thủ; Đánh chìm – toàn bộ thuyền bị phá hủy, hệ thống thông báo.  
7. Trận đấu kết thúc khi một trong hai người chơi bị phá hủy toàn bộ thuyền. Hệ thống thông báo kết quả (thắng/thua).  
8. Hệ thống hiển thị màn hình kết thúc với hai lựa chọn: Chơi lại và Trở về sảnh chính.  

**Alternative Flows:**  
- *8a – Chơi lại:* Nếu cả hai người chơi chọn Chơi lại, hệ thống xóa bảng cũ và quay về bước 1 (re-match). Nếu chỉ một người chọn Chơi lại, hệ thống chờ xác nhận từ người còn lại; sau timeout, hệ thống hủy yêu cầu.  
- *8b – Trở về sảnh chính:* Nếu người chơi chọn Trở về sảnh chính, hệ thống kết thúc phiên PvP và điều hướng người đó về màn hình chính. Nếu một người rời phòng sớm (trước khi trận kết thúc), hệ thống xử lý là thua và thông báo cho đối thủ.  

---

### 3.7 UC-07 – Create PvP Room

| Field | Detail |
|---|---|
| **Use Case ID** | UC-07 |
| **Use Case Name** | Create PvP Room |
| **Created By** | Nguyễn Hoàng Kỳ Anh |
| **Date Created** | 22/04/2026 |
| **Actor** | User (Host) |

**Description:**  
Cho phép User tạo một phòng PvP mới.

**Preconditions:**  
- User đã đăng nhập.  
- User đang ở lobby.  

**Postconditions:**  
- Phòng được tạo thành công.  
- User là Host.  
- Room ID / Link được tạo.  

**Main Flow:**  
1. User chọn "Create PvP Room".  
2. System hiển thị màn hình cấu hình.  
3. User thực hiện UC-07.1 (Configure Room).  
4. System tạo phòng (Room ID, trạng thái, link).  
5. System hiển thị phòng.  
6. User có thể Invite hoặc Share.  

**Alternative Flows:**  
- *7.1 – Invalid Configuration:* System báo lỗi, quay lại bước 2.  

**Included Use Cases:** UC-07.1: Configure Room  
**Extended Use Cases:** UC-07.2: Invite Player, UC-07.3: Share Room  

---

#### 3.7.1 UC-07.1 – Configure Room

| Field | Detail |
|---|---|
| **Use Case ID** | UC-07.1 |
| **Use Case Name** | Configure Room |
| **Created By** | Nguyễn Hoàng Kỳ Anh |
| **Date Created** | 22/04/2026 |
| **Actor** | User (Host) |

**Description:**  
Cho phép Host thiết lập các thông số của phòng PvP.

**Preconditions:**  
- User đã chọn Create PvP Room.  

**Postconditions:**  
- Cấu hình phòng được xác nhận.  

**Main Flow:**  
1. System hiển thị form cấu hình.  
2. User nhập thông tin (số người chơi, luật chơi, v.v.).  
3. User xác nhận cấu hình.  
4. System lưu cấu hình.  

**Alternative Flows:**  
- *4.1 – Invalid Input:* System báo lỗi, yêu cầu nhập lại.  

---

#### 3.7.2 UC-07.2 – Invite Player

| Field | Detail |
|---|---|
| **Use Case ID** | UC-07.2 |
| **Use Case Name** | Invite Player |
| **Created By** | Nguyễn Hoàng Kỳ Anh |
| **Date Created** | 22/04/2026 |
| **Actor** | User (Host) |

**Description:**  
Host gửi lời mời trực tiếp đến người chơi khác.

**Preconditions:**  
- Phòng đã được tạo.  

**Postconditions:**  
- Lời mời được gửi.  

**Main Flow:**  
1. Host chọn "Invite Player".  
2. System hiển thị danh sách bạn bè / nhập ID.  
3. Host chọn người chơi.  
4. System gửi lời mời.  

**Alternative Flows:**  
- *4.1 – User Not Available:* Không gửi được → báo lỗi.  

**Extended Use Cases:** Extends UC-07  

---

#### 3.7.3 UC-07.3 – Share Room

| Field | Detail |
|---|---|
| **Use Case ID** | UC-07.3 |
| **Use Case Name** | Share Room (Chia sẻ phòng) |
| **Created By** | Nguyễn Hoàng Kỳ Anh (Updated) |
| **Date Created** | 02/06/2026 |
| **Primary Actor** | User (Host / Player) |
| **Supporting Actor** | Game System |
| **Priority** | Mở rộng |

**Description:**  
Cho phép người chơi đang ở trong phòng PvP (cả Host hoặc Player thứ 2 vừa vào) tạo mã chia sẻ hoặc liên kết động (Deep Link) để gửi cho bạn bè qua các nền tảng mạng xã hội hoặc sao chép vào bộ nhớ tạm (Clipboard), giúp người khác vào phòng nhanh chóng.

**Preconditions:**  
- Người chơi đã đăng nhập thành công và hiện đang ở trong một phòng PvP hợp lệ (`Room trạng thái: WAITING`).

**Postconditions:**  
- Mã phòng (Room ID) hoặc link mời được sao chép thành công hoặc được gửi đi qua ứng dụng bên thứ ba. Trạng thái phòng không thay đổi.

**Trigger:**  
- Người chơi nhấn vào nút "Chia sẻ phòng" hoặc biểu tượng "Copy ID" trong giao diện phòng chờ PvP.

**Related Use Case:**  
- Mở rộng (`Extends`) từ UC-07 (Create PvP Room) hoặc UC-08 (Join PvP Room).

**Main Flow:**  
1. Người chơi nhấn nút "Chia sẻ phòng" tại giao diện phòng chờ.
2. Hệ thống kiểm tra trạng thái phòng hiện tại (đảm bảo phòng chưa bắt đầu đấu và chưa bị hủy).
3. Hệ thống tạo ra một chuỗi liên kết động (Deep Link) chứa thông tin `roomId`.
4. Hệ thống tự động sao chép chuỗi liên kết và Mã phòng vào Clipboard của thiết bị.
5. Hệ thống hiển thị thông báo (Toast/Popup): "Đã sao chép mã phòng và liên kết mời vào bộ nhớ tạm!".
6. Người chơi có thể dán (Paste) liên kết này để gửi cho người khác.

**Alternative Flows:**  
- *A1 – Chia sẻ qua tính năng Native Share trên Mobile:*
  1. Ở bước 3, nếu hệ thống phát hiện chạy trên ứng dụng Mobile, hệ thống sẽ gọi API chia sẻ gốc của hệ điều hành (Native Share Sheet).
  2. Người chơi chọn ứng dụng muốn chia sẻ trực tiếp (Messenger, Zalo, Discord, v.v.).
  3. Hệ thống tự động điền link phòng vào ứng dụng được chọn.

**Exception Flows:**  
- *E1 – Phòng đã bị đóng hoặc trận đấu đã Start:* 
  1. Người chơi nhấn chia sẻ nhưng cùng lúc Host bấm bắt đầu hoặc phòng bị lỗi kết nối.
  2. Hệ thống từ chối tạo link, hiển thị thông báo lỗi "Phòng không còn khả dụng để chia sẻ" và đưa người chơi về sảnh chính (Lobby).

**Business Rules:**  

| ID | Rule |
|---|---|
| BR-01 | Liên kết mời và Room ID chỉ có hiệu lực khi phòng ở trạng thái `WAITING` (chờ người chơi) và chưa đủ 2 người (nếu phòng đã đầy, link sẽ báo lỗi khi người thứ 3 click). |
| BR-02 | Link chia sẻ phải bảo mật, không được làm lộ token hoặc thông tin cá nhân mã hóa của Host. |

**Input / Output Data:**  
- **Input:** `roomId`, `playerId`
- **Output:** `shareLink` (String), Trạng thái sao chép (Boolean), Thông báo UI.

---

### 3.8 UC-08 – Join PvP Room

| Field | Detail |
|---|---|
| **Use Case ID** | UC-08 |
| **Use Case Name** | Join PvP Room |
| **Created By** | Nguyễn Hoàng Kỳ Anh |
| **Date Created** | 22/04/2026 |
| **Actor** | User (Player) |

**Description:**  
Cho phép User tham gia phòng PvP đã tồn tại.

**Preconditions:**  
- User đã đăng nhập.  
- Có Room ID hoặc link.  

**Postconditions:**  
- User vào phòng thành công.  
- Trạng thái phòng được cập nhật.  

**Main Flow:**  
1. User chọn "Join PvP Room".  
2. User thực hiện UC-08.1 (Provide Room Info).  
3. System kiểm tra room (tồn tại, chưa đầy, chưa start).  
4. System cho join (UC-08.2).  
5. System đồng bộ trạng thái.  
6. User có thể Ready (UC-08.3) hoặc Leave (UC-08.4).  

**Alternative Flows:**  
- *7.1 – Room Not Found:* Báo lỗi → quay lại bước 2.  
- *7.2 – Room Full:* Thông báo → kết thúc.  
- *7.3 – Game Started:* Không cho join → kết thúc.  

**Included Use Cases:** UC-08.1: Provide Room Info, UC-08.2: Join Room  
**Extended Use Cases:** UC-08.3: Ready, UC-08.4: Leave Room  

---

#### 3.8.1 UC-08.1 – Provide Room Info

| Field | Detail |
|---|---|
| **Use Case ID** | UC-08.1 |
| **Use Case Name** | Provide Room Info |
| **Created By** | Nguyễn Hoàng Kỳ Anh |
| **Date Created** | 22/04/2026 |
| **Actor** | User (Player) |

**Description:**  
User nhập thông tin để tham gia phòng.

**Preconditions:**  
- User chọn Join PvP Room.  

**Postconditions:**  
- Room ID / link được cung cấp cho system.  

**Main Flow:**  
1. System hiển thị form nhập.  
2. User nhập Room ID hoặc mở link.  
3. System nhận thông tin.  

**Alternative Flows:**  
- *3.1 – Invalid Format:* Báo lỗi → nhập lại.  

---

#### 3.8.2 UC-08.2 – Join Room

| Field | Detail |
|---|---|
| **Use Case ID** | UC-08.2 |
| **Use Case Name** | Join Room |
| **Created By** | Nguyễn Hoàng Kỳ Anh |
| **Date Created** | 22/04/2026 |
| **Actor** | User (Player) |

**Description:**  
System thêm User vào phòng PvP.

**Preconditions:**  
- Có Room ID hợp lệ.  

**Postconditions:**  
- User nằm trong phòng.  

**Main Flow:**  
1. System kiểm tra room.  
2. System thêm User vào danh sách phòng.  
3. System cập nhật trạng thái phòng.  

**Alternative Flows:**  
- *3.1 – Room Invalid:* Không tồn tại → lỗi.  

**Extended Use Cases:** Extends UC-08  

---

#### 3.8.3 UC-08.3 – Ready

| Field | Detail |
|---|---|
| **Use Case ID** | UC-08.3 |
| **Use Case Name** | Ready |
| **Created By** | Nguyễn Hoàng Kỳ Anh |
| **Date Created** | 22/04/2026 |
| **Actor** | User (Player) |

**Description:**  
User đánh dấu trạng thái sẵn sàng.

**Preconditions:**  
- User đã vào phòng.  

**Postconditions:**  
- Trạng thái User = Ready.  

**Main Flow:**  
1. User chọn "Ready".  
2. System cập nhật trạng thái.  
3. System đồng bộ với các Player khác.  

**Extended Use Cases:** Extends UC-08  

---

#### 3.8.4 UC-08.4 – Leave Room

| Field | Detail |
|---|---|
| **Use Case ID** | UC-08.4 |
| **Use Case Name** | Leave Room |
| **Created By** | Nguyễn Hoàng Kỳ Anh |
| **Date Created** | 22/04/2026 |
| **Actor** | User (Player) |

**Description:**  
User rời khỏi phòng PvP.

**Preconditions:**  
- User đang ở trong phòng.  

**Postconditions:**  
- User bị xóa khỏi phòng.  

**Main Flow:**  
1. User chọn "Leave Room".  
2. System xóa User khỏi room.  
3. System cập nhật trạng thái phòng.  

**Extended Use Cases:** Extends UC-08  

---

### 3.9 UC-09 – Đặt tàu

| Field | Detail |
|---|---|
| **Use Case ID** | UC-09 |
| **Use Case Name** | Đặt tàu |
| **Created By** | Trương Phúc Nên |
| **Date Created** | 24/04/2026 |
| **Primary Actor** | User / Guest |
| **Supporting Actor** | Game System |
| **Priority** | Cốt lõi |

**Description:**  
Người chơi chọn tàu, chọn ô bắt đầu và chọn hướng đặt tàu. Hệ thống kiểm tra vị trí hợp lệ rồi hiển thị tàu trên bàn chơi.

**Preconditions:**  
- GameSession đã được tạo; game đang ở trạng thái PLACING_SHIPS; người chơi chưa xác nhận sẵn sàng.

**Postconditions:**  
- Tàu được đặt hợp lệ trên bàn chơi. Khi đặt đủ tàu, người chơi có thể xác nhận sẵn sàng và trạng thái bàn chơi được lưu.

**Trigger:**  
- Người chơi vào màn hình chuẩn bị trận đấu và bắt đầu đặt tàu.

**Related Use Case:** Liên quan đến UC-10 khi game chuyển sang giai đoạn thực hiện lượt bắn.

**Main Flow:**  
1. Hệ thống hiển thị bàn chơi của người chơi.  
2. Hệ thống hiển thị danh sách tàu cần đặt.  
3. Người chơi chọn một tàu cần đặt.  
4. Người chơi chọn ô bắt đầu trên bàn chơi.  
5. Người chơi chọn hướng đặt tàu: ngang hoặc dọc.  
6. Hệ thống kiểm tra vị trí đặt tàu.  
7. Nếu vị trí hợp lệ, hệ thống đặt tàu lên bàn chơi.  
8. Hệ thống cập nhật giao diện và đánh dấu các ô đã có tàu.  
9. Người chơi tiếp tục đặt các tàu còn lại.  
10. Khi đã đặt đủ tàu, người chơi bấm Sẵn sàng.  
11. Hệ thống lưu trạng thái bàn chơi của người chơi.  

**Alternative Flows:**  
- *A1 – Đổi hướng tàu:* Người chơi chọn chức năng xoay tàu. Hệ thống đổi hướng từ ngang sang dọc hoặc ngược lại và cập nhật preview.  
- *A2 – Đặt lại bàn chơi:* Người chơi chọn đặt lại. Hệ thống xóa các tàu đã đặt và cho phép thực hiện lại.  
- *A3 – Tự động sắp xếp tàu:* Người chơi chọn tự động sắp xếp. Hệ thống tạo vị trí hợp lệ cho toàn bộ tàu và hiển thị lên bàn chơi.  

**Exception Flows:**  
- *E1 – Vị trí đặt tàu không hợp lệ:* Tàu vượt ra ngoài bàn chơi hoặc đè lên tàu khác. Hệ thống hiển thị thông báo lỗi và không đặt tàu.  
- *E2 – Chưa đặt đủ tàu nhưng bấm Sẵn sàng:* Hệ thống hiển thị thông báo yêu cầu đặt đủ toàn bộ tàu trước khi xác nhận.  
- *E3 – Thao tác khi game đã bắt đầu:* Hệ thống từ chối thao tác và giữ nguyên trạng thái bàn chơi.  

**Business Rules:**  

| ID | Rule |
|---|---|
| BR-01 | Tàu phải nằm hoàn toàn trong phạm vi bàn chơi. |
| BR-02 | Tàu không được chồng lên tàu khác. |
| BR-03 | Tàu chỉ được đặt theo đường thẳng ngang hoặc dọc. |
| BR-04 | Người chơi chỉ được xác nhận sẵn sàng khi đã đặt đủ toàn bộ tàu. |
| BR-05 | Sau khi trận đấu bắt đầu, người chơi không được thay đổi vị trí tàu. |

**Input / Output Data:**  
- Input: `playerId`, `shipId`, `startCoordinate`, `orientation`  
- Output: Trạng thái bàn chơi, danh sách tàu đã đặt, thông báo hợp lệ hoặc không hợp lệ.  

---

### 3.10 UC-10 – Thực hiện lượt bắn

| Field | Detail |
|---|---|
| **Use Case ID** | UC-10 |
| **Use Case Name** | Thực hiện lượt bắn |
| **Created By** | Trương Phúc Nên |
| **Date Created** | 24/04/2026 |
| **Primary Actor** | User / Guest |
| **Supporting Actor** | Game System, Opponent |
| **Priority** | Cốt lõi |

**Description:**  
Trong lượt của mình, người chơi chọn một ô trên bàn đối phương. Hệ thống kiểm tra lượt chơi, kiểm tra ô được chọn và xử lý lượt bắn.

**Preconditions:**  
- Game đang ở trạng thái IN_PROGRESS; hai bên đã đặt tàu xong; đang đến lượt của người chơi.

**Postconditions:**  
- Lượt bắn được ghi nhận; kết quả bắn được tạo; trạng thái lượt chơi được cập nhật.

**Trigger:**  
- Người chơi click hoặc chọn một ô trên bàn đối phương.

**Related Use Case:** Bao gồm UC-11 để xác định và hiển thị kết quả lượt bắn.

**Main Flow:**  
1. Hệ thống hiển thị bàn bắn của đối phương.  
2. Hệ thống hiển thị thông tin lượt hiện tại.  
3. Người chơi chọn một ô muốn bắn.  
4. Hệ thống kiểm tra game có đang diễn ra hay không.  
5. Hệ thống kiểm tra có đúng lượt của người chơi hay không.  
6. Hệ thống kiểm tra ô đã được bắn trước đó chưa.  
7. Nếu hợp lệ, hệ thống tạo đối tượng Shot.  
8. Hệ thống gửi tọa độ bắn đến bàn chơi của đối phương.  
9. Hệ thống xử lý kết quả lượt bắn thông qua UC-11.  
10. Hệ thống cập nhật trạng thái lượt chơi.  
11. Nếu game chưa kết thúc, lượt được chuyển sang người chơi tiếp theo.  

**Alternative Flows:**  
- *A1 – Chơi với AI trong PvE:* Sau khi người chơi bắn hợp lệ, hệ thống tự động thực hiện lượt bắn của AI theo độ khó đã chọn.  
- *A2 – Chơi PvP Local:* Hai người chơi dùng cùng thiết bị và thay phiên nhau chọn ô bắn. Hệ thống chỉ hiển thị thông tin phù hợp với người chơi hiện tại.  
- *A3 – Chơi PvP Online:* Hệ thống gửi lệnh bắn lên server để đồng bộ trạng thái trận đấu giữa hai người chơi.  

**Exception Flows:**  
- *E1 – Chưa đến lượt người chơi:* Hệ thống hiển thị thông báo "Chưa đến lượt của bạn" và không ghi nhận lượt bắn.  
- *E2 – Ô đã được bắn trước đó:* Hệ thống hiển thị thông báo "Ô này đã được bắn" và yêu cầu chọn ô khác.  
- *E3 – Tọa độ bắn không hợp lệ:* Hệ thống hiển thị thông báo lỗi và không xử lý lượt bắn.  
- *E4 – Game không ở trạng thái đang diễn ra:* Hệ thống từ chối thao tác và hiển thị trạng thái hiện tại của game.  
- *E5 – Đối thủ mất kết nối (PvP Online):* Hệ thống tạm dừng trận đấu hoặc chờ đối thủ kết nối lại theo thời gian chờ đã quy định.  

**Business Rules:**  

| ID | Rule |
|---|---|
| BR-01 | Mỗi lượt chỉ được bắn một ô hợp lệ. |
| BR-02 | Người chơi không được bắn vào bàn của chính mình. |
| BR-03 | Người chơi không được bắn lại vào ô đã bắn. |
| BR-04 | Lượt bắn chỉ được chấp nhận khi đúng lượt của người chơi. |
| BR-05 | Sau mỗi lượt bắn hợp lệ, hệ thống phải tạo kết quả bắn. |
| BR-06 | Nếu game chưa kết thúc, hệ thống chuyển lượt cho người chơi tiếp theo. |

**Input / Output Data:**  
- Input: `sessionId`, `playerId`, `targetCoordinate`  
- Output: `Shot`, `ShotResult`, trạng thái lượt chơi, thông báo kết quả hoặc thông báo lỗi.  

---

### 3.11 UC-11 – Xem kết quả lượt bắn

| Field | Detail |
|---|---|
| **Use Case ID** | UC-11 |
| **Use Case Name** | Xem kết quả lượt bắn |
| **Created By** | Trương Phúc Nên |
| **Date Created** | 24/04/2026 |
| **Primary Actor** | Game System |
| **Supporting Actor** | User / Guest |
| **Priority** | Cốt lõi |

**Description:**  
Hệ thống kiểm tra ô bị bắn, xác định kết quả là trúng, trượt, chìm tàu hoặc thắng trận, sau đó cập nhật bàn chơi và hiển thị kết quả cho người chơi.

**Preconditions:**  
- Lượt bắn từ UC-10 đã hợp lệ; tồn tại bàn chơi của đối phương; tọa độ bắn nằm trong phạm vi bàn chơi.

**Postconditions:**  
- Ô bị bắn được cập nhật trạng thái; kết quả được hiển thị; nếu toàn bộ tàu đối phương bị chìm thì game chuyển sang trạng thái FINISHED.

**Trigger:**  
- UC-10 gửi tọa độ bắn hợp lệ cho hệ thống xử lý.

**Related Use Case:** Được gọi từ UC-10 sau khi hệ thống xác nhận lượt bắn hợp lệ.

**Main Flow:**  
1. Hệ thống nhận thông tin lượt bắn gồm người bắn và tọa độ bắn.  
2. Hệ thống truy xuất ô tương ứng trên bàn chơi của đối phương.  
3. Hệ thống kiểm tra ô đó có tàu hay không.  
4. Nếu ô không có tàu, hệ thống đánh dấu kết quả là MISS – Trượt.  
5. Nếu ô có tàu, hệ thống đánh dấu kết quả là HIT – Trúng.  
6. Hệ thống cập nhật trạng thái ô trên bàn chơi.  
7. Nếu tàu bị bắn đã trúng đủ số ô, hệ thống đánh dấu tàu là SUNK – Chìm.  
8. Hệ thống kiểm tra toàn bộ tàu của đối phương đã chìm hết chưa.  
9. Nếu game chưa kết thúc, hệ thống hiển thị kết quả bắn cho người chơi.  
10. Hệ thống ghi nhận kết quả lượt bắn vào lịch sử ván chơi.  

**Alternative Flows:**  
- *A1 – Bắn trượt:* Ô không chứa tàu. Hệ thống cập nhật ô thành MISS và hiển thị thông báo "Bắn trượt".  
- *A2 – Bắn trúng:* Ô chứa một phần của tàu. Hệ thống cập nhật ô thành HIT và hiển thị thông báo "Bắn trúng".  
- *A3 – Bắn chìm tàu:* Toàn bộ các ô của tàu đều đã bị bắn. Hệ thống cập nhật trạng thái tàu là đã chìm và hiển thị thông báo.  
- *A4 – Kết thúc game:* Nếu tất cả tàu của đối phương đã chìm, hệ thống xác định người bắn là người chiến thắng và chuyển game sang trạng thái FINISHED.  

**Exception Flows:**  
- *E1 – Ô đã được bắn trước đó:* Hệ thống trả về kết quả ALREADY_SHOT và không cập nhật lại bàn chơi.  
- *E2 – Không tìm thấy bàn chơi mục tiêu:* Hệ thống ghi nhận lỗi và không xử lý kết quả bắn.  
- *E3 – Dữ liệu lượt bắn không hợp lệ:* Hệ thống từ chối xử lý và trả về kết quả INVALID.  

**Business Rules:**  

| ID | Rule |
|---|---|
| BR-01 | Nếu ô không có tàu, kết quả là MISS. |
| BR-02 | Nếu ô có tàu, kết quả là HIT. |
| BR-03 | Nếu toàn bộ phần của một tàu đã bị bắn trúng, tàu đó được xem là SUNK. |
| BR-04 | Nếu toàn bộ tàu của một người chơi đã chìm, người chơi còn lại thắng. |
| BR-05 | Người chơi chỉ được thấy kết quả bắn, không được thấy vị trí các tàu chưa bị bắn của đối phương. |
| BR-06 | Trạng thái ô, trạng thái tàu và trạng thái game phải được cập nhật đồng bộ sau lượt bắn. |

**Input / Output Data:**  
- Input: `Shot`, `targetBoard`, `targetCoordinate`  
- Output: `ShotResult`, trạng thái ô, trạng thái tàu, trạng thái game.  

---

### 3.12 UC-12 – Kết thúc game

| Field | Detail |
|---|---|
| **Use Case ID** | UC-12 |
| **Use Case Name** | Kết thúc game |
| **Created By** | Nguyễn Thành Đạt |
| **Date Created** | 26/04/2026 |
| **Primary Actor** | Hệ thống |

**Description:**  
Xác định khi nào trận đấu kết thúc và hiển thị kết quả.

**Preconditions:**  
1. Trận đấu PvE hoặc PvP đã được khởi tạo và đang diễn ra.  
2. Người chơi và đối thủ đã hoàn tất việc đặt tàu.  
3. Bàn cờ đã được cập nhật sau mỗi lần bắn.  
4. Hệ thống đang theo dõi tình trạng của các tàu (chìm/chưa chìm).  

**Postconditions:**  
1. Trận đấu được đánh dấu là "kết thúc".  
2. Hệ thống xác định thắng/thua.  
3. Hệ thống xuất ra thông báo người thắng/người thua.  

**Main Flow:**  
1. Sau mỗi lượt bắn, hệ thống cập nhật trạng thái hit/miss lên bàn cờ, tàu bị chìm.  
2. Hệ thống kiểm tra danh sách tàu của cả hai bên.  
3. Nếu phát hiện tất cả tàu của một bên đã bị bắn chìm.  
4. Hệ thống đánh dấu trận đấu là kết thúc.  
5. Hệ thống xác định bên thắng, bên thua.  
6. Hệ thống thông báo ra màn hình trận đấu kết thúc và ai là người thắng.  
7. Nếu vẫn còn tàu trên bàn cờ, trò chơi vẫn tiếp tục.  

**Alternative Flows:**  
- *A1 – Người chơi thoát game giữa trận:* Hệ thống xuất thông báo trận đấu đã kết thúc và phán định người chơi thoát giữa chừng thua.  
- *A2 – Lỗi hệ thống / mất kết nối:* Dừng trận đấu một khoảng thời gian và hiển thị thông báo "Trận đấu bị tạm dừng do lỗi hệ thống vui lòng đợi".  

**Exception Flows:**  
- Lỗi hệ thống (mất kết nối, dữ liệu không lưu được) → trận đấu tạm dừng, hiển thị thông báo lỗi.  

**Business Rules:**  
1. Trận đấu kết thúc khi toàn bộ tàu của một bên đã bị bắn chìm.  
2. Nếu người chơi thoát trận giữa chừng → hệ thống mặc định người chơi thua.  
3. Kết quả trận đấu phải được lưu lại.  
4. Hệ thống phải hiển thị thông báo kết quả rõ ràng (thắng/thua/hòa nếu có).  
5. Trong trường hợp lỗi hệ thống, trận đấu được đánh dấu là "kết thúc bất thường" và không tính vào bảng xếp hạng.  

---

### 3.13 UC-13 – Xem bảng xếp hạng

| Field | Detail |
|---|---|
| **Use Case ID** | UC-13 |
| **Use Case Name** | Xem bảng xếp hạng |
| **Created By** | Nguyễn Thành Đạt |
| **Date Created** | 26/04/2026 |
| **Primary Actor** | Người chơi |

**Description:**  
Xem thứ hạng của mình và các người chơi khác.

**Preconditions:**  
1. Người chơi đã đăng nhập vào hệ thống.  
2. Hệ thống có dữ liệu bảng xếp hạng.  

**Postconditions:**  
- Người chơi xem được thứ hạng hiện tại.  

**Main Flow:**  
1. Người chơi chọn chức năng "Xem bảng xếp hạng".  
2. Hệ thống truy xuất dữ liệu bảng xếp hạng.  
3. Hệ thống hiển thị danh sách thứ hạng, điểm số.  

**Alternative Flows:**  
- Nếu người chơi chưa có trận đấu nào → hệ thống hiển thị thông báo "Chưa có dữ liệu để xếp hạng".  

**Exception Flows:**  
- Lỗi truy xuất dữ liệu → hệ thống hiển thị thông báo "Không thể tải bảng xếp hạng".  

**Business Rules:**  
1. Người chơi chỉ xem được bảng xếp hạng sau khi đăng nhập.  
2. Bảng xếp hạng được tính dựa trên điểm số hoặc số trận thắng theo thuật toán đã định sẵn.  
3. Dữ liệu bảng xếp hạng phải được cập nhật sau mỗi trận đấu hợp lệ.  
4. Nếu người chơi chưa có dữ liệu → hệ thống hiển thị thông báo "Chưa có dữ liệu để xếp hạng".  
5. Bảng xếp hạng chỉ hiển thị thông tin cho phép (tên hiển thị, điểm số), không tiết lộ dữ liệu cá nhân.  

---

### 3.14 UC-14 – Xem lịch sử trận đấu

| Field | Detail |
|---|---|
| **Use Case ID** | UC-14 |
| **Use Case Name** | Xem lịch sử trận đấu |
| **Created By** | Nguyễn Thành Đạt |
| **Date Created** | 26/04/2026 |
| **Primary Actor** | Người chơi |

**Description:**  
Xem lại danh sách các trận đã chơi.

**Preconditions:**  
1. Người chơi đã đăng nhập.  
2. Hệ thống có dữ liệu lịch sử trận đấu.  

**Postconditions:**  
- Người chơi xem được danh sách các trận đã chơi.  

**Main Flow:**  
1. Người chơi chọn chức năng "Xem lịch sử trận đấu".  
2. Hệ thống truy xuất dữ liệu lịch sử.  
3. Hệ thống hiển thị danh sách các trận: ngày giờ, đối thủ, kết quả.  

**Alternative Flows:**  
- Nếu người chơi chưa từng chơi trận nào → hệ thống hiển thị thông báo "Chưa có lịch sử trận đấu".  

**Exception Flows:**  
- Lỗi truy xuất dữ liệu → hệ thống hiển thị thông báo "Không thể tải lịch sử trận đấu".  

**Business Rules:**  
1. Người chơi phải đăng nhập để xem lịch sử trận đấu của chính mình.  
2. Lịch sử trận đấu bao gồm: ngày giờ, đối thủ, kết quả, và trạng thái trận (hợp lệ/bất thường).  
3. Hệ thống chỉ hiển thị lịch sử của người chơi, không cho phép xem lịch sử của người khác.  
4. Nếu người chơi chưa từng chơi trận nào → hệ thống hiển thị thông báo "Chưa có lịch sử trận đấu".  
5. Lịch sử trận đấu phải được lưu trữ và truy xuất chính xác, không được chỉnh sửa thủ công bởi người chơi.  

---

### 3.15 UC-15 – Quick Join (Tham gia nhanh)

| Field | Detail |
|---|---|
| **Use Case ID** | UC-15 |
| **Use Case Name** | Quick Join (Tham gia nhanh) |
| **Created By** | Nguyễn Hoàng Kỳ Anh |
| **Date Created** | 26/05/2026 |
| **Primary Actor** | User (Player) |
| **Supporting Actor** | Matchmaking System (Hệ thống ghép trận) |
| **Priority** | Quan trọng |

**Description:**  
Cho phép người chơi tham gia ngay vào một trận đấu PvP ngẫu nhiên mà không cần phải nhập mã phòng (Room ID) hoặc đợi link mời. Hệ thống sẽ tự động quét các phòng đang thiếu người hoặc tự khởi tạo phòng mới nếu không tìm thấy phòng phù hợp.

**Preconditions:**  
- User đã đăng nhập thành công.  
- User đang ở màn hình sảnh chính (Lobby) và không nằm trong bất kỳ phòng chơi nào khác.  

**Postconditions:**  
- Người chơi được xếp vào một phòng PvP hợp lệ (`Room trạng thái: WAITING`), sẵn sàng cho giai đoạn đặt tàu.

**Trigger:**  
- Người chơi nhấn nút "Chơi nhanh" hoặc "Quick Join" từ màn hình sảnh chính.

**Related Use Case:**  
- Tương tác mật thiết với UC-08 (Join PvP Room) để đồng bộ hóa logic vào phòng công cộng.

**Main Flow:**  
1. Người chơi nhấn nút "Quick Join".
2. Hệ thống chuyển giao diện sang trạng thái chờ ghép trận ("Đang tìm kiếm đối thủ...").
3. Hệ thống Matchmaking quét trong cơ sở dữ liệu/bộ nhớ đệm để tìm các phòng PvP đang mở (`status = WAITING`) và mới chỉ có 1 người chơi (Host đang đợi).
4. Hệ thống tìm thấy một phòng phù hợp thỏa mãn điều kiện.
5. Hệ thống tự động thêm người chơi này vào phòng đó làm Đối thủ (Player 2).
6. Hệ thống đồng bộ hóa trạng thái phòng, gửi thông báo cho cả Host và Người chơi mới tham gia.
7. Giao diện chuyển hướng người chơi vào màn hình phòng chờ PvP chung.

**Alternative Flows:**  
- *A1 – Không tìm thấy phòng nào đang trống:*
  1. Ở bước 4, hệ thống quét toàn bộ danh sách phòng công cộng nhưng tất cả đều đầy hoặc đã bắt đầu chơi.
  2. Hệ thống tự động chuyển hướng gọi luồng **UC-07 (Create PvP Room)** để tạo một phòng công cộng mới và đặt User này làm Host của phòng đó.
  3. Hệ thống giữ User ở trạng thái chờ cho đến khi có một người chơi khác bấm "Quick Join" thế chỗ vào phòng của họ.

**Exception Flows:**  
- *E1 – Người chơi bấm Huỷ trong lúc đang tìm trận:*
  1. Người chơi nhấn nút "Hủy tìm trận" (Cancel).
  2. Hệ thống dừng tiến trình quét Matchmaking, giải phóng tài nguyên và đưa người chơi quay về sảnh chính an toàn.
- *E2 – Lỗi xung đột phòng đầy (Race Condition):*
  1. Hệ thống tìm thấy phòng trống ở bước 4 và chuẩn bị đẩy User vào, nhưng cùng mili-giây đó một User khác đã nhanh chân chiếm chỗ trước.
  2. Hệ thống ghi nhận lỗi "Room Full", tự động bỏ qua phòng đó và tiếp tục tiến trình quét tìm phòng khác mà không cần người dùng thao tác lại.

**Business Rules:**  

| ID | Rule |
|---|---|
| BR-01 | Hệ thống ưu tiên ghép vào phòng có thời gian chờ lâu nhất trước (First-Come, First-Served) để giảm thiểu thời gian nghẽn phòng của các Host khác. |
| BR-02 | Người chơi có quyền Hủy lệnh "Quick Join" bất cứ lúc nào trước khi hệ thống thực hiện lệnh Khóa phòng (Match Found). |
| BR-03 | Nếu hệ thống áp dụng hệ thống Rank/MMR sau này, Quick Join phải ưu tiên lọc các phòng có độ lệch Rank nhỏ hơn mức cấu hình quy định (ví dụ: +/- 200 điểm). |

**Input / Output Data:**  
- **Input:** `playerId`, lệnh `triggerQuickJoin`
- **Output:** `roomId` được chỉ định, trạng thái kết nối phòng (`success`/`failed`), thông tin đối thủ.
