# Trạng thái — m8

Mốc: 18/11/2026 11:59 +07 · `ginsengfood-ivr` `main` **local `4218d4eb`**, đi trước remote 6 commit, **chưa push**: W-0549 `11ed89f0`+`72c381e1` (khoá `krb5-libs`/`libxslt`), W-0550 `0da89319` (chặn gian lận cước + trần chi phí), W-0551 `feeca2ac`+`4218d4eb` (đo cước gọi + hợp đồng **draft.48** `978b0db4…`, callback không đổi). Remote = `aeb486eb` (pipeline chưa đọc: GitLab chưa đăng nhập ở phiên này). **.99 chạy `0f1a9eb5`** (MOCK, lịch TẮT, gọi thật NO). **.64 Asterisk 22.10.1** (bước 1 nâng cấp đã chuẩn bị, chưa đổi dịch vụ).

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
- Số W: NEXT_WORK_ID W-0552. Quyết định tới D-m8-139.

## Nợ

- **Trước push:** chạy lại quét trước push đầy đủ trên HEAD (lượt 12:0x bị dừng vì thiếu bộ nhớ); oasdiff draft.47→48 chỉ chạy trên CI.
- **Trước gọi thật:** GRANT `ivr_capacity_incidents` cho `ivr_monitor` (`monitor-grants.sql` ghim hash); chỉ mục duy nhất một sự cố tạm dừng đang mở (API pause + tự pause cùng lúc); mẫu `closed-profile.example.json` chưa có 120 s; Toàn chốt số trần/ngày; ufw RTP 10000–10999 + nguồn SIP sau NAT kiểm ở 05; CDR tối giản .64 (D-m8-136, chưa làm); chứng thư lá ARI hết hạn 13/01/2027 (thay trước ~14/12); hỏi MobiFone khối tính cước + chặn quốc tế.
- nginx 8443 .99 dòng `allow 172.29.0.1` thừa; test biên 08:53:30/31; `work-register.md` dòng trống; `test_e_tai_lieu.py` đỏ 2/7; `kiem-sau` `kenh_asterisk`; restic `x/net`; mật khẩu sudo .61 lộ chat 09/11.
- Sổ: 5 tin cũ `hop-thu/m8-*` chưa chuyển `xong/`; `_wt/m8/` bản sao cũ. Dirty không do phiên: `deploy/operations/m34_mock_agent.py` + test; `docs/weekly-tracking/nguyen-quoc-toan.md` (sheet-sync ghi).
- **Có một phiên m8 thứ hai [8c222c]** mở ~11:1x (sau đổi tài khoản), tin phiên tới nó bị giữ → Toàn chọn giữ phiên nào.

## Đang chờ

- Toàn: chạy 02I bước 2 (lệnh trên); nói "chạy" lúc 19:40 cho khung E02/E03; chọn phiên m8; hỏi chú báo động sớm khi callback lỗi kéo dài 24 giờ; đăng nhập GitLab để đọc CI.
- m34: báo N lúc 19:30; tab "Cước gọi" sau khi M8 push draft.48; deploy M3 `dev` (billing GitHub).
- Việc ngoài: Chú (lời thoại 3 miền + 455 tên, pháp lý VieNeu), MobiFone (~24/11).
- Gác: m8.58/59/61, m8.50. Câu mới đánh từ m8.108.
