# M8-WP07V — Hoàn tất bộ giọng đọc và chuỗi artifact được duyệt

Trạng thái: CHẶN · Rủi ro: R3 · Chế độ: A · Mốc: 06–07/11 cần đầu vào; trước đóng ứng viên và C 12/11
Hạng mục nâng: Giọng đọc 50 → 75/90 chỉ khi thử trên máy và người có thẩm quyền duyệt đúng bộ · Sheet: M8-004 · Làn: L1
Ước lượng: 10 giờ công AI (5 coder + 2 tester độc lập + 3 verifier; thời gian người nghe riêng); dự toán, chưa phải cam kết thời gian chờ ngoài.
Chỗ làm: dự kiến `C:\Projects\_wt\m8\m8-wp07v` (chưa tạo) · Base khảo sát: `c9f0cd188f4966d07aafb3155039656b1b451034`.
Chỗ kiểm: bản sao/checkout cố định của đúng bộ byte; không build trên checkout đang có coder sửa. Trước /song kiểm lại HEAD và phạm vi.

## Brief

1. Repo: `C:\Projects\ginsengfood-ivr`, chỉ `main`; phiên chính chuẩn bị bản sao git archive, không worktree/nhánh mới.
2. Mục tiêu: Hoàn tất bộ giọng đọc và chuỗi artifact được duyệt. Tiêu chí đạt:
   - 1. Nguồn phê duyệt đúng người/scope/phiên bản cho ba giọng; giữ phân biệt builder review và chữ ký Chú.
   - 2. Kho artifact mới verify byte và phục hồi offline; re-pin URI/digest/chain đúng nguồn, không biến mirror .61 thành approved bằng đổi cờ.
   - 3. Đóng mọi lệch tên/clip từ WP04A bằng sửa hoặc quyết định rõ của chủ sản phẩm, giữ mapping version. Render nội dung đã duyệt; kiểm text/PCM/hash/mối nối và phiếu nghe đúng bộ; không tự ACCEPTED.
   - 4. Kiểm đường approval script-version trong phần mềm với quyền/actor đúng: creator không tự duyệt; CONTENT và PRIVACY_LEGAL khác actor theo src/Ivr.Domain/Scripts/ScriptContentContracts.cs:237-254; không tạo actor giả thay phê duyệt thật. Kiểm âm provenance/acceptance tiếp tục từ chối thiếu/sai chữ ký/binding/mirror.
   - 5. Mốc 07V-L: artifact xử lý đầy đủ, có phê duyệt để đóng candidate, vẫn bậc 50. Sau 07B-L, playback đúng candidate trên môi trường đích, ghi served image/voice manifest, ca mối nối, actor/nghiệm thu để chấm 75/90. 07B-L chỉ phụ thuộc 07V-L, không đợi toàn WP07V ĐẠT.
3. Phạm vi ghi: deploy/tts/models/MODELS.lock; voice approval/binding và recipe render có kiểm; artifact/evidence mới, không ghi đè bộ niêm phong.
   Tệp nóng: MODELS.lock, approval binding, audio manifest/image hashes chỉ WP07V ghi; chạy trước WP07B, mọi đổi sau freeze làm candidate mất hiệu lực.
   Cấm: secret thật, .env*, sheet.json, OpenAPI/baseline/hash niêm phong ngoài scope; không commit/push/merge/PR/deploy hoặc đổi cờ production.
4. Đọc trước: MODELS.lock:10-28; docs/evidence/W-0122 (đoạn lịch sử phải đối chiếu lock hiện tại); W-0340 mirror-target-findings; WP04A.
   Thêm `AGENTS.md`, `CLAUDE.md` repo; `modules/m8/PHIEN.md`, `SAN_SANG.md`, bản rà `ra-soat/2026-11-02-ke-hoach-m8.md`.
5. Lệnh kiểm/phạm vi được dự kiến cho /song: Các selftest TTS provenance, voice acceptance, fixed render, container/Helm liên quan; Linux lab bằng artifact đã cho phép, không bật dịch vụ production.
   Lượt /ke-hoach CHƯA chạy các lệnh này. Runtime/công cụ cũ giữ nguyên; dependency chỉ cài trong nơi cô lập khi brief /song cho phép.
6. Bằng chứng: SHA nguồn + image/tool/artifact hash thích hợp, môi trường, lệnh, số pass/fail/skip, kiểm âm/đột biến, phạm vi thiếu; không dữ liệu/giá trị bí mật.
   R2: test đỏ trước → coder → verifier độc lập. R3: thêm tester độc lập và Lead duyệt diff trước ghép. Không tự ký nghiệm thu hay gọi test lab là production.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Parent giữ tracker/W-ID/generated files và tích hợp tuần tự; tối đa 3 agent nặng.
   GitNexus index lúc khảo sát stale `00b9004`, query thiếu FTS: trước sửa symbol parent xử lý index/impact theo luật repo; không scout tự analyze.
8. Đầu ra ≤25 dòng: đạt/chưa xong/chặn, tệp đổi, bằng chứng, việc còn lại/tệp xung đột; tracker và commit để phiên chính.

## Phụ thuộc và ranh giới

WP04A; Chú duyệt lời thoại và ký/ủy quyền VieNeu; kho artifact production được Chú cấp. .61 làm kho khóa lab không đóng các gate này.
D-m8-010: .61 chỉ là kho tạm LAB, không chặn code/lab; custody production vẫn chốt trước cấp production/release.
D-m8-008: phần M3 do phiên m34 tự xử lý; m8 chỉ đọc để biết, không giao việc hoặc soạn/gửi hợp đồng cho M3.
Rủi ro/ước lượng phải đánh giá lại khi tái hiện lỗi, scope hoặc HEAD thay đổi; phát hiện thiếu quyền thì làm tiếp phần lab độc lập.

## Diễn biến

- 02/11 /ke-hoach: tạo phiếu từ 3 scout chỉ đọc và đối chiếu nguồn; chưa giao coder, chưa tạo bản sao, chưa chạy test/host.

## Bước kế tiếp chính xác

Chờ đúng đầu vào; chưa tự tạo văn bản phê duyệt. Nếu trễ 07/11 phải dời freeze/retest, không gán test bộ cũ cho bộ mới.
