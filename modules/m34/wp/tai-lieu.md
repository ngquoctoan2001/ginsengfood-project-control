# tai-lieu — gói 9 (gộp gói 4): tài liệu nối M12 sang .99, ghi trần 20 dòng + thử lại 1 lần, decision log, spec P2-44, SKU_MOI

Trạng thái: XONG `9abcd32b1` (chưa push) · bộ đủ ĐẠT 10:24 · Sheet M3-139/149/155/165 Đạt · Rủi ro: R1 (chỉ tài liệu) · Chế độ: A (worktree → patch → phiên chính áp + commit `toandeptrai`) · Mốc: 19/11
Hạng mục nâng: sổ tay nối M12 đúng máy .99 và đúng mã hiện hành (người trực làm theo được) · Sheet: M3-139, M3-149, M3-155, M3-156, M3-165, M3-125 · Ước lượng: 3 giờ
Chỗ làm: `C:\Projects\_wt\m34\tai-lieu` · Base SHA: `09c13eefb` · Patch: `C:\Projects\_wt\m34\tai-lieu.patch`
Nguồn: phiếu `SUA-SAU-RA-SOAT-NKB.md` gói 4 + 9; ghi chú Cần sửa của 6 task trong `ra-soat/evidence/2026-11-14-nm3-26/ket-qua.json` và `auditor-*.md`; D-m34-074/077/078/080.

## Brief
1. Repo `C:\Projects\ginsengfood-business-platform` (chỉ đọc) · làm trong `C:\Projects\_wt\m34\tai-lieu` (HEAD tách `09c13eefb`) · luật chung `C:\Projects\_wt\m34\_tools\BRIEF_CHUNG_SUA_NKB.md`.
2. Mục tiêu: sửa tài liệu cho đúng mã và đúng máy, theo đúng việc ghi ở mục "note" của 6 task (đọc `C:\Projects\Project Control\modules\m34\ra-soat\evidence\2026-11-14-nm3-26\ket-qua.json`
   các mục M3-139, M3-149, M3-155, M3-156, M3-165, M3-125, và phiếu `C:\Projects\Project Control\modules\m34\wp\SUA-SAU-RA-SOAT-NKB.md` dòng gói 4 và gói 9). Tối thiểu:
   (a) `deploy/m34/ops-core/NOI_M12.md`: .60/.61 → .99 (thư mục `/data/ginsengfood-business-platform`, `OPS_CORE_BASE_URL=http://192.168.1.99:5000`, kiểm mạng be → .99:5000), .60/.61 chỉ còn là đường lui;
       bí mật bằng tệp `secrets/` (SEC-09), bỏ chỉ dẫn `.env`; cập nhật NM3-40..42, SKU-M3-03 theo mã; mức 3 (điều kiện vào: cổng 20/11 + Toàn duyệt; điểm lùi `OPS_CORE_ALLOCATION_ENABLED=false` rồi xử lý hold đang mở);
       ghi trần 20 dòng/đơn (`OPS_CORE_ALLOCATION_MAX_LINES_PER_ORDER`, 422 `ORDER_HOLD_TOO_MANY_LINES`) và thử lại 1 lần (`OPS_CORE_ALLOCATION_TRANSIENT_RETRIES`) đúng như mã ở `09c13eefb`;
       mục 6, 7, dòng vòng đời (biến `OPS_CORE_LIFECYCLE_ENABLED/ENFORCE/INTERVAL`, allowlist `OPS_CORE_BASE_URL_ALLOWED_HOSTS`, mặc định `lifecycle.enforce` trong mã khác yml: ghi rõ), tên blocker `OPS_CORE_SKU_LIFECYCLE_BLOCKED`;
       cờ Giờ Vàng `golden-hour-allocation.enabled=true` bị từ chối khi chưa có NK-c.
   (b) Decision log §10 (tìm tệp: `grep -rln "§10\|## 10" docs deploy/m34 | grep -i decision`): mục chờ chốt → ghi theo D-m34 đã chốt (dẫn số D), C1/D1 sang .99.
   (c) Spec P2-44: xác nhận + OD-06 + INDEX + §12, đóng M3-025 (theo note M3-155/156).
   (d) `deploy/m34/ops-core/SKU_MOI.md` sang .99, điền chỗ trống, số migration đúng.
   (e) NM3-16b V10 (theo note M3-165/M3-125): sửa tài liệu; tin cho Tài/m12 KHÔNG gửi, chỉ soạn nháp 3–5 dòng ở cuối đầu ra.
   Mọi khẳng định về mã phải có tệp:dòng ở `09c13eefb`; điều chưa chắc ghi "CHƯA KIỂM", không bịa. Không ghi bí mật, mật khẩu, số điện thoại, dữ liệu khách.
