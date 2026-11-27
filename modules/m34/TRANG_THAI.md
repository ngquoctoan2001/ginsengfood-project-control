# Trạng thái — m34

Mốc: 27/11/2026 16:5x (+07) · **D-m34-108 (D-lead-060): chỉ Phúc ghi .99 cho repo bán hàng; phiên m34 CHỈ ĐỌC .99**
· BP: local `toandeptrai` = `425192fec` (menu IVR cấp 0, CHƯA đẩy) trên `gitlab/dev` = `origin/dev` = `gitlab/PhucApu` = `662642874` (27/11 14:37, Phúc lượt đồng bộ bản 5; gộp vào `toandeptrai` bằng fast-forward 16:2x, migration cao nhất V416, 0 lỗi) · `gitlab/toandeptrai` `2a255c521` · `origin/dev015` `f1d7c206d` (Tài, MR !183) · M4-PLAN local `a1245e55f`, sau `origin/main` 106 commit (chưa pull)
· Đẩy CHỈ lên GitLab, GitHub nhận qua gương (D-m34-117); cách "đồng bộ dev": `PHIEN.md` mục "Git của repo bán hàng". Lần sau viết migration lấy từ V417.
Sẵn sàng: **40%** (chấm 10/11, chưa chấm lại) · 30/11: ĐỎ.

