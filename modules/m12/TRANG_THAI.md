# Trạng thái: m12

Mốc 21/11 10:1x (T7), phiên m12 mới mở (`/phien m12`).

- **ops-core:** `main` cục bộ `bb3e8b48e` · `origin` = `gitlab` = `af0beda56` ⇒ **10 commit chưa push** (`272c0808d..bb3e8b48e`, 20/11 16:55 → 21/11 10:03).
- **.99:** chạy `3e84ab68b` trên DB sạch `ginsengfood_ops_production` (157 migration, D-m12-126/128); DB cũ giữ lưu trữ. WP30–33 chưa lên.
- **Sẵn sàng:** 47% (`SAN_SANG.md` 17/11, chưa tính lại). Kịp 30/11: **VÀNG** (WP17b chưa ai làm).
- **Mốc** (D-m12-088): M-c ≤ 25/11 Production · M-d 28/11 · 30/11 chạy thật; ngoại lệ JWT hết 30/11 16:59Z.
- **Luật mới D-lead-063 (21/11 10:0x):** không worktree/bản sao; mọi phiên sửa thẳng `main`, khai khoá `tools/khoa_tep.py`, chỉ phiên chính commit theo đường dẫn.

## Tình hình

- **Phiên m12 khác đang chạy** (`local_cf1de578`, "m12 · M1–M2 vận hành + rà release") giữ WP30–33; phiếu `wp/M12-WP30-33-gop-y-20-11.md`:
  - WP30, WP31 ĐẠT kiểm; WP32 màn hình ĐẠT, máy chủ sửa lộ thời gian `610243558` chờ kiểm lại; cờ đặt lại mật khẩu TẮT;
  - WP33: P1a, P1b, P2, P3a, P4-BE, P4-FE ĐẠT; P5-BE `4014ce5a8`, P8a `bb3e8b48e` (migration 159) chờ kiểm;
  - pipeline #3093309855 (`af0beda56`) đỏ, đã sửa ở `e5b29ccc5` + `97d09da6c` (chưa push).
- **3 tệp dirty** supplier-portal (`FeedbackDialog.tsx`, `IntakeActivitySection.tsx`, `FeedbackPackagingDialog.tsx`): không thuộc WP30–33, chủ chưa rõ ⇒ làm né.
- **Phiếu ĐANG LÀM không phiên nào chạy:** WP24 (`120b2ea7e` 19/11), WP25 (chờ bộ đủ 18/11), WP27 (`3be14c8e5` 19/11), WP28 (`932b727bb`, cổng chưa chạy), WP12g đợt 2, WP-UAT sóng 0 (đứng từ 17/11). WP26 chờ Toàn duyệt diff R3 đợt 2.
- **WP17b:** mã chưa ai sửa từ 17/11 (`deploy/m12/**` không commit mới): OPS-01 kho bằng chứng, cổng JWT sau 30/11, compose Production.
- **36 worktree cũ** `_wt/m12` (D-lead-063 bảo dọn). Khoá tệp: chưa ai khai.
- **Dọn máy 10:0x:** dừng 13 tiến trình mồ côi (7 MSBuild, 5 tail, 1 bash), không đụng phiên còn sống.

## Cần bạn quyết

- **m12.200** phiên này nhận gói nào: A WP17b phần mã · B cổng WP28 · C WP-UAT. Đề xuất A.
- **m12.201** soạn tin mời nghiệm thu + tập huấn sáng 27/11 và sửa kịch bản M12-010 theo .99 DB sạch: có/không. Đề xuất có (gửi trước 24/11).
- **m12.202** 6 phiếu bỏ dở: A rà nhanh (1 scout chỉ đọc) rồi gộp phần còn lại · B để sau WP33. Đề xuất A.
- **m12.203** (Phúc 21/11: M3 nối kho `WH-20112026-000002`, 19/19 SKU, M12 trả "không bán được" — đúng thiết kế, DB sạch chưa có mẻ; `ra-soat/2026-11-21-m3-ban-duoc.md`) cách có mẻ bán được: A mẻ thật đầu tiên với xưởng · B mẻ thử qua API trên .99 rồi khoá bán · C chờ 30/11. Đề xuất A.
- **m12.204** chạy thật có hàng thành phẩm làm trước cần bán qua M3 không? Có ⇒ làm luồng nhập lô TP cũ (R3) vì tồn đầu kỳ nhập tay không bán được.
- (Số bắt đầu 200 để khỏi trùng phiên đang chạy, phiên đó đã dùng tới m12.190.)

## Việc chặn

- Lên .99 WP30–33: phiên kia push + pipeline tay (biến JWT) + `deploy-99` (D-m12-129 mục 181).
- Cờ mail .99 `true` trong `.env` nhưng API chưa tạo lại ⇒ lượt `deploy-99` kế sẽ bật luôn. Gắn mail công ty 5 người: Toàn.
- M3 quan sát trên DB sạch: Phúc đã nối kho + 19 SKU (21/11); còn thiếu mẻ đủ chuỗi + kích hoạt bán SKU (m12.203).
- Cổng JWT chỉ có nhánh gia hạn lần 3 ⇒ sau 30/11 16:59Z không ra image (SECR-02/OPS-05).

## Kế tiếp

1. Toàn trả lời m12.200–202.
2. Theo trả lời: WP17b phần mã (khai khoá `deploy/m12/**`, tệp cổng JWT, tệp kho bằng chứng; coder + tester độc lập + verifier R3, Toàn duyệt diff).
3. Dọn `_wt/m12` bằng `tools/don_wt.py` (nhắn phiên kia trước).
4. WP-NT: tin mời 27/11 + kịch bản M12-010.