3. Phạm vi ghi: chỉ tệp `.md` trong `deploy/m34/ops-core/`, `docs/` (decision log, spec P2-44, INDEX) đúng các mục trên. CẤM: mọi mã (`*.java`, `*.ts`, `*.py`, `*.sh`, yml), `docs/integration/m3-m8/**`
   (đang chờ phiên lead chốt phương án 4.1 của chú Dũng), `deploy/m34/m8-that/**` (gói `ivr-admin-99`), `docs/weekly-tracking/**`.
4. Đọc trước: 6 note ở mục 2, `NOI_M12.md`, `SKU_MOI.md`, `application.yml` khối `app.inventory.ops-core`, `deploy/m34/compose.yml`, `deploy/m34/env.mau`, `chung/MAY_CHU.md` (`C:\Projects\Project Control\chung\MAY_CHU.md`, chỉ đọc).
5. Lệnh kiểm nhanh: kiểm link nội bộ trong các tệp đã sửa còn trỏ đúng tệp; `grep -n "192.168.1.6[01]"` trong tệp đã sửa chỉ còn ở chỗ ghi "đường lui"; nếu repo có test đọc tài liệu (`grep -rl "NOI_M12\|SKU_MOI" deploy/m34/tests back-end/src/test`) thì chạy test đó.
6. Bằng chứng: patch; bảng 6 task × việc trong note → đã sửa ở tệp:dòng; danh sách khẳng định mã kèm tệp:dòng.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra ≤ 25 dòng theo brief chung + tin nháp mục 2(e).

