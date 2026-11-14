# Việc ngoài code (cổng G8)

Việc chờ bên ngoài chặn chạy thật dù mã xong. Phiên `lead` gom từ mục việc ngoài code trong `modules/*/SAN_SANG.md` mỗi sáng;
quá hạn hoặc còn ≤ 2 ngày → đưa lên bảng đầu phiên. Chỉ soạn tin khi bạn yêu cầu (D-lead-005).
Mốc đối chiếu sổ: 02/11/2026 09:52; nguồn: SAN_SANG/TRANG_THAI các luồng, quyết định và hộp thư m12/m34; Sheet đọc mới 242 task, 3 Bị chặn (M5-004/032/100).

| # | Việc | Luồng | Ai gỡ | Cần trước | Trạng thái |
|---|---|---|---|---|---|
| 1 | Hạ tầng M5: staging .63, máy production, sao lưu, script triển khai (phiếu M5-004) | m5 | Lead duyệt → Anh Tuấn | gửi phiếu 31/10; staging 03/11, production 05/11 | **quá hạn** (Sheet M5-004 hạn 30/10, Bị chặn) · m5.1; cũng chặn M4-004 máy chạy thử M4 (hạn 05/11) |
| 2 | Quyền Meta: Page thí điểm, xác minh doanh nghiệp, App Review | m5 | Tài | nộp App Review 06/11 | Tài **đã có quyền quản trị trang** (D-lead-006); còn App Review · Sheet M5-100 02/11 vẫn ghi Bị chặn "tài khoản Tài không quản lý Page nào" — lệch, cần Tài xác nhận |
| 3 | Quyền admin repo module5 cho Tài | m5 | Lead | không gấp | giai đoạn dev CI không bắt buộc (D-lead-006) |
| 4 | VNPAY cấp thông số chạy thật + danh sách IP | m34 | Tài | trước mốc D 14/11 | VNPAY đã nghiệm thu kỹ thuật, đã chạy bộ SIT của VNPAY, biên bản đã gửi (D-m34-002); chờ thông số thật |
| 5 | GHN: chốt báo giá, quyết có triển khai · Viettel Post: cần web chạy trên tên miền chính thức ginsengfood.vn/.com | m34 | chị Lan (GHN) · Tài (kỹ thuật) | trước mốc D | GHN kỹ thuật ổn trên sandbox (báo giá, nhận đơn, tin báo tự động); VTP chờ bên mình lên tên miền (D-m34-002) |
| 6 | MobiFone: xác nhận 36 kênh / 2 cuộc mỗi giây; gọi ngoại mạng | m8 | Lead | trước mốc C 12/11 | một cuộc nội mạng đạt 23/10 |
| 7 | Giấy chứng nhận định danh tên công ty (brand-name) | m8 | Lead | trước mốc D | đã gửi hồ sơ qua đơn vị dịch vụ, ~20 ngày có kết quả (D-lead-006); 15/11 chỉ MobiFone |
| 8 | Ý kiến pháp lý: VieNeu (giọng đọc), DF-03 | m8 | Lead | trước mốc C | chưa |
| 9 | Quyền sudo + khung bảo trì `.61`/`.64`, kho sao lưu cho M8 | m8 | Anh Tuấn | 07/11 | chưa |
| 10 | Dọn M7 cũ trên `.61`, đổi bí mật Redis/PG và xử lý lịch sử deploy | m7 | Lead → Anh Tuấn | T103, chưa chốt ngày | **hoãn**, dev local trước (D-m7-012); không yêu cầu tắt máy trong phiên đầu ngày |
| 11 | Ngân sách video trả phí + Page thử/chính sách Meta cho video 70 phút, nhãn AI | m7 | Lead / Chú | GĐ4 | chưa; bản tối thiểu 15/11 là demo local đang chờ m7.22 |
| 12 | Máy in tem, máy quét, mẫu tem tại xưởng; kế toán MISA | m12 | — | — | **hoãn** (D-lead-006) |
| 13 | SPX: ký hợp đồng để nhận tài liệu kỹ thuật, rồi nối thử sandbox | m34 | chị Lan | chưa có ngày | chờ hợp đồng (D-m34-002) |
| 14 | Runner GitLab Linux cho ops-core + OIDC/khoá ký (cosign) cho job image/SBOM/ký | m12 | Anh Tuấn | 07/11 | m12.21 A (D-m12-005); quá 10/11 → ngoại lệ có hạn như JWT; tin soạn sẵn `modules/m12/ra-soat/2026-11-02-tin-nhan.md` §1 |
| 15 | Tên miền + DNS + chứng chỉ HTTPS cho admin, trang truy xuất công khai, PWA xưởng trên .61 | m12 | Anh Tuấn | 07/11 | m12.21 A; DAST và kiểm rate limit công khai chờ việc này |
| 16 | Kênh cảnh báo thật + người nhận P1/P2 (`monitoring-alerting-runbook.md:53` `BLOCKED_EXTERNAL`) | m12 | Anh Tuấn | 07/11 | m12.21 A; quá 10/11 → ngoại lệ có hạn |
| 17 | Tài khoản máy `availability-v1` cho M6, M7 (DL-060) trên .61 | m12 | Lead tạo khi luồng báo cần | 14/11 | m12 gộp vào WP02c/WP11 |
| 18 | Pipeline GitLab gia hạn JWT: chạy web pipeline, biến `OPS10_JWT_SELECTED_SOURCE_SHA` = SHA đủ của `f223681db` (hoặc HEAD) | m12 | Lead | 03/11 | việc chặn của m12 |
| 19 | Mã truy cập Claude API có credit cho M4 (Tài thử 22/10, 26/10 đều báo hết credit) | m34 | Lead | 05/11 | bật AI = cắm mã (D-lead-006); báo cáo tuần M4 của Tài |
| 20 | Duyệt lời thoại 3 miền cho M8 | m8 | Chú (chưa gửi) | 06/11 | `modules/m8/TRANG_THAI.md` việc chặn |
| 21 | Tên hai tài khoản thật .61: người yêu cầu khác người duyệt; báo khung dừng API cho Phúc/Tài | m12 | Lead | 03/11 trưa / trước đợt tối | m12.14 chưa có tên; m12.15 A đã duyệt, còn điền giờ tin §2 |
| 22 | Chốt API đơn/callback, dữ liệu thử và lịch E01–E10 M3 ↔ M8 | m34, m8 | Lead code M3; Phúc phối hợp lõi đơn; phiên m8 | 06/11 | D-m34-003 chuyển phần kết nối sang Lead; chưa có lịch mới, không coi mốc Phúc 27/11 là lịch của phần Lead nhận |
| 23 | Adapter M3 giữ hàng/tra phân bổ/kéo tồn và bên nhận webhook + URL | m34, m12 | Phúc | 08/11 | chưa; hợp đồng C37 do phiên lead, Phúc review trước publish |
| 24 | Thiết bị PWA + người thật cho M12-010 | m12 | xưởng / Lead | 10/11 | chưa; không đồng nhất test trình duyệt với test thiết bị |
| 25 | Người ký nghiệm thu QA Lead / Operations Owner / Product Owner | m12 | Lead, quản đốc, chủ dự án | chốt 11/11, nghiệm thu 12/11 | m12.20 mở lại; 3 người khác nhau hoặc waiver theo cổng |
| 26 | Nhập dữ liệu thật thay dữ liệu giả khi cutover | m12 | chủ dự án | 14/11 | D-m12-003; không nhập dữ liệu thật trong lab |
| 27 | Claude Max/Ultra hoặc API cho adapter M7 | m7 | Lead | T034 (L3) | cách đã chốt DL-030; trước đó dùng mock |
| 28 | Máy để bàn chạy worker + tài khoản Muse/người giữ/cách đăng nhập | m7 | Lead | T059 / T064 (L10) | chưa chọn máy, chưa kiểm hệ điều hành; Muse TODO |
| 29 | Pháp chế DL-048 / DL-049 | m7 | pháp chế | trước chạy thật | chưa; guard giữ chặn theo SAN_SANG M7 |
| 30 | Người giữ GH_APPROVER, vận hành, trực | m7 | Lead, Chú | GĐ4 | chưa có tên; đợt 1–2 Lead giữ (DL-036) |
| 31 | Kho S3 .61 + ghép M7 vào deploy contract | m7, lead | Lead, Anh Tuấn | T103 | còn 5 điểm lệch; phụ thuộc ngoài không chặn L0 local |
