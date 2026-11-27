# Bàn giao Phúc · M3-023 · M8 draft.51 · 27/11/2026

Gói chuẩn bị bàn giao. Phúc phụ trách đưa BE/FE M3 lên .99 sau khi Toàn chốt SHA và duyệt triển khai. Luồng m8 phụ trách image API/Worker M8, bank, cờ nguồn và kịch bản cuộc gọi. M34 chuẩn bị và đối chiếu kết quả phía M3.

## Bản triển khai

| Hạng mục | Mốc và điều kiện |
| --- | --- |
| M3 | Mốc gốc `51c9f5275` trên `toandeptrai`. Điền SHA ứng viên, SHA GitLab `dev` và digest BE/FE khi có bản đủ điều kiện. Bản `ea46c8530` có hai migration V410, bỏ qua bản đó. |
| M8 | Nguồn draft.51 ở local `cebf9d1c`. SHA-256 `abf1d485f621b1a56f373053f459b7100bff0797bbc78ab38de047bbfcea61fd`. Trước UAT, lấy SHA và digest API/Worker **đang chạy** từ luồng m8, xác nhận đủ 32 tuyến quản trị trên M8. |
| Flyway | Draft.51 dùng lại `IVR.VOICE.EDIT` và `IVR.VOICE.ACTIVATE` từ V411 của M3. Kiểm lịch sử Flyway trên .99 và xác nhận V410 giỏ Giờ vàng, V411 quyền IVR. Toàn cấp quyền cho tài khoản thử. |
| Token | Xác nhận ba tầng `admin-read`, `admin-write`, `admin-danger` khớp M8. Tệp `admin-danger` từng được ghi là giữ chỗ, cần xác nhận bằng phản hồi trên tuyến được duyệt. Ghi trạng thái từng tầng, giữ bí mật trong kênh cấu hình. |
| Nguồn | Kiểm `Ivr:Voice:RegionSource` và `Ivr:Voice:ProfileSource` trên cả API lẫn Worker. Mặc định `OPTIONS`. Chỉ kiểm hiệu lực trên cuộc gọi khi luồng m8 xác nhận cả hai tiến trình đang dùng các cờ đã duyệt. |
| Bank | Hiện có 3 cặp giọng gốc. Hoán đổi sang cặp thiếu bank phải trả `VOICE_NOT_READY` và nêu `bank`. Ca hoán đổi thật chờ bank thêm 6 cặp trên .99 và Toàn nghe duyệt. Có thể chạy ca thành công với kho giả lập cô lập đã nạp đủ cặp. |

Thứ tự khi được duyệt là chốt ứng viên và kết quả kiểm, xác nhận bản M8, lưu SHA/digest đang chạy và bản sao lưu, rồi Phúc triển khai M3 bằng image CI và `trien-khai.sh` cùng lớp `compose.cong-khai.yml`. Kiểm health BE/FE, đăng nhập và mở các trang quản trị trước khi dùng fixture. Giữ cờ luật gọi M3 ở `LEGACY_V4` cho tới lượt duyệt riêng. Chi tiết bản trước và vị trí cấu hình ở [gói Giọng đọc và Trần gọi](2026-11-26-ban-giao-phuc-giong-doc-tran-ngay.md).

### Bằng chứng trên ứng viên M3

| Lớp kiểm | Kết quả |
| --- | --- |
| SHA/diff và ghim hợp đồng | Ghim SHA-256 draft.51 khớp YAML M8 và resource BFF. So với draft.50, thêm 6 thao tác và làm rõ mô tả của 7 thao tác và 5 schema cũ. Callback khớp hash cũ. Cây ứng viên đặt trên `51c9f5275`, chưa commit. |
| BE và hợp đồng BFF | 91 ca BE cục bộ đạt. Kiểm controller, service, phân quyền, header, chiếu dữ liệu, ghim hợp đồng và Springdoc. Đã cập nhật OpenAPI và hai snapshot IVR bằng 5 đường dẫn, 6 thao tác và 25 schema từ lần xuất Springdoc. |
| FE | 104/104 ca Vitest theo phạm vi. Kiểm kiểu TypeScript, ESLint theo tệp và Playwright Chromium dùng API giả lập. Đã xem desktop 1440 px và mobile 390 px. Playwright chạy banner OPTIONS, làm nóng, lặp kiểm sau 5 giây, PUT ghim phiên bản, khóa sau 409 và mở Đặt cả bộ. |
| Trước khi bật cờ | Chờ bộ đủ trên ứng viên, verifier độc lập vùng phân quyền và lời nói với khách theo D-lead-064, Toàn duyệt diff. |
| .99 và UAT | Chờ SHA/digest thực tế, cửa sổ được duyệt và bằng chứng. |