## Diễn biến
- 15/11 07:3x soạn phiếu; giao sau verifier bản ghim draft.46 (giữ ≤ 2 agent).
- 15/11 07:32 tạo worktree `_wt/m34/tai-lieu` (`09c13eefb`), giao coder.
- 15/11 08:00 coder: ĐẠT · patch 8 tệp +210/−114 (`NOI_M12.md` .99 + secrets/ + mức 3 + trần 20 dòng + thử lại 1 lần + mục 7 vòng đời + blocker + cờ Giờ Vàng; `SKU_MOI.md` .99 + migration + `source_doc_*`; decision log §10 chính thức + §10.6 OD-01..11; spec P2-44, OD-06, INDEX, M3-025, NM3-16b) · link 434 tham chiếu 0 hỏng, `192.168.1.6x` 0 dòng · báo cáo `_wt/m34/tai-lieu-bao-cao.md` · CẦN QUYẾT 4 mục → chốt thay D-m34-084 · CHƯA CHẠY: V7 trên .99 (ssh chỉ đọc, Toàn duyệt) · tin nháp Tài + m12 (không gửi) · việc sau: chú thích `OpsCoreBlockers.java:48`, manifest `_maintenance` 6 tệp lệch băm (D-m34-080 e). Giao verifier (R1, sonnet).
- 15/11 08:09 verifier: CẦN SỬA · mã/máy/link đúng (8+ khẳng định mã 0 sai, 378 link 0 hỏng, `192.168.1.6x` 0) · lệch D-m34-084: P2-44 §5.6 còn "chờ Toàn", payload hash NM3-51a chưa ghi "sau 30/11", chưa dẫn D-m34-084, lệnh kiểm V340 `LIMIT 3` sai, tên tệp SKU (nhận tinh chỉnh "/"→"-", sửa D-m34-084 c), nit số dòng/.60 ở NM3-16b · giao coder vòng 2.
- 15/11 08:12 coder vòng 2: ĐẠT · patch 8 tệp +217/−120 · §5.6 chốt D-m34-084 ở spec/HCC/m3-025/INDEX, câu `SHIPMENT_STOCK_GATE_BLOCKED` ở `NOI_M12.md:141`; NM3-51a "sau 30/11"; dẫn D-m34-084; lệnh kiểm V340; nit NM3-16b · verifier kiểm vòng 2.
- 15/11 08:14 verifier vòng 2: CẦN SỬA mục 1 · mã ĐÃ chạy phương án B (vòng đời M3 không chặn vận đơn đơn đã tạo: `SellableGateCommitCheckServiceImpl.java:162-163`, test `OpsCoreLifecycleEnforceWiringTest.java:175`), phiên chính tự đọc xác nhận → đính chính D-m34-084 (b), ghi D-m34-085 · mục 2–6 ĐẠT · giao coder vòng 3.
- 15/11 08:21 coder vòng 3 ĐẠT (giữ B) · verifier vòng 3: còn cụm "(đã hỏi m12)" ở `NOI_M12.md:141` → phiên chính sửa "(chờ hỏi m12; tin chưa gửi)" đúng như verifier chỉ, xuất lại patch · áp lên `toandeptrai` → `9abcd32b1`; Sheet: M3-139/149/155/165 Hoàn thành, M3-156 Đang làm 90% (chờ m12 xác nhận), M3-125 Đang làm 60% (V7 .99, Tài, m12) · nhật ký tuần `74de1cd0b`. Tin nháp Tài + m12 ở mục 7 `_wt/m34/tai-lieu-bao-cao.md` (chưa gửi).
- 15/11 10:24 bộ đủ sóng trên `kiem-song2` `74de1cd0b` (10:09–10:24): deploy 600 OK (98 bỏ qua) · ci-unit 34311 ca, 40 đỏ = 39 đỏ sẵn `afb6d404c` + 1 ca chập chờn có sẵn `PaymentPricingPolicyLifecyclePostgresTest` (bean lập lịch `PaymentPricingMandatoryCheckSchedulerConfig.java:14` không có điều kiện, 250 ms/lượt tranh với lời gọi tay; chạy riêng lớp: ca khác đỏ; sóng không chạm `order` ngoài 1 dòng javadoc) · vitest 9338 ca, 32 đỏ / 5 tệp, không tệp nào thuộc IVR; chạy riêng 4 tệp: StorefrontHeader, brands, collaborator xanh (quá giờ do máy bận), chỉ `proxy.test.ts` 24 ca (đỏ sẵn trên dev); `legal-hold-real-spec-guard` đỏ do checkout CRLF máy này (`core.autocrlf=true`) → **không ca đỏ mới**.
- 15/11 10:25 Sheet Lead duyệt (`sheet_lead.mjs ghi`, `ra-soat/evidence/2026-11-15-song-tai-lieu/ket-qua.json`): M3-139/149/155/165 Cần sửa → **Đạt**, ok, verified 4/4. M3-156 (chờ m12 xác nhận), M3-125 (V7 .99, Tài, m12) giữ Đang làm.

## Bước kế tiếp chính xác
Toàn gửi tin nháp Tài + m12 (`_wt/m34/tai-lieu-bao-cao.md` mục 7) → m12 xác nhận thì đóng M3-156; V7 trên .99 (ssh chỉ đọc, Toàn duyệt) cho M3-125. Việc sau: chú thích `OpsCoreBlockers.java:48`, manifest `_maintenance` (D-m34-080 e).

## Còn lại / CẦN QUYẾT
- (trống)
