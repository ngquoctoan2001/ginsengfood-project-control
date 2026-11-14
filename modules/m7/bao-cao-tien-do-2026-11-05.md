# Báo cáo tiến độ M7 — 05/11/2026 (chốt lúc 20:17, cập nhật 06/11/2026 01:35)

Luồng `m7` (M7 Video Giờ Vàng), repo `C:\Projects\ginsengfood-golden-hour-video`, nhánh `main`.

## 1. Tóm tắt

- Hôm nay có **8 commit** lên `main`. 4 commit đầu đã lên origin (origin dừng ở `9c6b15f`). **4 commit chưa push:** `6084eb0` (WP21), `e7f7b3e` (T052), `0ae4ba4` (T078), `23961bb` (T015); chờ bạn bảo push.
- **1 task đang dở:** T011 (T015 xong 21:25, T078 xong lúc 21:01). Coder T011 và verifier T015 dừng lúc khoảng 20:15 vì hạn mức; 20:24 đã nhắn làm tiếp (nếu còn hạn mức thì chạy, không thì tiếp sau 00:10 ngày 06/11). Không commit gì chưa qua verifier.
- **Chạy thật 15/11: ĐỎ.** % sẵn sàng chưa tính lại theo thang chung; để tính ở `/cuoi-phien`. Sheet ghi 21/181 task M7 Hoàn thành (số trong `TRANG_THAI.md`).

## 2. Đã xong hôm nay (đã commit trên `main`)

| Commit | Giờ | Task | Nội dung | Kiểm độc lập | Sheet | Push |
|---|---|---|---|---|---|---|
| `41196fd` | 02:48 | M7-T047 | Migration `_L10_StudioRun`: 10 bảng lượt Studio, worker, nhà cung cấp, job, tài sản video | R2 ĐẠT | M7-053 Hoàn thành + Đạt | đã push |
| `73980ce` | 03:42 | M7-T022 | Engine guard: dữ liệu hoá, chuẩn hoá tiếng Việt, tách câu, phủ định theo mệnh đề, corpus guard | R2 ĐẠT (6 vòng) | M7-028 Hoàn thành + Đạt | đã push |
| `c17722e` | 04:34 | M7-T009 | Kho tệp qua port `IFileStore`, adapter `FileSystemFileStore` cho dev, test | R2 ĐẠT (5 vòng) | M7-015 Hoàn thành + Đạt | đã push |
| `9c6b15f` | 10:49 | M7-T016 | Web Next.js: khung, đăng nhập qua BFF, client sinh từ OpenAPI, trang đầu | R2 ĐẠT (2 vòng) | M7-022 Hoàn thành + Đạt | đã push |
| `6084eb0` | 15:29 | M7-WP21 (+ T092) | Áp duyệt thiết kế L12 và quyết định 05/11 vào tài liệu, DL-221…DL-266 (27 tệp) | R1 ĐẠT (3 vòng) | M7-196, M7-098 Hoàn thành + Đạt | **chưa** |
| `e7f7b3e` | 17:28 | M7-T052 | Động cơ lượt và bước Studio: máy trạng thái, lease bước, chạy bước mock ở server, làm lại một bước (37 tệp) | R2 ĐẠT (2 vòng) | M7-058 Hoàn thành + Đạt | **chưa** |
| `0ae4ba4` | 21:01 | M7-T078 | Migration `_L11_ShortVideo`: 5 bảng video ngắn, 40 CHECK, trigger chuyển cấm, quyền, 34 chỉ mục có EXPLAIN, hạt giống 3 loại + 3 mẫu prompt (44 tệp) | R2 ĐẠT (2 vòng) | M7-084 Hoàn thành + Đạt | **chưa** |
| `23961bb` | 21:25 | M7-T015 | Metric OTLP, ảnh container không root, compose `m7` qua edge TLS, proxy tin cậy, dừng gọn trả lease cả bước Studio (45 tệp) | R2 ĐẠT (2 vòng); kiểm khói 20/20 | M7-021 Hoàn thành + Đạt | **chưa** |

## 3. Đang dở (chưa commit)

| Task | Rủi ro | Đã tới đâu | Còn lại | Bằng chứng |
|---|---|---|---|---|
| **M7-T011** audit chuỗi HMAC, job kiểm chuỗi, API audit (Sheet M7-017) | R3 | Verifier R3 vòng 3 trả CẦN SỬA: 1 lỗi phải sửa (test T052 dựng worker thiếu khoá audit sau khi ghép) và 4 điểm nên sửa. Coder vòng 4 xong lúc 20:49: sửa đủ 1 PHẢI SỬA + 4 NÊN SỬA, Integration 2261/2261, đột biến 9/9 đỏ. Verifier R3 vòng 4 **ĐẠT** (21:12); coder vòng 5 ghép xong lên `23961bb`; **verifier R3 vòng 5 ĐẠT** (06/11 01:34). Chỉ còn chờ bạn "ok gộp". | Verifier R3 → trình bạn diff + 12 câu (D-m7-059) → bạn nói "ok gộp" → commit | `ra-soat/2026-11-04-t011/` (`verifier/R3-vong3.md`, `vong4/`) |

