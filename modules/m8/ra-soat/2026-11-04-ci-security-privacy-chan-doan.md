# Pipeline `main` đỏ ở `security_scan` và `pii_scan` — chẩn đoán (04/11)

Mốc 04/11/2026 23:10 UTC+7 · Sheet M8-002 · Lead báo: pipeline `4791030a` qua `test`, đỏ `security_scan` (stage security) và `pii_scan` (stage privacy); GitLab đang chạy `e5d5aa8c`.
Remote GitLab/GitHub = `e5d5aa8c` (push không qua phiên này). Hai stage này lần đầu được chạy tới từ 31/10: trước đó `validate` đỏ (W-0499 sửa).

## `security_scan` — dựng lại xong

Agent chạy nguyên văn `deploy/ci/scripts/security-scan.sh` trong `mcr.microsoft.com/dotnet/sdk:10.0.201`, clone đủ lịch sử, `CI_COMMIT_SHA=e5d5aa8c`: rc 1, **chỉ bước cuối đỏ**.

| Bước | rc | Ghi chú |
|---|---|---|
| tải gitleaks 8.30.0 + checksum | 0 | |
| `dotnet restore --locked-mode`, NuGet `--vulnerable` HIGH | 0 | 0 lỗ hổng; GHSA-p3jp chỉ ở runtime pack của image (đã sửa W-0499), không ở PackageReference |
| `npm audit --audit-level=high` | 0 | 0 |
| CT-CI-04, `allowlist-selftest.mjs` | 42 (đúng) / 0 | PASS |
| **`gitleaks git --log-opts=<SHA>`** (toàn lịch sử) | **1** | **2144 phát hiện**, đều rule `generic-api-key`, 87 tệp, 9 commit |

**Có sẵn**: `6d81e315` (28/10) sạch; `e464cd05` (30/10) có 1; `caaa8f65` (trước W-0497) có 2143. Kết quả tất định → `e5d5aa8c` cũng đỏ.

| Nhóm | Số | Nguồn |
|---|---|---|
| Dương tính giả: dòng manifest `"<đường dẫn có chữ secret/token/key/auth>": "<sha256>"` | 2137 | commit sóng 1–2 của **phiên m8** ngày 02/11 (`f14a6a25` 641, `17ef92fe` W-0495 604, `5fa00ccd` 596, `055b9a9f` 142, `1ef80eb2` 107, `a625d694` 48) + `caaa8f65` W-0496 4 |
| Dương tính giả khác: fixture test (tên container, idempotency key, mật khẩu giả), sha256 trong README | 6 | trong đó 1 ở `1bc8ee6d` (W-0497); W-0498/0499/0500 không thêm |
| **Bí mật thật**: `tools/task-tracker/sheet.json` (token Sheet) | 1 | `e464cd05` 30/10 "cài bộ theo dõi task Google Sheet (M12-001)"; `.gitleaks.toml`/`.gitleaksignore` không xử lý tệp này |

Phiên chính đã không chạy gitleaks trên khoảng commit khi ghép các sóng 02/11, nên 2137 dương tính giả lọt vào lịch sử mà không ai thấy cho tới khi `validate` xanh.

Đã thử trên checkout tạm: thêm 2143 fingerprint (`commit:file:rule:line`, đúng dạng 354 dòng đang có trong `.gitleaksignore`) thì chỉ còn 1 phát hiện (`sheet.json`).
Danh sách sinh sẵn từ báo cáo đã che: `C:\Projects\_wt\m8\ci-sec-job\_log\proposed-gitleaksignore-fp.txt`. Log: `ci-sec-job\_log\` (`e5d5aa8c\steps-rc.txt`, `B8-gitleaks-report.json` đã che, `verify-fix.log`).

Tiền lệ: m7 bỏ theo dõi `sheet.json` (giữ tệp ở máy) + `.gitignore` + mẫu rỗng (D-m7-022, D-m7-051), chưa xoay token, chưa miễn finding lịch sử. Token dùng chung 6 repo → xoay là việc liên luồng (phiên `lead`).

## `pii_scan` — đang tìm

- `selftest-pii.sh`: PASS. `scan-pii.sh docs/evidence` trên bản xuất sạch `e5d5aa8c`: `PII_SCAN_PASS files=2960` → đỏ nằm ở `ci-artifacts` (junit XML, coverage, api-matrix report của `build_test_dotnet`; schema-compat; globalization; openapi).
- Mẫu PII: số điện thoại 10 số (0/84/+84), từ địa chỉ (đường, số nhà, ngõ/hẻm/ngách, thôn/ấp/tổ), `dial_token`. Nghi tên test có tham số hoặc thân lỗi `FailureBodyFormat=Verbose` chứa dữ liệu mẫu.
- Log job in `tệp:dòng:[REDACTED]` (không lộ giá trị) → hỏi Lead dán (m8.39); không có thì dựng lại `build_test_dotnet` (dind + testcontainers, 30–60 phút, nặng RAM).

## Đề xuất (chưa áp dụng)

W-0501 (02G, R2: coder + verifier), ghép một lần, push lệnh riêng:
1. `.gitleaksignore`: thêm 2143 fingerprint dương tính giả; verifier kiểm từng nhóm đúng là sha256/fixture (không có giá trị thật nào bị miễn).
2. `sheet.json` theo m8.41.
3. Phòng tái phát: thêm vào thủ tục ghép của phiên m8 (`PHIEN.md`) bước `gitleaks git --log-opts=<cha>..<commit mới>` trước khi commit.
4. `pii_scan`: sửa theo kết quả m8.39 (tuỳ nguyên nhân: đổi dữ liệu mẫu trong test hoặc cách ghi junit; không nới mẫu PII).

## Cần Lead quyết

- m8.39 Dán đoạn cuối log job `pii_scan` (các dòng `ci-artifacts/...:<số>:[REDACTED]` + `PII_SCAN_FAIL`), hoặc để phiên này dựng lại `build_test_dotnet` local.
- m8.40 Làm W-0501 mục 1 + 3 (miễn 2143 dương tính giả bằng fingerprint, thêm bước gitleaks vào thủ tục ghép)? **Đề xuất: làm.**
- m8.41 `sheet.json`: **A** = làm như m7 (bỏ theo dõi, `.gitignore`, mẫu rỗng; giữ tệp ở máy) + fingerprint lịch sử `e464cd05` ghi "token cũ, chờ xoay" + hộp thư `lead` đề nghị xoay token chung 6 repo · **B** = chỉ thêm fingerprint, chấp nhận rủi ro. **Đề xuất A.**
