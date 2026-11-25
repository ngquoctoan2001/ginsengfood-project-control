# Kiểm chéo tuần 14/11 – 24/11/2026 (/tong-hop-tuan)

Kỳ gộp: Toàn 14/11 15:30 → 24/11 (phiên M8 ghép, Toàn duyệt); Phúc, Tài 16–21/11 (tệp Toàn gửi từ Downloads, chép vào thư mục tuần).
Hai auditor chỉ đọc, 24/11 ~22:55–23:10. Ghim: BP `origin/dev` `d109369c2` (đứng từ 21/11 15:16), `PhucApu` `1e2406589`, `dev015` `ea3bc5c91`;
module5 `main` `d4b627c1`; M4-PLAN `d97cf36e`; contracts `main` `a7832a4`. Không ssh, không chạy test; GitLab của Phúc/Tài không đọc được.
Bản tổng hợp: `bao-cao-tuan/2026-11-14_2026-11-24/bao-cao-tong-hop-2026-11-14_2026-11-24.md` + `.docx` (12 trang, 31 bảng).

## Số đối chiếu
- Phúc (M3 giao diện + backend): 21/30 khớp. 63 commit đều trên `dev`; đọc 6 việc mã có thật (`a53caec4d` 409, `14708ad68` khoá OTP, mật khẩu 4–50, Google tắt, 3 cờ M12 tắt).
- Tài (M3 vận chuyển/thanh toán, M4, M5, M6): 16/25 khớp, 1 không kiểm được. 27 việc M4, 8/20 kịch bản, 56 PR module5 (41 + 15), 13 lượt .98, app Meta Live 18/11 đều khớp.

## Lệch đã sửa trong bản gửi Chú
| Báo cáo ghi | Thực tế | Bằng chứng |
|---|---|---|
| Phúc: quy tắc huỷ đơn "chưa chốt, hỏi lần 4" | Toàn chốt 10/11 (m34.68 A); tin nháp 17/11 có lẽ chưa gửi | `modules/m34/QUYET_DINH.md:75` |
| Phúc: NK-b, NK-c chưa có mã | NK-b đã có (Toàn, 12/11, trên `dev`); chỉ NK-c chưa | `6b19d621c`, `OpsCoreConfigRules.java:84` |
| Phúc + Tài: Claude trên .99 chạy từ 19/11 23:57 | 20/11 09:4x log .99: 42/42 lượt gọi 401; chưa thấy thay khoá | `modules/m34/ra-soat/2026-11-20-m4-dev-tai.md` |
| Phúc: Toàn chạy M3 → M8 "hai kịch bản đạt" | 15/11 đạt 7 ca (E01, E02, E03, E05, E06-A/B, E10) | `modules/m34/TRANG_THAI.md:42` |
| Phúc: "gửi 12 phiếu" mã M3-008 | M3-008 trên Sheet là việc khác (đã Đạt) | Sheet M3 |
| Tài: M6 "nhận sự kiện đơn đã xác nhận từ M3" | Chỉ có bộ nhận chạy với M3 giả lập ("Not wired"); BP không phát | `m6/app/measurement/inbound/order_verified.py` |
| Tài: "nhớ hội thoại" chờ Phúc chốt thứ tự migration | Nhánh chú (V361–V391) đã vào `dev` 19/11; chỉ còn đổi số | `04a01d4e6` |
| Tài: bản sửa cấu hình Claude .99 vào dev "chưa xác nhận" | Đã vào `dev` 19/11, Tài gộp sang `dev015` 20/11 | `8226e6e10`, `06951ab46` |
| Tài: M5 kể xong M5-060/093/112/140/144 | Sheet còn "Đang làm"; M5-060, M5-112 Lead chấm Cần sửa | Sheet M5 |

## Việc lớn bị sót (đã đưa vào bản gửi Chú)
- Phúc: 43/85 việc Sheet "Cần sửa"; .99 chạy hồ sơ demo (OTP email quản trị bật sẵn, `application-demo.yml:11`); đẩy thẳng `dev` không PR (trái m34.81).
- Tài: MISA/M9 không có dòng nào (0 commit MISA 16–24/11, tab M9 0 task); Messenger → M4 chưa nối (M4-004 hạn 17/11, M4-007 hạn 19/11);
  Go/No-go M5/M6 20/11 bỏ, khung thử Page 19/11 không làm; M5-094 thay bí mật hạn 04/11 trễ 20 ngày; 56 PR tự gộp, không người duyệt, CI GitHub đỏ.
- Hợp đồng M3 → M5 trạng thái đơn chỉ ở nhánh contracts `lead/order-channel-state-v1` (`2d6807d`), chưa vào `main`. Phần M3 → M6 chưa có người nhận phía bán hàng.

## Sau giờ báo cáo (21/11 23:59 → 24/11 23:00)
- `origin/dev` GitHub đứng ở `d109369c2`; .99 vẫn `1e2406589` (chưa có luật gọi M3 + V405–V409).
- Phúc: 0 commit GitHub sau 21/11 13:32, Sheet không cập nhật sau 21/11 16:31 → việc hẹn 22–24/11 chưa có bằng chứng.
- Tài: MR GitLab !177 (23/11), !178 (24/11) không có trên GitHub; "không được ăn" đạt 24/11 15:43; cổng trẻ em lượt 5 lọt 25 câu, lượt 6 chặn nhầm người lớn;
  log chẩn đoán hãng đã làm (`65bb70026`, `450fcd217`); module5 PR #176–#181: rà bảo mật M6 1 Cao (đã sửa, cài .98) + 5 Trung bình; .98 thêm 2 lượt (15); SMK M5 trên .98 1 đạt / 14 hỏng.

## Chỗ nối
| Nối | Kết quả |
|---|---|
| M5 → M4 (Messenger → AI) | Đường gọi hai phía khớp; M4 tắt mặc định, .98 giả lập; contracts không có hợp đồng — CHƯA NỐI |
| M3 → M6 sự kiện đơn | LỆCH với báo cáo: chỉ phía nhận; BP không phát |
| M5 → M6 | Chưa nối (0 lời gọi trong `src/`) |
| M7 → M5 video | Chưa nối (M7 không có client; M5 chế độ tắt) |
| M3 → M5 trạng thái đơn | Đường gọi khớp; hợp đồng chưa vào main; .98 giả lập |
| M6 → M9 chi phí | Khớp (`m6/app/http/m9.py:33` ↔ `M6AdSpendClient.java:30`) |
| M3 ↔ M12 đọc kho/SKU/tồn | Khớp hai phía, 3 cờ tắt; contracts chưa có OpenAPI cho 3 đường |
| VNPAY | Khớp mã; chưa thử sandbox trên .99; IPN .99 trả 403 |
| GHN / VTP / SPX | 3 hãng bật, chưa hãng nào báo giá (VTP 503, SPX 403, GHN thiếu cân/kích thước) |

## Câu hỏi cho Toàn (trình một lần)
- lead.103: gửi lại Phúc quy tắc huỷ đơn đã chốt 10/11 (tin nháp 17/11)? Đề xuất: gửi ngay sáng 25/11.
- lead.104: thước đo bậc 50 M3 (Phúc lấy "cổng .63 xanh", trái D-lead-064 cho repo bán hàng)? Đề xuất: theo D-lead-064, một bộ đủ trước 28/11.
- lead.105: chốt ai nối sự kiện đơn M3 → M6 (Phúc phát, Tài nhận)? Đề xuất: Phúc phát, hạn 28/11, không kịp thì M6 pilot chỉ chi phí.
