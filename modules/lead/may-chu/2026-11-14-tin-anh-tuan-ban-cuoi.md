# Tin gộp gửi Anh Tuấn · bản cuối (bản 3) · 16/11/2026 07:3x · Toàn tự gửi (phiên không gửi) · **CHƯA GỬI**

Bản 3 (16/11 07:3x, Toàn dán lại câu chữ của mình, phiên lead soát): giữ lời Toàn, sửa 4 chỗ — "tối nay" → "từ tối thứ Bảy tới giờ" (.63 vẫn mất
07:28 16/11); thêm "khởi động lại"; ý 2 thêm "trên máy .98" và hạn thứ Tư 18/11; ý 4 thêm lại câu "để nguyên ít bữa" (chưa có sao lưu ngoài .99).
Kiểm 07:3x: .98 cổng 3000 `/admin/` = 200, cổng 6600 `/api/admin/ads/dashboard` = 401 (M6 giữ nguyên tiền tố đường, chuyển nguyên đường là đúng), cổng 80 đóng
→ Anh Tuấn chia đường thẳng vào 3000/6600, thay cách nginx :80 của Tài trong D-lead-041.

lead.h2, D-lead-046. Thay mục 2 của `2026-11-14-tin-mkt-ram-63.md` và tin cuối `2026-11-14-ke-hoach-may-dev-63.md`.
**Chỉ gửi tin, không gửi tệp kèm** (Toàn 20:3x: "ảnh tự biết ảnh cần làm gì") — tệp kèm bản 1 đã bỏ.

Bản 2 theo góp ý Toàn 20:3x:
- Ý 1: Tài đã chạy xong trên .98 (M5 cổng 3000, M6 cổng 6600) → bỏ câu "Tài đang dựng", Anh Tuấn chia đường thẳng vào hai cổng.
  Kiểm 20:33: `192.168.1.98:3000` (M5) và `192.168.1.98:6600` (M6) nghe trên LAN, không có gì ở cổng 80 → **khác D-lead-041** (nginx :80 của Tài
  chia đường); chờ Toàn chốt. Giữ một câu đường `/api/admin/ads/` → 6600 vì Anh Tuấn không có cách nào tự biết đường đó.
- Ý 2: RAM cố định từ 8 GB trở lên, Anh Tuấn tự mở thêm.
- Ý 3: lý do mượn .63 theo lời Toàn (máy cá nhân không kham nổi nhiều luồng Claude + CI); bỏ câu hỏi .63 chung máy vật lý.
- Ý 4 (mới): .60, .61 không dùng nữa. Kiểm 20:3x: .60 chỉ còn CSDL M3 cũ + clamav (app dừng, M7 không chạy ở .60); .61 app M1-2, M8 dừng hết, còn
  container CSDL thử cũ `audit_m9_testpg` và cụm microk8s + Prometheus chung .61/.63/.64 (không phải của mình, lead.26). Xin Anh Tuấn **để nguyên ít
  bữa** vì M3, M8 chưa có bản sao lưu ngoài .99 — dữ liệu cũ trên .60/.61 là bản dự phòng duy nhất ngoài .99.
- Ý 5 (mới): nhắc tin đề xuất chia máy hôm trước (máy 1 .99, máy 2 .98 đã có) → còn thiếu máy video M7 và máy thử giống .99.

- 20:40 (bản 2b): **.63 mất kết nối** sau 20:14 (lần cuối phiên vào được). 20:36: ping từ máy Lead "Destination host unreachable", ARP trống cả từ máy Lead
  lẫn .64 (cùng mạng), ssh hết giờ; .64, .98, .99 bình thường → VM .63 treo/tắt (m12 phụ báo, lúc đó có job ops-core Unit + M7 dev + microk8s). Phiên không có
  quyền bảng Hyper-V → đưa "khởi động lại .63" lên ý 1 (gộp với ý .63 cũ), các ý sau lùi số. 20:4x Toàn thêm: nhờ Anh Tuấn **tìm nguyên nhân** ping không được,
  vì .63 từng bị một lần trước đây (Mạnh đã nhắn Anh Tuấn khắc phục; sổ không ghi lần đó).

## Tin Zalo

