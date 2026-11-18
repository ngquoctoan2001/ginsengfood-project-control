# Đề xuất rút gọn CI ops-core (m12.c11, bản 2) — 16/11/2026

Người soạn: phiên phụ CI (m12). Trạng thái: **Toàn duyệt 16/11 ~11:20 (D-m12-078)**. `f1eb28bfc` (verifier ĐẠT) đã push 16/11 14:06; pipeline đầu tiên với cấu hình mới: #3072410182 (huỷ theo lệnh Toàn). **Kết quả: pipeline tay #3072542878 xanh trọn 13/13 job, 2 giờ 29 phút tới build-images (cũ ~4 giờ 20), 2 job chạy song song thật trên may-63.** Lúc làm: giữ preflight-summary và runtime-summary riêng (cổng ứng viên, test governance ghim tên); job gộp validate giữ tên `source-boundary`; bỏ ý cache NuGet/pnpm → 12 job trên .63.

Bản 2 theo ý Toàn ngày 16/11 11:00: giữ như pipeline hiện tại (mỗi push vẫn chạy đủ mọi kiểm tra), chỉ gộp hoặc bỏ job không cần thiết, và cho runner chạy 2 job cùng lúc. Thay bản 1 (hai tầng nhanh/đủ).

## 1. Hiện trạng

- Runner `may-63`: `concurrent = 1`, `limit = 1`, mỗi job 6 CPU / 16 GB. Runner dùng chung với CI của M8 (ivr).
- Mỗi push chạy 23 job trên .63, nối tiếp từng job một. Job JWT chạy trên runner SaaS, song song. Một pipeline mất khoảng **4 giờ 20**.
- Mỗi job tốn ~1 phút dựng: container, dind, clone đủ lịch sử, cài công cụ.
- Backend build lại 7 lần. Frontend chạy `pnpm install` 7 lần.

Thời gian đo được (phút): toolchain-preflight 1,3 · source-boundary 1,1 · migration-diff 1,1 · seed-collision 2,3 · pester-security-static 20,5 · backend-build 7,5 · frontend-build 2,8 / 1,7 / 1,8 · Unit ~10 · ApiContract ~50 · Integration ~76 · SchemaSmoke ~9 · Governance ~6 · openapi-contract ~5 · frontend-quality 12 / 1 / 2 · security-source-scanners 12,5 · security-powershell-scan 2,2 · database-runtime 14 · preflight-summary + runtime-summary 2 · build-images 19.

## 2. Xét từng job

| Job hiện tại | Cách xử lý | Lý do |
|---|---|---|
| toolchain-preflight | gộp vào `kiem-nguon` | chỉ in phiên bản công cụ, đứng riêng thì tốn 1 phút dựng |
| source-boundary, migration-diff, seed-collision | gộp vào `kiem-nguon` | mỗi job 1–2 phút, giữ nguyên lệnh và tệp bằng chứng |
| pester-security-static | giữ | 20 phút, chạy song song được |
| backend-build | gộp vào `backend` | build một lần, các bước test sau dùng lại bản build |
| backend-tests Unit, SchemaSmoke, Governance | gộp vào `backend` | mỗi lane tự build lại 4–5 phút, test thật chỉ 2–5 phút |
| openapi-contract | gộp vào `backend` | cần đúng bản build backend đó |
| backend-tests ApiContract, Integration | giữ, mỗi lane một job | hai lane dài nhất, cần chạy song song |
| frontend-build ×3, frontend-quality ×3 | gộp thành 1 job `frontend` | cài pnpm một lần, build và test cả 3 app |
| security-source-scanners, security-powershell-scan | giữ | cổng bảo mật, test và quyết định cũ ghim tên job |
| historical-jwt-source-receipt-preview | giữ nguyên | chạy SaaS, của Phien M12 (WP20) |
| database-runtime | giữ, chạy sớm hơn | trước đây chờ mọi job test xong mới chạy; nay chạy ngay sau `kiem-nguon` |
| preflight-summary, runtime-summary | gộp vào `tong-hop` | mỗi job 1 phút; vẫn ghi đủ 2 tệp tổng hợp cũ |
| build-images, deploy-99 | giữ | `deploy-99` vẫn bấm tay |
| 5 job ứng viên phát hành | giữ nguyên | chỉ chạy khi có cờ |

