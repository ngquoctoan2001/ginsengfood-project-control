# M34 · Đồng bộ dev GitLab · 27/11/2026 · Codex

Đã đẩy `toandeptrai:dev` lên GitLab và xác nhận gương GitHub nhận cùng SHA `2a255c521f7a2de27cf110a09c81f77012b8136b`. Không triển khai máy chủ, không gọi khách. Task M3-023 giữ **IN_PROGRESS**.

## Phạm vi và kết quả Git

- Lệnh Lead: “đồng bộ dev gitlab”; sau khi phát hiện 80 mục WIP, Lead xác nhận “Đã xong, các phiên đã dừng”. Thực hiện theo PHIEN.md mục Git của repo bán hàng, D-m34-112/116/117.
- Nhánh làm việc: `toandeptrai`. HEAD đầu lượt: `51c9f5275ca6797836ab8090d11911ed21a6fd6a`.
- GitLab dev đầu lượt: `10e4525bdb07b0c96ecb8be24f65354705773552`; gộp 65 commit vào nhánh local. Fetch lại ngay trước push, dev vẫn là tổ tiên của HEAD.
- `a83e3ffb3`: chốt 86 tệp IVR draft.51 và điều kiện gửi đơn đã hoàn tất. Sao lưu 88 tệp WIP thực tế trước sửa; hai tệp ngoài commit là `.gitignore` và `docs/weekly-tracking/nguyen-quoc-toan.md`.
- `cdcd23e93`: merge GitLab dev, giữ cả thay đổi IVR và các thay đổi Giờ Vàng/SPX của dev. OpenAPI ba chiều khớp cây kỳ vọng: 895 path, 0 xung đột cấu trúc.
- `2a255c521`: sửa bảo toàn bằng chứng hạn mức và regression test Giờ Vàng COD sau khi Postgres phát hiện lỗi.
- Chạy riêng lệnh `git push gitlab toandeptrai:dev`, thành công. Không push nhánh `toandeptrai`, không push origin, không force, không mở PR.

| Ref đọc trực tiếp sau push | SHA |
| --- | --- |
| GitLab dev | `2a255c521f7a2de27cf110a09c81f77012b8136b` |
| GitHub dev qua gương | `2a255c521f7a2de27cf110a09c81f77012b8136b` |
| GitLab toandeptrai | `51c9f5275ca6797836ab8090d11911ed21a6fd6a` |
| GitHub toandeptrai qua gương | `51c9f5275ca6797836ab8090d11911ed21a6fd6a` |

Hai ref dev khớp nhau; hai ref toandeptrai khớp nhau nhưng chưa được đẩy trong phạm vi lệnh này. Vì local theo dõi `gitlab/toandeptrai`, Git vẫn báo ahead **68** (65 commit nhận từ dev + 3 commit lượt này). Số này không có nghĩa dev còn thiếu 68 commit.

## Kiểm tra và sửa lỗi

Ba reviewer độc lập rà backend, frontend, hợp đồng; reviewer backend rà lại diff hai tệp sửa. Không còn blocker trong phạm vi đã rà.

| Kiểm tra | Kết quả |
| --- | --- |
| Biên dịch backend + 19 lớp kiểm thử chọn lọc tại SHA cuối | **269 PASS**, 0 fail/error/skip |
| Postgres cô lập trong bộ trên | **70 PASS**; fresh và upgrade áp đủ 382 migration đến V416 |
| Frontend IVR + AdminSidebar | **554 PASS**, 36 tệp |
| TypeScript | **PASS** sau `next typegen`; lượt đầu vướng `.next/types` còn tham chiếu trang Giờ Vàng đã bị dev xóa |
| Kiểm số migration | 382 tệp, cao nhất V416, 0 lỗi |
| Danh mục Docker test | Đủ 530 lớp |
| Gitleaks phần thêm so với GitLab dev trước push | 2 commit nội dung, 0 phát hiện |
| OpenAPI merge ba chiều | PASS; giữ đúng thay đổi hai phía |

