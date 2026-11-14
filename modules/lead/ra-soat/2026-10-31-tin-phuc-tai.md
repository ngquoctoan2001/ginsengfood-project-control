Gửi Phúc, Tài · 31/10/2026 · từ Lead
Việc: báo trước, Sheet task và thư mục `tools/task-tracker/` trong business-platform vừa đổi, các bạn không cần sửa gì.
Vì sao: 6 cột (Người phụ trách, Sẵn sàng chạy, Ưu tiên, Trạng thái, Nguồn, Lead duyệt) chuyển sang trình đơn thả xuống có màu,
bỏ tô nền cả ô. Apps Script 1.3.0 đã triển khai, URL web app giữ nguyên, `sheet-sync.mjs` chạy như cũ (đã thử ping/get/log).
Cần làm: 1. Sửa tay trên Sheet thì chọn giá trị từ trình đơn thay vì gõ. 2. Cột Sẵn sàng chạy vẫn do hệ thống ghi; ô "Chờ: …",
"Thiếu: …" có chip xám kèm tam giác cảnh báo nhỏ, đó là bình thường. 3. Pull `dev` về: commit `f29bf2667` chỉ đổi
`tools/task-tracker/apps-script/Code.gs` và `tools/task-tracker/README.md` (mục màu trình đơn thả xuống).
Xong khi: không cần báo lại; thấy lệnh `sheet-sync.mjs` lỗi thì nhắn Lead kèm đầu ra.
Hạn: — · báo lại bằng: tin nhắn nếu có lỗi.
