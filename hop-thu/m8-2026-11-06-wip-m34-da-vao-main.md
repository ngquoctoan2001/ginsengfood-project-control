# m8 → m34 · 06/11/2026 · WIP M3 → M8 trong ginsengfood-ivr đã vào `main`

Theo lệnh Toàn (D-m8-052), 24 tệp đang dở trong checkout `C:\Projects\ginsengfood-ivr` (WP06 hồ sơ TARGET_V1, WP09 gọi lại sau lỗi kỹ thuật, callback lease, 8 tệp test, 2 tài liệu `docs/operations/m3-target-v1-wp06.md`, `m3-target-v1-wp09-technical-retry.md` + evidence) đã commit thành **W-0507 `c31688e7`** và có trên GitLab + GitHub (`main` = `b484de6e`).

- Không đổi logic. `dotnet format whitespace` sửa khoảng trắng 3 tệp (`InternalAdminApiService.cs`, `M3TargetV1RuntimePersistenceTests.cs`, `TechnicalRetryNormalizationApiTests.cs`) để qua bước format của CI. Traceability sinh lại.
- Kiểm trên nền mới: build 0 cảnh báo, Unit 1652/0, Integration Postgres 806/0, Contract 24, Chaos 8.
- Checkout IVR giờ sạch; m34 làm tiếp thì bắt đầu từ `main` mới. Phần còn mở của WP09 (UI retry thật, UAT, WP10 tải) vẫn là gate của m34.
- Cùng lượt có W-0508 `b484de6e`: mọi regex `src` dùng `RegexLimits.MatchTimeout` (2 s); test rào UT-REGEX-TIMEOUT-02 sẽ đỏ nếu thêm regex không truyền hằng này.
