# Gửi Tài + Phúc · 20/11/2026 · trả lời kế hoạch lên dev và lượt deploy .99 (~21/11)

Toàn kiểm .99 sáng 20/11, khoảng 08:50, chỉ đọc. Chỉ đọc tên biến và cờ, không đọc `.env` hay khoá.
Đối chiếu với `origin/dev` `e90ee22d` (19/11 21:17).

## 1. Claude cho chat M4: cổng đã mở, nhưng key bị Claude từ chối (sửa lại 20/11 ~10:20)

- Cổng đã mở, không cần lớp phủ `compose.claude-thu.yml`:
  - Trong container `m34-be-1`: `AI_GEMINI_PROVIDER_ENABLED=true`, `AI_GEMINI_DEV_ADAPTER_ENABLED=true`, `M4_CLAUDE_ENABLED=true`,
    `AI_CUSTOMER_FACING_CHAT_ENABLED=true`.
  - `compose.yml` trên .99 không còn ghi cứng `false` hai cờ chung, mà đọc từ `.env` (dòng 203–208, có chú thích).
    `AI_GEMINI_REAL_PROVIDER_ENABLED` vẫn ghi cứng `false`.
  - Lớp `compose.khan.yml` không nằm trong chuỗi compose của .99, nên không có chỗ nào để "đặt trước" nó.
- **Nhưng Claude chưa trả lời được câu nào.** Dòng khởi động `[AI-LLM-PROVIDER] provider=claude … port=CONNECTED` chỉ nghĩa là cổng mở và có key.
  - Từ 07:43 đến 08:59 ngày 20/11, log `[AI-LLM-CLAUDE]` có 42/42 lượt gọi thật `status=ERROR code=HTTP_401`, tức Anthropic không nhận key.
  - Nguyên nhân có thể là key sai hoặc đã bị thu hồi, workspace bị lưu trữ, hoặc dán thừa dấu nháy, khoảng trắng, ký tự xuống dòng vào `.env`.
    Hết tiền hay chạm trần chi tiêu thì không ra 401.
  - Lúc khoảng 10:04 `be` được khởi động lại. Tới 10:20 chưa có lượt gọi Claude nào, nên chưa biết đã hết lỗi chưa.
- **Tài:** nếu chưa thay key thì tạo key mới (đặt trần chi tiêu) và gửi Phúc thay trên .99. Sau đó thử một câu chat rồi nhờ Phúc gửi các dòng
  `[AI-LLM-CLAUDE]` (chỉ `status`/`code`, không kèm key). Phải ra `status=OK` mới tính là Claude chạy.

## 2. `compose.yml` trên .99 đang mới hơn nhánh `dev`: phải đưa vào `dev`

| Biến | Trên .99 | Trên `dev` |
|---|---|---|
| `SHIPPING_SPX_*` (11 biến, URL mặc định `https://test-stable.spx.vn`) | có | không |
| `SHIPPING_GHN_WEBHOOK_SECRET`, `SHIPPING_VIETTELPOST_WEBHOOK_TOKEN` | có | không |
| Hai cờ chung LLM đọc từ `.env` (mục 1) | có | không (ghi cứng `false`) |

- Trên máy có bản lưu `compose.yml.bak-spx-20261119T1652…Z` và `…T1656…Z`, tức tệp được sửa tay trên .99 khoảng 23:28–23:57 ngày 19/11.
- Việc 1 trong tin Tài ("biến môi trường vận chuyển cho .99") **đã có trên .99**. Phần còn lại là đưa đúng bản này vào `dev` qua PR.
  Nếu không, lượt deploy sau lấy `compose.yml` từ `dev` sẽ đè mất: SPX và webhook mất biến, còn Claude về NOOP.
- **Phúc** (người duy nhất đưa bản lên .99, D-lead-060): so `compose.yml` trên .99 với bản trong PR việc 1 của Tài trước khi deploy, để không mất dòng nào.
  Phúc đang sửa dòng `image: nginx` sáng nay (08:46), nhớ giữ cả hai thay đổi.

## 3. Hãng vận chuyển: đang trỏ môi trường thử, công tắc khẩn không ép tắt

| Hãng | Cờ bật trên `be` | URL đang dùng |
|---|---|---|
| GHN | `true` | `https://dev-online-gateway.ghn.vn` (môi trường thử) |
| Viettel Post | `true` | `https://partnerdev.viettelpost.vn` (môi trường thử) |
| SPX | chưa đọc cờ | mặc định `https://test-stable.spx.vn` (môi trường thử) |

- Chuỗi compose .99 hiện là `compose.yml`, `compose.override.yml`, `compose.m8-that.yml`, `compose.m8-that.quan-tri.yml`, `compose.m5-cua.yml`,
  `compose.cong-khai.yml`, `compose.vnpay-sandbox.yml`. Không có `compose.khan.yml`, nên không có gì ép tắt hãng.
- **Toàn chốt:** giai đoạn này chỉ dùng URL môi trường thử của cả ba hãng. Muốn đổi sang URL thật (tạo vận đơn thật, gọi shipper thật) thì báo Toàn duyệt trước.
- Hai dòng log Tài cần sau deploy (`AI-LLM-PROVIDER`, `Shipping carrier … enabled but not configured`) Phúc gửi như Tài xin, không kèm khoá.
  Lúc kiểm, log hiện tại không có dòng "not configured" nào.

## 4. Khách chưa đăng nhập trả VNPAY / QR (việc 2): xếp R3

- Việc này đụng tiền, và quyền xem đơn của người không đăng nhập (mã truy cập riêng mỗi đơn). Xếp **R3**.
- Trước khi gộp vào `dev`: Toàn duyệt diff, có tester độc lập viết bộ test riêng, như M5-153.
- Tối thiểu phải có test cho các trường hợp:
  - đoán hay đổi số đơn mà không có mã thì không xem được tiền và tài khoản;
  - mã của đơn A không mở được đơn B;
  - mã hết hạn hoặc sai chữ ký thì bị từ chối;
  - mã không nằm trong log hay Referer;
  - khoá ký thiếu thì `be` không khởi động.
- Khoá ký mã truy cập: Tài gửi **tên biến**, Phúc tự sinh giá trị trên .99. Không gửi qua tin nhắn.

## 5. Việc còn lại: đồng ý

- Phúc deploy .99 một lượt khi Tài báo "đủ" (dự kiến chiều hoặc tối 21/11): kéo `dev` mới nhất, giữ lớp `compose.cong-khai.yml`
  (`OTP_SMS_EXPOSE_MOCK_CODE=false`, `APP_IVR_INTEGRATION_ENABLED=false`; kiểm 08:50 vẫn đúng) và giữ lớp VNPAY sandbox.
- Câu công dụng 19 món Cháo Sâm và 4 sản phẩm thực phẩm chức năng: chờ chú duyệt rồi mới nạp.
  **Claude đang trả lời khách trên trang thật**, nên trong lúc chờ, Tài kiểm bot không tự nói công dụng hay chữa bệnh. Thử vài câu hỏi thẳng về công dụng.
- M5-153: Toàn đã rà xong, kết quả gửi riêng Tài (`2026-11-20_tai_duyet-m5-153.md`).