Frontend được kiểm tại `cdcd23e93`; đã đối chiếu `git diff cdcd23e93 HEAD -- front-end contracts` rỗng sau commit sửa. Không cộng kết quả backend lượt lỗi vào kết quả đạt: toàn bộ 19 lớp được chạy lại tại SHA cuối.

Lượt backend đầu: 268 ca, 2 lỗi. Đã xử lý:

1. V415 có `ON DELETE CASCADE` từ sổ hạn mức đến orders. Đổi thành `RESTRICT` để xóa đơn không làm mất bằng chứng DIALED và mở lại suất. Giữ nguyên bài test cấm cascade; V415 chưa có trên remote ở thời điểm sửa.
2. Test cũ còn yêu cầu GH COD bị từ chối, trái tính năng V416. Thay bằng kiểm tạo đúng một decision/confirmation/command, receipt NULL, payload GH+COD, replay giữ ID/bytes và trạng thái đơn/thanh toán. Bổ sung ca đơn ONLINE đã PAID và payment SUCCESS vẫn từ chối receipt null/rỗng/khoảng trắng; receipt hợp lệ mới tạo lệnh.

Một cảnh báo whitespace trong tệp `front-end/src/features/gold_hour/api.ts` nhận từ dev đã có nguyên trạng ở GitLab; blob sau merge bằng blob dev, không sửa ngoài phạm vi. Diff riêng của lượt này đạt kiểm whitespace.

## Giới hạn và bàn giao

- Đây là bằng chứng compile, contract, unit/component và Postgres cô lập. Chưa chạy full suite, CI hosted, kiểm UI trình duyệt hoặc UAT M8 thật trong lượt này; không kết luận go-live.
- PostgreSQL regression hiện có chứng minh fresh/upgrade và các luồng được chọn, chưa thay thế bộ nghiệm thu đầy đủ quota/admission/evidence mới qua M8.
- Phúc nhận dev đã có V414–V416, không cần gộp lại nhánh Toàn. GH COD checkout phía Phúc và kiểm đủ bốn tổ hợp M3–M8 MOCK còn theo gói tương ứng. Trước triển khai .99 cần bộ đủ và duyệt triển khai; phiên m34 không ghi .99.
- Giữ chính sách/evidence tắt mặc định, chế độ quota MOCK; không tự bật kết nối hoặc gọi thật.
- `.gitignore` giữ nguyên hash; nhật ký tuần chỉ thêm 15 dòng. `assets/` vẫn bị ignore ở dòng 23, không có tệp assets nào được Git theo dõi.
- [M3-023](https://docs.google.com/spreadsheets/d/1Fxftz_B9zQXCREcmDvvGjxqRwqI_ux1klOhoaCbIJnY/edit#gid=170527702&range=A24): đã ghi bằng CLI và đọc lại, branch `toandeptrai`, SHA cuối, trạng thái **Đang làm**; không đổi cột Lead duyệt.

## Bằng chứng cục bộ

Thư mục `C:\Projects\_wt\_luu\m34\dong-bo-gitlab-20261127-codex` chứa:

- `wip-before.zip`, `wip-manifest.json`, `allowlist.txt`: sao lưu và phạm vi commit.
- `be-tests.log`, `initial-migration-failure.txt`, `initial-producer-failure.txt`: lượt phát hiện lỗi.
- `be-tests-final.log`, `be-exit-final.json`, `validation-summary.json`: kết quả tại SHA cuối, kèm tổng 70 ca Postgres.
- `fe-tests.log`, `fe-types.log`, `fe-typegen.log`, `fe-types-regenerated-exit.json`: kết quả frontend và lỗi cache đã khắc phục.
- `openapi-merge-check.json`, `gitleaks-fixed.json`, `gitleaks-fixed.log`: kiểm merge hợp đồng và bí mật.
- `gitlab-refs-after.txt`, `github-refs-after.txt`, `tracker-log.json`, `weekly-before-final-log.md`: xác nhận remote/tracker và bảo toàn nhật ký.

Khoá `@dong-bo`/`@bo-kiem-du` và các thư mục được giữ trong suốt công việc, giải khi hoàn tất. Không thay đổi hoặc gỡ khoá của phiên khác.
