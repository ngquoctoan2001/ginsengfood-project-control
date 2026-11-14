> ĐÃ CŨ (14/11 08:58): máy đã cắt sang .99 lúc 07:36; dùng `2026-11-14-tin-nhom-da-chuyen-99.md` (mẫu tin mới, CLAUDE.md §7).

Gửi Tài · 13/11 · từ Toàn (NHÁP, chưa gửi)

Việc: Sắp tới M3–M4 (gồm thanh toán, vận chuyển, AI tư vấn) chuyển từ .60 sang máy 192.168.1.99. Không còn giờ cố định (D-lead-038): làm ngay khi M1–M2 đã sang .99 và kịch bản sẵn, không làm giữa buổi chạy mốc D 14/11. Lúc bắt đầu mình nhắn một câu; M3/M4 không trả lời khoảng 20–60 phút.
Vì sao: D-lead-035/036 chốt .99 là máy bán hàng chính thức. Image CI giữ nguyên, cờ đối tác vẫn tắt như trên .60, mình không gọi VNPAY/GHN/Viettel Post thật trong lúc chuyển.
Cần làm:
1. M5 trên .98 gọi M4 `/advise` và M3-181: `M4_ADVISOR_BASE_URL` bên M5 bắt https trừ loopback (`module5/src/outbound-guard/adapters/real/http-m4-advisor.ts:83-84`), nên đặt theo tên miền https qua nginx của Anh Tuấn khi tên miền đã về .99, đừng đặt `http://192.168.1.99`. Chỗ nào đang trỏ 192.168.1.60 thì sau khi chuyển sẽ không còn trả lời.
2. Đối tác (VNPAY IPN/return, webhook GHN, Viettel Post): cấu hình dùng tên miền thì không phải đổi gì. Còn chỗ nào dùng IP .60 thì báo mình trước khi chuyển.
3. Sau khi mình báo xong, kiểm vận chuyển, thanh toán và M4 trên http://192.168.1.99.
Xong khi: M5 gọi được M4 qua https tên miền, và luồng thanh toán/vận chuyển thử (cờ tắt) chạy trên .99 như trên .60.
Không cần trả lời nếu không có chỗ nào dùng IP .60.
