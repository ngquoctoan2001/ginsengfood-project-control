# Trạng thái — m8

Mốc: 20/11/2026 23:59 +07 · `ginsengfood-ivr` `main` **local `b37a0ade`**, đi trước remote 4 commit, **chưa push**: W-0552 `74967f59` (bộ máy luật), W-0553 `e20bc936` (dữ liệu luật), W-0554 + W-0555 `2a14e2bd` (lịch gọi dùng bộ máy luật + API quản trị luật, hợp đồng **draft.49** `c5f10955…1ac8`, callback `323ba1d2…` không đổi), `b37a0ade` (ghim gitleaks + chỉnh chữ README cho quét PII). Remote = GitLab = GitHub = **.99 chạy `da306952`** (MOCK, lịch TẮT, gọi thật NO). **.64 Asterisk 22.11.0**.

**20/11 23:59 — luật gọi cấu hình được, phía M8 (D-m8-143…147, [phiếu M8-WP08A](wp/luat-goi-cau-hinh.md), theo dõi chung `modules/lead/wp/theo-doi-luat-goi.md`):** L-03 bộ máy, L-02 dữ liệu, L-04 lịch gọi, L-06 API quản trị đã vào `main` local (Sheet M8-020…M8-023; M8-022/023 để "Chờ review" vì phần sửa sau verifier chưa kiểm lại độc lập). Bộ kiểm đủ trên cây ghép: build 0/0, unit 2213, contract 24, media 14, tích hợp 1046 (2 Skip), `deploy/m8/tests` 458, gitleaks 918 commit không rò, PII cây commit PASS, gate-sweep 50/51 (`scan-pii` cục bộ). **Còn: L-05 intake chế độ luật, L-07 gọi lại thủ công, L-08 kiểm, L-09 push/CI/.99 (chỉ khi Toàn nói), L-10 E2E với m34, L-11 DSAR `phone_key`.** Chờ Toàn: **m8.115** hai rủi ro lịch gọi (trần cuộc/số/ngày chỉ kiểm lúc lên lịch; claim không kiểm lại khung giờ của luật) — **ĐÃ CHỐT 21/11**: Toàn "sửa luôn" (D-m8-148), đang sửa ở W-0556 (coder giao 21/11 06:4x, verifier R3 sau), không còn chờ; trả lời **m34.134** (đảo QT-CHUNG-011/015/016 ở chế độ M8_RULES). Hết tin mới thì dòng 5 trở đi là cũ.

**20/11 15:43:** Toàn chốt hướng "luật gọi cấu hình được" (D-m8-143/144/145, [phiếu M8-WP08A](wp/luat-goi-cau-hinh.md)): số cuộc/khoảng cách/khung giờ/gọi lại sửa bằng API + UI M3; hết luật mà chưa 0/1 → M3 đưa đơn vào hàng chờ nhân viên (xác nhận/không xác nhận, hoặc gọi lại bằng IVR), không tự huỷ (đảo TN-2). m8.114 đã chốt (mốc Giờ Vàng sau phiên cũng cấu hình được, D-m8-146); chưa giao việc, chưa gửi m34, chờ Toàn nói "chạy". **20/11 11:08:** 02I bước 2 ĐẠT: **.64 Asterisk 22.11.0**, ufw 5060 chỉ SBC MobiFone `42.1.66.131`, cầu ARI + 8443 vẫn thông ([phiếu](wp/M8-WP02I.md)); còn nợ RTP/NAT/CDR. **20/11 10:22:** `main` = GitLab = GitHub = `da306952`; CI xanh (`#3092120823`); `deploy_m8_99` xong 10:20 → .99 chạy `da306952`, migration W0551 đã áp, API đo cước sẵn (bảng 0 dòng vì chưa có cuộc mới), MOCK, lịch TẮT, gọi thật NO. `da306952` sửa lỗi W-0551 (số dòng snapshot lệch làm `test_noi_m3_tai_lieu` đỏ ở `4218d4eb`). `m8-https` + `m8-ari` lên `nginx:1.30.7-alpine`, ghim `sha256:bef15473…` (D-m8-142). Chi tiết [nhật ký 20/11](nhat-ky/2026-11-20.md). Các mục dưới đây còn số liệu 18/11 (bỏ qua chỗ ghi 'chưa push', '.99 chạy 0f1a9eb5').

