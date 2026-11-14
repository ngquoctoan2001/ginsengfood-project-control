# M8-WP04B — Làm nóng tên phường/xã và gói duyệt cho Chú

Trạng thái: ĐANG LÀM (đã ghép local `16135c72`, chờ push) · Rủi ro: R2 · Chế độ: A · Mốc: 11/11 (chạy máy đêm 10–11/11)
Hạng mục nâng: Giọng đọc, lời thoại 3 miền, tên địa bàn — giữ 50 (lên 75 khi kho trên .61 đủ và phát thử qua .64) · Sheet: M8-004 · Ước lượng: 12 giờ
Chỗ làm: `C:\Projects\_wt\m8\M8-WP04B` (bản sao archive, repo tạm commit `goc` f437d4e) · Base SHA: `005bc43d` · Chỗ kiểm: cùng bản sao
Quyết định: D-m8-071 (m8.63: làm nóng đủ 3.321 phường/xã × 3 miền trên .61, chạy ngoài giờ), D-m8-012 (nguồn địa bàn M3 ghim tại M8).

## Brief
1. Repo · thư mục: bản sao archive của `ginsengfood-ivr` @ `005bc43d` tại `C:\Projects\_wt\m8\M8-WP04B` (repo tạm có commit `goc`; KHÔNG commit thêm).
   Repo gốc `C:\Projects\ginsengfood-ivr` chỉ đọc.
2. Mục tiêu:
   a) Công cụ tạo danh sách làm nóng từ nguồn địa bàn M8 đã ghim (3.321 phường/xã, mã nội bộ M3) ra đúng định dạng JSON của `Ivr.Ops phrases-request`
      (`tools/Ivr.Ops/README.md`, mục kho clip tự bổ sung) cho đủ 3 miền/giọng; chia lô (vd. 300 cụm/lô) để chạy đêm, dừng/tiếp được; chữ của cụm giao hàng
      lấy đúng theo hàm tạo trong `src/` (không tự soạn chữ), kiểm bằng mẫu đối chiếu với hàm đó.
   b) Runbook chạy trên .61 (project `m8`): container nào có `Ivr.Ops`, lệnh `phrases-request` theo lô; worker `SpeechPhraseJobHost` có chạy khi
      `Ivr__Scheduler__Enabled=false` không (nếu bị tắt theo → ghi `CẦN QUYẾT`, không tự đổi compose); theo dõi tiến độ (READY/PENDING/FAILED/`qa_rejected`
      bằng `phrases-list` hoặc SQL chỉ đọc); ước giờ máy theo trung vị 1,9 s/cụm; dừng an toàn; đơn sống luôn đi trước pre-warm; ghi `docker stats` định kỳ.
   c) Gói duyệt cho Chú: 455 tên chờ duyệt (`deploy/tts/ward-review/`) + danh sách lời thoại 3 miền hiện hành, xuất một tệp dễ đọc (markdown hoặc CSV)
      có cột quyết định; không đổi trạng thái duyệt nào.
   Tiêu chí đạt: test viết đỏ trước rồi xanh cho (a): đủ 3.321 × 3 miền, không trùng, chữ khớp hàm `src/` trên mẫu, chia lô đúng, đếm đúng; dry-run in số cụm và ước giờ;
   `python -B -X utf8 -m unittest` vùng mới đạt (ghi số). Chạy `scan-pii.sh` trên tệp mới trong container Linux; nếu mẫu địa chỉ khớp tên hành chính
   (vd. "thôn", "tổ") thì ghi rõ và để phiên chính quyết, không né mẫu.
3. Phạm vi ghi: `deploy/tts/lam-nong/**` (mới), `deploy/tts/ward-review/**` (chỉ thêm tệp xuất gói duyệt, không sửa tệp cũ), `deploy/tts/README.md` (một mục),
   `docs/evidence/W-PENDING-04B/**`. Cấm: `deploy/tts/models/MODELS.lock`, `deploy/m8/**`, `src/**` (chỉ đọc), bank audio, `docs/release/*`, `.gitleaks*`.
4. Đọc trước: `CLAUDE.md`, `AGENTS.md`; `deploy/tts/README.md` mục "Kho clip tự bổ sung"; `tools/Ivr.Ops/README.md` (phrases-*); nơi tạo cụm giao hàng trong `src/`
   (grep `giao đến`, `Delivery`); nguồn địa bàn (grep trong `deploy/tts`, `src/Ivr.Domain`); `deploy/m8/compose.yml` (phrase-tts, worker, ops-agent);
   `C:\Projects\Project Control\modules\m8\ra-soat\2026-11-09-tts-ha-tang.md`.
5. Được chạy: python, node nếu có sẵn; `dotnet build`/`run` chỉ khi thật cần đọc tham số `phrases-request` mà mã nguồn không đủ rõ (tránh). KHÔNG: chạy VieNeu/TTS thật,
   docker nặng, ssh/scp, gọi .60/.61/.64, sheet-sync, cấp W-ID, sửa repo gốc. Dừng nếu RAM trống < 4 GB.
