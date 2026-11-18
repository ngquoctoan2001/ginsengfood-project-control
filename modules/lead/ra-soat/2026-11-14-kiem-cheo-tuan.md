# Kiểm chéo tuần 09–14/11 (bản tổng hợp M1–M8)

Lập 14/11 15:1x. Đầu vào: báo cáo Toàn (`…-Toan.md`, lập 14:40 từ 5 phiên + 3 auditor), Phúc (`…-M3-ban-hang.md`, chốt 14:00),
Tài (một tệp chung M3/M4/M5/M6 `…-Tai.md`, chốt 13:30). 4 auditor chỉ đọc: Phúc · Tài M3+M4 · Tài M5+M6 · Toàn + commit sau giờ + chỗ nối.
Bản rà trong thư mục tuần: `…-M3-ban-hang-ra-soat.md`, `…-Tai-ra-soat.md`, `…-Toan-ra-soat.md`.

## Commit sau giờ báo cáo
- Không commit nào làm sai câu nào của báo cáo Toàn. Sau 14:30: ops-core `a29721959` (sổ), `0aa2ecb3e` (sửa 2 lỗi SAST, chỉ GitLab); M7 push `5609ed1`, `9ca04ca`, `d743c88` lên `origin/main`.
- Báo cáo Phúc cũ ở 4 chỗ "Toàn chạy E01, E02" — `e8e3e5e13` 14:06 đính chính 6/10 ca.
- Báo cáo Tài cũ: module5 `de2d0925` (PR #117) gộp 14:07; M4-PLAN chuyển việc dữ liệu thử sang commit.

## Chỗ nối hai module
| Nối | Kết luận |
|---|---|
| M3 → M8 gọi xác nhận | Khớp hai phía (task + callback); hợp đồng ở repo ivr `1.0.0-draft.45`, repo hợp đồng chung còn bản 21/09. Phúc ghi "thiếu xác nhận đơn tự động" — lệch (đã có, đạt trên .99) |
| M3 ↔ kho M1–M2 | Khớp: hai phía xong, tắt (`OPS_CORE_ENABLED=false`); hợp đồng chỉ ở nhánh `m12-noi-m3`. Phúc ghi "NK-b chưa có mã" — lệch (Toàn viết 12/11); NK-c (giữ hàng Giờ Vàng) chưa có |
| M5 đọc trạng thái đơn M3 | API của Phúc đã ở `dev`, nginx chỉ .98 đã có từ 13/11; bộ đọc M5 còn ở nhánh. Tài ghi "chờ Phúc làm API" — lệch. Thiếu thật: bản .99 chưa chứa API, compose .99 thiếu 2 biến, cửa TLS .99–.98 chưa mở (việc Toàn) |
| M5 → M4 tư vấn | Đường gọi khớp hai phía; không có hợp đồng chung; M5 đòi https → phụ thuộc cửa TLS .99–.98 |
| M3 → M6 doanh thu | M6 chưa bật đường nhận (DL-O10 mở), M3 chưa có mã gửi → chưa ai nhận chốt |
| Thanh toán, vận chuyển | VNPAY sửa đã vào `dev`, chưa trên .99; .99 chưa HTTPS; SPX chưa vào `dev` |

## Đã xử lý trong bản gửi Chú
- Dùng số đã đối chiếu: gọi xác nhận 6/10; NK-b đã có; API trạng thái đơn đã có (thiếu triển khai .99); quy tắc huỷ đơn đã chốt 10/11; số đo M4 16/76/58; M5 "gộp" ≠ xong (23 việc còn phải sửa); No-go M5 là cho pilot một Page lượt 13/11.
- Báo cáo Toàn sửa 15:0x: 77 commit; nghiệm thu "số tới 10/11"; M3 chuyển .99 thêm 1,5 phút lượt 2; 3 lượt giữ đang mở; bỏ màn "Liên kết nhà máy"; T085 xong; kế hoạch thêm 3 việc người khác chờ Toàn.
- Màu Kịp 30/11 phiên lead chấm (Toàn duyệt): M3 Phúc, M5, M6, M7 Đỏ; còn lại Vàng.

## Còn để Toàn quyết (ngoài bản gửi Chú)
- Ai chốt đường M3 → M6 (DL-O10); m34.7 người duyệt câu an toàn sức khoẻ M4; có nạp dữ liệu thử M4 lên .99 không; bắt buộc vào `dev` qua PR (Phúc bật ruleset); gửi lại quy tắc huỷ đơn cho Phúc; 30/11 M3 chỉ COD hay chờ VNPAY.
