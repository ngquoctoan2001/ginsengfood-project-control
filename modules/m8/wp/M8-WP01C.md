# M8-WP01C — Bộ nghiệm thu E01–E10 cho cặp M3 .60 ↔ M8 .61 (phần chuẩn bị)

Trạng thái: ĐÃ GỘP W-0524 `2dbfe0aa` (đã lên GitLab + GitHub 13:48, không do phiên này; chưa chạy trên .60/.61) · Rủi ro: R2 · Chế độ: A · Mốc: 13/11 (UAT 14/11)
Hạng mục nâng: Nối với M3 (chuẩn bị nghiệm thu; bậc chỉ lên khi chạy thật trên .60/.61) · Sheet: M8-001 · Ước lượng: 7 giờ (phần chuẩn bị ~4)
Chỗ làm: `C:\Projects\_wt\m8\M8-WP01C` (bản sao archive, repo tạm commit `goc` 1ddb8f8) · Base SHA: `10f335de` · Chỗ kiểm: cùng bản sao
Quyết định: D-m8-069 (bản tối thiểu M3 .60 ↔ M8 .61), D-m8-076 (15/11 gọi MOCK, không gọi số thật). Chạy thật E01–E10 chờ M3 .60 (hộp thư m34) + 01B áp cấu hình.

## Brief
1. Repo · thư mục: bản sao archive của `ginsengfood-ivr` @ `10f335de` tại `C:\Projects\_wt\m8\M8-WP01C` (repo tạm có commit `goc`; KHÔNG commit thêm).
   Repo gốc `C:\Projects\ginsengfood-ivr` chỉ đọc. Repo `C:\Projects\ginsengfood-business-platform` chỉ đọc (phía M3, để biết M3 lưu gì).
2. Mục tiêu: Lead có bộ nghiệm thu dùng ngay khi M3 .60 sẵn sàng (UAT 14/11, bản tối thiểu gọi MOCK):
   a) **Phiếu theo ca E01–E10** (một tệp): mỗi ca có ID, mục tiêu, điều kiện trước (.60/.61, MOCK, commit M3 + SHA/digest M8 để điền), bước làm
      (ai làm: phía M3 hay phía M8), kết quả mong đợi đo được, ô bằng chứng (correlation, mã HTTP, giờ +07, mã job/callback đã ẩn danh, log đã lọc,
      người M3 xác nhận), trạng thái mặc định `CHƯA TEST M3`. Ca không làm được trong bản tối thiểu (ví dụ cần UI BFF, cutover) ghi `NOT_RUN` + lý do
      + điều kiện để mở. Nguồn: `deploy/rollouts/production-window-20261027/m3-e2e.md:25-39` (ma trận gốc, không đổi nghĩa),
      `docs/evidence/W-0494/e01-e10-mapping.md`, `deploy/m8/noi-m3/luot-thu.md` (lượt thử một đơn MOCK), `deploy/m8/noi-m3/viec-m34.md`.
      Thêm bảng chỉ mục M3-E11…E42 (`integration-requirements/08-module-3-sandbox-guide.md`): một dòng/ca, thuộc bản 15/11 hay không, lý do.
   b) **Công cụ đối soát chỉ đọc phía M8** `doi_soat_m3.py` (python3 thư viện chuẩn, chạy trên .61 trong khuôn `~/m8`, cùng cách `deploy/m8/noi-m3/kiem_noi_m3.py`
      đọc DB): đầu vào là tệp danh sách correlation/mã task; đọc bằng SELECT trong giao dịch READ ONLY qua `docker compose exec`; in JSON mỗi ca:
      lúc nhận task, job, kết quả MOCK, callback (trạng thái, số lần gửi, mã ACK), cờ bất thường (hai job cho một task, hai callback final, callback
      không có task). Không in PII (số điện thoại, tên, địa chỉ, địa bàn), không in bí mật. Mã thoát: 0 khớp mong đợi, 1 lệch, 2 lỗi dùng/kết nối.
      Bảng/cột lấy đúng theo model + migration hiện hành (trích `tệp:dòng`).
   c) **Runbook UAT** `deploy/m8/nghiem-thu-m3/README.md`: thứ tự E01–E10 trên cặp .60/.61 sau khi 01B áp cấu hình, phía M3 (m34) làm gì, phía M8 (Lead)
      làm gì, lệnh đối soát, cách điền phiếu, điều kiện dừng; không gọi số thật, `REAL_CUSTOMER_CALL_ALLOWED=NO`.
   Tiêu chí đạt: 10/10 ca có đường lấy correlation M3 → job → callback hoặc lý do NOT_RUN; phiếu theo ca có ID, kết quả mong đợi, ô bằng chứng;
   test viết đỏ trước rồi xanh (đối soát: fixture kết quả SQL giả qua docker giả; tài liệu: mỗi ca đủ trường, mọi `tệp:dòng` trích dẫn tồn tại);
   `python -B -X utf8 -m unittest` vùng mới đạt (ghi số); quét PII trong container Linux trên bản LF của `deploy/m8/nghiem-thu-m3` + bằng chứng đạt.
