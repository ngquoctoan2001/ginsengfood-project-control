# M9 — phản hồi PR #149 (sửa sau rà PR #148)

Người rà: Nguyễn Quốc Toàn · 06/11/2026
- PR: https://github.com/PhucApu/ginsengfood-business-platform/pull/149, nhánh `fix/m9-ra-soat-0511`, mã `b89b1d6e7`, tách từ `dev 1446b1524`.
- Cách rà: worktree tách rời; đọc toàn bộ diff (85 tệp); chạy lại bộ test M9 có DB; thử đột biến (bỏ từng chỗ sửa xem test có bắt không); đo các test đỏ sẵn trên `dev 1446b1524` để tách lỗi có sẵn với lỗi do PR.

## 1. Kết luận

PR sửa đúng lỗi chi trùng (P0) và các mục P1 anh nhận. Em không thấy lỗi P0, P1 mới.

**Chưa gộp được vì trùng số migration.** Sáng 06/11 `dev` đã có `V307__m3_m8_order_edit_permission.sql` (phần sửa đơn trước khi gọi IVR). PR đang dùng `V307__m9_finance_read_port_indexes.sql`. GitHub vẫn báo gộp được vì hai tệp khác tên, nhưng gộp vào thì Flyway báo trùng V307 và ứng dụng không khởi động. Anh đổi ba migration của PR thành V308, V309, V310 (hoặc số kế tiếp trên `dev` lúc gộp), chạy lại bộ test M9 rồi gộp.

## 2. Đã kiểm

| Hạng mục | Kết quả |
|---|---|
| Bộ test M9 có DB (lệnh như mô tả PR) | 58 lớp, 412 ca, 1 đỏ (`RbacDataSeederTest.catalog_matchesCanonicalFlowPermissionCodes`, đỏ sẵn trên `dev`), 1 bỏ qua (bộ nạp demo). Khớp số anh báo. Lượt đảo thứ tự lớp em chưa chạy lại được (Docker máy em dừng giữa chừng). FE `src/features/finance`: 50/50 đạt |
| Thử đột biến | Bỏ phần sửa P0, P1.5, P1.1, P2.3 thì test đều đỏ. Đổi lại mặc định nguồn quảng cáo về `stub` trong `application.yml` thì **không test nào bắt** (mục 5) |
| CI GitHub của PR (9 lớp đỏ) | 6 lớp đỏ sẵn trên `dev 1446b1524` trước PR (mục 4). Chạy lại trên đầu PR: `CarrierShipmentConcurrencyTest` đạt (CI đỏ do chập chờn). Hai lớp Postgres (`GuestOrderLookup…`, `CollaboratorRealE2e…`) đạt trên `dev`, trên CI đỏ vì mất kết nối Postgres; em chưa đo lại trên đầu PR được vì Docker dừng. PR không sửa mã của các vùng này |
| Đọc mã | Khoá khoản rồi khoá dòng trước khi xét chứng từ; ghi chứng từ song song không lọt; dòng đang giữ không ghi chứng từ được; hoàn nhiều lần không ghi `CLAWBACK` trùng (`source_ref` duy nhất, `ON CONFLICT DO NOTHING`) |

## 3. Trả lời các ý trong tin anh

