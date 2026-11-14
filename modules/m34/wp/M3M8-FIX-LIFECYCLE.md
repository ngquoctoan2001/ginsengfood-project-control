# M3M8-FIX-LIFECYCLE — Vòng lặp LIFECYCLE_PROCESSING_FAILED: ghi nguyên nhân, giãn nhịp, lab đủ chính sách GH

Trạng thái: XONG `5cfce4753` (Lead duyệt diff D-m34-016, chưa push) · Rủi ro: R3 (nhánh huỷ đơn đã thu tiền + hoàn tiền) · Chế độ: S · Mốc: B (trước chạy lại WP09)
Hạng mục nâng: M3→M8 lifecycle chạy bền khi lỗi xác định · Sheet: M3-036 (WP09) / cha M3-023 · Ước lượng: 0,5 ngày công AI
Chỗ làm: checkout BP `toandeptrai` @ `8f72b4493` (coder) · tester: `C:/Projects/_wt/m34/kiem-lifecycle-tester` (detached @ `8f72b4493`)
Chỗ kiểm: verifier tạo worktree detached riêng · Bằng chứng: `C:/Projects/_wt/m34/fix-lifecycle/` · Quyết định: D-m34-012

## Chẩn đoán (03/11 08:20–08:35, phiên m34, lab `389f977a`)

Chuỗi: 35 đơn GH ONLINE PAID, xác nhận ACCEPTED, giữ chờ giờ gọi (hold ceiling 12:00). OTP SMS hết hạn sau 2h (06:16:26–30)
→ `contacts.recheck` không ALLOW → `cancel(CONTACT_RESTRICTED)` (sau 08:06 là `IVR_WATCHDOG_EXPIRED`, dòng 116 trong JAR)
→ `cancelAndRequestRefund` + `OrderIvrResourceReleaseAdapter.release` → `GoldenHourIvrReservationServiceImpl.release:55`
→ `GoldenHourReleaseService.releaseInventoryHolds:294` → `publishInCurrentTransaction` → `EventPublisherServiceImpl.resolvePolicyVersionId:148`
→ `AppException "POLICY_VERSION_MISSING: GOLDEN_HOUR_POLICY/GLOBAL"` (JFR: 80 lần/25 s) → rollback toàn bộ → `OrderIvrLifecycleService:76-87`
nuốt lỗi không ghi nguyên nhân, đặt marker, ứng viên xếp theo `lifecycle_checked_at` nên thử lại mãi (~11 s/đơn, 23.183 dòng log).
Hệ quả phụ: revoke không bao giờ commit nên M8 vẫn gọi 35 đơn lúc 08:00. Không có migration nào seed `GOLDEN_HOUR_POLICY`
(chỉ seeder E2E `GoldenHourRealE2eDataSeeder`). Bằng chứng: `C:/Projects/_wt/m34/wp0910-20261103/lifecycle-loop-20261103/`
(psv, JFR, exceptions*.txt, javap, dump DB BP/M8).

