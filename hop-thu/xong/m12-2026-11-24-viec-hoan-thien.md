# Từ phiên `lead` · 24/11/2026 18:0x · việc cần làm để hoàn thiện M1–M2 tới 30/11

Toàn: "bắn việc cần làm qua phiên m12 m8 nhé. để hoàn thiện hệ thống." Nguồn: `modules/lead/ban-giao/2026-11-24-chuyen-tai-khoan.md` §2–§3, `modules/m12/TRANG_THAI.md`.
Luật: `CLAUDE.md` §3 mục 5 và 8 (D-lead-063 một checkout + `tools/khoa_tep.py`; D-lead-064 kiểm hai mức), `chung/CACH_LAM.md` §3–§4. Push, lên .99,
cờ production, `.env`, bật cờ đặt lại mật khẩu: chỉ khi Toàn nói rõ trong phiên. Hai phiên m12: `cf1de578` giữ WP30–33, `874c329c` giữ m12.200 trở đi; phiên nào
không chạy thì phiên kia nhận phần đó, khai khoá trước khi sửa.

Làm theo thứ tự (chọn theo đề xuất của phiên ở m12.200–202):
1. Giải khoá `m12/nong` (giữ 68 giờ trên ops-core) nếu việc đã xong.
2. **m12.201 — làm ngay hôm nay:** soạn tin mời nghiệm thu + tập huấn sáng 27/11 (giọng theo `CLAUDE.md` §7; chú Dũng: con/chú) và sửa kịch bản M12-010 theo DB sạch .99. Toàn tự gửi.
3. **m12.200 A — WP17b phần mã:** OPS-01 kho bằng chứng, cổng JWT sau 30/11 16:59Z (hết ngoại lệ), compose Production; khai khoá `deploy/m12/**`. Vùng Nguy hiểm → verifier độc lập một lần ở cổng.
4. **m12.202 A:** rà nhanh 6 phiếu bỏ dở (WP24, WP25, WP27, WP28, WP12g đợt 2, WP-UAT sóng 0), gộp phần còn lại vào gói đang làm hoặc đóng có lý do; WP28 chạy cổng.
5. **Cổng Nguy hiểm 25–27/11:** chuẩn bị diff từng vùng (WP31, WP32, P10, P13, #17, P14, VAT P1b) để Toàn duyệt trước khi bật cờ thật.
6. **Mốc:** M-c Production 25/11 · nghiệm thu + tập huấn sáng 27/11 · M-d 28/11 · chạy thật 30/11. Lên .99 theo D-m12-133 (dựng 5 ảnh ở máy Lead, `docker save | ssh .99 docker load`, `trien-khai.sh <sha>`) khi Toàn nói.
7. **Vẫn chờ Toàn, trình lại gọn một lần:** m12.203 (cách có mẻ bán được qua M3), m12.204 (luồng nhập lô thành phẩm cũ); lịch đêm 03:30 cần token GitLab.

Báo Toàn sau mỗi gói: đã đổi gì (SHA), còn gì, cần duyệt gì. Đọc xong chuyển tin này sang `hop-thu/xong/`.
