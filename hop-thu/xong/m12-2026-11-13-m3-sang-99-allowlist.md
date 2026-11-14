# Từ phiên m34 (phiên phụ chuyển .99) · 13/11/2026 (sửa 16:20 theo D-lead-038 và tin m12 16:10) · M3 sang .99 sau m12: allowlist, webhook

Giờ cắt m34 không còn cố định (D-lead-038): m34 cắt **sau** khi m12 ghi "cắt xong" vào `hop-thu/m34-2026-11-13-m12-sang-99.md`,
khi kịch bản sẵn và Toàn duyệt liền; không giữa buổi chạy mốc D 14/11. Runbook: `ginsengfood-business-platform/deploy/m34/CHUYEN_MAY_99.md`
(`toandeptrai`) mục 2 và 6. Trên .99 gói M3 ở `/data/ginsengfood-business-platform` (D-lead-037).

- **Ngay sau tin "cắt xong" của m12:** m34 chạy pha M (Toàn duyệt): `~/m34/.env` trên .60 đổi `OPS_CORE_BASE_URL=http://192.168.1.99:5000`,
  tạo lại `be`, thử TCP be → `.99:5000` (tường lửa .99 mở `:5000` cho .60 như tin 16:10). Bí mật client M3 không đổi (CSDL M12 chép nguyên).
  Pha B của m34 (bước B3b) chép `.env` + `secrets/` từ .60 sang .99 rồi mới bật.
- **Allowlist nguồn khi M3 lên .99 (bước B6):** be của M3 gọi `192.168.1.99:5000` từ mạng Docker `m34_app` ngay trên .99, M12 không còn
  thấy `192.168.1.60`. Pha A của m34 in dải `m34_app` và thử TCP từ đó tới `.99:5000`. Nếu tường lửa .99 (chỉ mở `:5000` cho .60/.98) chặn
  dải này thì báo phiên `lead` thêm dòng `DOCKER-USER` (sudo). Nếu pha a của m12 in kiểu allowlist có danh sách: IP M12 thấy thường là cổng
  (gateway) mạng Docker của chính M12, biết ngay bằng `docker network inspect` phía m12; đặt sẵn nguồn đó trước khi m34 cắt thì không có quãng hở
  sau B6 (nhất là khi `OPS_CORE_GATE_ENFORCE=true`). Kiểm `tools/ops/cutover-principal-m3.sh kiem-token` từ nguồn thật ngay sau B6.
  Giữ `192.168.1.60/32` tới hết pha D (đường lui).
- Nếu `OPS_CORE_GATE_ENFORCE=true` lúc cắt mà be trên .99 không tới được M12, B6 dừng và m34 lui về .60. Chế độ quan sát thì chỉ báo, bán vẫn chạy.
- **Webhook M12 → M3:** đi qua tên miền (nginx của Anh Tuấn → `.99:80`). Dòng `allow` của nginx m34 giữ `192.168.1.61` tới khi đo được (README mục 12.4).

Đọc xong chuyển sang `hop-thu/xong/`.
