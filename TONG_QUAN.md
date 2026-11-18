# Tổng quan hệ thống Ginsengfood M1–M9

Mốc dữ liệu: 14/11/2026 15:15 (`/tong-hop-tuan` 09–14/11) · chỉ phiên `lead` sửa tệp này.
Máy chủ chính thức từ 13/11: .99 nhà máy + bán hàng (M1–M2 13/11 19:15, M3/M4/M9 14/11 07:36, M8 07:46), .98 mkt (M5 + M6, chế độ tắt), .63 máy dev + CI; .60/.61 đường lui (`chung/MAY_CHU.md`).
**Hạn dự án 30/11/2026, 15/11 là mốc giữa kỳ (D-lead-025).** Màu theo bản tổng hợp 09–14/11 (`C:/Projects/bao-cao-tuan/2026-11-09_2026-11-14/bao-cao-tong-hop-2026-11-09_2026-11-14.md` + `.docx`, 13 trang),
số đã đối chiếu ở các bản `-ra-soat.md` cùng thư mục và `modules/lead/ra-soat/2026-11-14-kiem-cheo-tuan.md`. Chưa bậc nào lên 75 (trừ N5 M3→M8 có bằng chứng trên .99, giả lập).

## Bảng 10 dòng

| Module | Làm gì | Người | Phiên | 15/11 | 30/11 | Tình hình một câu |
|---|---|---|---|---|---|---|
| M1–M2 | nhà máy, kho, truy xuất, QC | Toàn | `m12` | nghiệm thu + ký trên .99 | VÀNG | .99 chạy bản 11/11; bản mới (bảo mật, nối M3) chờ CI Linux; UAT tới 10/11 1.643/14/121/58/466 |
| M3 bán hàng | giao diện + backend | Phúc | `m34` | code lên nhánh chung | ĐỎ | 55 commit đẩy thẳng `dev` không PR, ~400 mục chưa commit, 47 ca đỏ, 10/11 cam kết trượt, chưa chạy thử .99 |
| M3 vận chuyển + thanh toán | VNPAY, GHN, SPX, VTP | Tài | `m34` | COD | VÀNG | 2 lỗi VNPAY sửa xong; SPX chỉ máy Tài; chưa thử trên máy chủ |
| M3 nối M8 + M12, máy chủ | M3 → M8, M3 ↔ M12, .99 | Toàn | `m34` | gọi xác nhận .99 giả lập | VÀNG | 6/10 ca E01–E10 đạt .99; nối kho xong code, tắt |
| M4 | AI tư vấn | Tài | `m34` | chưa | VÀNG | 8 tình huống an toàn sửa; đo 150 tình huống 16/76/58 trước sửa; test chính thức .99 18–19/11 |
| M5 | cổng Facebook | Tài | `m5` | chưa (No-go pilot 13/11) | ĐỎ | 21 PR gộp, 23 việc Cần sửa; .98 chạy chế độ tắt, chưa tường lửa; App Review chưa nộp |
| M6 | đo quảng cáo / ROAS | Tài | `m6` | màn quản trị chi phí | ĐỎ | giao diện quản trị Đạt 18 việc; 27 P0 chưa bắt đầu gồm lõi doanh thu/ROAS; M3 → M6 chưa chốt (DL-O10) |
| M7 | video Giờ Vàng | Toàn | `m7` | video thử 15–16/11 | ĐỎ | 62 commit, T085 xong `d743c88`; clip Muse thật 10 giây; T190 chưa chạy (cài công cụ .63) |
| M8 | gọi xác nhận đơn | Toàn | `m8` | gọi giả lập .99 | VÀNG | W-0513…W-0540 trên remote `21e8f958`; MobiFone 400 cuộc/10 s/IP, gọi thử ~24/11; giấy định danh ~20/11 |
| M9 | tài chính: hoa hồng, chi trả, kế toán, kết nối MISA | chú Dũng (tài liệu, mã), Phúc (rà, gộp, test), Tài (MISA) — từ 17/11 | `m9` | giữ chạy .99 | VÀNG | 17/11 mở luồng `m9` (D-lead-059); chú đưa tài liệu kết nối MISA bản 2 (17 loại chứng từ) cho Tài; chưa có mã MISA |