**Cách chạy tiếp:** sau 00:10 ngày 06/11, bạn gõ "tiếp". Phiên sẽ nhắn từng agent làm tiếp từ chỗ dừng (không mở agent mới, không mất phần đã làm).

## 4. Chưa làm (để nguyên)

- **Thứ tự kế tiếp:** T079 sau T078; T073 API lượt Studio sau T052; T008 (R3) và T012 sau T011; T013 sau T008; T050 sau T013; T054.
- **Cùng chờ:** T023, T024, T034.
- **Gói tài liệu kế:** áp m7.93–m7.98 nếu bạn duyệt; sửa SAD §9.7 (còn ghi X-Forwarded-For); sửa `api-schemas.md` dòng 396 (`csrf_token` rỗng khi không HTTPS).

## 5. Cần bạn quyết

| Mã | Việc | Đề xuất |
|---|---|---|
| m7.93 | Lấy mẫu kiểm sha256 kho tệp T009 chưa có task nhận | Giao M7-T153 |
| m7.94 | Audit từng chuyển trạng thái lượt, bước Studio chưa có task nhận | Thêm vào "Xong khi" của M7-T073; T073 phụ thuộc thêm T011 |
| m7.95 | Kiểm adapter tắt lúc nhận bước | Đưa vào M7-T054 |
| m7.96 | Trần `SERVER` theo loại bước + `studio.starvation_minutes` đang gán nhầm T055 | Chuyển sang M7-T054 |
| m7.97 | Đường prompt `TREND_SYNTHESIZE` | Giữ cách WP21 (`TREND_SYNTHESIZE/TREND_SYNTHESIZE`) |
| m7.98 | Rà soát task hạng C (tài liệu, test thuần) | A: review = R1 (verifier đọc nhanh) |
| m7.99 | T015 không tạo được `deploy/compose/.env.example` (luật chặn `.env*`) | A: không tạo tệp mẫu; biến ghi ở env-reference + RU-19 |
| m7.100 | Chứng chỉ bền cho `m7-edge` trên .60 | Dev dùng chứng chỉ tự ký; chứng chỉ .60 chuyển phiên lead |
| m7.101 | Web chuyển `X-Forwarded-Proto` ở lời gọi `/me` phía máy chủ | B: web không chuyển header này |
| m7.102 | T078: hai khoá `short_video.*` có `is_sensitive` không | `false` |
| m7.103 | T078: hai khoá ngoại tới `short_video_id` đang để `NOT VALID` | `VALIDATE` ở migration M7-T039 |
| m7.104 | Worker dừng thì runner bước Studio (T052) không trả lease | Đã xử lý: sửa luôn ở T015 vòng 4 theo FR-OPS-009, không cần quyết |
| — | Push 4 commit `6084eb0`, `e7f7b3e`, `0ae4ba4`, `23961bb` lên origin | Chờ bạn bảo |
| — | Xoá container `recursing_chaplygin` do verifier T011 để sót | Chờ bạn cho phép |
| — | T011: "ok gộp" + 12 câu (D-m7-059) | Verifier R3 vòng 5 ĐẠT trên main hiện tại; bản trình ở `ra-soat/2026-11-04-t011/trinh-anh-toan.md` |

## 6. Máy và dọn dẹp

- **RAM:** đã ghi `C:\Users\Administrator\.wslconfig` (`memory=12GB`, `autoMemoryReclaim=dropcache`) và khởi động lại WSL, Docker lúc 20:25–20:37 (khi GitLab runner yên). WSL nay giới hạn 12 GB, vmmemWSL 4,0 GB, Windows trống 11,7 GB (trước 2,4 GB).
- Đã bật lại đủ 8 container của phiên khác: `m9review-redis`, `m9review-pg`, `wp09-*` (5), `ginsengfood-postgres-local`. `recursing_chaplygin` đã dừng, chưa xoá (chờ bạn).
- **Clone làm việc:** đã xoá clone T078, T015 (đã commit). Còn `C:\Projects\_wt\m7\code-T011`, `kiem-T011`, giữ tới khi T011 commit.

Sổ chi tiết: `modules/m7/TRANG_THAI.md`, `modules/m7/wp/M7-WP07.md`, `M7-WP10.md`, `M7-WP11.md`, `M7-WP21.md`, `modules/m7/nhat-ky/2026-11-05.md`.
