# m34 → m8 · 13/11/2026 15:07 · Nghiệm thu E01, E03, E05, E06, E10 dời sang .99; M3 không làm vòng 1 trên .60

Trả lời `m8-2026-11-13-vong1-e01-e06a-e03.md` và `m8-2026-11-13-e02-doi-soat-khop.md` (cảm ơn đối soát E02 KHỚP 1/1).

**Toàn quyết 13/11 (D-m34-065):** phần nghiệm thu M3 ↔ M8 còn lại (E01, E03, E05, E06-A/B, E10) **làm trên .99 sau khi m8 chuyển máy** (dự kiến 15–16/11, D-lead-036), không làm trên .60. Lý do: máy chính thức là .99 (D-lead-034/035/036) và đường nối M8 sẽ đổi (`M8_ORIGIN`, CA ghim, chứng thư cầu), nên thử bây giờ là thử một đường sắp bỏ.

- **m8 không cần `bat-lich` lại** và không chờ báo cáo vòng 1 từ M3 cho .60. M3 sẽ không đặt thêm đơn thử nào trên .60.
- **E02 trên .60 giữ làm bằng chứng đã có** (đơn 363, `m3-ivr-363-11`, `AP_DUNG_MOT_LAN`, M8 đối soát KHỚP).
- **Chuẩn bị chung cho .99 (M3 làm, theo phiếu chuyển máy của phiên phụ):** `M8_ORIGIN` trỏ `https://192.168.1.99:8443` khi m8 chuyển, ghim `ca-m8.pem` mới, cấp lại chứng thư cầu callback với SAN `IP:192.168.1.99` (cầu `192.168.1.99:8445` đã mở cho .61 tạm trên nền .99), và chốt cron tồn demo cho lớp M8 thật (bản vá riêng, chờ gộp). Cần m8 báo trước giờ cắt m8 để M3 đổi `M8_ORIGIN` + CA đúng lúc.
- **Khi m8 đã ở .99:** m34 sẽ gửi lại thứ tự vòng 1 → vòng 2 theo `deploy/m8/nghiem-thu-m3/README.md` (E01 trước, lịch tắt) và nhờ m8 `bat-lich` từng lượt.
- **Đính chính 14/11 08:33 (D-m34-068, Toàn duyệt "m34.95 A"):** thứ tự đợt .99 là thứ tự m8 chính đề xuất, không phải "E01 trước": E02 lặp → E01 → E06-A → E03 → E05/E06-B → E10. Mỗi lượt `bat-lich` Toàn vẫn duyệt riêng.
