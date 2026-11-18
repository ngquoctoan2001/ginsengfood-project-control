# Tin báo tên miền HTTPS chạy thật · 17/11/2026 tối (CHƯA GỬI)

Nguồn: tên miền public chạy thật từ 17/11 ~16:3x (D-lead-057, D-lead-058; proxy Caddy .98, chứng chỉ Sectigo wildcard tới 03/06/2027).
Kế hoạch: `modules/lead/may-chu/2026-11-17-ke-hoach-ten-mien-public.md`. Tài đã nhận tin khai Meta lúc 19:40 (`modules/m5/ra-soat/2026-11-17-tin-tai-khai-meta.md`) nên tin riêng không lặp lại.
Không có tệp kèm: tin chỉ báo việc, không giao việc kỹ thuật mới.

## (a) Nhóm chung (chú Dũng, Phúc, Tài)

```text
Dạ chú với mọi người ơi, tên miền ginsengfood.vn chạy https có SSL rồi nha. Ở công ty hay ở nhà gõ tên miền là vô được, khỏi gõ IP nữa.
- ginsengfood.vn: web bán hàng, quản trị bán hàng thêm /admin
- ops.ginsengfood.vn: quản trị nhà máy
- pwa.ginsengfood.vn: app xưởng trên điện thoại
- trace.ginsengfood.vn: truy xuất nguồn gốc
- mkt.ginsengfood.vn: quản trị marketing
Gõ có https:// ở đầu nghen. Ai vô thấy lỗi gì chụp màn hình gửi Toàn liền nha.
```

## (b) Riêng Tài

```text
Tài ơi, proxy trên .98 chạy thật rồi nha, mkt. vô https ngon lành. Em deploy M5, M6 cứ làm bình thường, không ảnh hưởng proxy.
Chỉ cần giữ M5 cổng 3000, M6 cổng 6600 như giờ, đừng đụng compose edge với cổng 80, 443. Muốn đổi cổng thì báo anh trước để anh chỉnh proxy hen.
Còn khai Meta thì như anh nhắn hồi nãy nghen.
```