## Brief
1. Repo `C:\Projects\ginsengfood-business-platform`, nhánh `toandeptrai` (kiểm `git branch --show-current` trước khi sửa), base `8f72b4493`.
2. Mục tiêu — khi xong:
   F1 lỗi lifecycle ghi `IVR lifecycle check failed confirmationId={id} code=LIFECYCLE_PROCESSING_FAILED cause={SimpleClassName}`
      và với `AppException` thêm `:{CODE}` = cụm `[A-Z_]+` đứng trước `:` đầu tiên của message (ví dụ `cause=AppException:POLICY_VERSION_MISSING`);
      không ghi message khác, không SĐT/tên/địa chỉ, không stack trace ở mức WARN.
   F2 xác nhận có `lifecycle_error_code='LIFECYCLE_PROCESSING_FAILED'` không được chọn lại trước `lifecycle_checked_at + backoff`
      (`app.ivr-lifecycle.failure-backoff-ms`, mặc định 300000), so với `Clock` của service; ứng viên khoẻ không bị đói trong cùng lô;
      không đổi schema/migration; `expireIfDue`, `invalidateAfterTransition` không đổi.
   F3 lab WP09 publish đúng một phiên bản hiệu lực `GOLDEN_HOUR_POLICY`/`GLOBAL` theo cách seeder E2E/chuẩn đang làm, và kiểm sẵn sàng
      checkout của lab có thêm điều kiện "resolve được GOLDEN_HOUR_POLICY" (thiếu thì dừng sớm).
   Hành vi nghiệp vụ giữ nguyên: lỗi vẫn rollback hết (đơn CONFIRMED/PAID, 0 dòng `payment_refunds` mới, reservation BOUND);
   khi có chính sách thì huỷ commit đúng một lần (1 refund PENDING, idempotent).
   Tiêu chí: test Postgres mới ĐỎ trên `8f72b4493` rồi XANH sau sửa; bộ hồi quy `OrderIvr*Test`, `GoldenHour*Ivr*Test`,
   `GoldenHourReleaseServiceTest`, `ModuleBoundaryArchitectureTest` xanh (trừ 3 skip POSIX đã biết).
3. Phạm vi ghi: `order/service/impl/OrderIvrLifecycleService.java`, `order/repository/jdbc/OrderIvrLifecycleJdbcRepository.java`,
   port store tương ứng, `application.yml` (khoá mới), test mới/sửa trong `back-end/src/test/.../order/`, công cụ/seed lab trong
   `tools/m3-m8-wp09/` và seeder E2E chỉ-lab, ghi chép `docs/integration/m3-m8/evidence/wp0910-20261103/lifecycle-loop-fix.md`.
   Cấm: migration, `pom.xml`, M8 repo, cấu hình production, `SecurityConfig`, sửa ngữ nghĩa CONTACT UNKNOWN → huỷ (chờ m34.23).
4. Đọc trước: phần Chẩn đoán ở trên; `OrderIvrLifecycleService.java:55-127,220-250`; `OrderIvrLifecyclePostgresTest.java`;
   `OrderIvrWp0203PostgresFixture.java`; `GoldenHourRealE2eDataSeeder.java`; `tools/m3-m8-wp09/README.md` §5.
5. Lệnh được chạy: Maven targeted với `-Dginsengfood.build.directory=<thư mục riêng trong C:/Projects/_wt/m34/fix-lifecycle/>`,
   `MAVEN_OPTS=-Xmx512m`, `JAVA_TOOL_OPTIONS=-Xmx1024m`; Testcontainers. KHÔNG: `git add/commit/push`, DB dùng chung, lab/`lab.mjs`,
   `docker system prune`, đụng container không phải của mình (m12 đang chạy test .NET trên cùng Docker).
6. Bằng chứng: lệnh + số ca đỏ/xanh, log trích dòng WARN mới, diff stat, danh sách tệp đổi, dọn container test.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra: tin nhắn cuối ≤ 25 dòng theo LUAT_SUBAGENT mục 10.

## F4 — bổ sung theo D-m34-013 (03/11 08:52, "23 A"), làm SAU F1–F3, test đỏ riêng

Áp cho xác nhận còn hiệu lực, M8 đã nhận (`accepted_job_id` có), trong `OrderIvrLifecycleService.reconcile` sau bước watchdog:
- `contact.restriction()==BLOCK` → giữ nguyên hành vi hiện tại: `cancel(order,c,"CONTACT_RESTRICTED",now)` (huỷ + hoàn + nhả + revoke).
- Mọi trường hợp khác không ALLOW (UNKNOWN với mọi lý do: OTP hết hạn sau khi chốt, nguồn liên hệ lỗi, dữ liệu mâu thuẫn; `contact==null`
  do ngoại lệ; ALLOW nhưng lệch số/`contactRef`/`proofRef`/thời điểm đọc) → KHÔNG huỷ, KHÔNG hoàn, KHÔNG revoke; đặt
  `lifecycle_error_code='CONTACT_RECHECK_UNKNOWN'` (cho vận hành thấy), WARN một lần khi chuyển vào trạng thái này
  (`IVR lifecycle contact recheck unknown confirmationId={id} reason={mã lý do không PII}`), các vòng sau kiểm lại bình thường;
  khi kiểm lại ra ALLOW thì xoá mã này (như `store.checked` đang làm). Watchdog/D17 tới hạn giữ nguyên.
