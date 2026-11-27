# Trạng thái — m6

Mốc 27/11/2026 · pull 12:48 · module5 `main f9318df5` = origin/main; M4-PLAN `main a1245e55` = origin/main; hai checkout sạch. M6 nằm trong module5/m6, không dùng repo module6 lưu trữ.
Sheet đọc 12:48, đối chiếu 13:03; rà23 task và ghi/đọc lại W/X 23/23. Trạng thái của Tài giữ nguyên. Hạn chạy thật 30/11(D-lead-025); chưa có bằng chứng chốt Go/No-go mới.

## Lượt rà 5 — 27/11

- **13 Đạt,10 Cần sửa,0 chờ sửa trước lượt rà.** [Bản rà](ra-soat/2026-11-27-tai.md) · [Bảng23 task](ra-soat/evidence/2026-11-27-tai/task-review.md).
- Từ lượt rà 16/11(`6ee2bedc`):136 commit chạm M6,121 tệp;21 PR M6 gộp từ 17/11. Có inbox/hoàn-huỷ/quy kết/dashboard giả lập M3, liên kết conversion↔measurement↔DQ, nhiều sửa bảo mật và deploy.
- Đạt: M6-014,024,038,039,051,054,055,056,130,133,157,159,160.
- Cần sửa: M6-042,052,057,058,082,100,120,122,125,131. Cụ thể đã nối ghi chú X và chấm W.
- Test lọc36 tệp/1085 ca:1084 pass,1 fail sau sửa runner thiếu git/chạy lại deploy;0 error,0 skip. Ca đỏ là fixture/giả định JSON sâu trên Linux Py 3.12.16, chưa chứng minh lỗi production. Không phải full suite.
- RUNBOOKPG 16 trống:31 migration áp dụng, chạy lại0, pending 0. Docs 0 lỗi, 40 cảnh báo, traceability khớp.

## Vận hành: bằng chứng mới thay mốc18/11

- Log .98 ngày 21/11 có image-check 0, migration 0031, health 200,M6B_DONE; hồ sơ login/dashboard đã có. Bỏ nhận định cũ “chưa bật JWT” và “M6-159 chưa sửa” khỏi danh sách chặn mã.
- BAN_KHAI ghi build/deploy bảo mật24–25/11 đạt. Lead chỉ đối chiếu log/tài liệu, chưa SSH/live UAT và chưa xác nhận SHA image đang phục vụ.
- Chưa nối doanh thu M3 thật; reader runtime vẫn unavailable, route nguồn còn đóng; revenue/ROAS chưa được nghiệm thu. BLOCKED/OFF/OFF giữ nguyên.

## Việc chặn cần theo dõi

| Việc | Người xử lý | Mốc |
|---|---|---|
| DL-228(M5),110,120,113,111,112 chưa ký/chốt; smoke và hồ sơ lệch code | Tài; phần thuộc Lead trình Toàn | trước Go/No-go |
| M6-058/DL-O81: NO_SOURCE hay REVENUE_SOURCE_UNAVAILABLE khi chưa có đơn | Tài trình người quyết | hạn DL 28/11 |
| M6-082/TRK-90: policy=None vẫn enqueue, chưa có task lane E nối tiếp | Tài | trước mở gửi/khép tiêu chí |
| M6-122: T7/T8/T9 thiếu bằng chứng; test closed-3000 đỏ trên Linux; báo cáo còn SHA cũ | Tài/phía giữ quyền tương ứng | trước production |
| M6-125/131: hồ sơ Go/No-go và release notes chưa cùng candidate; thiếu chứng cứ các gate thật | Tài soát → Toàn quyết | trước chạy thật 30/11 |
| Nguồn M3, DQ/recall và nối M9 thật còn phải chứng minh theo từng gate | Tài, Phúc | theo phạm vi pilot được duyệt |

## Cần quyết / tiếp theo

- m6.20 (lịch họp 19–20/11) đã qua; chưa thấy biên bản quyết trong nguồn đã rà. Tài cập nhật lịch và nộp pack mới ở M6-125; không tự ghi quyết định thay Lead.
- m6.21/DL-112 về STAGED/DONE và SHA ứng viên vẫn chưa chốt; giữ chờ quyết.
- M6-114: T-5/6/7/10 tiếp tục mặc định theo DL-104 tới khi có quyết định mới.
- [Tin nhắn nháp](ra-soat/2026-11-27-tai-tin-nhan-nhap.md) đã soạn, chưa gửi. Sau khi Tài sửa, rà lại đúng task được cập nhật; chấm trọng số sẵn sàng bằng /ke-hoach khi cần.

Không sửa/commit mã repo Tài, không push/deploy/đổi cờ trong lượt rà. Không worktree rà.