| Ý của anh | Em trả lời |
|---|---|
| P0: dòng đã có chứng từ coi như đã chi, phần hoàn ghi `CLAWBACK` | Đồng ý, mã đúng như anh tả. Test P0-013 mới có ca hoàn hết; anh thêm giúp ca hoàn một phần và ca hoàn hai lần vào PR sửa 2 |
| P1.1 thực chi | Đúng. «Thực chi» = dòng còn chi + đã chi, dòng giữ tách riêng, số lúc lập giữ nguyên |
| P1.2 «Đối soát với M3: Chưa chạy» | Đồng ý tạm như vậy. Đối soát thật với trang doanh thu M3 em nghĩ nên có trước nghiệm thu 09/11 (cổng `report.port.in`, làm với Phúc) |
| P1.3 nguồn mặc định `none` | Đúng. Em soát cả cấu hình các môi trường và `deploy/`, không còn chỗ nào mặc định `stub` |
| P1.4 cờ seed không cấp `FINANCE.*` | Đúng. DB nào đã seed trước PR thì anh gỡ tay quyền `FINANCE.*` của admin seed |
| P1.5 duyệt kéo lại hoa hồng M3 | Đúng, chạy trong cùng giao dịch duyệt; M3 lỗi thì không duyệt được, không lọt |
| P1.7 cả bộ xanh một lượt | Đúng, em chạy lại thấy cả bộ M9 xanh trong một lượt (trừ ca đỏ sẵn) |
| Ý a chỉ mục, ý c xoá đệm | Đúng. Xoá đệm chạy sau khi giao dịch hoàn commit, lỗi đệm không làm hỏng giao dịch hoàn. Phúc review phần mã M3. Ba chỗ M3 đổi trạng thái tiền mà chưa xoá đệm (anh liệt kê trong PR): anh gọi cùng cổng ở ba chỗ đó luôn |
| P2.3 M6 trả rỗng | Đúng |
| P2.10 không bắt khác người giữa ghi chứng từ và «Đã chi» | Đồng ý, chốt chặn là khớp sao kê |
| P2.11 hoa hồng tăng ghi bản ghi bỏ qua | Không chi thêm là đúng. Nhưng chưa có màn hay API nào cho kế toán xem bản ghi `M3_COMMISSION_INCREASED`; job chạy nền thì số bỏ qua chỉ vào log. Anh thêm chỗ xem ở PR sửa 2 |
| P2.1 ngưỡng thuế theo lần hay theo tháng | Anh hỏi kế toán, có câu trả lời thì báo em |
| `.63`: staging chính và `stg_m9` đặt `SEED_ADMIN_FULL_PERMISSIONS=false`; `stg_m9` có dữ liệu demo cho chú xem | Được. Chú xem xong anh xoá `stg_m9` |
| MISA, ngân hàng: xuất tệp Excel đúng mẫu trước, API sau | Đồng ý làm tệp trước cho kịp hạn, với điều kiện: tệp đúng mẫu nhập của bản MISA công ty đang dùng, kế toán nhập thử thành công một kỳ trước 09/11, M9 ghi trạng thái từng chứng từ (đã xuất, kế toán đã nhập) để không nhập trùng. Ngân hàng cũng vậy: xuất UNC đúng mẫu và nhập sao kê khớp `bank_ref` phải xong trong hạn. Gửi MISA qua API làm khi có tài khoản thử |
| M6: để nguồn `none` tới khi Tài xong TRK-54 | Đúng, hiện API M6-134 trả mảng rỗng vì M6 chưa có job đưa chi phí đã duyệt vào bảng (TRK-67) và route nhập chi phí chưa nối DB (TRK-54). Em nhắc Tài xong hai việc này trước 08/11 để 09/11 bật `m6` |

## 4. Ba điểm anh nhờ quyết

1. **Số migration M9:** giữ luật của PR: migration mới lấy số kế tiếp trên `dev`, không bật out-of-order trên LAN. Thay cho ý b hôm trước (M9 giữ V270–V299). Trước khi gộp luôn kiểm lại số với `dev` mới nhất, như vụ V307 lần này.
2. **Mặc định chung `SEED_ADMIN_FULL_PERMISSIONS`:** giữ như PR, chỉ loại `FINANCE.*`, không đổi mặc định chung. `deploy/compose.lan.yml` đã đặt `false` sẵn.
3. **Test đỏ sẵn trên `dev`:** em đo trên `dev 1446b1524` thì có 6 lớp đỏ sẵn, không phải 3. Không phải việc của M9, PR này không cần sửa:

| Lớp | Lý do đỏ | Ai sửa |
|---|---|---|
| `RbacDataSeederTest` | `GOVERNANCE.APPROVAL.VIEW` (V300) chưa có trong danh mục quyền chuẩn | Phúc |
| `SkuTwoStateLifecycleMigrationContractTest` | Đầu tệp V302 thiếu chữ "số TẠM" test đòi | Phúc |
| `GoldenHourRulesPolicyGuardMigrationContractTest` | Thang số migration có lỗ (V256, V265–V269, dải M9 bỏ trống) và V248 đã có nhưng test vẫn coi là lỗ | Phúc ghi lỗ vào `AGREED_LADDER_GAPS` |
| `AdminChangePasswordOpenApiContractTest` | Chưa xuất OpenAPI đổi mật khẩu admin vào `latest.json` và chưa có snapshot | Phúc |
| `SkuMasterSeederWriteContractTest`, `P5F03cGoldenHourSessionWriterCensusTest` | `IvrOrdersRealE2eDataSeeder` (bộ dữ liệu thử M3→M8) | Toàn |

## 5. Gợi ý còn lại trong PR #149

Anh xem cái nào làm luôn trong PR sửa 2.

1. **Khoá ngược thứ tự.** Lệnh duyệt khoá bảng kê → khoản; lượt kéo số khoá khoản → dòng → bảng kê; «Đã chi» khoá dòng → khoản. Hai việc chạy cùng lúc thì Postgres huỷ một bên. Số không hỏng, nhưng nếu bên bị huỷ là lượt kéo thì cả lượt phải chạy lại. Sau PR ca này dễ gặp hơn vì `CLAWBACK` rơi đúng lúc kế toán sắp bấm «Đã chi». Gợi ý: cả ba chỗ khoá theo cùng một thứ tự.
2. **P2.4 còn sót:** tỷ lệ hoàn và giá trị trung bình vẫn trả 0 khi không có doanh số (`FinanceDashboardFigures.java:126-135`), nên vẫn hiện «0,0%», «0 ₫».
3. **V307 tạo chỉ mục không `CONCURRENTLY`** nên chặn ghi `orders` trong lúc dựng. Chạy lúc vắng, hoặc tách ra chạy `CONCURRENTLY`.
4. **Xoá đệm** quét toàn bộ Redis 4 lần mỗi lần hoàn; nên xoá theo khoá cụ thể.
5. **`increaseSkipSourceRef`** dùng `toPlainString()`, nên `100` và `100.00` thành hai bản ghi khác nhau.
6. **Mặc định nguồn quảng cáo chưa có test giữ.** Đổi `application.yml:606` về `stub` thì cả bộ M9 vẫn xanh. Nên thêm một test đọc cấu hình thật, khẳng định mặc định là `none`. Test `M6AdSpendClientTest.configurationPicksNoneByDefault…` có bắt phần annotation nhưng không nằm trong lệnh `-Dtest` của PR (tên không có chữ `Finance`), anh thêm vào lệnh chạy bộ M9.
7. Mô tả PR chưa liệt kê ba tệp FE: `api/adapters/finance-dashboard.adapter.ts`, `api/dto/finance-dashboard.dto.ts`, `src/test/finance/finance-acceptance-dashboard.test.tsx`.

## 6. Hạn

Hạn M9 là **09/11** (6 ngày từ 04/11), gồm cả MISA và ngân hàng. Lịch theo ngày ở mục 5 file rà 05/11 vẫn dùng, lùi một ngày.

## Giải thích từ

| Từ | Nghĩa |
|---|---|
| migration | tệp tạo hoặc sửa bảng dữ liệu, đánh số V…; hai tệp cùng số thì ứng dụng không chạy |
| Flyway | công cụ chạy migration theo số thứ tự khi ứng dụng khởi động |
| đột biến | cố ý bỏ một chỗ sửa để xem test có phát hiện không; test bắt được là test tốt |
| CI | máy tự chạy toàn bộ bài kiểm tra mỗi lần đẩy mã |
| khoá (lock) | giữ chỗ một dòng dữ liệu khi đang sửa để người khác không sửa cùng lúc |
| CLAWBACK | khoản phải thu lại vì tiền đã chi mà đơn bị hoàn |
| đệm | bản lưu tạm số liệu trong 10 phút cho trang chạy nhanh |