- Thêm `'CONTACT_RECHECK_UNKNOWN'` vào CHECK của `V262__m3_m8_lifecycle_watchdog_and_edit_guard.sql` (migration này chỉ có trên
  `toandeptrai` local, chưa push, chưa chạy trên DB dùng chung nào — được sửa tại chỗ cho F4, không tạo migration mới).
- Sửa P04 trong BP `docs/integration/m3-m8/09-wp00-phieu-chot-p01-p09.md`: thêm một câu ghi D-m34-013 cho lần kiểm lại sau khi M8 nhận.
- Test (đỏ trên `8f72b4493`): OTP hết hạn sau chốt → đơn CONFIRMED/PAID, 0 refund mới, reservation BOUND, xác nhận còn hiệu lực,
  mã `CONTACT_RECHECK_UNKNOWN`; nguồn lỗi (`contacts.recheck` ném) → như trên; BLOCK → huỷ + 1 refund PENDING đúng một lần;
  hết hạn watchdog → huỷ như cũ; UNKNOWN rồi ALLOW → mã được xoá.

## Diễn biến
- 03/11 08:40 giao coder (F1–F3, test đỏ trước) và tester độc lập (test F1–F2 từ đặc tả, không đọc diff coder) song song.
- 03/11 08:53 D-m34-013: thêm F4; giao tiếp cho chính coder (cùng tệp) và tester sau khi xong phần đang làm.
- 03/11 09:3x coder vòng 1 ĐẠT (F1–F4, hồi quy 271/271, ArchUnit 15/15 heap 2 GB) · tester độc lập 26 ca, 21 đỏ đúng lý do trên gốc.
- 03/11 09:5x coder vòng 2: cờ `reconciliation_required` + 2 bản sao schema (đỏ 1/14 → xanh 77/77). Giao verifier ở `_wt/m34/kiem-FIX-LIFECYCLE`.
- 03/11 10:25 verifier ĐẠT: hai patch áp sạch @8f72b4493, 407/407 (7 lỗi OOM ryuk chạy lại 58/58), tester 26/26, ArchUnit 15/15, đột biến 5/5
  (backoff 4 đỏ, cause 10, UNKNOWN→huỷ 16, cờ đối soát 1, kiểm chính sách GH 1). Phát hiện TB: V262 đã push 10:15 → sửa tại chỗ đổi checksum (m34.30);
  thấp: CONTACT_RECHECK_UNKNOWN ghi đè STATUS_OBSERVATION_UNKNOWN cùng vòng; `safeCause` lấy cụm HOA trước dấu `:`. Bằng chứng `fix-lifecycle/verifier/`.

## Bước kế tiếp chính xác
Lead duyệt diff + chọn cách xử lý V262 (m34.30) → commit 18 tệp lên `toandeptrai` (không push; kèm 2 test của tester đặt vào
`back-end/src/test/java/com/ginsengfood/project/order/`) → `sheet-sync log` M3-036 → m34.26 gộp `origin/dev` → chạy lại WP09 cohort mới.
Dọn worktree `_wt/m34/kiem-lifecycle-tester`, `_wt/m34/kiem-FIX-LIFECYCLE` và thư mục build `fix-lifecycle/verifier*/target` sau commit.

## Còn lại / CẦN QUYẾT
m34.30 (duyệt diff, V262 tại chỗ hay V265) · m34.29 (`GOLDEN_HOUR_POLICY` trên .60). m34.23 đã chốt A (D-m34-013 → F4).
