# Bật quản trị IVR của M3 trên .99 — kịch bản 16/11

Trạng thái: ĐÃ BẬT 15/11 18:06 (D-m8-111) · bước 0, 1 (M8) 16:23; 1b, 2 (m34, `74de1cd0b`) 18:05–18:06, be nghỉ ~40 s; bước 3 ĐẠT 18:07; bước 4 ĐẠT (Toàn "Thấy rồi"; nginx :80 60 phút tới 20:45: `capabilities` 200 ×118, `review-items` 200 ×699, 401 ×4; M8, be 0 lỗi); còn bước 5 (E07/E08, Toàn) · soạn 15/11 07:18, khớp phần M3 08:24 (phiên m8) · Rủi ro R2 · Căn cứ D-m8-108, D-m34-082
Lượt ghi .99 chỉ chạy khi Toàn duyệt đúng lệnh ngày 16/11. Phần M3 do Phien M34 làm và hẹn giờ: commit `024fa7430` trên `toandeptrai`
(lớp chồng compose + sổ tay `deploy/m34/m8-that/BAT_QUAN_TRI_IVR.md`, verifier m34 ĐẠT), **chưa push** — phải push trước vì bước 1b lấy
hai tệp compose từ commit đã push.

## 1. Vì sao

Trang M3 `/admin/ivr` báo "Chưa kiểm tra được quyền" vì be M3 chạy `app.ivr-admin.enabled=false` (lớp `compose.m8-that.yml`):
`GET /api/v1/admin/ivr/capabilities` không có route nên trả 401. Bật nhóm này để Toàn xem IVR trên trang quản trị M3 và chạy E07, E08.

## 2. Dữ kiện đã kiểm (15/11 07:18, chỉ đọc, [log](../ra-soat/kich-ban-99-1611/))

- M8 có đủ 3 token quản trị đọc/ghi/nguy hiểm trong `du-lieu/api/api.env` (64 ký tự, khác nhau, đúng dạng M3 nhận).
- nginx 8443 của M8 có một `location /` và `allow 172.29.0.1` (nguồn M3 qua NAT) nên đường quản trị không cần mở thêm.
- be M3 (uid 10001) gọi `https://192.168.1.99:8443/health/live` được 200; TLS dùng cùng CA ghim của `app.ivr-auth` (`/run/m8t/be/ca-m8.pem`).
- Thư mục bí mật M3: `/data/ginsengfood-business-platform/m8-that/bi-mat/` (ssv, 0700); dịch vụ một lần `m8that-bi-mat` chép sang volume của be, chủ 10001, quyền 0400. Chưa có tệp `admin-*`.
- M3 đọc tệp token mỗi lần gọi và cắt khoảng trắng cuối (`IvrClientSecretFile.read`); `app.ivr-admin.validate()` đòi base-uri `https`, path đúng `/v1/ivr/order-confirmation`, environment thuộc dev/staging/lab/pilot/prod, ba tệp token tồn tại, không quyền group/other, ≤ 4096 byte.

## 2b. Hàng đợi M8 lúc kiểm thử (15/11 08:23, `kiem_hang_1611.sh`, [log](../ra-soat/kich-ban-99-1611/))

- 0 attempt đang gọi, 0 callback đang gửi; 5 job `RESULT_READY_FOR_CALLBACK`/`HELD_CALLBACK` (đúng thiết kế sau callback); callback
  `DELIVERED_ACCEPTED` 4, `REJECTED_STALE` 1, `INVALID_DEAD_LETTER` 5 (cũ, 13/11 07:14Z mang từ .61, M3 trả 404; không do lượt này, không replay).
- Giờ in trên .99 là UTC (08:23 ở đây = 01:23 trên máy).

## 3. Giá trị cấu hình (m34 áp)

| Khoá | Giá trị |
| --- | --- |
| `app.ivr-admin.enabled` | `true` |
| `app.ivr-admin.base-uri` | `${M8_ORIGIN}/v1/ivr/order-confirmation` = `https://192.168.1.99:8443/v1/ivr/order-confirmation` |
| `app.ivr-admin.environment` | `lab` (M8 trên .99 chạy MOCK; trùng tên môi trường feature-flag của M8) |
| `app.ivr-admin.read-token-file` / `write-token-file` / `danger-token-file` | `/run/m8t/be/admin-read` / `admin-write` / `admin-danger` |
| `app.ivr-admin.privileged-user-id` | **không đặt** → `canDanger`, `canAudit`, `canExport` luôn false |

Cách m34 áp: lớp gốc `compose.m8-that.yml` ghi cứng `QUAN_TRI_IVR=tat` (mặc định tắt, `.env` không bật lén được; chế độ tắt xoá bản chép
`admin-*` trong volume be). Lớp chồng `compose.m8-that.quan-tri.yml`, đặt ngay sau `compose.m8-that.yml` trong `COMPOSE_FILE` của `.env`,
đổi `QUAN_TRI_IVR=bat` (`m8that-bi-mat` chép `admin-read`, `admin-write`, `admin-danger` sang `/dich/be/`, chủ `BE_UID`, 0400; thiếu, rỗng,
> 4096 byte hoặc quyền group/other thì dừng) và nạp bản properties có khối trên vào **cùng** `/run/m8t/m8-that.properties` (script M8 grep đúng tệp này).

Bật quản trị còn mở hai lối M3 gọi nền bằng token đọc, có `X-Actor-Id` hệ thống (M8 đòi actor ở tầng đọc): vòng kiểm đơn
`/call-jobs/{id}/detail` (5 s/lượt, actor `m3-ivr-reconciliation`) và `/operations` (30 s/lượt, actor `m3-ivr-monitor`).
`kiem_sau_1611.sh` mục 4b gọi thử cả hai.

