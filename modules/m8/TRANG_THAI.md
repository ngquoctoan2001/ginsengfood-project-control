# Trạng thái — m8

Mốc: 18/11/2026 07:53 +07 (đầu phiên ở tài khoản Claude mới, bàn giao `modules/lead/ban-giao/2026-11-18-chuyen-tai-khoan.md` §3.7) · `ginsengfood-ivr` `main` local = GitLab = GitHub **`aeb486eb`** (W-0548 khoá zlib; lên remote từ ngoài phiên sau 17/11 13:21, ghi SHA; pipeline GitLab của `aeb486eb` CHƯA ĐỌC) · **.99 chạy `0f1a9eb5` từ 17/11 08:58** (`deploy_m8_99`, D-m8-120; 46 migration), hạn mức `Ivr:ServiceQuota` 600/60 s (D-m8-127) · W-0545…0548 chỉ đổi CI/công cụ/tài liệu/khoá gói, không cần deploy.

## Máy chạy M8

- **M8 chạy trên 192.168.1.99 từ 14/11 07:45** ([phiếu](wp/chuyen-may-99.md)): 9 dịch vụ, `https://192.168.1.99:8443`; callback → cầu M3 `https://192.168.1.99:8445`; gọi thật NO; **lịch gọi TẮT** (từ 17/11 08:15).
- .61 dừng hết, giữ đường lui thủ công (`chuyen.sh quay-lui`; job CI .61 gỡ W-0545, khoá CD .61 thu hồi D-m8-125). .64 Asterisk vẫn bản 27/10, cầu ARI mở cho .99.
- Job CI `deploy_m8_99` chạy được (17/11, bấm tay). Custody khoá .99 XONG ([phiếu](wp/custody-khoa-m8.md), gói Toàn giữ, sha256 `f209e8ea…`).

## Nghiệm thu M3 ↔ M8 trên .99 (01E) — 8/10 ca ĐẠT

- 14/11: 6/10 (W-0540). 17/11 ([phiếu](wp/buoi-e07-e02-e03-e08.md)): **E07, E08 ĐẠT** (Toàn xác nhận). **02J ĐẠT, 07E ĐẠT** (401/403/429) trên .99 17/11.
- **E02/E03 đặt qua web CHỜ khung hẹn** (D-m8-130): m34 đã tắt nối M3 → M8 trên .99 lúc 08:32 18/11 (m34.130, D-m34-105; lớp `compose.cong-khai.yml`: `APP_IVR_INTEGRATION_ENABLED=false`, watchdog IVR tắt theo, OTP giả tắt; 0 bản ghi IVR active trước khi tắt) → đơn COD do nhân viên xác nhận, không còn rủi ro huỷ oan. Buổi E02/E03 (m34 đề xuất 19:45–21:15, bọc khung gọi lại 20–21; câu m8.102 tối nay hay chờ deploy M3 `dev`): khung bật lại cả OTP giả (đơn COD chỉ vào IVR khi SĐT xác minh OTP), M3 không có danh sách khách thử → đơn lạ trong khung vào MOCK — **worker .99 đang có kịch bản mặc định `*` = nghe máy bấm 1 → đơn lạ sẽ bị tự xác nhận** (đọc 18/11) ; không nghe máy tới hết lượt ở M3 = HUỶ + hoàn tiền (không chuyển nhân viên, m34 đọc mã) nên không che bằng RingTimeout → D-m8-134 giữ `*` bấm 1 (đơn lạ tự xác nhận, nhân viên gọi lại); trước `tat` phải 0 xác nhận active; m34 canh đơn mới mỗi phút; m34 `cong-khai-99.sh lui` bật lại nối IVR trong khung, M8 bật lịch MOCK, xong tắt lại cả hai. E04 `NOT_RUN` (M3 chưa gửi lại), E09 (chưa có 9443).
- Sau deploy 17/11 còn phải chạy lại E05, E06-A/B, gọi lại khung mới, `/result`, E10 (D-lead-056) — cần đơn đi qua M3, cùng điều kiện với E02/E03.

## Sẵn sàng và ranh giới

- **55%** (phiên tự chấm 14/11, chờ phiên `lead` đối chiếu; `SAN_SANG.md` mốc 14/11 chưa ghi 02K/02J/07E/custody đã ĐẠT) ([bảng](SAN_SANG.md)). Kịp 15/11: XANH (đã đạt). Kịp 30/11: VÀNG (việc ngoài + .64 + gọi thật nội bộ 01D).
- `REAL_CUSTOMER_CALL_ALLOWED=NO`, `production_accepted=false`, `deployable=false`.

## Quyết định đang hiệu lực