## Hôm nay (chi tiết: [nhật ký 18/11](nhat-ky/2026-11-18.md))

- **W-0549 ĐẠT** ([phiếu](wp/W-0549-krb5.md)): ảnh `backup`/`postgres` trivy 19 → 0 HIGH. Quét trước push bản sao: 17/17 dựng + trivy đạt; `refresh-locks` đỏ lúc 09:3x vì `tokenizers 0.22.2` — 11:5x kiểm lại CLEAN (trục trặc tạm PyPI).
- **W-0550 ĐẠT** ([phiếu](wp/W-0550-chan-cuoc.md), D-m8-137 b/138): gọi thật chỉ quay di động VN (`DESTINATION_NOT_VN_MOBILE`), trần 120 s/cuộc bắt buộc production, trần lượt/giây nghe theo ngày tự `QUEUE_PAUSE` + báo động qua ops-agent. Verifier đột biến 5/5.
- **W-0551 ĐẠT** ([phiếu](wp/W-0551-do-cuoc.md), D-m8-135): bảng `ivr_call_usage_daily`, API `analytics/call-usage` + export CSV/JSON; hợp đồng draft.48 chỉ thêm. Verifier đột biến 6/6. Tab "Cước gọi" bên M3: thả [hộp thư m34](../../hop-thu/m34-2026-11-18-m8-api-do-cuoc-draft48.md) (tin phiên bị giữ).
- **Bộ kiểm đủ cả sóng XANH** trên `4218d4eb` (11:21–11:54): build 0/0, unit 1759/1759, contract 24/24, media 14/14, integration 878/878, gate-sweep 50/51 (`scan-pii` đỏ chỉ do thư mục gitignore cục bộ; PII trên cây commit PASS). Sheet M8-018, M8-019: Lead Đạt. Quét trước push đầy đủ trên HEAD: bị dừng vì máy thiếu bộ nhớ (api/worker dựng PASS, migrate lỗi mạng tạm, còn lại CHƯA CHẠY) — chạy lại khi Toàn bảo, trước push.
- **02I .64** ([phiếu](wp/M8-WP02I.md)): bước 0 (chỉ đọc) ĐẠT — 0 kênh, bí mật khớp .99; bước 1 ĐẠT — ảnh 22.11.0 nạp, `plan`/`preflight` PASS. **Bước 2** (D-m8-139: apply 22.11.0 + verify + ufw 5060 chỉ SBC MobiFone `42.1.66.131`) chép sẵn `/tmp/kiem64c/buoc2.sh`, **chờ Toàn chạy** `ssh -t ssv@192.168.1.64 "sudo bash /tmp/kiem64c/buoc2.sh 2>&1 | tee /home/ssv/buoc2-02i-1811.log"` (trước 19:40).
- **Khung E02/E03 tối 18/11 19:40–21:05** ([phiếu](wp/buoi-e02-e03-web.md), chốt với m34 `modules/m34/wp/khung-e-1811.md`): giữ MOCK `*` bấm 1 (D-m8-134; ở M3 mọi kết quả khác "xác nhận" = huỷ + hoàn tiền); E06-A cuối khung khi lịch tắt; "gọi lại khung mới" NOT_RUN (M3 chưa gửi task gọi lại). Script `ra-soat/kich-ban-99-1811/e_chuan_bi_1811.sh` sẵn. Rủi ro còn: 20:30–20:50 nối bật mà lịch tắt → đơn lạ bị watchdog huỷ.
- m34 tắt nối M3 → M8 trên .99 lúc 08:32 (D-m34-105) → không còn rủi ro huỷ oan đơn COD thật ngoài khung.

## Sẵn sàng và ranh giới

- **55%** (phiên tự chấm 14/11, chờ phiên `lead` đối chiếu; `SAN_SANG.md` có ghi chú 18/11, chưa chấm lại). Kịp 30/11: VÀNG (việc ngoài + .64 + gọi thật nội bộ 01D + MobiFone ~24/11).
- `REAL_CUSTOMER_CALL_ALLOWED=NO`, `production_accepted=false`, `deployable=false`.

