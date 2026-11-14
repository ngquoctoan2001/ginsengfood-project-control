# M8-WP04A — Đối chiếu tên địa bàn và chuẩn bị bộ lời thoại để duyệt

Trạng thái: ĐẠT nguồn/công cụ; đã commit local, nội dung/audio còn chờ · Rủi ro: R2 · Chế độ: A · Mốc: 04/11 gói đối chiếu; cần Chú duyệt nội dung trước 06/11
Hạng mục nâng: Giọng đọc 50 → 50 (chuẩn bị nghiệm thu có phiên bản) · Sheet: M8-004 · Làn: L1
Ước lượng: 10 giờ công AI (6 coder + 4 verifier; chưa gồm thời gian người nghe); dự toán, chưa phải cam kết thời gian chờ ngoài.
Chỗ làm: `C:\Projects\_wt\m8\m8-wp04a` · Base sóng 1: `c9f0cd188f4966d07aafb3155039656b1b451034`.
Chỗ kiểm: bản sao/checkout cố định của đúng bộ byte; không build trên checkout đang có coder sửa. Trước /song kiểm lại HEAD và phạm vi.

## Brief

1. Repo: `C:\Projects\ginsengfood-ivr`, chỉ `main`; phiên chính chuẩn bị bản sao git archive, không worktree/nhánh mới.
2. Mục tiêu: Đối chiếu tên địa bàn và chuẩn bị bộ lời thoại để duyệt. Tiêu chí đạt:
   - 1. Đối chiếu đủ 3.321 tên với nguồn hành chính chính thức đúng phiên bản, có URL/ngày/hash và bảng thiếu/trùng/lệch; không chỉ dựa số lượng WAV.
   - 2. Mỗi khác biệt có kết luận hoặc mục chờ chủ sản phẩm; giữ nguyên receipt 92 mẫu đã duyệt, không coi 92 mẫu thay toàn danh mục.
   - 3. Gói duyệt gồm text/lời thoại 3 miền, phiên bản, danh sách cần nghe và ca nối tên/tiền/đơn; tệp mới, chưa tự gửi cho Chú.
   - 4. Kiểm tự động tính đầy đủ, normalization/mapping và PCM/hash khi có clip mới; verifier chọn ca lệch và đối chứng, không tự ký nội dung.
3. Phạm vi ghi: Công cụ/báo cáo đối chiếu tên mới dưới deploy/tts/ và docs/evidence/<WP>/; dữ liệu tham chiếu công khai đã ghim nguồn. Chỉ sửa render-fixed-speech/speech catalog khi chỉ rõ lỗi và impact; không viết lại TTS lõi.
   Tệp nóng: Không ghi MODELS.lock, voice acceptance binding, WAV/manifest niêm phong hoặc runtime pack trong WP này.
   Cấm: secret thật, .env*, sheet.json, OpenAPI/baseline/hash niêm phong ngoài scope; không commit/push/merge/PR/deploy hoặc đổi cờ production.
4. Đọc trước: docs/evidence/l26-listening-20261020/README.md:3-19; docs/evidence/W-0484/README.md:9-15; deploy/ci/scripts/render-fixed-speech.mjs; deploy/lab/speech-segments.json; deploy/tts/shim/voices.json (chỉ đọc tại 04A); tests/Ivr.IntegrationTests/Speech/SpeechPhrasePipelineTests.cs; release-final README:37-38,66-68.
   Thêm `AGENTS.md`, `CLAUDE.md` repo; `modules/m8/PHIEN.md`, `SAN_SANG.md`, bản rà `ra-soat/2026-11-02-ke-hoach-m8.md`.
5. Lệnh kiểm/phạm vi được dự kiến cho /song: Chạy selftest đối chiếu mới với fixture ngắn; dùng các cổng TTS hiện có cho đúng phạm vi. Khi lấy danh mục địa bàn phải tra nguồn chính thức lúc thực hiện, không đoán từ trí nhớ.
   Lượt /ke-hoach CHƯA chạy các lệnh này. Runtime/công cụ cũ giữ nguyên; dependency chỉ cài trong nơi cô lập khi brief /song cho phép.
6. Bằng chứng: SHA nguồn + image/tool/artifact hash thích hợp, môi trường, lệnh, số pass/fail/skip, kiểm âm/đột biến, phạm vi thiếu; không dữ liệu/giá trị bí mật.
   R2: test đỏ trước → coder → verifier độc lập. R3: thêm tester độc lập và Lead duyệt diff trước ghép. Không tự ký nghiệm thu hay gọi test lab là production.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Parent giữ tracker/W-ID/generated files và tích hợp tuần tự; tối đa 3 agent nặng.
   GitNexus index lúc khảo sát stale `00b9004`, query thiếu FTS: trước sửa symbol parent xử lý index/impact theo luật repo; không scout tự analyze.
8. Đầu ra ≤25 dòng: đạt/chưa xong/chặn, tệp đổi, bằng chứng, việc còn lại/tệp xung đột; tracker và commit để phiên chính.