3. Phạm vi ghi: `deploy/m8/nghiem-thu-m3/**` (mới), `deploy/m8/tests/test_nghiem_thu_m3_*.py` (mới), một dòng trỏ tới phiếu trong
   `deploy/rollouts/production-window-20261027/m3-e2e.md` (không đổi bảng gốc), `docs/evidence/W-PENDING-01C/**`.
   Cấm: `deploy/m8/README.md` (của 02J sóng này — cần dòng mục lục thì ghi đề xuất trong đầu ra), `deploy/m8/compose.yml`, `deploy/m8/trien-khai.sh`,
   `deploy/m8/noi-m3/**` (chỉ đọc; cần sửa → ghi đề xuất), `deploy/operations/**`, `src/**`, migration, `docs/release/*`, `.gitleaks*`.
4. Đọc trước: `CLAUDE.md`, `AGENTS.md`; các nguồn ở mục 2a; `deploy/m8/noi-m3/README.md`, `kiem_noi_m3.py`, `deploy/m8/tests/test_noi_m3_kiem.py`
   (cách giả docker); `deploy/m8/README.md`; `specs/api/openapi/ivr-order-confirmation.v1.yaml` (draft.45) và
   `specs/api/openapi/order-core-ivr-callback.target-v1.yaml` (tên trường); phía M3 chỉ đọc: `C:\Projects\ginsengfood-business-platform\docs\integration\m3-m8\`.
5. Được chạy: python unittest; Docker local chỉ cho quét PII (image ghim `sha256:c86ecead…` trong `deploy/ci/scripts/selftest-pii.sh`, `--network none`)
   và nếu cần một Postgres 16 nhỏ tiền tố `m8w01c-` (`--memory 1g`, không cổng ra ngoài, xoá khi xong); không chạy Docker khi có container nhãn
   `com.gitlab.gitlab-runner.type`. Test của công cụ chỉ dùng docker giả qua PATH: trước khi chạy test, kiểm `type docker` trỏ vào shim, không bao giờ chạm
   container thật project `m8`. KHÔNG: ssh/scp, gọi .60/.61/.64, sheet-sync, cấp W-ID, sửa repo gốc/repo M3, gửi tin cho ai.
6. Bằng chứng: `docs/evidence/W-PENDING-01C/README.md` (lệnh + số, đỏ trước/xanh sau, giới hạn, CHƯA CHẠY trên .60/.61); không lập MANIFEST.
   Tránh chữ khớp mẫu địa chỉ của `deploy/ci/pii-patterns.txt` (dòng 2) trong mọi tệp mới; dùng "lối"/`loi`/path.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra: tin nhắn cuối ≤ 25 dòng theo LUAT_SUBAGENT mục 10.

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- 11/11 10:18 giao coder v1 (sóng 2, Lead "làm tiếp").
- 11/11 11:07 coder v1 xong (tự báo ĐẠT phần chuẩn bị): `deploy/m8/nghiem-thu-m3/` (phiếu E01–E10: E01/02/03/05/06/10 `CHƯA TEST M3`, E04/07/08/09 `NOT_RUN` có lý do; chỉ mục E11…E42: 1 Có/12 Một phần/19 Không; `doi_soat_m3.py` chỉ đọc mã thoát 0/1/2, 5 cờ bất thường; `bang-cot.md` 6 bảng 52 cột; runbook + 2 tệp mẫu), 2 tệp test (đỏ trước 56 test 0 đạt → xanh 57 OK), hồi quy `test_noi_m3_*` 115 OK (11 skip), SQL thật trên PG16 tạm 13/13, quét PII PASS (2 tệp đối chứng FAIL đúng). Sửa trong lượt: trường `khoa` từng in mã đơn thô → băm `h:`. `m3-e2e.md` +2 dòng (trỏ ở dòng 46). Giao verifier R2.
- 11/11 11:25 verifier R2: **CẦN SỬA** (57 OK, hồi quy noi_m3 115 OK, PII PASS, 9/9 đột biến đỏ, 30 trích dẫn đúng, 52 cột khớp snapshot). Lỗi: (1) `README.md:87-88` curl E01 thiếu `X-Source-System: order-core` → allowlist trả 403 trước khi xét token (`OrderCoreAllowlistMiddleware.cs:30-36`), phiếu/README ghi 401 sai; (2) correlation in thô = `task_id` `m3-ivr-<orderId>-<decisionId>` (`OrderIvrTaskAssembler.java:88-89`) nên băm `h:` vô tác dụng. Chọn B (theo brief: ô bằng chứng giữ correlation; mã đơn test tenant là mã nội bộ, không phải PII) — ghi rõ trong tài liệu. Điểm nhỏ: `README.md:123` case DỪNG không chặn lệnh sau, stderr psql `doi_soat_m3.py:270`, quét PII lại, E09 phần producer dừng/bật. Giao coder vòng 2 (cùng agent).
- 11/11 11:46 coder vòng 2 xong: E01 thêm `X-Source-System` cả 3 curl + bảng mã theo thứ tự kiểm (không token 401 `IVR_UNAUTHENTICATED`; token rác/sai nguồn/sai audience/hết hạn 403 `IVR_FORBIDDEN_CALLER`), correlation thô theo B (ghi rõ, `h:` chỉ là mã rút gọn), khối E03 không chạy tiếp khi DỪNG, `tom_loi_psql` che khoá, E09 phương án một phần. Đỏ trước 61/4 fail → xanh 61 OK; hồi quy noi_m3 115 OK; PII vòng 4 PASS sau lần sửa cuối. Giao verifier R2 lượt 2.
- 11/11 11:45 verifier R2 lượt 2: **CẦN SỬA (chỉ test)** — 6 lỗi lượt 1 sửa đúng (mã E01 xác nhận theo mã: sai nguồn 403 `OrderCoreAllowlistMiddleware.cs:30-37`, không token 401 `:39-45`, token rác `Malformed` → 403 `ServiceIdentity.cs:355-369` + `ApiBehaviorMatrixTests.cs:194,336`; khối E03 chạy thử 8 ca đúng), 61 OK, hồi quy 115 OK, PII PASS, không hồi quy. Đột biến sống: `test_nghiem_thu_m3_tai_lieu.py:284-294` không kiểm đúng nhánh `case` (đưa lệnh dựng vào nhánh DỪNG / bỏ `&&` vẫn xanh); `:260-282` chỉ đòi có chữ 401/403 (đổi 401↔403 trong bảng vẫn xanh). Theo luật hai vòng → **dừng WP, trình Lead m8.76**.

- 11/11 13:55 Lead "Duyệt" m8.79 + m8.76 A (D-m8-078/079): phiên chính tự siết 2 test (`test_khoi_dat_kich_ban_e03_…` kiểm đúng nhánh `case` + `&&`; `test_bang_ma_e01_dung_tung_dong` mới), 9/9 đột biến đỏ, `Ran 62` OK, hồi quy noi_m3 115 OK. Ghép A-mode: thư mục bằng chứng đổi thành `docs/evidence/W-0524`; gitleaks dir trên cây sắp commit bắt `curl-auth-header` ở 2 lệnh curl E01 (token rác viết thẳng) → đổi thành biến `TOKEN_RAC` dựng lúc chạy, sửa trước commit; PII Linux PASS (đối chứng FAIL), gate-status/selftest PASS. **Commit local `2dbfe0aa`** (W-0524, 21 tệp +3182), gitleaks toàn lịch sử + khoảng sạch. 13:48 `origin/main` và `github/main` đã là `2dbfe0aa` (reflog "update by push"): push do người/phiên khác, không phải phiên này.

## Bước kế tiếp chính xác
Chạy thật E01–E10 khi M3 .60 sẵn sàng + Lead áp cấu hình 01B.

## Còn lại / CẦN QUYẾT
- Chạy thật E01–E10: chờ M3 .60 (hộp thư `m34-2026-11-10-noi-m8-that-61.md`) và lệnh Lead áp cấu hình 01B trên .61.
- Coder hỏi (trình Lead cuối sóng): (1) phần hủy E03 cần kịch bản MOCK bấm 0 theo `task_id` đơn hủy — A (đề xuất) vá thêm kịch bản, đặt bằng
  `dat-cau-hinh.sh` khi lịch gọi tắt; B ghi `NOT_RUN`. (2) Replay E05/E06-B cần `IVR_ADMIN_DANGER_TOKEN` trong api.env .61 và 8443 nhận yêu cầu từ chính .61;
  thiếu → `NOT_RUN`.
- Đề xuất dòng mục lục `deploy/m8/README.md` (tệp của 02J): "`nghiem-thu-m3/` — phiếu E01–E10, đối soát chỉ đọc, runbook UAT M3 .60 ↔ M8 .61 (M8-WP01C)" — thêm lúc ghép.
