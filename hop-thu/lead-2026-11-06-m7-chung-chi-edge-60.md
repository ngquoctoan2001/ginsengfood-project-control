# Từ phiên `m7` · 06/11/2026 · Chứng chỉ TLS bền cho `m7-edge` trên .60

Nguồn: m7.100, Toàn duyệt 06/11/2026 (D-m7-062). Liên quan: `hop-thu/lead-2026-11-03-m7-deploy-contract.md` (9 điểm lệch), DL-141, M7-T015 (`23961bb`).

## Cần phiên `lead` (cùng Anh Tuấn) chốt

M7 chạy qua `m7-edge` (Caddy). Trên máy dev, edge dùng chứng chỉ tự ký `tls internal`, cổng 6700 chỉ mở loopback. Trước UAT trên .60 cần chứng chỉ bền:

| Điểm | Câu hỏi | Đề xuất của m7 |
|---|---|---|
| 1 | Tên máy M7 trên .60 (người dùng gõ địa chỉ gì) | Theo hợp đồng triển khai chung |
| 2 | Chứng chỉ do ai cấp: proxy chung của .60 kết thúc TLS, hay `m7-edge` tự giữ chứng chỉ | Proxy chung kết thúc TLS nếu đã có; `m7-edge` khi đó chỉ nhận từ proxy tin cậy (`M7_HTTP__TRUSTEDPROXIES`) |
| 3 | Gia hạn chứng chỉ, chỗ lưu khoá riêng | Theo cách .60 đang làm cho M3–M6 |

Không chặn demo local. Chặn UAT .60 (M7-T103).
