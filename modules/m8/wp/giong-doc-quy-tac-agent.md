# Quy tắc chung cho agent làm đợt giọng đọc + trần cuộc/ngày (M8, 25–30/11)

Mọi brief của đợt này trỏ về đây. Thiết kế gốc: [giong-doc-thiet-ke.md](giong-doc-thiet-ke.md) (đọc đúng các mục brief nêu). Kế hoạch: [../KE_HOACH.md](../KE_HOACH.md). Repo `C:\Projects\ginsengfood-ivr`, chỉ nhánh `main`, một checkout dùng chung nhiều agent cùng lúc (D-lead-063).

## An toàn (cứng)
- KHÔNG commit, KHÔNG push, KHÔNG stash/reset/clean/`checkout --`/`restore .`/rebase, KHÔNG `git worktree add`, KHÔNG `git add`. Chỉ phiên chính commit.
- KHÔNG ssh/scp, KHÔNG chạm .99/.98/.60/.61/.63/.64, KHÔNG gọi mạng ngoài ngoài `dotnet restore` từ cache sẵn, KHÔNG đổi cờ/`.env*`, KHÔNG đọc/in `.env*`, `sheet.json`, khoá, token, mật khẩu, số điện thoại (≥ 10 chữ số). Không chạy script máy thật. `REAL_CUSTOMER_CALL_ALLOWED` luôn NO.
- Tệp dưới `C:\Projects\Project Control\` là repo công khai: không bí mật, không số điện thoại.

## Khoá tệp
- Trước khi sửa/tạo tệp: `python "C:\Projects\Project Control\tools\khoa_tep.py" khai --repo ivr --chu m8/<mã gói> --tep <thư mục hoặc tệp…>` (thư mục MỚI của mình + tệp nóng được phép). Mã thoát 2 = chồng khoá: KHÔNG sửa, làm phần khác hoặc chờ; báo trong báo cáo cuối. Xong `giai`.
- Chỉ sửa trong phạm vi brief. Tệp nóng KHÔNG được liệt kê trong brief của bạn: không sửa (kể cả "một dòng"). Cần thêm dòng ở tệp nóng của người khác: ghi vào báo cáo cuối, phiên chính nối.
- Khoá đặc biệt: chạy test chạm PostgreSQL/Docker (Testcontainers) CHỈ khi giữ `@bo-kiem-du` (`khai --tep @bo-kiem-du`; bị chồng thì chờ 60 giây rồi thử lại, tối đa 25 phút; giải ngay khi chạy xong, không giữ lúc viết mã). Cạn cổng TCP/đỏ hàng loạt kiểu kết nối ⇒ chờ rồi chạy lại riêng lớp đó trước khi kết luận. KHÔNG dừng/xoá/prune container nào (`ginsengfood-postgres-local` của phiên khác).

## Build/test
- Mỗi agent dùng thư mục build riêng TRONG repo: `--artifacts-path .artifacts/build-<mã gói>` (đường `.artifacts/` đã gitignore; đặt artifacts-path NGOÀI repo làm vài test tìm gốc repo hỏng — W-0564, W-0565 xác nhận). Cho cả `dotnet build` và `dotnet test`; dọn thư mục này khi xong. Lệnh không chấp nhận thì dùng `-p:UseArtifactsOutput=true -p:ArtifactsPath=…`.
- Checkout có code dở của agent khác: build đỏ vì tệp KHÔNG phải của bạn ⇒ chờ 3 phút, build lại, tối đa 5 lần; vẫn đỏ ⇒ dừng phần đó, ghi tệp lỗi + chủ khoá (`khoa_tep.py xem --repo ivr`) vào báo cáo; KHÔNG sửa tệp người khác, KHÔNG xoá thay họ. Khi bạn bàn giao tệp, tệp phải biên dịch được ở trạng thái cuối.
- Chỉ test lọc (D-lead-064): lớp của gói + lớp cũ liên quan. Không bộ đủ, không CI, không `FullyQualifiedName~Traceab` (bảng truy vết do phiên chính sinh một lần cuối sóng), không `gate-status --write`, không sửa `docs/release/*`, `docs/traceability-tests.md`. Mỗi test mới có `[Trait("TestId","…")]` (tiền tố `UT-VOICE-`, `IT-VOICE-`, `UT-COST-`, `IT-COST-`, `COMP-VOICE-`…), tên lớp theo bảng §I thiết kế. Test viết trước và chạy đỏ trước khi sửa mã khi có thể.
- `Directory.Build.props` bật `TreatWarningsAsErrors`: build phải 0 lỗi 0 cảnh báo. GitNexus chỉ mục cũ: không bắt buộc `impact`; thay bằng `grep` mọi nơi dùng symbol bạn sửa.
- Cuối việc: `dotnet build-server shutdown`; không để tiến trình/container của bạn.

## Số hiệu gói (phiên chính cấp, agent KHÔNG cấp)
W-0563 nợ nhóm C đợt 1 · W-0564 hợp đồng draft.50 + nối 0 · W-0565 dữ liệu giọng/trần (migration) · W-0566 `RegionalVoiceMap` đọc kho · W-0567 API hồ sơ giọng · W-0568 nghe thử · W-0569 API kho cụm · W-0570 trần cuộc/ngày · W-0571 vùng 3 (sổ cổng) · W-0572… việc sau. Ghi mã gói vào comment XML/tiêu đề bằng chứng, không vào `work-register.md`.

## Bằng chứng
`docs/evidence/W-05xx/README.md` (mới, ≤ 120 dòng): đặc tả → test; số ca thật (đạt/đỏ/bỏ qua) từng lệnh; đột biến tự thử (nhánh → đỏ/xanh, đã hoàn lại, `cmp` khớp); CHƯA CHẠY; bảng "cổng Nguy hiểm" (điều phải đúng · chỗ đọc · đột biến gợi ý ≤ 3) cho gói Nguy hiểm.

## Báo cáo cuối (≤ 45 dòng, tiếng Việt)
Tệp sửa/mới (xác nhận không có tệp ngoài phạm vi); từng mục brief → test nào; số ca từng lệnh; đột biến; CHƯA CHẠY; chỗ lệch thiết kế hoặc kế hoạch (tệp:dòng); việc cần phiên chính nối ở tệp nóng; khoá đã giải.

## Bổ sung 26/11 (sau W-0563…W-0565)
- Python test ghim số dòng của tệp C#/tài liệu (`deploy/m8/tests/test_noi_m3_tai_lieu.py`, `test_tat_khan_tinh.py`, `deploy/m8/noi-m3/kiem-doc-lap/test_e_tai_lieu.py`, `deploy/m8/nghiem-thu-m3/bang-cot.md`, `noi-m3/luot-thu.md`): sau khi sửa tệp được ghim, chạy các test đó và cập nhật ghim lệch (khai khoá trước); nếu không phải tệp của bạn thì báo, đừng sửa.
- Migration đã có (W-0565): `ivr_voice_profiles`, `ivr_voice_previews`, `ivr_cost_ceilings` + entity `VoiceProfileEntity`, `VoicePreviewEntity`, `CostCeilingEntity`, `DbSet` trong `IvrDbContext`; chỉ mục duy nhất một sự cố `ADMIN_QUEUE_PAUSE` mở (bắt 23505 khi hai pause đua nhau).
- Số hiệu thêm: W-0572 CDR · W-0573 nợ nhẹ sau cổng · W-0574 ghim gói tổng đài · W-0575 nối sau migration · W-0576… việc sau. NEXT_WORK_ID sau nối 3 = tuỳ số cuối.
- Câu hỏi cho Toàn đánh số từ m8.145 (m8.120–m8.144 đã dùng).
- **Chữ trong `docs/evidence/**` của repo ivr (quét PII `deploy/ci/scripts/scan-pii.sh`, 26/11):** không viết các chữ khớp quy tắc địa chỉ trong văn xuôi: `đường`, `ngõ`, `ngách`, `thôn`, `ấp`, `tổ`, `số nhà`, chuỗi 10 chữ số/đầu 0/84, `dial_token:` kèm giá trị. Dùng `lối`, `path`, `nhánh`, `tuyến`. Chạy `sh deploy/ci/scripts/scan-pii.sh docs/evidence/W-05xx` trước khi báo cáo (phải `PII_SCAN_PASS`).
- Số hiệu thêm 26/11 (G-11b, m8.130 = B): W-0576 đóng băng draft.50 · W-0577 ma trận 87 · W-0578 dấu NO README · W-0579 bộ co giãn WSOLA · W-0580 bank schema 3 · W-0581 bản dẫn xuất · W-0582 luồng gọi dùng bản dẫn xuất · W-0583 luật/readiness/nguồn/nghe thử theo tốc độ · W-0584 dựng bank 9 cặp ở .99 · W-0585 làm nóng + bật thật. Câu hỏi cho Toàn đánh số từ m8.152.
