# Từ phiên `lead` · 24/11/2026 18:0x · việc cần làm để hoàn thiện M8 tới 30/11

Toàn: "bắn việc cần làm qua phiên m12 m8 nhé. để hoàn thiện hệ thống." Nguồn: `modules/lead/ban-giao/2026-11-24-chuyen-tai-khoan.md` §2–§3, `modules/m8/TRANG_THAI.md`,
`modules/m8/cong-nguy-hiem.md`, phiếu `modules/m8/wp/luat-goi-cau-hinh.md`. Luật: `CLAUDE.md` §3 mục 5 và 8 (D-lead-063, D-lead-064), `chung/CACH_LAM.md` §3–§4.
Giữ nguyên trên .99: MOCK, lịch gọi TẮT, `REAL_CUSTOMER_CALL_ALLOWED=NO`. Push, lên .99, đổi cờ: chỉ khi Toàn nói rõ trong phiên.

Làm theo thứ tự:
1. **L-05** (intake chế độ luật, vùng Nguy hiểm số 1) — bắt đầu theo phiếu luật gọi; rồi **L-07**, **L-10** (chạy thử đầu–cuối với m34, MOCK), **L-11**. `NEXT_WORK_ID` W-0558.
   M3 (m34) chỉ lật cờ luật gọi khi M8 xong L-05 và L-07: báo m34 qua `hop-thu/m34-…` khi xong mỗi phần.
2. **Nợ trước gọi thật:** GRANT `ivr_capacity_incidents` cho `ivr_monitor` (`monitor-grants.sql` ghim hash); chỉ mục duy nhất một sự cố tạm dừng đang mở;
   mẫu `closed-profile.example.json`; dòng `allow 172.29.0.1` thừa ở nginx 8443 .99; test biên 08:53:30/31; `test_e_tai_lieu.py` đỏ 2/7.
3. **Cổng Nguy hiểm 25–27/11:** chuẩn bị diff từng vùng trong `cong-nguy-hiem.md` để Toàn duyệt trước khi bật cờ thật; thử đột biến chỉ ở cổng.
4. **MobiFone (~24/11):** luật v4 cũ không được vỡ khi thử.
5. **Còn chờ Toàn, trình gọn một lần:** giữ phiên m8 nào (đang có hai phiên); token GitLab cho lịch đêm 03:30.

Báo Toàn sau mỗi gói: đã đổi gì (SHA), còn gì, cần duyệt gì. Đọc xong chuyển tin này sang `hop-thu/xong/`.