6. Bằng chứng: `docs/evidence/W-PENDING-04B/README.md` (lệnh + số, số cụm, ước giờ máy, giới hạn, CHƯA CHẠY trên host); không lập MANIFEST.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra: tin nhắn cuối ≤ 25 dòng theo LUAT_SUBAGENT mục 10.

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- 10/11 10:37 giao coder v1.
- 10/11 11:45 coder v1: ĐẠT phần local · mới `deploy/tts/lam-nong/` (cum_giao, lam_nong, goi_duyet, 2 test, README, RUNBOOK-61), gói `ward-review/goi-duyet-chu-2026-11-10.md`, README tts +1 mục · 3.321 phường → 3.318 cụm (Bắc 1.368, Trung 1.096, Nam 854; 3 tên M3 bị `src/` từ chối: mã 00378, 00533, 00555), 12 lô × 300, ~1,75 giờ máy; unittest 50/50, ward-review cũ 80/80, đột biến 17/17; PII evidence PASS. Phiên chính chốt: giữ 3.318 cụm (mỗi phường đúng giọng miền của tỉnh); làm nóng ngay không chờ Chú; 2 tên xã thật có chữ "Đường" trong gói duyệt và 3 ca giả trong test để nguyên (ngoài vùng CI quét); báo 3 tên lỗi cho m34; .61 chưa có Ivr.Ops → chọn A: CI dựng + đẩy image `ivr-ops` (coder v2).

- 10/11 12:10 coder v2: ĐẠT · CI `publish_images` dựng/quét/đẩy `ivr-ops` (`deploy/ci/cd.gitlab-ci.yml`), `cd-selftest.mjs` thêm kiểm, `pre-push-scan.sh` thêm image, RUNBOOK-61 mục 2a/3/4 · cd/ci-config/docs selftest PASS, gate-sweep --list 51/41, đột biến CI 6/6, runbook 31/31, dựng `Dockerfile.ops` 67 MB `USER 1654`, trivy HIGH/CRITICAL 0, PII 6/6, làm nóng 50/50. Còn: `deploy/ci/README.md` dòng 79/281 liệt kê image cũ (phiên chính sửa khi ghép); làm nóng cần bản có `ivr-ops` trên .61.
- 10/11 12:29 verifier R2: CẦN SỬA · (1) trung bình `RUNBOOK-61.md:160` vòng nạp lô không `pipefail` → lô hỏng vẫn đánh dấu đã nạp (thử thật với `ops` giả); (2) thấp `test_lam_nong.py:313` không giữ cỡ lô 300 · còn lại đạt: harness C# trên `src/` 3.318/3.321 khớp 0 lệch, 12 lô đọc bằng `JsonOptions` Ivr.Ops, gói duyệt sinh lại khớp byte, CI dựng→trivy→đẩy, CRLF giữ nguyên, PII evidence 17 tệp PASS, phạm vi đúng; 50 + 80 test, 3 selftest PASS; đột biến 9/10. Lưu ý: clip chỉ dùng được khi M3 gửi "phường X, tỉnh Y"; M3 hiện gửi chỉ tên tỉnh → việc m34 (qua 01B). Giao coder v3 sửa (1)(2) + `deploy/ci/README.md` dòng 79/281.
- 10/11 12:50 coder v3: ĐẠT · RUNBOOK-61 mục 5 chỉ đánh dấu `.da-nap` khi `ops` thoát 0 và `requested` = `count` lô (đọc bằng `awk`), hỏng ghi `HONG` rồi `break`; `test_runbook.py` mới (18 test, chạy bash thật với `ops`/`q`/`docker` giả; đỏ 6/18 trên runbook cũ); `batch_size` 300 được giữ; `deploy/ci/README.md` thêm `ivr-ops` (2 dòng, CRLF giữ) · lam-nong 68/68, ward-review 80, docs/cd/ci-config selftest PASS, PII evidence 23 tệp PASS, đột biến 8/8. Còn: `deploy/m8/README.md:170` danh sách image cũ → phiên chính sửa khi ghép (tệp của 01B). Giao verifier kiểm lại.
- 10/11 13:08 verifier R2 vòng 3: ĐẠT (runbook mục 5 bash Linux 14/14, `awk` đọc count đúng 3.318, đột biến 6/6, 68 + 80 test, 3 selftest PASS; lưu ý thấp: `awk` dựa thứ tự khoá `file`→`count`). Ghép W-0520 trên checkout chính (chưa commit): bản vá áp sạch, 5 tệp sửa `cmp` khớp; bằng chứng → `docs/evidence/W-0520` + `verifier-r2.md`; `deploy/m8/README.md` thêm `ivr-ops`. Hai lỗi chỉ lộ trên Windows: (1) tệp mới `lam-nong/` CRLF → thêm `deploy/tts/lam-nong/.gitattributes` LF; (2) `goi_duyet.py` băm byte trên đĩa của kế hoạch W-0457 (hash gói `fc41ebe1…` ở bản sao, đúng là `9b63cf12…` của byte commit) → bỏ CR trước khi băm, sinh lại gói (chỉ dòng hash đổi). Sau sửa 68/68 + 80/80, gate-status PASS; đang chạy `deploy/m8/tests`.
- 10/11 13:16 ghép xong local: W-0520 = `fa8b4a89` + `16135c72` (sửa một câu bằng chứng khớp mẫu địa chỉ "đường"). `deploy/m8/tests` 88 OK; clone Linux: MANIFEST khớp, lam-nong 68 + ward-review OK, PII `docs/evidence` 3.257 tệp PASS, gitleaks `005bc43d..HEAD` 0; tracker M8-004 đã ghi. `pre-push-scan.sh` đang chạy (bỏ 3 image phụ không đổi đầu vào).
- 10/11 14:00 Lead duyệt push + deploy; `main` GitLab + GitHub = `16135c72`; pipeline `3048379552` đang dựng `ivr-ops`.

## Bước kế tiếp chính xác
pre-push-scan xong → trình Lead push `main` (W-0519 + W-0520) lên GitLab + GitHub → pipeline dựng `ivr-ops` → deploy SHA mới lên .61 (02H) → rồi phiên chính chạy lô làm nóng trên .61 tối 10/11 theo runbook.

## Còn lại / CẦN QUYẾT
- Gửi gói duyệt cho Chú: Lead gửi (tin nháp do phiên chính soạn).