## Quyết định đang hiệu lực

- D-m8-078: một mục tiêu; kiểm theo rủi ro; không push chỉ để bảo trì; tối đa 2 agent nền. D-m8-055/037: quét trước push + gitleaks.
- D-m8-112…117 (D-lead-051): nhánh chú → rà, sửa cho xanh, gộp `main` (+ commit W của Toàn), giữ luật chú. D-m8-122: 02I m8 tự làm, Toàn gõ sudo.
- D-m8-130…134: khung E02/E03 tối với m34, giữ `*` bấm 1; 02I chạy 18/11; 04B đêm 19/11 (không tải nặng .99 18–19/11). D-m8-135…138: đo cước, CDR tối giản .64, chống gian lận cước, trần chi phí. D-m8-139: chạy 02I bước 2.
- D-m8-106: MobiFone 400 cuộc/10 giây/1 IP. D-m8-107: không tự viết báo cáo tuần.
- Số W: NEXT_WORK_ID W-0557 (W-0556 đã giữ cho L-04b, đang làm). Quyết định tới D-m8-148.

## Nợ

- **Trước push:** chạy lại quét trước push đầy đủ trên HEAD (lượt 12:0x bị dừng vì thiếu bộ nhớ); oasdiff draft.47→48 chỉ chạy trên CI.
- **Trước gọi thật:** GRANT `ivr_capacity_incidents` cho `ivr_monitor` (`monitor-grants.sql` ghim hash); chỉ mục duy nhất một sự cố tạm dừng đang mở (API pause + tự pause cùng lúc); mẫu `closed-profile.example.json` chưa có 120 s; Toàn chốt số trần/ngày; ufw RTP 10000–10999 + nguồn SIP sau NAT kiểm ở 05; CDR tối giản .64 (D-m8-136, chưa làm); chứng thư lá ARI hết hạn 13/01/2027 (thay trước ~14/12); hỏi MobiFone khối tính cước + chặn quốc tế.
- nginx 8443 .99 dòng `allow 172.29.0.1` thừa; test biên 08:53:30/31; `work-register.md` dòng trống; `test_e_tai_lieu.py` đỏ 2/7; `kiem-sau` `kenh_asterisk`; restic `x/net`; mật khẩu sudo .61 lộ chat 09/11.
- Sổ: 5 tin cũ `hop-thu/m8-*` chưa chuyển `xong/`; `_wt/m8/` bản sao cũ. Dirty không do phiên: `deploy/operations/m34_mock_agent.py` + test; `docs/weekly-tracking/nguyen-quoc-toan.md` (sheet-sync ghi).
- **Có một phiên m8 thứ hai [8c222c]** mở ~11:1x (sau đổi tài khoản), tin phiên tới nó bị giữ → Toàn chọn giữ phiên nào.

## Đang chờ

- Toàn: chạy 02I bước 2 (lệnh trên); nói "chạy" lúc 19:40 cho khung E02/E03; chọn phiên m8; hỏi chú báo động sớm khi callback lỗi kéo dài 24 giờ; đăng nhập GitLab để đọc CI.
- m34: tab "Cước gọi" phía M3 ĐÃ có trên .99 (m34 đọc jar `be` 20/11 10:2x: class `IvrCallUsageCsv`, image `5b68a2162`, mã tab `7c3910714` qua PR #170 ngày 18/11; chưa đối chiếu dòng-dòng vì image build ở GitLab của Phúc). Chưa thử đầu–cuối: Toàn vào /admin → IVR → Báo cáo → Cước gọi, kỳ vọng bảng rỗng, không 401/403. Còn: báo N lúc 19:30 (khung E02/E03 đã bỏ), deploy M3 `dev` (billing GitHub).
- Việc ngoài: Chú (lời thoại 3 miền + 455 tên, pháp lý VieNeu), MobiFone (~24/11).
- Gác: m8.58/59/61, m8.50. Câu mới đánh từ m8.108.
