# Từ phiên `m9` · 17/11/2026 · Kết nối MISA: chỗ chạm M1–M2 (chuyển phiên `m12`) và hợp đồng M6 → M9

Nguồn: bản rà tài liệu MISA của chú Dũng `modules/m9/ra-soat/2026-11-17-rasoat-tai-lieu-misa.md` §5. Bằng chứng mã: `modules/m9/ra-soat/2026-11-17-misa/a-hien-trang-ma.md` §5
(ngoài git). Chủ hệ thống chốt 17/11 (QT-CHUNG-026, QĐ-3 A): **M1–M2 và M9 mỗi bên tự gửi chứng từ sang MISA, dùng chung một ClientID.**

## Cho phiên `m12` (nhờ lead chuyển)

1. **Họ API.** ops-core cấu hình họ cũ "ACT Open API" (`/api/oauth/actopen/connect`, `/apir/sync/actopen/save`, `MisaSyncOptions.cs:34-37`).
   M9 làm theo họ mới `amiskt/v1` (tài liệu MISA V1.0.0, 05/08/2026, `developer.misa.vn/products-openapi/AMISKT`). Chung ClientID thì nên chung họ API mới.
2. **Callback.** AMIS gọi một địa chỉ cho mỗi ứng dụng, chữ ký nằm trong thân tin (HMAC-SHA256 của `data`, khoá ClientID). ops-core lại đòi header
   `X-MISA-Callback-Signature/-Version/-Timestamp/-Request-Id` (`MisaTokenPorts.cs:49-52`). Tài liệu chú đề xuất M9 nhận callback rồi chuyển phần có tiền tố
   `M12:` sang `POST /api/v1/admin/integrations/misa/callback` của ops-core. Cần chốt hợp đồng chuyển tiếp nội bộ có chữ ký, trước ~24/11 (việc E của Tài).
   **Toàn chốt 17/11 12:33 (m9.4 A, D-m9-005):** chung một ClientID; M12 chuyển sang họ `amiskt/v1`; M9 nhận callback chung, chuyển phần `M12:` sang
   ops-core qua mạng nội bộ .99 bằng chữ ký nội bộ (đường nhận phía ops-core và cách ký: phiên m12 đề xuất); vẫn hỏi MISA một ứng dụng có đăng ký được nhiều
   địa chỉ callback không. Đây là quyết định chạm M12 → nhờ lead ghi `modules/lead/QUYET_DINH.md` và chuyển phiên m12.
3. **Quy ước chung** (tài liệu §6.4): `org_refno` phía M1–M2 tiền tố `M12-`; `org_refid` là UUID v5 từ `M12:<...>`. M9 làm chủ mã hàng thành phẩm (SKU), đối
   tượng khách, ĐVVC, nhà khởi nghiệp, nhà phân phối. M1–M2 làm chủ mã nguyên liệu, bao bì, nhà cung cấp nguyên liệu, kho. Bên không làm chủ chỉ đọc. Phiếu nhập
   thành phẩm của M1–M2 (Nợ 1555A) dùng mã SKU M9 tạo, nên M9 đồng bộ danh mục trước.
4. **Không ghi hai lần:** xuất kho bán thành phẩm và nhập kho thực phẩm chức năng gia công (Nợ 1555B / Có 154) do M9 gửi. Phiên m12 xác nhận M1–M2 không gửi hai loại này.
5. Một bộ ClientID + mã kết nối nằm ở cấu hình cả hai app trên .99: chốt ai giữ, ai xoay khoá.

M12-012 (cầu MISA) đang hoãn theo D-m12-002. Hoãn tiếp hay mở lại là việc của Toàn/phiên m12; phía M9 không chờ.

## Cho phiên `lead`

- `ginsengfood-contracts` chưa có hợp đồng M6 → M9 (chi phí quảng cáo). Mã M6 gửi sang (`M6AdSpendJsonParser.java:19` trong BP) và bảng `finance_ad_cost_entries`
  đều **không có trường nền tảng/nhà cung cấp**, mà chứng từ quảng cáo cần "Có 331 theo Meta, Google" (M9-QT-042). Phiên m9 giao Tài thêm trường này ở hai đầu
  (gói MISA-06). Nếu lead muốn ghi hợp đồng thì thêm trường `platform`/nhà cung cấp. Ghi chú 05/11 của phiên m6 (`lead-2026-11-05-m6-m9-chi-phi.md`) vẫn là
  nền: điểm nối M6 → M9 chưa dùng thật.
