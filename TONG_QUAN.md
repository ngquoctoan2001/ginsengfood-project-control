# Tổng quan hệ thống Ginsengfood M1–M9

Mốc dữ liệu: 07/11/2026 11:00 (`/tong-hop-tuan` 02–07/11) · chỉ phiên `lead` sửa tệp này.
Máy chủ chính thức từ 13/11: .99 nhà máy + bán hàng, .98 mkt, .60 chỉ còn M7 tạm + đường lui (`chung/MAY_CHU.md`, D-lead-034/035/036).
**Hạn dự án 30/11/2026, 15/11 là mốc giữa kỳ (D-lead-025).** Số sẵn sàng theo bản rà báo cáo tuần 02–07/11
(`C:\Projects\bao-cao-tuan\2026-11-02_2026-11-07\*-ra-soat.md`), kiểm chéo `modules/lead/ra-soat/2026-11-07-kiem-cheo-tuan.md`;
chưa có bậc nào lên 75. Thang: `chung/CONG_PRODUCTION.md`. Báo cáo gửi Chú: `…\bao-cao-tong-hop-2026-11-02_2026-11-07.md` + `.docx`.

## Bảng 10 dòng

| Module | Làm gì | Người | Phiên | Sẵn sàng | 15/11 | 30/11 | Tình hình một câu |
|---|---|---|---|---|---|---|---|
| M1–M2 | nhà máy, kho, truy xuất, QC | Toàn | `m12` | 44% | VÀNG | VÀNG | 79 commit trên `main` `e81a56017`; .61 vẫn bản 19/10, 3 bước chuẩn bị của Toàn chặn; token Sheet còn sống; sao lưu đêm lỗi từ 02/11 |
| M3 bán hàng | giao diện + backend | Phúc | `m34` | ~34% (báo cáo 35%) | ĐỎ | VÀNG | 59 commit vào `dev` qua 3 lần đẩy thẳng, 0 PR/CI; XII R3 chạy trên .60 chưa rà; `proxy.test.ts` 24 đỏ; huỷ đơn 0 commit |
| M3 vận chuyển + thanh toán | VNPAY, GHN, SPX, VTP | Tài | `m34` | 43% | VÀNG | VÀNG | PR #146 gộp 06/11; .60 compose tắt VNPAY; Giờ Vàng cấm COD → chỉ COD thì không bán Giờ Vàng |
| M3 nối M8 + .60 | M3 → M8, máy chạy thử .60, CI | Toàn | `m34` | 40% | VÀNG | VÀNG | .60 chạy `9a4690574` từ 07/11 09:14, sao lưu đêm; cờ IVR tắt; M3-091, UAT m34.52 chưa làm; M3-083 mở; M34-VH chưa có task |
| M4 | AI tư vấn | Tài | `m34` | ~36% (báo cáo 37%) | VÀNG | VÀNG | 8 việc vào `dev` 06/11 + #152; tự hại gián tiếp lọt 8/24; .60 compose khoá AI |
| M5 | cổng Facebook | Tài | `m5` | ~25% (báo cáo 26%) | ĐỎ | VÀNG | 47 PR + 032/036/051 gộp 07/11 không chờ rà; chưa .60 HTTPS, token Page, App Review; Actions dừng (lỗi thanh toán) |
| M6 | đo quảng cáo / ROAS | Tài | `m6` | ~21% (báo cáo 26,5%) | VÀNG (bản chạy thử) | VÀNG | 68 PR, 2.781 test đạt; chưa máy, chưa image; M6-015b cho qua phát hiện bí mật (trái D-m6-010) |
| M7 | video Giờ Vàng | Toàn | `m7` | 9% | VÀNG nghiêng ĐỎ | ĐỎ | 38 commit `303ec9c`, 955 test đạt; dựng video còn mock; D-m7-063 hai mốc |
| M8 | gọi xác nhận đơn | Toàn | `m8` | 47% | ĐỎ | VÀNG | 29 commit; GitLab chưa xanh trọn; 4 yêu cầu ra ngoài chưa gửi 2 tuần; S5 .61 vẫn bản 27/10 |
| M9 | hoa hồng, chi trả, kế toán | anh Mạnh | `lead` rà | — | hạn 09/11 | VÀNG | PR #149, #150 gộp 06/11; còn MISA, ngân hàng, đối soát; menu 2 màn, quyền soát thuế trước khi mở |

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
