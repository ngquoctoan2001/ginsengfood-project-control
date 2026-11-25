# WP17b phần MÃ: phạm vi còn thiếu (scout 24/11 18:5x, ops-core `417f15d53`)

Scout chỉ đọc, chưa chạy test, không đọc `.env`, không ssh. Mọi thứ trên `.99` là CHƯA KIỂM. `deploy/m12/**` chưa ai sửa từ 16/11 (`13f4ecdd9`).

| Mục | Trạng thái | Việc | Ai/làn |
|---|---|---|---|
| OPS-03 `extra_hosts` | THIẾU | thêm `ops.ginsengfood.vn:${M12_FRONT_PROXY_IP:-192.168.1.98}` cho `ops-core-api`, không dùng `-k` | coder làn compose (giao 24/11 18:5x) |
| OPS-07 `M12_PUBLIC_TRACE_PROXY_SECRET` | THIẾU (`:-` rỗng ở compose.yml:158, :304) | đổi `:?` + sửa mọi chỗ ghim (M12CD02 E-05, ComposeSamples, 2 smoke, kiem-dien-tap) | làn compose |
| OPS-04 tên DB | MỘT PHẦN (mặc định `ginsengfood_operational`, `.99` `.env` đã đúng từ 20/11) | đổi mặc định + ca kiểm tĩnh | làn compose |
| `NEXT_PUBLIC_TRACE_MEDIA_ORIGINS` | THIẾU: `build-args.61.json` vẫn `""` (D-m12-106 chưa làm), 2 lượt build tay 21/11 và 23/11 dùng tệp này ⇒ **trang truy xuất công khai trên `.99` có thể đang ẩn ảnh/video bằng chứng** | đặt `https://trace.ginsengfood.vn`; BUILD LẠI ảnh `public-trace` và đưa lên `.99` là việc cần lệnh Toàn | làn compose (mã) + Toàn (build/lên) |
| SECR-02/OPS-05 cổng JWT sau 30/11 16:59Z | THIẾU | thêm mắt xích `REVOKED_BY_KEY_ROTATION` (trước hạn y nguyên, sau hạn đòi hồ sơ xoay khoá); hồ sơ thật cần lời Toàn xác nhận khoá mới khác khoá lịch sử | coder làn JWT (giao 24/11 18:5x) |
| OPS-01 kho bằng chứng (P0, R3) | THIẾU: validator `EvidenceStorageOptionsValidator.cs:151-164` đòi tổng số/băm khớp attestation; không có bước sinh attestation trong repo ⇒ bật Production là API không lên/không upload được | **chờ Toàn: m12.207** (A nới thành "quét sạch": plaintext 0, malformed 0, unreadable 0, đề xuất · B CLI trong image · C giữ quy trình tay) | chưa giao |
| OPS-02 `CAU_HINH.sha256` | MỘT PHẦN | KHÔNG làm đợt này; dùng `sha256sum` trong runbook cutover | bỏ |
| Cờ tắt khẩn (c) | MỘT PHẦN, ưu tiên thấp | `.env` + recreate vẫn tắt được; không làm trước 25/11 | bỏ |

Đã làm, đừng làm lại: SEC-19 (`77cd91d93`), XFF `:?`, cổng web 127.0.0.1, đệm webhook, allowlist `/v1`, WP17 Production (`e3fac2b2b`), DB sạch (`9716c515d`), đường CI rút gọn `18107a811`.
Phát hiện thêm: pipeline `M12_FAST_DEPLOY=true` bỏ job JWT (`.gitlab-ci.yml:714-715`) nên "hotfix không ra image" của OPS-05 đã nhẹ hơn; đường rút gọn chưa thấy chạy thật trong sổ (**CHƯA CHẠY**).

Rủi ro khi chép compose lên `.99` (SEC-19, chưa chạy container thật): `pg-ops` `read_only` làm `trien-khai.sh` bước [2/5] hỏng nếu `daily-backup.py` ghi `/tmp` ⇒ đọc `sao-luu/daily-backup.py` + chạy tay một lần sao lưu trước; 4 upload video song song có thể OOM (chưa đo); `migrate` `read_only` chưa thử.

Việc cần Toàn nói rõ (không coder nào làm): duyệt diff R3 (OPS-01, cổng JWT) trước commit; ký hồ sơ đóng ngoại lệ JWT; push; build lại `public-trace` rồi `docker save | ssh`; ssh `.99` chép compose + Caddyfile + trien-khai.sh, recreate; 5 file secret (JWT mới) + `M12_SECRETS_VERSION`; `.env` (`M12_OUTBOX_WEBHOOK_URL`, `M12_EVIDENCE_INVENTORY_SHA256`, `M12_SOURCE_ALLOWLIST_*`, `M12_FRONT_PROXY_CIDR`, `M12_PUBLIC_TRACE_PROXY_SECRET`); đếm bản rõ trong `du-lieu/api-var`.
Phiên lead (không phải m12): proxy và chứng chỉ `.98`.