Kết quả: từ **23 job** trên .63 còn **11 job** (cộng job JWT chạy SaaS và `deploy-99` bấm tay). Không bỏ bộ test hay cổng bảo mật nào.

## 3. Thêm

- **Push mới thì huỷ pipeline push cũ đang chạy dở.** Đặt `interruptible: true` cho các job kiểm tra. `build-images`, `deploy-99` và job JWT giữ `false` để không bị cắt giữa chừng. Nhánh chú push 6 commit một ngày thì chỉ commit mới nhất chạy hết, không xếp hàng.
- **Cache cục bộ trên runner** cho gói NuGet và kho pnpm, khoá theo lockfile.
- **Runner `may-63` lên 2 job cùng lúc:** `concurrent = 2`, `limit = 2`, mỗi job 5 CPU / 12 GB.
  - Số CPU chỉ là mức trần, không giữ chỗ, nên lúc chỉ có một job thì job đó vẫn dùng được 5 nhân.
  - 2 job × 12 GB = 24 GB trên tổng 38 GB; M7 dev, stg_* và test M7 hiện dùng ~7 GB.
  - Lúc 11:04 ngày 16/11, tải trung bình ~9 trên 10 nhân khi đang chạy 1 job CI cộng test M7 (Testcontainers). Chạy 2 job thì mỗi job chậm hơn một chút, đổi lại tổng thời gian giảm mạnh.
  - Phiên hạ tầng `lead-nen-99` đổi cấu hình. Muốn trả về 1 job chỉ sửa một dòng.

## 4. Xếp lịch 2 job cùng lúc (ước tính)

| Phút | Ô 1 | Ô 2 |
|---|---|---|
| 0–4 | kiem-nguon | pester-security-static (0–20) |
| 4–76 | Integration | (pester tới 20) → ApiContract 20–67 |
| 67–91 | | backend (build một lần + Unit, SchemaSmoke, Governance, openapi) |
| 76–95 | frontend | |
| 91–106 | | security-source-scanners → security-powershell-scan |
| 95–109 | database-runtime | |
| 109–130 | tong-hop → build-images | |

Một pipeline: **khoảng 2 giờ 10 – 2 giờ 30** (cộng phần chậm khi 2 job tranh CPU), thay vì ~4 giờ 20. Đường dài nhất là Integration (~72 phút).

## 5. Không đổi

- Mọi push lên `main` vẫn chạy đủ mọi kiểm tra.
- Job JWT giữ nguyên: ở pipeline push vẫn đỏ `SELECTED_SHA_REQUIRED` như hôm nay, nên muốn có `build-images` và `deploy-99` vẫn phải chạy pipeline tay có `OPS10_JWT_SELECTED_SOURCE_SHA`. Muốn pipeline push xanh trọn thì phải đổi luật của job JWT. Đó là việc của Phien M12 (WP20), để quyết riêng sau.

## 6. Khối lượng

- Sửa `.gitlab-ci.yml`, `tools/ci/*` (2 script job gộp, danh sách job trong `New-CiGateSummary`). Sửa các test ghim tên job: M12CD01, OPS10.ScannerExecution, OPS0212, CI05… Runbook cũ chỉ thêm một dòng ghi chú.
- Cách làm như WP ci-linux-63: chạy trọn trên .63 bằng công cụ thử, verifier kiểm độc lập (R2), commit cục bộ. Push hỏi Toàn riêng.
- Nhắn `lead-nen-99` đổi cấu hình runner; báo phiên M8, vì CI M8 dùng chung runner nên cũng được 2 job cùng lúc.
- Ước tính ~1 ngày làm, cộng ~3 giờ máy .63 để chạy thử.
