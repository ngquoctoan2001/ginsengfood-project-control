# Tổng quan hệ thống Ginsengfood M1–M9

Mốc dữ liệu: 24/11/2026 23:xx (`/tong-hop-tuan` 14–24/11, gộp hai tuần) · chỉ phiên `lead` sửa tệp này.
Máy chủ: .99 nhà máy + bán hàng (M1–M2 `417f15d53`, M3/M4/M9 `1e2406589` do Phúc đưa 21/11, M8 `f8e29b46`), .98 mkt (M5 + M6) + proxy HTTPS `edge`,
.63 CI + M7; .60/.61 dừng, giữ dữ liệu làm đường lui (`chung/MAY_CHU.md`). **Hạn dự án 30/11/2026** (D-lead-025); 15/11 giữa kỳ không đạt.
Bản gửi Chú: `C:/Projects/bao-cao-tuan/2026-11-14_2026-11-24/bao-cao-tong-hop-2026-11-14_2026-11-24.md` + `.docx` (12 trang, chưa gửi);
số đã đối chiếu: `modules/lead/ra-soat/2026-11-24-kiem-cheo-tuan.md` (Phúc 21/30 khớp, Tài 16/25 khớp). Màu dưới đây là của phiên lead, không đưa vào bản gửi Chú.

## Bảng 10 dòng

| Module | Làm gì | Người | Phiên | 30/11 | Tình hình một câu |
|---|---|---|---|---|---|
| M1–M2 | nhà máy, kho, truy xuất, QC | Toàn | `m12` | VÀNG | 5 lượt lên .99 (tới 23/11); UAT tới 17/11 1.737/10/53/58/468; chưa phiếu thật; nghiệm thu + tập huấn sáng 27/11 |
| M3 bán hàng | giao diện + backend | Phúc | `m34` | ĐỎ | 63 commit trên `dev`, 4 lượt .99; chưa chạy thử luồng khách, huỷ đơn 0 commit; 43/85 việc Cần sửa; 0 commit GitHub 22–24/11 |
| M3 vận chuyển + thanh toán | VNPAY, GHN, SPX, VTP | Tài | `m34` | VÀNG | 3 logo + VNPAY khách vãng lai trên .99; chưa hãng nào báo giá (VTP 503, SPX 403, GHN thiếu cân); IPN .99 403 |
| M3 nối M8 + M12, máy chủ | M3 → M8, M3 ↔ M12, .99 | Toàn | `m34` | VÀNG | E01–E10 8/10 (giả lập); luật gọi M3 trên `dev`, chưa lên .99; nối kho tắt, chưa đầu-cuối |
| M4 | AI tư vấn | Tài | `m34` | ĐỎ | 27 việc an toàn; 20 kịch bản bán hàng .99 8/20 (máy tự chấm); Claude .99 401 ngày 20/11; chưa nối M5 |
| M5 | cổng Facebook | Tài | `m5` | VÀNG | 41 PR, .98 15 lượt; app Meta Live 18/11; chưa gắn Page, chưa App Review; M5-094 bí mật trễ 20 ngày; SMK .98 1/14 |
| M6 | đo quảng cáo / ROAS | Tài | `m6` | ĐỎ | 15 PR; nhận đơn M3 chỉ phía nhận (giả lập), BP chưa phát; 1 lỗi Cao bảo mật sửa 24/11 |
| M7 | video Giờ Vàng | Toàn | `m7` | ĐỎ | video 2 (24/11) kiểm lời 0,934; chưa duyệt; Mốc 2 chưa có code, Toàn quyết 26/11 |
| M8 | gọi xác nhận đơn | Toàn | `m8` | VÀNG | luật gọi cấu hình được trên .99 (MOCK, lịch tắt); 0 cuộc thật; MobiFone hạn 24/11 qua |
| M9 | hoa hồng, chi trả, kế toán, MISA | chú Dũng, Phúc, Tài | `m9` | VÀNG | nhánh chú gộp `dev` 19/11, trên .99 từ 21/11; MISA 0 commit, tab M9 0 task |

## Luồng khách đầu-cuối

| # | Bước | Module | Chạy thử được chưa | Còn thiếu gì |
|---|---|---|---|---|
| 1 | Xem video Giờ Vàng | M7 | video thử .63, dữ liệu mẫu | duyệt video; máy video (Anh Tuấn) |
| 2 | Nhắn Messenger / bình luận | M5 | .98 sẵn, chưa gắn Page | Page pilot; nối M4 (M4-004/007 quá hạn); App Review |
| 3 | AI tư vấn | M4 | .99, 8/20 | nội dung 19 món; "mua N hộp" → giỏ; khoá Claude .99 |
| 4 | Đặt hàng trên web | M3 | bản 21/11 trên .99, chưa ai thử như khách | luồng khách Phúc; huỷ đơn |
| 5 | Gọi xác nhận | M3, M8 | 8/10 giả lập; nối tắt từ 18/11 | luật gọi mới đầu-cuối 28–29/11; MobiFone |
| 6 | Thanh toán | M3 | COD; VNPAY sandbox bật | thử sandbox; IPN 403; VNPAY thật |
| 7 | Vận chuyển | M3 | 3 logo, chưa báo giá | cân/kích thước SKU; hãng; key production |
| 8 | Chăm sóc sau mua | M3 | chưa | phạm vi chưa chốt |
| + | Kho giữ/trừ hàng | M1–M2, M3 | code hai phía, tắt | kho, tồn thật 26–27/11; NK-c chưa có mã |
| + | Đo quảng cáo | M6 | phía nhận, giả lập | BP phát sự kiện đơn (lead.105) |

## 5 rủi ro lớn nhất

| Rủi ro | Ảnh hưởng | Cách xử lý | Ai |
|---|---|---|---|
| Chưa chạy đầu-cuối trên máy thật (luồng khách M3, nối kho, luật gọi mới) | lỗi lộ muộn | chạy thử toàn luồng 25/11; đầu-cuối 28–29/11 | Phúc, Toàn |
| CI gần như tắt từ 21/11; bản BP 21/11 lên đường khẩn | lỗi sau gộp chưa biết | cổng Nguy hiểm 25–27/11; một bộ đủ trước 28/11 | Toàn, Phúc |
| BP, M8 (và M5/M6 trên .98) chỉ có sao lưu trên chính máy; M1–M2 kéo đêm về máy Toàn đều tới 24/11 | .99 hỏng là mất dữ liệu bán hàng | Anh Tuấn xác nhận chụp `/data`; chưa có thì kéo đêm như M1–M2 | Anh Tuấn, Toàn |
| Phụ thuộc ngoài: MobiFone, định danh, hãng ship, Meta, người duyệt nội dung, Anh Tuấn (cổng 80, RAM .98, máy video) | chưa gọi thật, chưa báo giá, chưa gắn Page | dự phòng COD, xác nhận tay | Toàn, Tài |
| M4 bán hàng 8/20; khoá M4 từng bị dán lộ; Claude .99 401 | bot sai khi khách mua | chỉ bật khi đạt + có người trực; thay khoá trước 28/11 | Tài, Phúc |

Việc cần Toàn quyết, gom từ mọi luồng: `modules/lead/TRANG_THAI.md`. Việc chờ bên ngoài: `modules/lead/VIEC_NGOAI.md`.
