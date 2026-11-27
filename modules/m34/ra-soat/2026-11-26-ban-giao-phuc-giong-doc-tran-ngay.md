Gửi Phúc · 26/11/2026 · từ Lead (Toàn)
Việc: đưa `dev` mới nhất lên .99 để có phần quản trị IVR mới của Module 3: trang "Giọng đọc", trang "Cụm tên địa bàn" và thẻ "Trần gọi mỗi ngày" (tab "Cước gọi" của Báo cáo). Chỉ làm SAU khi Toàn đã đưa M8 trên .99 lên bản có 26 tuyến mới (mục 5).
Vì sao: Toàn chốt giao Module 3 phần này (D-m8-161, D-m34-114, D-m34-115). Mã đã nằm trên `dev` ở cả GitHub và GitLab (mục 1). Quyền lên .99 chỉ Phúc (D-lead-060), nên Phúc làm bước đưa lên và kiểm.
Cần làm: mục 1 đến 4 bên dưới (mã, migration, cấu hình, thứ tự + kiểm + lùi).
Xong khi: mục 4 "Kiểm sau khi lên" đạt hết, và Phúc báo lại Toàn.
Hạn: đề xuất xong trước 28/11 để chừa 29–30/11 (Toàn chốt lại nếu khác) · báo lại bằng: tin cho Toàn + dòng trên Sheet của Phúc.

Tệp này chỉ nói phần của phiên m34 (Toàn). `dev` còn chứa việc của Phúc, Tài và luật gọi M3 (mục 3.4): không nằm trong tệp này.

**Đừng deploy `ea46c8530`** (đầu GitLab `dev` lúc 10:47 ngày 26/11): bản đó chứa HAI tệp V410, `be` sẽ không khởi động. Dùng `51c9f5275` trở đi.

**Nếu build hoặc chạy test ở máy có sẵn thư mục `back-end/target` từ lần build trước:** xoá tệp thừa `back-end/target/classes/db/migration/V410__m3_ivr_voice_permissions.sql` (bản cũ của quyền giọng đọc, đã đổi thành V411); còn nó thì Flyway báo "Found more than one migration with version 410" dù mã nguồn đúng (m34 dính đúng lỗi này ở máy mình). CI dựng từ cây sạch nên không dính.

**Có 3 test đỏ thuộc mã Giờ vàng của Phúc, m34 không sửa:** `GoldenHourRulesHccModuleBoundaryTest` (3 ca: `addsNoNewPolicyInternalImportInPromotionProductionSource`, `keepsAllFrozenLegacyViolationsInsideTheRulesServiceImplementation`, `gate1BAddsNoNewBoundaryViolationToTheFrozenAllowlist`) vì `promotion/service/impl/GoldenHourCartServiceImpl.java` import `policy.domain.PolicyVersion` và `policy.repository.PolicyVersionRepository` (danh sách vi phạm đóng băng chỉ cho `GoldenHourRulesServiceImpl`). Phúc quyết: đưa qua cổng `port.in` của Policy hoặc cập nhật danh sách đóng băng.

## 1. Mã

- Repo bán hàng. `dev` trên GitHub và trên GitLab đều là `51c9f5275` (26/11, Toàn đẩy; đã gộp xong hai nhánh của Phúc và của Toàn, không xung đột về chữ).
- Commit của m34 trong đó:
  - `ed2983eb0` backend G-08: M3 chuyển đủ 26 tuyến của M8 (hồ sơ giọng 10, nghe thử 5, cụm tên địa bàn 8, trần cuộc/ngày 3) và thêm tuyến `POST /api/v1/admin/ivr/queue/resume`.
  - `c70323514` frontend G-09 + T-02: hai trang mới và thẻ trần.
  - `356e7e1e3` tài liệu: ghi lại việc mở tuyến `queue/resume` (Toàn chốt 26/11, m34.136 = A).
  - `32dc2f3c1` đổi số migration quyền giọng đọc từ V410 sang V411 (V410 là của giỏ Giờ vàng, Phúc).
  - `31d1d6261` và `51c9f5275`: hai commit gộp (GitLab `dev` của Phúc vào `toandeptrai`, giữ V410 của Phúc và V411 của m34).
- Ghim hợp đồng M8 draft.50, hash `a8852a7f92d98f6f58424b37ec86d190fe61f5991c549f59668531c66481bcb6`.
- Đường JSON dùng chung của quản trị IVR (IvrAdminHttpClient) giữ nguyên hành vi; audio và CSV đi nhánh riêng thêm vào (trần 2 MiB, clip bank tối đa 44 + 2 × 2.400.000 byte).

## 2. Flyway (migration)