Shared UI check đạt. Đã đọc COMPONENT_MAP và dùng thành phần có sẵn từ `@/shared/components`, gồm DataTable, FormField, SelectInput, Checkbox, InlineBanner, IconButton và ConfirmDialog. Hộp chọn lô và thẻ readiness ghép các thành phần này với thanh tiến độ HTML có nhãn. Không có import từ `@/shared/components/admin`.

Kit check và Vietnamese UI check đạt trong phạm vi trình duyệt giả lập. Giữ các mã định danh giọng, IVR, STORE, địa chỉ tuyến và tên môi trường do máy chủ trả về. Ảnh và lệnh kiểm ở [thư mục bằng chứng UI](../../../../_wt/_luu/m34/draft51-ui-20261127). Cổng trình duyệt nối M3 với M8 thật vẫn mở. `Can next phase start: NO`.

## Kiểm sáu tuyến quản trị draft.51

Đường dẫn bảng dưới tính từ `/api/v1/admin/ivr` tại M3. BFF ánh xạ hai tuyến ghi sang `POST /voice-profiles:activate-set` và `POST /region-provinces/{key}:warm` tại M8. Ghi HTTP, mã lỗi và correlation cho từng ca. Đọc `error.code` và `details` ở M8, `error_code` và `data` ở BFF. Đối chiếu actor và lý do bằng audit trong môi trường thử. Kiểm được cả khi đi từ UI và khi gọi BFF bằng tài khoản thử đúng vai trò.

| Tuyến | Quyền và kết quả cần chứng minh |
| --- | --- |
| `POST /voice-profiles/activate-set` | Tầng danger, `IVR.VOICE.ACTIVATE`. Chọn 2–3 DRAFT khác vùng, gửi từng `profile_id`, `if_match` và một lý do 10–500 ký tự. Kiểm lỗi số lượng, hồ sơ/vùng lặp, lý do ngắn. M8 dùng 400, BFF dùng 422 kèm lỗi theo trường. Một hồ sơ cũ hoặc chưa sẵn sàng trả 409 và đánh đúng hồ sơ bằng `profile_index` tính từ 0. So sánh toàn bộ bộ ACTIVE trước/sau lỗi. Với bank đủ, một lần áp dụng đổi trọn bộ và vẫn giữ ba giọng khác nhau. Thử cùng `Idempotency-Key` và thân, rồi cùng khoá khác thân. |
| `GET /region-provinces` | Tầng read. Có đủ 34 tỉnh, `table_version` khớp `ETag` M8, số tỉnh từng vùng khớp các dòng. Màn Tỉnh–Vùng lọc theo tên hiện hành/tên gộp và vùng. Khi `source.flag=OPTIONS`, hiện rõ thay đổi trong bảng chưa có hiệu lực với cuộc gọi. |
| `GET /region-provinces/{key}` | Tầng read. Kiểm chi tiết và lịch sử, vùng hiện tại/mặc định, phiên bản và người/giờ đổi. Dòng chưa đổi được đánh dấu mặc định. |
| `GET /region-provinces/{key}/readiness` | Tầng read. Bước 1 chọn đích rồi xem theo từng tỉnh `needed`, `ready`, `failed`, `pending`, `missing_count`, `complete`, `store_empty`. Xem mẫu kho rỗng và mẫu `bank=false` với `missing_count=0` vẫn chưa sẵn sàng. Kiểm trang tiếp theo, `missing_limit` hợp lệ 1–200. Sau làm nóng, kiểm lặp mỗi 5 giây tới `complete`, dừng khi rời hộp thoại. |
| `POST /region-provinces/{key}/warm` | Tầng write, `IVR.VOICE.EDIT`. Bước 2 gửi `target_region`, đối chiếu `requested`, `already`, `needed` và thử lặp để chứng minh làm nóng không tạo hàng trùng. Trong lúc chờ, kiểm nút Áp dụng chưa mở khi còn tỉnh chưa `complete`. |
| `PUT /region-provinces` | Tầng danger, `IVR.VOICE.ACTIVATE`. Bước 3 gửi `If-Match` theo phiên bản bảng đã xem, lý do, `X-Action-Reason` ở hop M8 và `changes[{province_key, region}]`. Kiểm cả lô thành công, phiên bản bảng tăng một lần, mỗi tỉnh có audit. Với tỉnh mất readiness sau bước 2, kiểm 409 `REGION_NOT_READY`, giữ nguyên cả lô và hiện `not_ready`/kiểm thiếu. Với hai phiên cùng phiên bản, phiên sau nhận 409 `IVR_VERSION_CONFLICT`, thấy `current_table_version` và phải tải lại trước khi áp dụng. |

