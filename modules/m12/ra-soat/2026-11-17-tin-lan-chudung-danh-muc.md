# Tin nháp Toàn gửi chú Dũng + Lan · xin danh mục thật cho M1–M2 · 17/11/2026 (KHÔNG GỬI — D-m12-092: danh mục nhập sau khi vào vận hành)

Theo D-m12-089 (m12.119 B): DB chạy thật trên `.99` dựng SẠCH, nạp danh mục thật; hạn dữ liệu **thứ Bảy 22/11**; thiếu thì lui giữ DB hiện tại.
Gửi kèm: phiếu xin dữ liệu `ginsengfood-ops-core/docs/runbooks/release/01-11-00-43-phieu-xin-du-lieu-that-thi-diem-runbook.md` (bản đọc được,
xuất .docx/.pdf nếu cần) + 10 tệp mẫu `docs/templates/pilot-master-data/01…10-*.csv` (KHÔNG gửi thư mục `fake/`).
Xưng hô với Lan: bản nháp để trung tính, Toàn chỉnh theo thói quen.

## Chia việc theo phiếu (mục 4)

| Nhóm | Tệp | Ai | Bắt buộc cho 30/11 |
|---|---|---|---|
| 1 Nhà cung cấp | `01-nha-cung-cap.csv` | chú Dũng (chủ hàng, phòng mua) | có |
| 2 Nhà cung cấp – vật tư | `02-ncc-vat-tu.csv` | Lan (phòng mua) | có |
| 7 Ca sản xuất | `07-ca-san-xuat.csv` | chú Dũng (quản đốc) | có |
| 8 Kho, vị trí kho | `08-kho-vi-tri.csv` | Lan (thủ kho) | có |
| 9 Tổ trưởng, người ký | `09-to-truong.csv` | chú Dũng (quản đốc) | có |
| 10 Vật tư đối chiếu + tồn đầu kỳ | `10-vat-tu-doi-chieu.csv` | Lan (thủ kho), chú xác nhận | có |
| 4 Tham số công đoạn (H01) | `04-tham-so-h01.csv` | chú Dũng | có (manifest H01) |
| 5 Hướng dẫn cấp đông/sấy | `05-huong-dan-7a.csv` | chú Dũng | nên có |
| 6 Nội dung công khai 19 SKU | `06-noi-dung-cong-khai.csv` | chú Dũng (marketing) | nên có (trang truy xuất QR) |
| 3 Artwork, mẫu quét hộp | `03-artwork-quet-box.csv` | chú Dũng + Lan quét mẫu | sau (in tem tại xưởng đang hoãn) |

Ghi chú kỹ thuật (cho Toàn): nhóm 1, 2, 7, 8, 9 nhập qua giao diện quản trị SAU khi lên DB sạch (cổng E-07 bắt các bảng này trống trước);
CSV là bản nháp để kiểm trước bằng `Test-PilotMasterDataIntake.ps1` (phiếu mục 6), rồi người được giao nhập lại trên giao diện.

---

## Tin gửi chú Dũng

Dạ chú, tụi con chốt bản chạy thật M1–M2 ngày 30/11 sẽ dựng dữ liệu sạch, không xài lại dữ liệu chạy thử nữa. Nên con nhờ chú gửi giúp con danh mục thật trước thứ Bảy 22/11 nha chú: nhà cung cấp, ca sản xuất, tổ trưởng với người ký, thông số từng công đoạn, hướng dẫn cấp đông với sấy, nội dung công khai cho 19 sản phẩm. Phần kho với tồn đầu kỳ con nhờ Lan làm, chú xem lại giúp con.

Mỗi mục có sẵn một tệp mẫu, chú điền theo cột là được, chỗ nào chưa chắc chú cứ ghi chú bên cạnh, con kiểm rồi hỏi lại. Nếu tới 22/11 chưa đủ thì con giữ dữ liệu cũ để kịp ngày, rồi bổ sung sau.

Chi tiết con để trong file nghen chú.

## Tin gửi Lan

Lan ơi, M1–M2 chạy thật ngày 30/11 sẽ dựng dữ liệu sạch, nên nhờ Lan gửi giúp mấy danh mục này trước thứ Bảy 22/11 nha: nhà cung cấp với vật tư từng nhà cung cấp, danh sách kho và vị trí kho, vật tư đối chiếu với tồn đầu kỳ thật (Lan kiểm đếm rồi chú Dũng xác nhận).

Có sẵn tệp mẫu, Lan điền theo cột là được, chỗ nào chưa rõ cứ ghi chú bên cạnh. Lên bản mới thì từ nay Lan là người đóng phiếu nhập nguyên liệu và nhập giá phiếu bao bì, kho không đóng phiếu nữa; có gì vướng Lan nhắn liền nha.

Chi tiết để trong file.
