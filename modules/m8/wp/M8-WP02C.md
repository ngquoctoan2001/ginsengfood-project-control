# M8-WP02C — Bộ điều phối cửa sổ: kế hoạch chuyển, kiểm sau chuyển, quay lui sinh từ inventory

Trạng thái: ĐẠT — đã ghép `main` 00b90044 (W-0488), đã có trên GitLab/GitHub tại c9f0cd18 (fetch + ls-remote 02/11 09:55) · Rủi ro: R2 · Chế độ: A · Mốc: A 07/11 (công cụ), D 14/11 (chạy thật)
Hạng mục nâng: Cài bản thật `.61`/`.64` từ 50 lên 50 (giữ bậc, thêm công cụ có kiểm lab) · Sheet: M8-002 · W: W-0488 · Ước lượng: 6–8 giờ
Chỗ làm: `C:\Projects\_wt\m8\wp02c-cuaso` (bản sao `git archive`, repo tạm, commit `goc` 7bd61c6) · Base SHA: `2aaacb35` · Chỗ kiểm: cùng bản sao

## Brief
1. Repo `ginsengfood-ivr` (.NET 10 + công cụ Python ở `deploy/`). Thư mục làm việc DUY NHẤT: `C:\Projects\_wt\m8\wp02c-cuaso`
   (bản sao, repo git tạm có commit `goc`). KHÔNG ghi vào `C:\Projects\ginsengfood-ivr` và `G:\ivr-lab\` (chỉ đọc). Không tạo nhánh.
2. Mục tiêu: README cửa sổ nói "lệnh apply/revert cụ thể phải được sinh từ inventory đang chạy và secret thực đã cấp… chưa phải
   lệnh copy-paste". Khi xong, có `deploy/production-window/cutover/window.py` (Python 3.10, stdlib) với các bước:
   - `plan --inventory61 <json> --inventory64 <json> --candidate <thư mục ứng viên> [--receipts <thư mục>]`: sinh kế hoạch theo đúng
     bảng T+0…T+90 của README §2 — từng bước có lệnh cụ thể (tên container/project/image ID/volume/unit lấy từ inventory, không
     đoán), điều kiện đi tiếp, điểm dừng; và kế hoạch quay lui §4 tương ứng từng phần đã thay. Từ chối sinh khi: inventory thiếu
     trường, cổng 5060/18088/18089/18090/9443 xung đột, thiếu receipt bí mật, cờ `REAL_CUSTOMER_CALL_ALLOWED` hay scheduler/adapter/
     trunk/callback không ở trạng thái đóng, lệnh nào có `compose down -v`/xoá volume/`migration Down`, worker stop < 210 giây,
     policy không có `--version gh-247-prod-v4`. Không lệnh nào ghi đè mù hay kéo tag mutable.
   - Phần `.64`: gọi/dẫn `deploy/telephony-vm/vm_deploy.py` (`plan|preflight|apply|verify|rollback`) thay vì viết lại.
     Phần giám sát T+65–80: dẫn `deploy/operations/migration/` (host_handoff/state_transfer) đã diễn tập, không viết lại.
   - `verify --phase pre|post|rollback`: bộ kiểm sau chuyển (cổng/ACL mong đợi, cờ đóng, ARI 0 kênh, health, HTTP không token bị
     401/403, S5 8443 không đổi, image/config đúng hash ứng viên) — nhận đầu ra lệnh đã thu (JSON/văn bản do Lead chạy trên máy
     gửi về) hoặc bộ chạy lệnh tiêm vào được; trả ĐẠT/LỖI từng mục.
   - Công cụ KHÔNG tự ssh hay chạy lệnh trên máy thật: chỉ in kế hoạch (`--format md|sh`) để Lead chạy, và kiểm đầu ra Lead dán lại.
   Tiêu chí đạt: (a) `python -X utf8 -m unittest discover -s deploy/production-window/cutover/tests -v` đạt, test đỏ-trước cho từng
   quy tắc từ chối ở trên; (b) chạy `plan` trên fixture dựng từ `deploy/operations/readiness/{host61,host64}.current.json` + thư mục
   ứng viên `G:/ivr-lab/release-final-20261026/candidate` → kế hoạch md lưu vào bằng chứng, đối chiếu đủ mọi dòng bảng §2 và §4;
   (c) đột biến: bỏ một điều kiện từ chối → test đỏ; (d) `README.md` của thư mục công cụ: trình tự Lead làm trong ngày cửa sổ.
3. Ghi được: `deploy/production-window/cutover/**`, `docs/evidence/W-0488/**`. Cấm: mọi tệp khác, đặc biệt `deploy/rollouts/**`,
   `deploy/telephony-vm/**`, `deploy/operations/**`, `deploy/release-candidate/**` (đọc, dùng lại; thấy cần sửa → `CẦN QUYẾT`),
   `docs/release/**`, `docs/traceability-tests.md`, `.gitattributes`, `tools/task-tracker/**`. Không đụng `deploy/production-window/db/`,
   `deploy/production-window/secrets/` (WP khác đang viết; chỉ tham chiếu bằng đường dẫn tệp receipt/README dự kiến).
4. Đọc trước: `CLAUDE.md` của bản sao; `deploy/rollouts/production-window-20261027/{README.md,provisioning-sequence.md,m3-e2e.md}`;
   `deploy/telephony-vm/{README.md,vm_deploy.py}`; `deploy/telephony-link/README.md` mục quy trình L34;
   `deploy/operations/readiness/{README.md,host_audit.py,host61.current.json,host64.current.json}`; `deploy/operations/migration/README.md`;
   `deploy/release-candidate/{README.md,render_hosts.py}`; `G:/ivr-lab/release-final-20261026/candidate/{config/,rollback/rollback.json,
   docs/operations/production-operating-model.md}`; `docs/evidence/deployment-window-20261027/README.md`.
5. Được chạy: Python unittest; đọc tệp. KHÔNG: docker/compose (không cần cho WP này), ssh/scp, mọi máy `.60/.61/.63/.64`,
   `s5v4_host.py`, `run_lab.py`, `vm_deploy.py apply|restart|rollback` (chỉ `plan` trên thư mục tạm nếu cần), sheet-sync,
   `gitnexus analyze`, đọc `.env*`/khoá thật.
6. Bằng chứng: `docs/evidence/W-0488/README.md` + kế hoạch sinh mẫu (md), không bí mật/PII;
   `sh deploy/ci/scripts/scan-pii.sh docs/evidence/W-0488` đạt.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Không commit trong bản sao (để thay đổi ở cây làm việc).
8. Đầu ra: tin nhắn cuối ≤ 25 dòng theo LUAT_SUBAGENT mục 10.

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- 01/11 17:40 tạo bản sao + phiếu, giao coder v1
- 01/11 18:41 coder v1 bị ngắt do 429 (hạn mức 5 giờ) khi mới đọc tài liệu, bản sao chưa đổi → cho chạy tiếp
- 01/11 19:35 coder v1: ĐẠT (lab) · 21 tệp mới `deploy/production-window/cutover/**` (window.py: capture/inventory/plan/verify/drift, 16 mã từ chối) + `docs/evidence/W-0488/**`, chưa track · unittest 56/56; đỏ trước 50 test (20 fail, 5 error) · đột biến 29/29 bị bắt · `plan` trên ứng viên thật exit 0, đủ 7 mốc §2 + 6 mục quay lui §4, trạng thái BLOCKED_PENDING_INPUTS đúng · scan-pii PASS · Python 3.10 CHƯA CHẠY · CẦN QUYẾT: (1) `vm_deploy.py` chỉ quản 1 container, chưa quản project 3 dịch vụ `.64`; preflight đòi `.64 ari-secret.json` không có trong bảng bí mật; (2) chuyển giám sát T+65–80 hoãn vì `host_handoff.py` chỉ chạy lab; (3) khớp CLI/receipt với WP02A/02B; (4) thêm `.gitattributes` `deploy/production-window/** text eol=lf`; (5) ACK/media epoch T+80–90 Lead xác nhận tay
- 01/11 23:54 coder v2 (bị ngắt 1 lần do 429): ĐẠT · khớp CLI `db_provision.py` (thêm mã `MIGRATION_SQL_FORBIDDEN`, owner = `POSTGRES_USER`) và receipt `ivr-secret-provisioning-receipt/v1` (`SECRET_RECEIPT_INVALID`); `.64 ari-secret.json` 0:0 0400 kiểm trước preflight · unittest 66/66 trên Py 3.13 và Py 3.10.12 (container `ivr-monitor-systemd-lab`, không mạng) · đột biến 46/46 · plan-sample từ ứng viên thật + receipt lab đủ §2/§4 · scan-pii PASS
- 02/11 00:56 giao verifier (tiêu chí 1–7, container `m8-wp02c-v-`)
- 02/11 01:09 verifier lần 1: CẦN SỬA · 66/66 chạy lại (Py 3.13 + container Py 3.10); plan trên ứng viên thật đủ 7 mốc + R1–R6, BLOCKED 5 lý do đúng; verify 8 kiểu lỗi tự làm đều exit 1 · NẶNG: (1) kế hoạch không chép `public_acl_baseline.json` cùng `db_provision.py` → T+10–30 dừng; (2) `last_json` đọc sai JSON `indent=1` → `PASS_WITH_PENDING` (ca mặc định) bị chấm LỖI · VỪA: 15/15 đột biến tự chọn sống; dòng `test` trong kế hoạch im lặng khi sai; hash ghim lệch khi checkout CRLF · NHẸ: thiếu `s5-tls` vẫn ĐẠT
- 02/11 01:09 giao coder v3 sửa 6 điểm
- 02/11 01:43 coder v3: ĐẠT · ghim + chép `public_acl_baseline.json`; `last_json` đọc toàn văn; test cho 15 nhánh sống; khối lệnh `( set -e … )` + guard `DỪNG`; `TOOL_BYTES_NOT_LF`, kiểm Py ≥ 3.10; `prod-tls` LỖI khi thiếu `s5-tls` · đỏ-trước 11 hỏng · 88 OK Py 3.13 + Py 3.10 · đột biến 90/90 · guard 16/16 trên dash/bash/Git Bash · hash ghim khớp WP02A (`f9a58829…`/`fe29df64…`)
- 02/11 01:43 giao verifier lần 2 (lần cuối)
- 02/11 01:56 verifier lần 2: ĐẠT · 88/88 Py 3.13 + Py 3.10; 15/15 đột biến cũ đỏ, 14/15 mới (tổng 30/31); tái hiện 2 NẶNG đã sửa; ghim hash khớp tệp WP02A thật; dán khối F0/F2/F3 vào dash/bash 16/16 ca dừng đúng, không thoát phiên ssh · NHẸ: chưa có test giữ `channels_zero` '^0 active' (`:827-829`); README chưa dặn chạy tiếp sau khi khối DỪNG
- 02/11 01:56 phiên chính: bản vá `wp02c-cuaso.patch` (21 tệp, +5264, LF, trong phạm vi), apply --check OK; ghép cùng lượt với 02A/02B sau khi Lead trả lời (sổ work-register + gate-sweep chạy một lần)

- 02/11 09:05 Lead `ok gộp 02A 02B 02C` → phiên chính ghép: commit `00b90044` W-0488 · test: 88/88 Windows + 88/88 container Py 3.10; README công cụ đổi hash `db_provision.py` trích sang `4060bf84…`; README bằng chứng thêm `REAL_CUSTOMER_CALL_ALLOWED=NO` (luật C1) và ghi chú hash vòng 4 · gate-sweep 47/51, 4 FAIL có sẵn từ trước (document-links, progressive-selftest, selftest-pii, tts-provenance), không do ghép · detect_changes LOW · Sheet M8-002 đã ghi
## Bước kế tiếp chính xác
Đã ghép. Việc tiếp theo thuộc sóng 2 M8-002 (phiếu mới): `vm_deploy.py` quản project 3 dịch vụ `.64`, nợ test NHẸ của 3 gói, chuyển giám sát thật; chạy thật chờ m8.6 + anh Tuấn.

## Còn lại / CẦN QUYẾT
- Sóng sau: WP mới cho `vm_deploy.py` quản project 3 dịch vụ `.64` (ngoài phạm vi gói này) + chuyển giám sát thật.
- `.gitattributes`: phiên chính thêm một dòng LF cho `deploy/production-window/**` khi ghép (dòng mới, không đổi dòng cũ).
- Inventory thật của hai máy phải thu lại ngay trước cửa sổ (Lead chạy `host_audit.py`), cần sudo của anh Tuấn.