## Phụ thuộc và ranh giới

Đối chiếu làm ngay; nội dung chính thức và render cuối chuyển WP07V sau Chú duyệt.
D-m8-010: .61 chỉ là kho tạm LAB, không chặn code/lab; custody production vẫn chốt trước cấp production/release.
D-m8-008: phần M3 do phiên m34 tự xử lý; m8 chỉ đọc để biết, không giao việc hoặc soạn/gửi hợp đồng cho M3.
Rủi ro/ước lượng phải đánh giá lại khi tái hiện lỗi, scope hoặc HEAD thay đổi; phát hiện thiếu quyền thì làm tiếp phần lab độc lập.

## Diễn biến

- 02/11 /ke-hoach: tạo phiếu từ 3 scout chỉ đọc và đối chiếu nguồn; chưa giao coder, chưa tạo bản sao, chưa chạy test/host.

## Bước kế tiếp chính xác

/song tạo bộ đối chiếu và gói duyệt, để Lead tự duyệt/chuyển nội dung; không mở việc M3.

- 02/11 11:29 /song: Lead duyệt D-m8-011; parent chuẩn bị và điều phối sóng 1. Dành số W-0491; evidence docs/evidence/W-0491/. Archive LF từ c9f0cd18, loại .env* và sheet.json theo luật bí mật; full history gate chỉ ở main.
- 02/11 11:37 · Archive đã tạo, hash tar64a91ff4721a01f1e7f92421f6b998bf0dad71db522e8492d8370e013ae93114; coder đã nhận brief đầy đủ. GitNexus index-only PASS136s, c9f0cd18 up-to-date; không đổi AGENTS/CLAUDE.
- 02/11 11:58 · Coder frozen:36/36test,3/3mutation; pinnedupstreamđúngcommit đối chiếu3321(2908exact,1format,412pendingProduct),0missing/duplicate/unexpected. Source-record/mappingL26gốc chưa có nên namesComparedgốc=false.47filehashđạt; parentthêm2.gitattributes hẹpgiữbytePDF/CRLFđểghéppatch, không sửa47file. Verifierchờslotauthor02D rảnh.
- 02/11 12:36 · Verifier độc lập ĐẠT kỹ thuật: 47/47 hash, 36/36 test, 3 mutation, 7 PDF tải lại khớp SHA, 20 trang xem lại; nguồn L26 gốc và 412 quyết định Product còn chờ. Parent ghép patch 92 tệp allowlist lên main, byte khớp 92/92, chạy lại 36/36; chưa commit. Dependency/mirror tạm bị auto-review chặn dọn nên giữ, không vào patch.
- 02/11 12:40 · Lead trả lời m8.14 bằng D-m8-012: lấy JSON tỉnh/thành phố và phường/xã M3 về M8, chuẩn hóa cho các bước sau và dọn bản tạm. Giao core đọc nguồn M3 chỉ đọc; phạm vi mới gồm bộ nguồn có provenance, kiểm đầy đủ/parent mapping và hướng dẫn cập nhật, không thay lịch sử L26.
- 02/11 12:49 · M3 canonical xác minh 34 tỉnh/thành, 3.321 phường/xã, khớp V134 seed; branch toandeptrai HEAD547dd59a, source blob b4c31b19. Core đang tạo bộ dữ liệu M8 từ exact LF blob và importer/tests độc lập; Voice kiểm riêng delta mới, không tự duyệt code cũ do mình viết.
- 02/11 12:58 · Delta M3 coder frozen: 31 tệp theo manifest cd9cbae6, 34 tỉnh/thành và 3.321 xã, 67/67 test, 3 mutation, 92 tệp cũ không đổi. Mã M3 thuộc namespace nội bộ, không ghép với mã hành chính trùng số. Đối chiếu tên–tỉnh: 2.854 exact +12 format, 455 pending, 0 ambiguous. Voice đang kiểm delta độc lập.
- 02/11 14:04 · D-m8-012 hoàn tất: nguồnM3 34/3321, giữnamespace riêng; privacy-r2verifier80/80,7/7rebuild+7/7resolve,3mutations. Main183/183byte và80test+catalogvalidateđạt, commit1ef80eb2. 455reviewtên/412đốichiếucũ giữ; nguồnL26lịch sử khôngchặnchuẩnbịnguồnmới. Cleanup bịpolicychặn,khôngvào delivery.
- 02/11 14:18 · Chốt nguồn/công cụ: 80/80 test; 183/183 tệp khớp bản đã kiểm; 34 tỉnh/thành và 3.321 đơn vị cấp xã từ M3. 2.866 khớp tên–tỉnh, 455 pending, 0 ambiguous. Main 1ef80eb2 đạt default gates 51/51; bằng chứng a625d694. Nguồn M3 mới sẵn cho chuẩn bị WP07V; L26 lịch sử không được nhận là đã phục hồi; nội dung/audio chưa nghiệm thu.
