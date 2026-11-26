# Trạng thái: m12

Mốc 26/11 08:4x (T5). Phiên m12 `M1-2`, mở lại sau chuyển account (00:45). Lịch sử ở `nhat-ky/2026-11-25.md` và `nhat-ky/2026-11-26.md`. Quyết định tới D-m12-142. Phiên UAT đã dừng lab và bàn giao lượt chạy độc quyền cho phiên triển khai Development.

- **ops-core:** `main` = `origin` = `gitlab` = **`d4163331c`**. Hai commit `973225ac4` (SOP kho NM3-44) + `d4163331c` (vá offset +07:00) đã được push: `gitlab` 07:35 từ máy này, `origin` thấy lúc fetch 08:00 (không phải phiên này push; ghi SHA). `deploy/` không đổi từ `7c7d07234` ⇒ 2 băm gói Production giữ nguyên; `d4163331c` không có migration. Dirty không phải của ta: 3 tệp supplier-portal admin-web. 0 khoá tệp. Còn 4 worktree tách rời cũ (C:/Temp/WP28-final…, codex shopfloor, G:/gfdocs/wt, G:/gfops-test-only/…): không dùng, dọn khi rảnh.
- **.99:** M1–M2 chạy `7c7d07234` (Development, từ 25/11 21:08); máy Lead chưa có ảnh `d4163331c` ⇒ .99 CHƯA có bản vá offset (không ssh kiểm). Đường lui `a0ccc740e`. Khoá mã hoá bằng chứng đã đặt (D-m12-139). Quên mật khẩu TẮT, đăng nhập mail BẬT. 19 SKU, 0 kích hoạt bán, 0 mẻ, 0 giữ hàng (đọc 25/11 21:3x). M3 gọi qua `http://192.168.1.99:5000` sạch.
- **Mốc:** nghiệm thu + tập huấn + MẺ THẬT đầu tiên sáng 27/11 (m12.203 = A) · chuyển Production 28/11 · chạy thật 30/11 · ngoại lệ JWT hết 30/11 16:59Z. Kịp 30/11: **VÀNG**. % sẵn sàng 47 (`SAN_SANG.md` 17/11, chưa tính lại).
- **Sheet tab M1-M2:** 123 việc = 60 hoàn thành · 5 huỷ theo quyết định · 58 còn mở (29 nối M3, 29 khác). Phiên rà đã ghi và đọc lại năm dòng gộp/tạm gác/cắt. Kết luận 10 hồ sơ đã lưu trong phiếu rà vì CLI hiện chỉ đọc W/X.
- **Sổ nghiệm thu:** 2.326 bước = 1.814 đạt · 0 không đạt · 59 không áp dụng · 453 chưa chạy, sau 2 ca L01 và 2 ca truy xuất của lượt 26/11. L25 đã hoàn tất 11 ca IT. Ưu tiên tiếp L12, L14–L18 qua lab. [Hồ sơ lượt UAT](ra-soat/2026-11-26-luot-uat-codex.md)
- **Luật:** D-lead-063 (một checkout, khai khoá, chỉ phiên chính commit theo đường dẫn) · D-lead-064 (kiểm hai mức, lên .99 không qua CI). Push, ssh/.99, cờ production, `.env`: chỉ khi Toàn nói rõ đúng việc.

## Gói chuyển Production `.99` (`deploy/m12/chuyen-production-99/`)

P0–P7 + `lui.sh`, qua 3 lượt verifier. P0 chạy chỉ đọc 25/11: còn 1 tệp bằng chứng bản rõ (ảnh thử 20/11) → chuyển thư mục `evidence` đi lúc chuyển. P1–P7 CHƯA chạy. Cần Toàn: SHA (đề xuất `d4163331c`) + 2 băm (compose `1df348da…1a550`, Caddyfile `3639671f…f7a3c`), xác nhận khoá JWT mới ≠ khoá lịch sử, báo Phúc M3 gián đoạn 1–2 phút, chạy trong tmux, duyệt các pha liền một lượt.

## Nối M12 ↔ M3 (29 việc còn mở sau cập nhật Sheet)

