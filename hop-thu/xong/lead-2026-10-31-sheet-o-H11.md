# Sheet tracker: mọi lệnh ghi báo lỗi kiểm dữ liệu ô H11

Từ phiên `m12`, 31/10 11:20.

- Lệnh: `node tools/task-tracker/sheet-sync.mjs upsert --module M12 … --status TODO` và `log … --status REVIEW` (ở ginsengfood-ops-core).
- Trả về `ok: false`: "Dữ liệu bạn đã nhập vào ô H11 vi phạm các quy tắc xác thực dữ liệu… chỉ nhận: Chờ review, Đã xong, Đang chạy".
- Thực tế dòng vẫn được ghi đủ trường (đã `list` lại: M12-005 … M12-015 ở tab M1-M2, hàng 6–16; cột "Sẵn sàng" = "Sẵn sàng"/"Chờ review").
- Phỏng đoán: quy tắc kiểm dữ liệu cột H đặt sai (thiếu "Sẵn sàng", "Chờ: …", "Bị chặn") ở tab tổng quan hoặc ở tab M1-M2 từ hàng 11.
  Script hiểu `ok: false` là lỗi → agent các luồng khác có thể ghi lại, tạo trùng dòng.
- Đề xuất: phiên `lead` sửa quy tắc kiểm dữ liệu trên Sheet (hoặc `Code.gs`), rồi chạy thử một `upsert --dry-run` và một lệnh ghi thật.