Trên trang Giọng đọc, lỗi trùng giọng khi kích hoạt từng hồ sơ hướng người dùng sang **Đặt cả bộ**. Kiểm BFF và UI giữ được các chi tiết 422/409 `errors`, `failed_checks`, `variants_missing`, `profile_index`, `not_ready`, `current_table_version` tương ứng. Ở Tỉnh–Vùng, trước khi xác nhận, kiểm nội dung nhắc khách sẽ nghe giọng và cách đọc số của vùng mới khi `STORE` có hiệu lực. Đơn đã nhận nhưng chưa gọi sẽ theo vùng mới, lượt đang gọi giữ vùng đã ghim. Kiểm **Về mặc định** gửi đúng `default_region` qua cùng quy trình readiness và phiên bản. Tài khoản chỉ xem đọc được, tài khoản EDIT làm nóng được, tài khoản ACTIVATE mới đặt cả bộ/áp dụng được. Kiểm tài khoản đã mất quyền bị từ chối khi gửi lại yêu cầu ghi.

## Phiếu chạy E01–E10 trên .99

Vòng 14/11 W-0540 đã đạt 6/10 ca ở bản tối thiểu cũ (E01, E02, E03, E05, E06-A/B, E10). E04, E07, E08 và E09 khi đó là `NOT_RUN`. Bản này **chưa chạy trên draft.51**. Dùng phiếu gốc M8 làm mẫu nhập kết quả và dùng hướng dẫn .99 cho thứ tự thực tế.

### Chuẩn bị và trình tự

1. Xác nhận Toàn duyệt từng lượt đụng .99, người giữ lịch bên m8, người giữ cầu callback bên M3 và đường khôi phục. Ghi SHA/digest hai phía, giờ +07, tenant thử, CA/issuer theo runbook hiện hành, health intake .99:8443 và cầu .99:8445. Xác nhận MOCK, `REAL_CUSTOMER_CALL_ALLOWED=NO`, lịch gọi tắt, khoảng gọi được duyệt và số thử riêng từng đơn. Trước khi đặt đơn sau mỗi lượt bật lịch, đợi đồng bộ media lắng hai mẫu 30 giây liên tiếp.
2. Thứ tự đã kiểm chứng trên .99 là E02 → E01 → E06-A → E03 → E05/E06-B → E10. Chạy E07/E08 trong cửa sổ riêng với tài khoản và fixture đã duyệt, lịch gọi tắt. E04/E09 cần điều kiện mở trong bảng. Với E05/E06-B, bật lịch và kiểm bắt tay cầu trước khi dừng cầu. Chụp log đã lọc trước khi tạo lại worker.
3. Dừng khi cờ gọi thật bật, có lượt ngoài MOCK, gặp dữ liệu thật, thấy chứng thư/health sai, mất đối soát hoặc có việc tồn ngoài dự kiến. M8 tắt lịch, M3 khôi phục cầu, hai bên xác nhận lại trạng thái và báo Toàn. Lượt có lỗi lưu kết quả thực tế rồi đặt lại fixture theo runbook nếu được duyệt.