## 4. Các bước ngày 16/11

| # | Ai | Việc | Đạt khi |
| --- | --- | --- | --- |
| 0 | M8 | `kiem_truoc_1611.sh` + `kiem_hang_1611.sh` (chỉ đọc) | như mục 2, chưa có `admin-*`; attempt đang gọi 0, callback đang gửi 0, callback chết đúng 5 dòng cũ (mục 2b) |
| 1 | M8 | `cap_token_1611.sh` (ghi .99): đặt `admin-read` = token đọc M8, `admin-write` = token ghi M8, `admin-danger` = chuỗi ngẫu nhiên giữ chỗ (không phải token M8) vào thư mục bí mật M3, 0600, không in giá trị | in `read/write khop token M8: True`, 3 tệp 0600 ssv |
| 1b | m34 | Chép `compose.m8-that.yml` + `compose.m8-that.quan-tri.yml` từ commit đã push lên .99 (`git archive` + `scp`, sổ tay m34 mục 2) | `grep -c chep_admin compose.m8-that.yml` ≥ 2 |
| 2 | m34 | Ngay trước: M8 chạy lại `kiem_hang_1611.sh` (còn 0 đang gọi/đang gửi). Thêm lớp chồng vào `COMPOSE_FILE`, `docker compose up -d --no-build --wait` dưới `flock` (be gián đoạn 1–3 phút, nginx :80 khởi động lại theo be) | `m8that-bi-mat` "da chep 7 tep"; be `healthy`, log `[IVR-AUTH-CONFIG] tls=PINNED token-client=ON callback-verifier=ON`, không `APPLICATION FAILED` |
| 3 | M8 | `kiem_sau_1611.sh` + `kiem_hang_1611.sh` (chỉ đọc; gọi M8 từ bên trong be, chỉ in mã HTTP) | cấu hình đúng mục 3, `privileged-user-id` 0 dòng; tệp `admin-*` 0400 app; `/queue` token đọc 200, token ghi (scope `ivr.admin.write`) 200, token ghi kèm scope read 403 (tiêu đề phải đúng tầng token), thiếu `X-Actor-Id` 403, tệp giữ chỗ 401; `/operations` 200 (503 = chưa có snapshot, ghi lại), `/call-jobs` 200; callback chết vẫn đúng 5 dòng cũ; M8 9 container khoẻ, gọi thật NO |
| 4 | Toàn | Đăng nhập trang quản trị M3 bằng tài khoản admin, mở `/admin/ivr` | trang hiện dữ liệu IVR, không còn "Chưa kiểm tra được quyền"; nginx :80 ghi `capabilities` 200 (chạy lại bước 3 mục 5) |
| 5 | Toàn (+ m8 khi cần lỗi giả) | E07, E08 theo `wp/huong-dan-bac-90-noi-m3.md` | ký bảng mục 4 của hướng dẫn |

Không có thao tác nguy hiểm nào trong lượt: không đổi feature flag, không bật lịch gọi (giữ TẮT). Replay callback là tầng nguy hiểm của M8
(M3 không có token này): chỉ làm khi bước 3 thấy callback chết **mới**, là lượt ghi riêng Toàn duyệt, M8 gọi `:replay` bằng token nguy hiểm của M8.
Lịch gọi tắt và 0 attempt đang gọi nên trong lúc be tạo lại M8 không sinh kết quả mới; rủi ro này gần như bằng 0.

## 5. Đường lui

1. m34 bỏ `:compose.m8-that.quan-tri.yml` khỏi `COMPOSE_FILE`, `up` lại (sổ tay m34 mục 5): be về `enabled=false`, `m8that-bi-mat` chế độ tắt
   xoá bản chép `admin-*` trong volume be. Lưu ý: lớp chồng nằm trong `.env` nên các lượt đổi bản sau (`trien-khai.sh`, CD) giữ quản trị bật.
2. M8 chạy `duong_lui_1611.sh`: kiểm be đã `enabled=false` rồi xoá đúng 3 tệp `admin-*` khỏi thư mục bí mật M3.
3. Nghi lộ token đọc/ghi thì xoay `IVR_ADMIN_READ_TOKEN`/`IVR_ADMIN_WRITE_TOKEN` của M8 (việc riêng, cần Toàn duyệt, tạo lại api M8).

## 6. Rủi ro đã biết

- Token ghi cho phép M3 gửi thao tác tầng ghi (duyệt, xử lý review) thay người dùng M3 có quyền `IVR.REVIEW`; M8 ghi `X-Actor-Id` từng lệnh. Token nguy hiểm không giao.
- Hai bên dùng chung token đọc/ghi hiện hành của M8 (không có cặp riêng cho M3); xoay token phải đổi cả hai chỗ trong cùng lượt.
- be M3 tạo lại làm web M3 gián đoạn 1–3 phút; m34 chọn giờ ít đơn và nói rõ việc đơn đang chờ gửi sang M8 lúc tạo lại (M8 chưa kiểm phần này).

Script phía M8 (loại khỏi git): `modules/m8/ra-soat/kich-ban-99-1611/{kiem_truoc_1611.sh, kiem_hang_1611.sh, cap_token_1611.sh, kiem_sau_1611.sh, duong_lui_1611.sh}`, chạy bằng
`ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes -o BatchMode=yes ssv@192.168.1.99 'bash -s' < <script>`.
