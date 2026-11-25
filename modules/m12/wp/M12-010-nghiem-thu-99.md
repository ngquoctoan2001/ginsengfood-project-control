# M12-010 — Nghiệm thu bản tối thiểu M1–M2 trên `.99` qua LAN, sáng CN 15/11/2026

> **Cập nhật 24/11:** buổi 15/11 dời; nghiệm thu + tập huấn chạy **sáng 27/11** (D-m12-091) trên `.99` DB sạch. Kịch bản mới `wp/M12-010-bo-sang-27-11.md`, biên bản `wp/M12-010-bien-ban-27-11.md`, tin mời `ra-soat/2026-11-24-tin-nghiem-thu-27-11.md`. Phần dưới giữ làm lịch sử 14/11.

Trạng thái: CHUẨN BỊ · Rủi ro: R3 (người thật thao tác trên máy chạy thật) · Quyết định: D-m12-062 · Sheet: M12-013 (tập huấn/nghiệm thu)
Nguồn: manifest `docs/runbooks/release/02-11-08-50-manifest-nghiem-thu-moc-c-checklist.md` (ops-core), giáo án
`docs/runbooks/release/huong-dan-su-dung/02-11-08-45-giao-an-tap-huan-doi-chay-thu-runbook.md`, checklist `13-08-21-04-production-manual-acceptance-checklist.md`.

## Đường vào (phiên kiểm 14/11 13:1x, chỉ đọc)

- `.99:8012` (Caddy) trả lời trong LAN khi đúng tên miền: `ops.` → 307 `/login`, trang login 200; `pwa.` → 307 `/pwa/tasks`; `trace.` 200;
  `api-ops.` `/health/live` HEALTHY. Gõ thẳng `http://192.168.1.99:8012/` → 404 (Caddy chỉ nhận theo tên).
- Tên miền công khai từ trong LAN: `ops.ginsengfood.vn` → `14.224.139.101`, gọi cổng 80/443 **hết giờ chờ** (không vòng ngược NAT, hoặc nginx chưa trỏ `.99`).
  ⇒ Sáng 15/11 người trong xưởng **không** vào được bằng tên miền như bình thường.
- Cách dùng ngày mai (mặc định phiên chọn): máy tính dùng nghiệm thu thêm 1 dòng vào tệp hosts (cần quyền admin máy đó):
  `192.168.1.99 ops.ginsengfood.vn pwa.ginsengfood.vn trace.ginsengfood.vn` rồi mở `http://ops.ginsengfood.vn:8012`, `http://pwa.ginsengfood.vn:8012`.
  Điện thoại/máy tính bảng không sửa hosts được ⇒ PWA chạy trên trình duyệt máy tính (chế độ điện thoại); thiết bị thật (P7, `MA-DEVICE-001`)
  dời tới khi Anh Tuấn mở vòng ngược NAT hoặc DNS nội bộ (tin nháp `ra-soat/2026-11-14-tin-nghiem-thu-15-11.md`).
- Chưa thử đăng nhập thật (phiên không có tài khoản `.99`). Bản đang chạy: `87acc810` (compose WP16, Development, cookie không `Secure` nên http dùng được).
  `deploy-99` bản mới chờ CI Linux (D-m12-060); nếu chưa xong trước buổi sáng thì nghiệm thu trên `87acc810` và ghi đúng SHA đó.

## Phạm vi sáng 15/11 (khoảng 8:00–11:30)

| Giờ | Việc | Ai | Kết quả ghi |
|---|---|---|---|
| 8:00–8:20 | Kiểm máy: hosts, đăng nhập từng vai, `/health/live`, menu theo vai (`MA-ACCESS-001` phần đăng nhập/menu) | Toàn | ảnh màn + giờ |
| 8:20–10:20 | Tập huấn rút gọn = giáo án buổi 1 + buổi 3 phần F3/F1 (đầu vào → lệnh SX → QC TP → phát hành → kho → truy xuất); mỗi người tự làm thao tác vai mình | Toàn hướng dẫn; Sang (xưởng), Khánh (QC/QA), Lan (kho/kế toán), chú Dũng (vận hành) | biên bản giáo án §7 |
| 10:20–11:00 | Chạy chuỗi `MA-CORE-FLOW-001` rút gọn trên một lệnh thử + truy xuất công khai nội bộ (`MA-PUBLIC-TRACE-001` phần LAN) | 4 người, Toàn ghi | mã lệnh/mẻ/lô, ảnh |
| 11:00–11:30 | Ký biên bản nghiệm thu **có điều kiện** (3 vai D-m12-013: Khánh QA Lead, Toàn Operations Owner, chú Dũng Product Owner) | 3 người | biên bản §8 |

Biên bản phải ghi đúng: theo manifest §8 thiếu điều kiện vào ⇒ `release_decision = NO-GO` cho chạy thật đầy đủ. Ngày 15/11 ký **"đạt các mục đã chạy, NO-GO
có điều kiện"**, liệt kê mục chưa đạt: P2 CI xanh trên SHA (CI Linux `.63`), P3 UAT còn ~468 ca, P4 11 ca M3, P7 thiết bị thật, HTTPS công khai trang
truy xuất, in tem + MISA (hoãn D-m12-002), `MA-RECONCILIATION-001`/`MA-OPERATIONS-001` (phiên tự chạy sau). Không ghi "sẵn sàng chạy thật".

## Chuẩn bị tối 14/11 (Toàn duyệt từng lệnh ghi trên `.99`)

1. Tài khoản theo vai trên `.99` cho 4 người (giáo án §4: R-PROD-MGR/OP, R-QC-*, R-QA-REL, R-WH-*, R-OPS-MGR): Toàn tạo qua giao diện
   *Hệ thống › Người dùng & Vai trò* hoặc duyệt lệnh phiên soạn; mật khẩu Toàn tự đặt, không ghi vào sổ/tin.
2. Một lệnh SX thử + dữ liệu đầu vào đủ chạy F1–F5 (dùng dữ liệu đang có trên `.99`, không nhập dữ liệu khách thật).
3. In 3 bản biên bản: bản điền sẵn phần kỹ thuật `wp/M12-010-bien-ban-15-11.md` (14/11 16:0x; bảng mục chạy, bảng mục chưa đạt, 3 chữ ký).
4. Gửi tin mời (nháp ở `ra-soat/2026-11-14-tin-nghiem-thu-15-11.md`).

## Còn lại / CẦN QUYẾT
- Giờ bắt đầu 8:00 là đề xuất; Toàn đổi trong tin mời nếu cần.