- Thang trên `dev` bây giờ: V405 đến V409 luật gọi M3 (thêm cột, nới ràng buộc; V407 thêm 3 quyền Luật gọi), **V410 giỏ Giờ vàng của Phúc**, **V411 của gói này**. `kiem_migration`: 377 tệp, lớn nhất V411, 0 lỗi (m34 chạy trên cây đã gộp).
- Theo lời Phúc, .99 đang chạy `c5a43caaa` (đã có V410): m34 chưa đọc lại bảng lịch sử Flyway trên .99, **CHƯA KIỂM**; Phúc xem số cao nhất trên .99 trước khi lên (Flyway `out-of-order=false`).
- **V411:** chỉ thêm danh mục 4 quyền, chạy lại được (`ON CONFLICT DO NOTHING`):
  - `IVR.VOICE.EDIT` (soạn, sửa, làm nóng hồ sơ giọng, nghe thử), `IVR.VOICE.ACTIVATE` (đưa hồ sơ giọng vào chạy, quay lại bản trước), `IVR.PHRASE.REVIEW` (duyệt, từ chối, đọc lại, yêu cầu dựng cụm), `IVR.COST.EDIT` (đặt trần gọi mỗi ngày).
  - M3 gửi sang M8 tên tương ứng `IVR_VOICE_EDIT`, `IVR_VOICE_ACTIVATE`, `IVR_PHRASE_REVIEW`, `IVR_COST_EDIT`.
- **Bốn quyền KHÔNG gán sẵn cho vai trò hay tài khoản nào.** Toàn tự gán trong quản trị phân quyền sau khi lên bản. Phúc không gán.
- Tuyến `queue/resume` không thêm quyền mới: dùng `IVR.DANGER` (chủ hệ thống), xem 3.3.
- Lần sau ai cần số migration mới thì lấy từ V412.

## 3. Cấu hình .99

3.1. **Không có biến mới bắt buộc cho 26 tuyến.** M3 dùng khối `app.ivr-admin.*` đã có (lớp chồng `compose.m8-that.quan-tri.yml`, D-m34-082): địa chỉ M8, ba tệp token `admin-read`, `admin-write`, `admin-danger`. Đọc và nghe dùng token đọc; soạn nháp, làm nóng, nghe thử, duyệt cụm dùng token ghi; kích hoạt, quay lại hồ sơ giọng và đặt trần dùng token tầng danger.

3.2. **CẢNH BÁO token danger.** Theo chú thích của chính lớp chồng, `admin-danger` trên .99 chỉ là tệp giữ chỗ để cấu hình qua bước kiểm tra. Các thao tác kích hoạt, quay lại hồ sơ giọng, đặt trần, và cả duyệt/kích hoạt Luật gọi đi bằng token tầng danger, nên cần một token danger thật khớp với M8 (Toàn/M8 cấp, đặt qua đường `m8-that/bi-mat` như hai token kia). Nếu vẫn là tệp giữ chỗ thì M8 từ chối các thao tác đó; đọc, nghe, soạn nháp, duyệt cụm vẫn chạy. m34 không đọc bí mật trên .99 nên **CHƯA KIỂM** token hiện tại. Phúc không tự tạo token, hỏi Toàn.

3.3. **`app.ivr-admin.privileged-user-id`: giữ không đặt.** Chỉ đặt khi Toàn nói rõ. Khoá này gắn `IVR.DANGER`, `IVR.AUDIT`, `IVR.EXPORT` cho đúng MỘT tài khoản (số id người dùng của Toàn), và nó mở nhiều hơn nút "Mở lại hàng đợi": còn tạm dừng hàng đợi, dừng cuộc gọi, gửi lại kết quả, xuất audit và báo cáo. Khi chưa đặt: nút "Mở lại hàng đợi" bị khoá và tuyến `queue/resume` trả 403 (đúng thiết kế, Toàn chốt 26/11).

3.4. **Giữ nguyên, không đụng trong đợt này:** luật gọi M3 vẫn `IVR_RULES_MODE_24_7=LEGACY_V4`, `IVR_RULES_MODE_GOLDEN_HOUR=LEGACY_V4` (đừng bật chế độ luật của M8; chờ cổng kiểm riêng của Toàn); các cờ production và cờ nối M3 với M8 như đang chạy.

## 4. Thứ tự, kiểm sau khi lên, cách lùi

**Thứ tự**
1. Nên để Toàn đưa M8 trên .99 lên bản có 26 tuyến draft.50 trước và cấu hình M8 (mục 5); KHÔNG bắt buộc để Phúc deploy: nếu M8 chưa lên thì chỉ các trang mới báo lỗi 404 hoặc 501 từ M8, các trang cũ và hoạt động bán hàng không đổi. Phúc cứ deploy khi sẵn sàng, Toàn báo khi M8 xong.
2. Phúc ghi lại SHA `be` và `fe` đang chạy trên .99 (để lùi), sao lưu DB theo quy trình hiện tại, rồi lên `be` + `fe` từ `dev` (`51c9f5275` trở đi) như mọi lần. Flyway tự chạy migration còn thiếu.
3. Toàn gán 4 quyền cho tài khoản của Toàn.
4. Kiểm như dưới.

