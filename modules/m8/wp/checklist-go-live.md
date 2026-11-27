# Checklist trước go-live M8 (gom những điều kiện đã biết; chưa đủ để gọi khách thật)

Lập 26/11/2026 từ các cổng Nguy hiểm vùng 1–3 và quyết định D-m8-161/162 (m8.147). Nguồn: [cong-nguy-hiem.md](../cong-nguy-hiem.md), [giong-thuc-te-thiet-ke.md](giong-thuc-te-thiet-ke.md), [tinh-vung-thiet-ke.md](tinh-vung-thiet-ke.md), [ho-so-phat-hanh-07F.md](ho-so-phat-hanh-07F.md). `REAL_CUSTOMER_CALL_ALLOWED=NO` cho tới khi Toàn tự quyết. Mỗi dòng: việc · ai · trạng thái.

## 1. Thứ tự lên .99
- [ ] Sao lưu CSDL M8 trước khi lên (cron 02:30 đã có; chụp thêm một bản ngay trước) · Toàn.
- [ ] **M8 lên TRƯỚC, M3 sau.** Các trang quản trị mới của M3 gọi 26 tuyến draft.50 (và 6 tuyến draft.51); .99 đang chạy `f8e29b46` (sổ 21/11, chưa kiểm lại) · Toàn (pipeline M8) rồi Phúc (bản M3).
- [ ] Migration chạy TRƯỚC khi bản mới nhận việc: W0565 (giọng, nghe thử, trần), W0581 (bản dẫn xuất), W0582 (cột tốc độ đã phát), W0586 (tỉnh–vùng). Bản mới trên lược đồ cũ từ chối phục vụ (đã có test); `SpeechPhraseRetention` truy vấn bảng bản dẫn xuất kể cả khi công tắc tắt · Toàn.
- [ ] Kiểm sau lên: `/health/live`, `/health/ready`, JWKS, 26 + 6 tuyến trả đúng mã với token đủ quyền, trần hiển thị, lùi bằng bản trước (có lệnh trong `deploy/m8/README.md`).

## 2. Cấu hình bắt buộc/khuyến nghị trên .99
- [ ] **Trần thời lượng cuộc**: `PlaybackCallLimitSeconds` là cấu hình BẮT BUỘC (1–300); **120 chỉ là giá trị mẫu** ở `closed-profile.example.json`, không phải mặc định của mã (m8.147). Đặt và kiểm khởi động (production không có thì từ chối chạy).
- [ ] `Ivr:Telephony:DailyBudget:Enabled=true` ở worker VÀ ở API (API đọc để hiển thị; thiếu thì màn hình báo tắt trong khi worker vẫn chặn). Số trần KHÔNG ghi trong cấu hình: nhập trên màn hình.
- [ ] API: `Ivr:Speech:Tts:Prerendered` (ManifestPath + sha), đủ 3 `RegionalVoices`, `Ivr:Speech:Phrases:MediaDirectory` (để nghe cụm); `Ivr:Voice:ProfileSource=OPTIONS`, `Ivr:Voice:RegionSource=OPTIONS`, `Ivr:Voice:Variants:Enabled=false`, `Ivr:Voice:Preview:Synthesis=OFF` (mặc định; bật chỉ khi Toàn nói, cho CẢ API và worker + `Phrases:Enabled`).
- [ ] Người nhận cảnh báo ngoài giờ + người trực (X-04); hiện chưa có luật báo "chưa đặt trần" (m8.145 = C: chỉ checklist) nên nhập trần là việc thủ công.

## 3. Nhập trần trước giờ bật (D-m8-138)
- [ ] Chưa có trần ⇒ worker KHÔNG quay (`CEILING_UNSET`), không có báo động. Toàn nhập cuộc quay/ngày + giây có người nghe/ngày trên màn hình "Trần gọi mỗi ngày"; hạ trần ≤ mức đã dùng hôm nay phải kèm xác nhận. Ở tốc độ 0.80 giây có người nghe tăng ≈ 25% cho cùng số cuộc: tính khi đặt trần.

## 4. Bật giọng/tốc độ/vùng thật (chỉ khi Toàn nói; từng bước, mỗi bước lùi được bằng cờ về OPTIONS)
- [ ] Dựng 6 cặp bank mới ở .99 (≈ 37 phút máy; Phúc hoặc Toàn chạy công cụ trong mạng của worker) · Toàn nghe duyệt 6 cặp mới · đổi ghim bank (`bank-stage`).
- [ ] Toàn **nghe thử tốc độ 0.80 và 1.20** trên chính câu có SỐ TIỀN (nguy cơ nghe sai số: ở 1.20 bỏ ≈ 17% sóng); khuyến nghị chỉ bật thật trong 0.90–1.10 cho tới khi nghe xong hai mép (lệnh `Ivr.Ops tempo-listen` hoặc nghe thử trên màn hình).
- [ ] Hash vàng của bộ co giãn tái hiện trên Linux (CI); bật `Variants:Enabled` ở worker, chờ bản dẫn xuất đủ (readiness 100%), `:warm`, nghe 1–2 cụm mới.
- [ ] Bật `ProfileSource=STORE`, kích hoạt hồ sơ (một vùng, hoặc cả bộ để hoán đổi giọng); đối chiếu `voice_speaking_rate` của lượt gọi kế.
- [ ] Đổi vùng của một tỉnh: xem thiếu → làm nóng → nghe → áp dụng (có lý do) → bật `RegionSource=STORE`; đơn đã nhận mà chưa quay theo vùng MỚI (m8.152 = A).
- [ ] Pháp lý mô hình giọng (`MODELS.lock` PENDING_SEP_SIGNATURE, X-03) chặn bật production: chưa đóng.

## 5. Quét và bằng chứng trước push/lên máy
- [ ] gitleaks chế độ git trên lịch sử (đã quét diff: 21 phát hiện giả), `oasdiff` baseline draft.50 → draft.51 chỉ thêm, trivy ảnh, CI bộ đủ (đã chạy tay 26/11: integration 1550, unit 2705, contract 33, media 14, chaos 8, python 458).
- [ ] Verifier độc lập cho phần giọng thật và tỉnh–vùng (đang làm 26/11; đột biến sau khi hợp đồng draft.51 xong).
- [ ] Việc ngoài: MobiFone gọi thử + công thức cước, custody khoá, token GitLab (lịch đêm), sudo .64 (khung bảo trì ufw RTP, CDR, thay chứng thư lá ARI hết hạn 13/01/2027), số nội bộ cho gọi thật 01D.