## Luồng khách đầu-cuối

| # | Bước | Module | Chạy thử được chưa | Còn thiếu gì |
|---|---|---|---|---|
| 1 | Xem video Giờ Vàng | M7 | chưa | T002 khung mã local chờ commit; chưa có sản phẩm tích hợp, demo tối thiểu chờ m7.22 |
| 2 | Nhắn Messenger / bình luận | M5 | chưa (máy dev, bộ giả) | App Review, máy chủ chạy thử; quyền Page đã cấp theo D-lead-006 nhưng Sheet còn lệch, cần đối chiếu |
| 3 | AI tư vấn | M4 | chưa | endpoint cho M5 trên `dev015`, chưa vào `dev`; máy chủ chạy thử; bật bằng mã truy cập |
| 4 | Đặt hàng trên web | M3 | chưa kiểm | báo cáo + phần máy chủ của Phúc |
| 5 | Gọi xác nhận | M8 | trên giả lập | Lead nhận M3-023 (D-m34-003), chưa có mã gửi đơn/nhận kết quả; N5 chưa có bằng chứng tích hợp |
| 6 | Thanh toán | M3 | VNPAY nghiệm thu kỹ thuật (môi trường thử) | bật trên .63, V256, thông số thật |
| 7 | Vận chuyển | M3 | GHN trên sandbox | chốt báo giá GHN; SPX chờ hợp đồng; VTP chờ tên miền chính thức; 15/11 phí nội bộ + vận đơn tay nếu chưa có hãng |
| 8 | Chăm sóc sau mua | M4, M5 | chưa | ngoài phạm vi 15/11 |
| + | Kho, nhà máy giữ/trừ hàng | M1–M2 | chưa nối | ops-core đã có C37/ISSUED, hợp đồng chung chưa publish; M3 còn thiếu adapter và webhook; N8 chưa có bằng chứng tích hợp |
| + | Đo quảng cáo | M6 | chưa | đã có mã PR #1–#6 `620045b`, chưa có bằng chứng chạy thử đầu-cuối; doanh thu chờ M3 |

## 5 rủi ro lớn nhất

| Rủi ro | Ảnh hưởng | Cách xử lý | Ai |
|---|---|---|---|
| M3 chưa nối M8, M1–M2; lịch mới chưa chốt | bước 4–7 và M8, M1–M2 thiếu bằng chứng trước 10/11 | Lead nhận M3 → M8, cần E01–E10 trước 06/11; Phúc tiếp nối kho trước 08/11; chốt lại lịch theo D-m34-003 | Lead, Phúc |
| Máy chủ chạy thử M4/M5/M6 chưa có | không nộp App Review 06/11, không chạy thử đầu-cuối | phiếu M5-004 gửi anh Tuấn (m5.1) | Lead, anh Tuấn |
| Việc ngoài code: VNPAY thông số thật, MobiFone, tên định danh (~20 ngày), hạ tầng anh Tuấn | chặn chạy thật dù mã xong | 02/11 gửi hết, mỗi việc một người đi gỡ + hạn | Lead, anh Tuấn |
| M7 mới có khung T002 local, chưa commit | không có chương trình Giờ Vàng chạy thật 15/11 | chốt m7.23 để tiếp T003; sau T005 chọn demo local m7.22, giữ riêng với nghiệm thu/chạy thật | Lead |
| Bí mật lộ (token Sheet trong 6 repo, mật khẩu Redis trong `deploy`) | cổng bảo mật G3 | thay token, gỡ khỏi repo trước 07/11 | Lead |

Việc cần Lead quyết, gom từ mọi luồng: `modules/lead/TRANG_THAI.md`. Việc chờ bên ngoài: `modules/lead/VIEC_NGOAI.md`.
