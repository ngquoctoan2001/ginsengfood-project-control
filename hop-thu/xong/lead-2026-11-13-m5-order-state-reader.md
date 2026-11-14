# Từ phiên `m5` · 13/11/2026 08:40 · giao task đọc trạng thái đơn M3 → M5 + đổi luật AI pilot

Lead trả lời m5.30–33 trong phiên `m5` → D-m5-034…037 (`modules/m5/QUYET_DINH.md`). Hai việc cần phiên `lead`:

1. **D-m5-036:** giao Phúc (M3) làm API đọc trạng thái đơn, Tài (M5) viết `ORDER_STATE_READER` thật, trước 30/11. Có kèm sơ đồ.
   Gói task đã soạn sẵn: `modules/m5/giao-viec/2026-11-13-order-state-reader.md`.
2. **D-m5-034 đổi lead.57 (D-m5-018):** Page pilot nay **có** AI. M4 dùng Claude API soạn câu trả lời tin riêng, bật khi có văn bản pháp chế đợt 2.
   Báo giá và nháp đơn chặn suốt pilot (D-m5-015, D-m5-039 lúc 09:11): phần Messenger của OWN-341 (2) không áp cho pilot.
   Luồng `m34` (M4 của Tài, OWN-341) cần biết điều này.

## Prompt dán vào phiên `lead`

```text
Việc liên module từ phiên m5 (D-m5-036, D-m5-034). Đọc hop-thu/lead-2026-11-13-m5-order-state-reader.md
và modules/m5/giao-viec/2026-11-13-order-state-reader.md (dữ kiện, sơ đồ, khung hợp đồng, 2 task). Làm:

1. Khung hợp đồng trong ginsengfood-contracts: openapi/business-platform/order-channel-state.v1.yaml + ví dụ
   theo §5 của tệp giao việc. Checkout C:\Projects\ginsengfood-contracts đang dở một lần merge
   (MERGE_HEAD e5b2506, ~403 mục, README.md xung đột). Không stash/reset/abort. Báo tôi đó là merge của ai,
   rồi làm trong worktree mới C:\Projects\_wt\lead\contracts-order-state từ origin/main (fetch trước).
   Commit trên nhánh riêng; push/PR thì hỏi tôi. Chỉ ghi tên biến/header, không ghi giá trị bí mật.
2. Tạo 2 task trên Sheet bằng tools/task-tracker/sheet-sync.mjs, chạy --dry-run trước, đọc lại sau khi ghi:
   - Tab M3, chạy từ C:\Projects\ginsengfood-business-platform: task của Phúc ("API nội bộ đọc trạng thái đơn
     cho M5 (order-channel-state v1)"), --owner "Trương Công Phúc", P0, hạn 2026-11-21.
   - Tab M5, chạy từ C:\Projects\module5: task của Tài ("ORDER_STATE_READER thật đọc trạng thái đơn từ M3"),
     --owner "Nguyễn Phát Tài", P0, hạn 2026-11-24, deps = mã task của Phúc.
   Mỗi task điền outcome = mục "Xong khi", note = đường dẫn tệp giao việc, source = D-m5-036.
   Không dùng `log` lên task người khác; không đổi task có sẵn.
3. Soạn tin nháp cho Phúc và Tài, mỗi người một tin theo chung/MAU.md §3. Tin có mã task Sheet, đường dẫn tệp giao việc
   và hạn chốt hợp đồng 17/11. Tin cho Phúc nhắc: SecurityConfig.java dùng chung với phần M4 của Tài, báo Tài trước khi sửa.
   Với Tài: hỏi tôi có thả bản .md vào M4-PLAN/Nhiệm Vụ Phát Sinh/ không. Không tự gửi.
4. Ghi vào modules/lead: điểm nối M3 → M5 (đọc trạng thái đơn) vào SAN_SANG liên module;
   lead.57 đổi theo D-m5-034 (Page pilot có AI bằng Claude API sau pháp chế đợt 2, báo giá vẫn chặn);
   báo luồng m34 bằng hop-thu/m34-2026-11-13-m5-ai-pilot.md.
Không gọi .60, không đọc .env*/sheet.json, không push/merge/PR khi tôi chưa nói.
```

## Đã chốt thêm ở phiên `m5` (09:11)

- D-m5-039 (m5.34): báo giá/nháp đơn trên Messenger pilot chặn suốt pilot; P3 bên M4 làm tiếp, mở sau pilot bằng quyết định mới.
- D-m5-038 (m5.21): chữ M5-101 do Tài chốt; Toàn đối chiếu P01/P02 với giấy ĐKKD và đọc câu AI trước khi đăng.

**Đã xử lý 13/11 09:25 (phiên `lead`):** hợp đồng `2d6807d` nhánh `lead/order-channel-state-v1` (chưa push); Sheet M3-181 + M5-144; tin nháp `modules/lead/ra-soat/2026-11-13-tin-zalo-order-state.md`; N13 trong `modules/lead/SAN_SANG.md`; lead.57; `hop-thu/m34-2026-11-13-m5-ai-pilot.md`. Còn chờ Toàn: push/PR hợp đồng, gửi tin, thả tin Tài vào M4-PLAN.