## Đang làm (27/11): giao diện quản trị IVR — phiếu [wp/ivr-menu-kit-2711.md](wp/ivr-menu-kit-2711.md)
- Toàn 27/11 16:2x: "Quản trị IVR" ra menu cấp 0 cùng cấp Vận hành bán hàng, các tab thành mục menu, mọi màn IVR theo ui-kit-v2 (phân trang chưa đúng mẫu).
- XONG `425192fec` (chưa đẩy): nhóm "Quản trị IVR" 12 mục, bỏ thanh điều hướng con, đường dẫn trang từ "Quản trị IVR", 12 đường dẫn cần `IVR.VIEW`; vitest 659/659.
- ĐANG CHẠY: coder A (khung + Tổng quan, Danh sách xác nhận, Giám sát, Kênh gọi, Ngoại lệ, Báo cáo, Cấu hình) và coder B (Luật gọi, Điều kiện gửi đơn, Giọng đọc,
  Cụm tên địa bàn, Tỉnh–Vùng); khoá `m34/ivr-kit-a`, `m34/ivr-kit-b`; ảnh trước/sau `C:\Projects\_wt\_luu\m34\ivr-kit-2711\`. Next dev cổng 3107 (phiên m34 giữ, tắt khi xong gói).
- Lên .99: chỉ Phúc, sau khi Toàn cho "đồng bộ dev".

## Luật gọi cấu hình được + hàng chờ nhân viên (phần M3; theo dõi chung `modules/lead/wp/theo-doi-luat-goi.md`)
- Mã M3-02…07 đã trên `dev` từ 21/11 (D-lead-063); cờ `app.ivr-rules.mode` mặc định `LEGACY_V4`. D-lead-064: M3-04/M3-05 vùng Nguy hiểm → cổng trước khi bật `M8_RULES`; lỗi nhẹ trong Nợ (`wp/luat-goi-m3.md` §6).
- 27/11 Codex (`nhat-ky/2026-11-27-codex-dong-bo-gitlab.md`): V414–V416 + hạn mức/chứng cứ M8 vào dev qua `2a255c521`; chính sách tắt, MOCK. CHƯA CHẠY: bộ đủ, trình duyệt, M8 thật.
- D-m34-110/111: chế độ mới đảo QT-CHUNG-011/015, giữ 016.

## Giọng đọc + trần cuộc/ngày (G-08/G-09/T-02, D-m34-114/115)
- Mã XONG trên `dev` (26 tuyến M8 draft.50, FE voices/phrases/thẻ trần, V411 bốn quyền không gán sẵn). CHƯA CHẠY: trình duyệt thật + M8 thật, cổng Nguy hiểm.
- Lên .99 chỉ Phúc, SAU khi M8 lên bản có 26 tuyến (gói `ra-soat/2026-11-26-ban-giao-phuc-giong-doc-tran-ngay.md`). Chờ hợp đồng draft.51 của M8.

## Trang bán hàng ra Internet (https://ginsengfood.vn từ 17/11)
- OTP giả + nối M3 → M8 TẮT trên .99 bằng `compose.cong-khai.yml` (D-m34-105, 18/11 08:32). Watchdog IVR tắt theo cờ; quản trị IVR giữ.
- Khung E (`wp/khung-e-1811.md`) DỪNG, làm lại với Phúc chạy `lui`/`tat`. Đồng hồ M3: gọi cuối ≤ +15 phút, kết quả ≤ +17 phút (D-m34-106).

## M4 / Tài (chưa rà lại từ 20/11)
- 20/11: khoá Claude trên .99 bị 401 (42/42) → chat ra câu mẫu; tin nháp Tài + tin đồng bộ GitLab↔GitHub trong [rà 20/11](ra-soat/2026-11-20-m4-dev-tai.md), CHƯA GỬI.
- Khung chat FE bật trong ảnh từ `3627ce4f0` → lên .99 là người ngoài thấy (m34.129); P0 `FIX-CHAT-CHILD-GATE-LEAK-PUNCT-001` của Tài phải xong trước khi gắn Page khách thật.
- 27/11: `dev015` có M4-026 + M3-168 (MR !183), M3-SHIP-SPX-NOBOOK-001; M4-PLAN mới (diễn tập M5 16:00, M6 P0). Chưa đọc chi tiết.

## Nối M12 ↔ M3 trên .99
- XONG 17/11 (D-m34-100–102). Còn: bật quan sát (m34.124: `OPS_CORE_*` + restart be, ENFORCE + giữ hàng tắt).
- D-m34-095: M2 đổi DB sạch 29–30/11 → M3 tắt giữ hàng/ENFORCE/OPS_CORE trước giờ đổi, nạp lại link khi M2 có kho.

## NK-b (phiếu `wp/SUA-SAU-RA-SOAT-NKB.md`, tạm dừng tới khi Toàn lệnh)
- Gói 10 `sec22` (M3-164) · gói 2 `kien-truc` · gói 11 `chay-99`. Bộ ngắt mạch theo ngăn `75663cf47` đã vào dev.

## M3 → M8 (IVR)
- Nghiệm thu 15/11: E01, E02, E03, E05, E06-A/B, E10 ĐẠT; E07/E02/E03/E08 dời; lần tới đọc lại id đơn (`_wt/m34/_tools/doc-id-don-99.sh`).
- Tab "Cước gọi" M3 + M8 đã trên .99 (20/11). Chưa thử đầu-cuối: Toàn mở IVR → Báo cáo → Cước gọi, kỳ vọng bảng rỗng, không lỗi.

## Phúc / Tài
- Rà Phúc 17/11: 3 Đạt, 36 Cần sửa; tin nháp CHƯA GỬI. 27/11 Phúc đẩy dev 12 commit (Giờ vàng worker, OTP email 10 phút, menu Hoa hồng → Hội viên, DropdownSelect, SKU M12).
- Tài: tự gộp MR vào `dev` trên GitLab; contracts PR #2 chưa ai review.
- Chưa kiểm Sheet M3/M4 từ 18/11.

## Máy
- `don_may -Dung` 27/11 16:2x: 0 tiến trình, 0 container dừng (giữ `ginsengfood-postgres-local`, `m12-uat-2711-pg`). Next dev 3107 của m34 đang chạy.

## Quyết định đã áp (chi tiết `QUYET_DINH.md`)
- D-m34-001…117 như sổ cũ. Luật giữ: KHÔNG ghi .99 (D-m34-108); không push/PR/gửi tin khi Toàn chưa nói rõ từng lần; không sửa nhánh chú, không nhắn chú. M9 thuộc luồng `m9`.

## Câu hỏi mở
- m34.129 (khung chat khi tên miền đã mở, gắn với khoá Claude).
- m34.135 (LEGACY_V4, chưa gấp): huỷ đơn giữ vì lỗi kỹ thuật ở chế độ cũ vẫn tính vào khách; đề xuất giữ LEGACY, sửa sau khi chạy luật mới; hạn: trước khi bật `M8_RULES` thật.