```text
Dạ anh Tuấn, em nhờ anh xem giúp em:

1. Máy .63 từ tối thứ Bảy tới giờ em ping ko được, vô cũng ko được luôn. Anh khởi động lại rồi coi giúp em sao bị vậy với. Bữa trước máy này bị một lần, a Mạnh có nhắn anh khắc phục dùm. Máy này em đang mượn chạy CI với thử Module 7 video, tại em chạy nhiều việc cùng lúc, nhiều luồng Claude với CI của mấy module, máy cá nhân em chạy ko nổi nên em đưa lên .63.

2. Tên mkt bữa em nói Tài báo cổng sau, Tài dựng xong rồi trên máy .98: phần kết nối Facebook ở cổng 3000, phần đo quảng cáo ở cổng 6600. Anh làm HTTPS rồi đẩy vô giúp em: /api/admin/ads/ vô cổng 6600, còn lại vô cổng 3000 hết. Anh làm trước thứ Tư 18/11 được hong anh, để tụi em kịp thử.

3. Máy .98 đang để RAM động, giờ máy chỉ thấy hơn 3 GB. Anh để cố định giúp em từ 8 GB trở lên được hong anh?

4. Máy .60 với .61 giờ tụi em ko dùng nữa, phần mềm chuyển qua .99 và .98 hết rồi. Anh để nguyên giúp em ít bữa nha, trong đó còn dữ liệu cũ em giữ làm dự phòng, xong em báo anh thu hồi.

5. Bữa trước em có nhắn dựng giúp em 4 máy, anh đã dựng máy 1 với máy 2. Bên em còn cần thêm 1 máy chạy video Giờ Vàng (Module 7) với 1 máy giống máy 1 để thử bản mới trước khi đẩy lên .98, .99. Khi nào anh sắp xếp được làm giúp em nha.

Em cảm ơn anh nhiều!!!
```

## Ghi khi có tin (phiên lead ghi giờ)

- [ ] Toàn đã gửi Anh Tuấn — giờ:
- [x] .63 lên lại — giờ: **16/11 10:14** (máy được khởi động lại; runner `gitlab-runner-63` nhận job ngay, bộ M7 tự chạy; đã báo m12 phụ, Phiên M12, m7-tren-63). Nhật ký lần chạy trước dừng ngang 14/11 20:31:50, không có dòng hết RAM, kernel panic hay treo đĩa → VM đứng ở tầng máy ảo/máy chủ vật lý; trước đó microk8s `kubelite` tự khởi động lại 6 lần từ 17:47, `calico-node` lặp lỗi (cụm lead.26, không phải của mình). Lịch sử: **15/11 01:01 vẫn mất** (canh 4 giờ hết hạn; ping "unreachable", ARP trống, ssh hết giờ; .64/.98/.99 bình thường) → phải chờ Anh Tuấn; **11:02 vẫn mất** (canh 14 giờ), ngừng canh nền, đã báo m12 phụ tự kiểm khi Toàn báo lên (phiên hạ tầng, báo m12 phụ kiểm runner `may-63` + pipeline ops-core; xem `journalctl -b -1` tìm nguyên nhân treo)
- [ ] `mkt.` HTTPS → .98 (6600 cho `/api/admin/ads/`, còn lại 3000) — hẹn ngày: · phiên lead kiểm từ ngoài (check-host.net): chứng chỉ hợp lệ,
      `/admin/` tới M5, `/api/admin/ads/` tới M6
- [ ] RAM .98 cố định ≥ 8 GB — xong lúc: (phiên lead kiểm `free -m` trên .98)
- [ ] .63 · .60/.61 để nguyên tới khi Toàn báo thu hồi · máy video M7 · máy thử — Anh Tuấn trả lời:
- 16/11 sáng: Toàn ĐÃ GỬI tin gộp (bản 3 + câu card M7 + câu HTTPS). 10:02 D-lead-050 sửa phần `mkt.`: chỉ chuyển `/api/admin/ads/` → 6600, `/admin/`, `/api/admin/`, `/api/channel/meta/` → 3000, `/` → `/admin/`, còn lại 404 — tin bổ sung `modules/m5/ra-soat/2026-11-16-tin-anh-tuan-mkt.md` (CHƯA GỬI).