**Kiểm sau khi lên (không gọi khách, không kích hoạt hồ sơ giọng thật, không đổi trần thật)**
- `be` healthy; Flyway cao nhất V411 thành công; 4 mã quyền có trong bảng quyền và chưa dòng nào gán cho ai.
- Đăng nhập tài khoản Toàn (đã gán quyền): mở `/admin/ivr/voices`, `/admin/ivr/phrases`, Báo cáo → tab "Cước gọi" → thẻ "Trần gọi mỗi ngày". Mỗi trang vào được, trong tab Network không có 401, 403, 404, 501. Nếu thấy 404 hoặc 501 ở các tuyến giọng, cụm, trần: M8 trên .99 chưa lên bản mới, dừng và báo Toàn (không phải lỗi M3).
- Thẻ trần hiện "Chưa đặt trần" nếu Toàn chưa nhập: bình thường (M8 không quay cuộc nào cho tới khi có trần).
- Nghe thử: nghe được câu cố định hoặc clip đã có; dựng mới trả "chưa bật" (409 `PREVIEW_UNAVAILABLE`) là đúng mặc định.
- Tài khoản không được gán quyền: vẫn xem được trang nhưng mọi nút ghi bị khoá.
- Nút "Mở lại hàng đợi" bị khoá khi `privileged-user-id` chưa đặt: đúng.

**Cách lùi**
- Chạy lại image `be` và `fe` của SHA đã ghi ở bước 2. Không có lệnh lùi migration: V405 đến V409 và V411 chỉ thêm cột, chỉ mục, nới ràng buộc hoặc thêm dòng quyền; mã cũ chạy được trên schema mới (m34 đọc mã migration, **CHƯA thử lùi trên .99**).
- Nếu chỉ các trang mới lỗi mà chỗ khác chạy bình thường: không cần lùi, báo Toàn. Mỗi trang chỉ hiện cho người có quyền xem IVR.

## 5. Điều kiện phía M8 (phiên M8 báo, Toàn lo, Phúc không làm)
- Repo ivr `origin/main` đã chứa mã 26 tuyến và hợp đồng draft.50 (hash như mục 1). **.99 hiện chạy M8 bản cũ `f8e29b46` theo sổ 21/11, chưa kiểm lại**, nên M8 phải được Toàn đưa lên .99 TRƯỚC (pipeline M8 do Toàn).
- Cấu hình M8 trên .99 (Toàn lo): API M8 cần khối `Ivr:Telephony:DailyBudget` giống worker; `Ivr:Speech:Tts:Prerendered` có ManifestPath và hash; đủ 3 `RegionalVoices`; `Ivr:Speech:Phrases:MediaDirectory` để nghe cụm; nghe thử dựng mới mặc định TẮT (`Ivr__Voice__Preview__Synthesis=OFF`); trần chưa nhập thì M8 không quay (`CEILING_UNSET`), nên Toàn phải nhập trần trên màn hình trước giờ bật gọi.

## 6. Đã chạy và CHƯA CHẠY (trung thực)
- Đã chạy (m34, 26/11 trên `51c9f5275`): `kiem_migration` 377 tệp 0 lỗi, `docker_tests.py --check` đạt, cây gộp không còn V410 trùng. Test lọc backend lượt 1 (2080 ca): 3 đỏ thật ở `GoldenHourRulesHccModuleBoundaryTest` (mã Giờ vàng của Phúc, ở trên) và 197 lỗi chỉ vì tệp V410 thừa trong `target` (đã xoá). Lượt 2 sau khi xoá: 93 lớp chạy xong, 0 lỗi Flyway, 0 đỏ, rồi hệ thống hết bộ nhớ nên lượt bị dừng, CHƯA có kết quả trọn. Giao diện bản trước khi gộp: eslint 0 lỗi, `tsc` 0 lỗi, `next build` đạt, vitest 11931 xanh và 9 đỏ (hai tệp `StorefrontHeader`, `collaborator-center-page`, chạy rất lâu, nhiều khả năng do tải máy).
- Coder tự báo (trước khi gộp): lớp Postgres của quyền giọng đọc chạy lại 2 lần không đổi dữ liệu, `E2eIvrPackPostgresTest`, xanh.
- **CHƯA CHẠY:** lượt test lọc backend sau gộp chạy trọn (bị dừng vì thiếu bộ nhớ máy); bộ đủ backend (hai shard); bộ đủ giao diện sau gộp; khởi động `be` thật với V410 + V411 trên Postgres sạch; trình duyệt thật với M8 thật; chạy trên .99 (m34 chỉ đọc, D-lead-060); verifier độc lập cổng Nguy hiểm cho phần này; kiểm token danger thật; thử lùi. **Phúc nên build và khởi động `be` thử trước khi deploy (Phúc thường làm bước này).**
- Chưa làm, chờ M8 gửi hợp đồng draft.51 (đợt lên bản thứ hai): nút "đặt cả bộ" (hoán đổi giọng giữa vùng) và màn hình cấu hình tỉnh thuộc vùng.
