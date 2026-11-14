# Rà báo cáo tuần M3 bán hàng (Phúc) · kỳ 26–31/10 · 31/10 16:30

Nguồn: `C:\Projects\bao-cao-tuan\2026-10-26_2026-10-31\bao-cao-tuan-2026-10-26_2026-10-31-M3-ban-hang.md` (Phúc nộp 15:03).
Đối chiếu git `origin/PhucApu` `23e57191d`, `origin/dev` `f29bf2667`: 12 điểm, 9 khớp, 3 lệch nhỏ. Không trả lại (D-lead-005);
phần đưa vào bản gửi Chú đã điền thẳng. Dưới đây là chỗ lệch để Toàn dùng khi làm việc với Phúc.

## Khớp
- `cfc8eea85` gộp 12 commit, ~1.017 tệp; `7dae05bf8` sửa 11 tệp, đổi V251 → V258; `c28e29f39` 45 tệp ui-pages + 12 tệp `front-end/src`.
- Migration 259 tệp, trống V249, V253, V256. Chỗ thiếu trong mã đúng như Phúc nêu: `OrderCreateServiceImpl.java:1197` (COD luôn đi
  tuyến nhân viên), `application.yml:241` (job hết hạn đơn tắt), `V252:137` (`ORDER.CANCEL` không gán vai), `V61:28-31` (hạng cũ).
  Không có `ivr-result-callbacks`; chỉ gọi `/v1/availability/check`, không gọi `inventory/allocations`.

## Lệch
1. 9 SHA lô 1 + V01 (`b270cae26`, `590e83e01`, `b206a3bd0`, `1a33caa06`, `385663958`, `aca7f75b2`, `47ef9d321`, `1b88238ed`,
   `712fa5447`) không có trên remote → 23/23, 8/8, 15/15, 364/367 chỉ là lời kể.
2. "Xoá CLAUDE.md thừa" gắn `c28e29f39`, `23e57191d` nhưng không commit nào xoá CLAUDE.md; `c28e29f39` thêm .docx 2,5 MB, `23e57191d` xoá lại.
3. Đầu báo cáo "chốt 12:51" nhưng dùng số chạy lúc 14:17, 14:54.
4. Ghi nguồn "nhật ký" nhưng `docs/weekly-tracking/truong-cong-phuc.md` tuần 44 "chưa có mục nào".
5. "10 ca giá link CTV đã sửa" chưa vào git: `PaymentPricingVisualEngineProductScopeTest`, `AffiliateProductScopeConsistencyTest` trên `dev` vẫn đỏ.
6. `cfc8eea85` gộp thẳng `dev`, không PR, chỉ `test-compile`; `dev` mang ~18 ca đỏ (6 thang migration/CRLF, 10 giá CTV, 2 hoa hồng).
7. V248 (`d17776f36`, 10/10) vào `dev` sau V250–V258; `deploy/compose.lan.yml:107` `SPRING_FLYWAY_OUT_OF_ORDER: "false"` → DB đã chạy
   tới V257 không khởi động được; `GoldenHourRulesPolicyGuardMigrationContractTest.java:76` đỏ. Phúc có nêu, chưa gắn hạn với lần cài máy chạy thử.
8. Kiểm giao diện 4.517 − 4.422 = 95 ca không đạt; báo cáo ghi 74 (chênh 21, có thể là ca bỏ qua).
9. Ba chỗ nối (IVR gửi đơn, nhận kết quả, giữ hàng) Phúc xếp 27/11; M8 cần trước 06/11, kho chạy chung 09/11.
10. "Chờ hợp đồng từ Toàn": hợp đồng nhận kết quả đã có ở `C:\Projects\ginsengfood-ivr\docs\api\order-core-ivr-callback-target-v1.html`,
    `docs\contracts\openapi-contract-diff.md` → Toàn gỡ được ngay.

## Phúc hỏi (trả trước 03/11)
4 câu trong báo cáo; quan trọng nhất: ai được huỷ đơn, có hoàn tiền thủ công không.
