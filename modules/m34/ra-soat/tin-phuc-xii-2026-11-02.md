# Tin nháp gửi Phúc — mảng XII Quản trị hệ thống (02/11)

> Chưa gửi. Lead xem, sửa rồi tự gửi. D-m34-010 (m34.12) đã chốt 02/11 17:32; còn dòng ưu tiên (m34.14) chờ chốt.

Phúc ơi, anh giao em đóng hẳn mảng XII "Quản trị hệ thống" (báo cáo hiện trạng đang ghi khoảng 80%). Anh đã đưa 21 thẻ lên Sheet tab M3,
giai đoạn "XII Quản trị hệ thống", mã **M3-039 → M3-059**. Mỗi thẻ có đích đến, cách chia agent chạy song song, cách kiểm và giờ ước tính.

- **Nền:** nhánh `PhucApu` từ `09304d56a` (đã có M3-024 dọn menu). Trước sóng 1 em commit/push hoặc dọn hết phần đang dở (UI-kit v2).
- **Lịch:** 7 sóng từ 03/11 đến 10/11, mỗi sóng 2–3 thẻ:
  - 03/11: M3-039, 040, 041, 042
  - 04/11: 043, 045, 046
  - 05/11: 047, 048, 049
  - 06/11: 050, 051, 052
  - 07/11: 053, 054, 055
  - 09/11: 056, 057
  - 10/11: 059, 058

  Cột "Sẵn sàng" trên Sheet đã tự hiện thẻ nào còn chờ thẻ nào.
- **Cách chạy:** mỗi sóng một phiên điều phối của em. Mỗi thẻ 2–3 subagent chạy cùng lúc (coder BE, coder FE, tester viết test trước);
  verifier chạy sau, làm lại từ đầu và thử đột biến. Không quá 6 agent nặng cùng lúc.
  - Test/verifier chạy trong worktree tách rời (`git worktree add --detach`), không build trên checkout chung.
  - Chỉ phiên điều phối được sửa các tệp nóng: `SecurityConfig`, seed quyền/sự kiện, `pom.xml`, `application*.yml`, OpenAPI/snapshot,
    `AdminSidebar`. Đầu sóng thì seed quyền và mở route; cuối sóng thì sinh OpenAPI.
- **Push sau mỗi thẻ**, ghi Sheet `--id`. Thẻ R3 (đăng nhập, phân quyền, duyệt, legal hold) chỉ gộp `dev` khi cột "Lead duyệt" = Đạt.
- **Migration:** hạn chế. Cần thì lấy số ngay trước khi gộp `dev`, sau khi xem mọi nhánh. Em đang giữ V259 (bảng hạng); bên M3→M8 của
  anh đã chuyển sang V260–V261 (chưa commit), em tránh hai số này.
- **Ưu tiên:** XII trước lô giao diện M3-022/M3-026, nhưng vẫn giữ M3-010 hạn 03/11 (chờ anh chốt).
- **M3-044** (giới hạn đăng nhập theo IP/thiết bị) đang Bị chặn vì chờ hạ tầng, em bỏ qua.
- **M3-058** (kho S3) là thẻ bỏ đầu tiên nếu hết lượt AI.
- Anh đã chốt các mặc định (D-m34-010):
  - 2FA ngoài phạm vi tới 15/11. Quên mật khẩu nhân viên dùng OTP qua email công việc, chưa bắt Authenticator; bù bằng thu hồi mọi phiên
    và mail báo. Em ghi thêm dòng AAH-D68 vào sổ quyết định xác thực trong M3-039.
  - Email anh/em nhập khi tạo nhân viên được coi là email công việc đã xác minh.
  - Màn thiết bị đang đăng nhập theo phương án A cả 4 điểm (OD-01..04).
  - Tạo nhân viên chỉ ghi audit, không thêm mã sự kiện mới.
  - Hạn hậu kiểm break-glass là 1 ngày làm việc T2–T6, chưa trừ lễ.
  - Legal hold: máy chủ trước 15/11, màn hình 09/11.
  - Anh duyệt các spec P0-39/40/41, em làm luôn, không chờ chủ dự án duyệt nữa.

Ước tính: viết tay khoảng 214 giờ. Chạy AI đa luồng theo sóng khoảng 45 giờ đồng hồ, trong đó em ngồi trực tiếp khoảng 33 giờ.