| Ca | Bước kiểm và bằng chứng phải có | Trạng thái draft.51 |
| --- | --- | --- |
| E01 | Lịch tắt. Chạy kiểm kết nối chỉ đọc M3 và kiểm intake E01 theo runbook. Metadata/JWKS 200, issuer đúng, giờ lệch ≤ 30 giây. Ba yêu cầu fixture bị từ chối 401/403/403, mỗi correlation có 0 task/job/callback. Lấy dấu vết client xin token từ lần gọi hợp lệ E02. | Chưa chạy |
| E02 | Tạo một đơn MOCK COD sau khi media lắng. M8 có 1 task/job/attempt/result/callback, phím 1 → `IVR_CONFIRMED`, ACK `ACCEPTED` 200. M3 lưu receipt/task/job, đơn `CONFIRMED`, inbox/chuyển trạng thái/sự kiện nghiệp vụ áp một lần. | Chưa chạy |
| E03 | Dùng E02 cho nhánh xác nhận. M8 ghim fixture phím 0 cho đơn COD hủy và chờ media lắng trước khi M3 đặt. M8 trả `IVR_CUSTOMER_CANCELLED`, M3 `CANCELLED` với `IVR_CUSTOMER_REQUEST` đúng một lần, không phát sinh hoàn tiền. Kiểm ACK khớp callback và correlation ở cả hai đơn. | Chưa chạy |
| E04 | Fixture producer phát lại đúng bản tin intake đã có receipt. Cùng khoá/cùng body nhận receipt cũ và không thêm job. Cùng khoá/khác body trả 409, số task/job/side effect giữ nguyên. | Chờ fixture producer được duyệt |
| E05 | Trong cửa sổ thử, dừng cầu sau khi scheduler lên, gửi đơn, ghi callback thử lại/cạn. Tắt lịch, mở lại cầu. Phát lại đúng callback đã cạn bằng quyền được duyệt. So callback trước/sau, M3 có một inbox và áp `CONFIRMED` đúng một lần. | Chưa chạy |
| E06-A/B | A, lịch tắt, tạo đơn rồi đợi SUBMIT `SETTLED` mới thu hồi. Ghi REVOKE, `TASK_REVOKED`, 0 lượt gọi/callback. B, dùng cửa sổ cầu dừng của E05, đợi callback cạn, đổi/hủy đơn trước khi M8 replay đơn đó. M3 nhận và chặn kết quả cũ với `REJECTED_STALE` hoặc `BLOCKED_BY_CORE` theo fixture, giữ trạng thái sau đổi. | Chưa chạy |
| E07 | Ba tài khoản xem, ghi và có quyền nguy hiểm. Kiểm UI, BFF và audit trên fixture. Vai trò xem chỉ đọc, vai trò ghi chỉ làm việc được cấp, vai trò ACTIVATE thao tác ghi có actor/lý do đúng. Token tầng upstream chỉ ở BFF. | Chờ tài khoản/fixture và ba tầng token |
| E08 | Màn Operations đọc được, fixture gây lỗi stale/timeout/503 làm UI hiện `UNKNOWN`. Khi hồi phục thấy `FIRING` → `RESOLVED`, cursor không lặp. Kiểm tab Network không có token tầng M8. | Chờ fixture lỗi cô lập |
| E09 | Với endpoint thứ hai được duyệt, dừng producer, chuyển endpoint rồi quay lại khi còn task/outbox thử đang chờ. Đối chiếu task/job/kết quả từng mốc, chứng minh không mất/trùng, không đổi credential giữa lượt hoặc chuyển task bằng DB. | Chờ endpoint thứ hai và cửa sổ được duyệt |
| E10 | Lịch tắt. Kiểm việc tồn, cờ gọi thật và 0 active channels qua nguồn đọc Asterisk .64 theo runbook .99. Đối soát trước/sau thu dọn và ghim receipt SHA-256. Thu dọn fixture M3 theo retention, giữ audit/journal/inbox. Nếu giữ đơn để đối soát, ghi quyết định và tình trạng thật. | Chưa chạy |

Biên bản mỗi dòng cần SHA/digest hai phía, giờ +07, người chạy, correlation, mã HTTP/ACK, kết quả M3 và M8, đường dẫn bằng chứng đã lọc PII, kết quả thu dọn và trạng thái cuối. Dùng mã task/job/callback rút gọn theo công cụ đối soát.

## Khôi phục

- Phúc lùi BE/FE M3 về image đã ghi theo quy trình `trien-khai.sh` khi Toàn duyệt. Kiểm health/đăng nhập và cầu callback sau khi lùi.
- Trên M8, luồng m8 có thể trả nguồn về `OPTIONS` khi được duyệt để lượt mới dùng bảng/cấu hình mặc định. Để trả riêng một tỉnh, áp lại vùng cũ qua cùng readiness, `If-Match` và audit. Lượt đang quay giữ vùng đã ghim.

## Tin nháp gửi Phúc

> Phúc ơi, anh có gói M3-023 cho Đặt cả bộ giọng và Tỉnh–Vùng. Bản M3 đã qua kiểm cục bộ, còn chờ anh chốt SHA và bên M8 xác nhận API/Worker đang chạy draft.51. Khi anh báo đủ điều kiện, em lên .99 giúp anh theo gói này rồi mình chạy phiếu E01–E10 với m8 nha.

## Nguồn kiểm

- [Handoff draft.51 của m8](../../../hop-thu/m34-2026-11-26-m8-draft51-hash-moi.md) và [hợp đồng OpenAPI](../../../../ginsengfood-ivr/specs/api/openapi/ivr-order-confirmation.v1.yaml).
- [Tỉnh–Vùng](../../../../ginsengfood-ivr/docs/operations/region-provinces-admin.md) và [Hồ sơ giọng](../../../../ginsengfood-ivr/docs/operations/voice-profiles-admin.md).
- [Phiếu E01–E10](../../../../ginsengfood-ivr/deploy/m8/nghiem-thu-m3/phieu-e01-e10.md), [quy trình .99](../../m8/wp/nghiem-thu-tren-99.md), [đối soát W-0540 ngày 14/11](../../../../ginsengfood-ivr/docs/evidence/W-0540/README.md) và [bằng chứng phía M3](../../../../ginsengfood-business-platform/deploy/m34/m8-that/BANG_CHUNG_M3.md).
