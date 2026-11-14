# m34 → lead · 04/11/2026 08:2x · D-m34-023: M3 chưa có đường nạp ảnh tồn kho WMS — điều kiện trước khi bật IVR M3 → M8

Lead chốt m34.42 A (phiên m34). Bằng chứng: WP09 lab `0a87a79d` sáng 04/11 (`C:/Projects/_wt/m34/wp0910-20261103/rerun-20261103/pha-c.md`).

- Kết quả IVR "khách xác nhận" về M3 được kiểm lại tồn kho bằng bảng `inventory_wms_stock_snapshots`; ảnh thiếu hoặc quá `valid_until` → UNKNOWN →
  `REVIEW_REQUIRED` → watchdog huỷ khi tới hạn kết quả (GH ~6,5 phút, COD ~16 phút sau cuộc gọi), đơn đã trả thì yêu cầu hoàn
  (`OrderIvrInventoryServiceImpl.java:72-78`, `OrderIvrResultServiceImpl.java:76-79`, `OrderIvrLifecycleService.java:130,253-256` @ `toandeptrai` `d550ddba6`).
- BP không có đường production nào ghi bảng này: `WmsInventoryIngestionService.ingest` chỉ được `WmsInventoryRealE2eDataSeeder` gọi; không có
  controller, consumer hay lịch chạy. Lab sáng 04/11: ảnh do seeder tạo hết hạn 00:10 → 71/72 đơn khách xác nhận thành `REVIEW_REQUIRED`,
  35 đơn GH đã trả bị huỷ + 35 yêu cầu hoàn (thanh toán mock), 36 COD huỷ 08:17.
- Luật giữ fail-closed (D-m34-021, 36 A). Cờ `app.ivr-integration.enabled` trên production giữ tắt cho tới khi M2 → M3 nạp ảnh WMS liên tục,
  `valid_until` phủ qua đêm tới khi gọi buổi sáng (hoặc làm mới trước 08:00).

Việc cho phiên `lead`: đưa "M2 → M3 ảnh tồn kho WMS (`inventory_wms_stock_snapshots` qua `WmsInventoryIngestionService`)" vào bảng điểm nối liên module
và `ginsengfood-contracts` nếu cần; chốt bên làm (M12 phát, M3 nhận — gần với adapter giữ/trừ hàng M1–M2 của Phúc hạn 08/11 trong `SAN_SANG.md` m34 G2)
và lịch làm mới. Phiên m34 tự sửa seeder lab (R1) và chạy lại phần buổi sáng.