- D-m8-078: một mục tiêu; kiểm theo rủi ro; không push chỉ để bảo trì; tối đa 2 agent nền. D-m8-055/037: quét trước push + gitleaks.
- D-m8-112…115, 117 (D-lead-051): nhánh chú → rà, sửa cho xanh, gộp `main` (tua nhanh + commit W của Toàn ở đầu), giữ luật chú; báo động callback không tự thêm.
- D-m8-122 (D-lead-058): không nhờ Anh Tuấn cho M8; 02I .64 m8 tự làm, Toàn gõ sudo; bỏ kho sao lưu ngoài máy.
- D-m8-106: MobiFone 400 cuộc/10 giây/1 IP. D-m8-107: không tự viết báo cáo tuần. D-m34-081: bản ghi thử 8 tên xã có chữ "đường".
- D-m8-130…133 (18/11): E02/E03 web trong khung tối với m34 sau m34.130; 02I chạy chiều 18/11 khi Toàn duyệt kịch bản; 04B đêm 19/11; sóng 18/11.
- Số W: NEXT_WORK_ID W-0549. Quyết định tới D-m8-138.

## Nợ

- **Mới:** ảnh phát hành `backup`/`postgres`: 19 HIGH `krb5-libs 1.22.2-r1` của ảnh gốc `postgres:16-alpine` (sửa ở 1.22.3-r0) — nâng digest hoặc khoá `krb5-libs` trước khi dựng bản phát hành (W-0548 README).
- nginx 8443 .99 còn dòng `allow 172.29.0.1` thừa (dải cũ) — gỡ ở lượt đổi cấu hình nginx sau.
- Câu mô tả `recall_of_task_id` draft.47 còn ghi khung cũ (D-m8-119); test biên 08:53:30/31 cho policy 390 s; `work-register.md` dòng trống cắt đôi bảng; `noi-m3/kiem-doc-lap/test_e_tai_lieu.py` đỏ 2/7 (trích `README.md:254` cũ, CI không chạy).
- `kiem-sau` mục `kenh_asterisk` cho .99; tiêu chí h công cụ diễn tập so schema theo chữ; 400-trước-401 ở lối nội bộ; oasdiff draft.46→47; W-0510 thân phản hồi thô trong junit; D-m8-019 `sudo python3` không `-I`; restic `x/net` v0.60.0; mật khẩu sudo .61 lộ chat 09/11 chưa có bằng chứng đã đổi.
- Sổ: phiếu cũ còn ghi `ĐANG LÀM` dù đã xong (`wp/M8-WP04B.md` "chờ push", `wp/chuyen-may-99.md` cắt xong 14/11); 5 tin cũ `hop-thu/m8-*` (02–12/11) chưa chuyển `xong/`; `_wt/m8/` bản sao cũ.
- Dirty không do phiên: `docs/weekly-tracking/nguyen-quoc-toan.md` (sheet-sync), `deploy/operations/m34_mock_agent.py` + test; worktree lạ `_wt/m34/m3-112/m8` (m34 gỡ).
- Sheet: M8-003 Đang làm 90%; M8-005 (MobiFone ~24/11), M8-006 (định danh) Bị chặn.

## Việc tuần 16–21/11 (D-lead-048 → D-lead-055)

1. Xong 17/11: buổi E07/E08, `deploy_m8_99`, 02J, 07E, custody .99, thu hồi .61, W-0545…0548 lên remote.
2. **02I .64** (D-m8-131): phiên soạn phiếu + kịch bản, kiểm kê .64 chỉ đọc; chạy chiều 18/11 khi Toàn duyệt kịch bản, Toàn gõ sudo.
3. E02/E03 qua web + chạy lại E05, E06-A/B, gọi lại, `/result`, E10 trong một khung tối với m34, sau m34.130 (D-m8-130).
4. 04B làm nóng trên .99 đêm 19/11 (D-m8-132); không tải nặng trên .99 18–19/11.
5. D-m8-135…138 (m8.104–107 "ok"): W-0550 chặn đích không phải di động VN + trần 120 s/cuộc + trần chi phí/ngày tự dừng hàng đợi (coder nền, Sheet M8-018); W-0551 đo cước theo ngày/tháng + CSV đối soát (coder nền, Sheet M8-019; tab M3 ở m34 sau); ufw .64 chỉ cho SBC MobiFone `42.1.66.131` + CDR tối giản (W sau, làm cùng lượt sudo .64); hỏi MobiFone khối tính cước + chặn quốc tế lúc gọi thử. W-0549 krb5-libs (bản sao A, commit local, D-m8-133). Chuẩn bị gọi thử MobiFone qua trunk (~24/11), cần .64 mới.

## Đang chờ

- Toàn: nói "chạy" lúc vào khung E02/E03 19:45 (D-m8-130/134; m8.102 chưa trả lời riêng, chuẩn bị theo A); duyệt kịch bản 02I; hỏi chú báo động sớm khi callback lỗi kéo dài 24 giờ. Phiên m34: giờ khung E02/E03 (Toàn hẹn), lượt deploy M3 `dev` mới lên .99 (CI GitHub BP kẹt billing).
- Việc ngoài: Chú (lời thoại 3 miền + 455 tên, pháp lý VieNeu), MobiFone (~24/11). Còn: bật `customer_input_at` khi M3 nhận trường này + lên .99.
- Gác: m8.58/59/61, m8.50 lịch chạy đêm. Câu mới đánh từ m8.108.
