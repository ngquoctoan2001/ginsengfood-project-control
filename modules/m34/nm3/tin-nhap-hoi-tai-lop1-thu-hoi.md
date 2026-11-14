# Tin nháp gửi Tài — lớp 1 thu hồi (11/11/2026) · CHƯA GỬI

Người gửi: Nguyễn Quốc Toàn · Nguồn: `NM3-16b-kiem-v7-v8-v10.md` (V10) · Toàn xem rồi gửi.

---

Tài ơi, mình đang nối M3 với M12 (ops-core) và cần biết lớp 1 của phần thu hồi để xếp lịch.

Mình thấy runbook thu hồi trong repo ghi `OPS_CORE_RECALL_STOP_SKU_BEFORE_PICKUP` (chặn trước lúc hãng lấy hàng, GHN `ready_to_pick`/`picking`, VTP 102–104/202) là "lớp 1 của Tài, chưa có trên nhánh này", và trong `dev` mình không tìm thấy mã nào dùng chuỗi đó. Tài cho mình biết giúp:
1. Lớp 1 hiện nằm ở nhánh hay PR nào, dự kiến vào `dev` ngày nào?
2. "OD-01..11" trong phần này là danh sách điểm treo nào, nằm ở tệp nào (mình chưa tìm thấy tệp có tên đó)? Mình cần biết điểm nào còn mở trước khi bật chế độ quan sát trên .60 (13/11).
3. Trong chế độ quan sát (chưa bật cổng bán), nếu M12 báo có ca thu hồi thì M3 chỉ ghi trạng thái dừng và log ERROR cho các đơn chưa xuất kho; lớp 1 có cần chạy trong chế độ quan sát không, hay chỉ cần khi bật cổng thật?

Không gấp trong hôm nay, nhưng trước 12/11 thì mình kịp ghi vào kế hoạch. Cảm ơn Tài.