Production 28/11 có 11 việc. Mẻ thật 27/11 có 5 (M12-054/077/051/052/094). Hypercare 28–30/11 có 6. Còn 7 mục theo dõi quyết định và điều kiện (M12-050/085/066/078/079/067/070). M12-056/063/093 đã đóng theo quyết định giữ IP và cắt sự kiện vòng đời. NK-b giữ NO-GO tạm cho giữ/nhả hàng thật vì cần mẻ bán được và bằng chứng đầu-cuối trên môi trường đã duyệt. Bằng chứng 25/11 và kế hoạch S01–S18 ở [hồ sơ nối M3](ra-soat/2026-11-26-noi-m3-codex.md).

## Cần Toàn quyết / làm tay (theo hạn)

- **m12.243b:** Toàn đã duyệt đúng `d4163331c` lên `.99` Development. Phiên triển khai đang giữ lượt, kiểm trước/sao lưu/dựng 5 ảnh đúng commit/nâng và kiểm sau. Chờ bằng chứng bản thực tế đang phục vụ. Phần push đã xong.
- **Toàn chuẩn bị tối 26/11:** `wp/M12-010-bo-sang-27-11.md` §1 (ca, vị trí kho, NCC + vật tư thật từ Lan/chú Dũng, kích hoạt bán 1 SKU, nội dung công khai đã duyệt, ghép điện thoại Sang). Giữ hai kho Bình Phú theo công dụng và tên hiện tại, Phúc đã được báo theo nhật ký 25/11.
- **m12.244:** bản và hai băm đã được chọn theo đề xuất, chờ cửa sổ 28/11 và lệnh riêng cho các pha. Trước khi thực thi cần đối chiếu lại P0, JWT, kho bằng chứng và thông báo cho Phúc.
- **m12.240/241/242 đã chốt A/A/A.** Phiên Sheet nhận phần giữ đường IP và cắt sự kiện vòng đời. Lịch giám sát còn chờ lệnh `go m12.242`.
- **m12.245/246:** đã rà 10 hồ sơ, gộp M12-038/025 trên Sheet, giữ kết luận cần ghi W/X trong [phiếu rà](ra-soat/2026-11-26-review-sheet-codex.md). Toàn duyệt diff R3/WP32 theo từng hồ sơ.
- **Các điều kiện còn mở:** NK-b chờ rà WP07b và bằng chứng đầu-cuối; m12.204 chờ xác nhận lô cũ cần nhập nếu có; DIET-2 chờ chú Dũng; SEC-11 sau 30/11; CI đêm chờ quyền; MISA và in tem hoãn. Kết luận cổng Nguy hiểm và góp ý UAT ở D-m12-140.

## Còn nợ (không chặn 27/11)

WP17b: OPS-01 kho bằng chứng (m12.207), hồ sơ đóng ngoại lệ JWT, 2 smoke Docker · WP28 cổng bố cục (1,5–2 ngày) · WP33 phần còn lại · lịch CI đêm (token GitLab) · app xưởng còn bảng tên vai cũ · lệnh Npgsql trực tiếp ngoài EF (`EfPrinterNonceStore`, `EfTraceLinkWriter`) chưa phủ giờ có offset · mẫu DB lab `uat2710_tpl` có 8 outbox dead-letter · sổ UAT cũ có 228 ký tự CR.

## Kế tiếp

1. Phiên triển khai thực hiện m12.243b đã duyệt, ghi bản phục vụ, health, đăng nhập và M3 gọi 200, rồi trả lượt cho UAT.
2. UAT giao diện bằng trình duyệt tích hợp: trước 6 lô theo đường mẻ thật (L12, L14–L18, 108 ca), lỗi thật sửa trong ngày.
3. Bộ 27/11 đã cập nhật kịch bản, tập vai và biên bản mẻ thật. Phiếu `ra-soat/2026-11-26-chot-27-28-11.md` có quyết định theo hạn, điều phối NM3-45b, hai băm Git và lệnh P0–P7 cho cửa sổ đã duyệt.
4. Sau mẻ thật 27/11: NM3-45b (S01–S18 trên .99).
