# Sóng 2 M8 — 02E + 03A + 01A phía M8

Mốc 02/11/2026 20:31 UTC+7: **ĐẠT phạm vi công cụ/LAB và M8 mock; đã chốt bằng commit local** theo D-m8-015 và D-m8-016. Chưa push, deploy, SSH hoặc mở gọi thật.

## Mã nguồn và bằng chứng

- Gói ba WP: `5fa00ccdc6cabb52b5e13edfe41b7b46c4289c28`.
- Nguồn được kiểm cố định: `055b9a9f799a1e4a0ec5fba46d3fdf9b29e159aa`; gồm sửa test Dashboard đọc trường query có cấu trúc, không đổi runtime/allowlist metric/dependency.
- Commit chốt hồ sơ: `f14a6a256d0a69f1edaef2512015d6bd372f3628`. Chỉ evidence, CURRENT, một liên kết README tracker và mục nhật ký của sóng này; giữ WIP callback/M3 và nội dung nhật ký của phiên kia. Không nhận main hiện tại là source đã kiểm hoặc checkout sạch.
- [Hồ sơ kiểm bản sao](../../../../ginsengfood-ivr/docs/evidence/W-0494/wave2-final/README.md) và [diff trước ghép](2026-11-02-song2-diff-r3.md) giữ kết quả, hashes và lịch sử đỏ. Repo evidence thực tế tại `C:\Projects\ginsengfood-ivr\docs\evidence\W-0494\wave2-final`.

## Kết quả ba gói

| WP | Hoàn thành và kiểm độc lập | Giới hạn |
|---|---|---|
| 02E / W-0492 | Entry monitoring theo profile/inventory/approval ghim, action và scope state kiểm trước engine; Linux62, actual same14/cross14+2foreign, tester/verifier91 và2mutants; SQLite/TSDB + UNKNOWN→fresh | Chưa nối F5/R5 hoặc niêm phong candidate; máy thật/reboot thuộc02F/07B |
| 03A / W-0493 | Nối5ref LAB, ivr_backup TCP, transport identity, CA recovery; v2 chain36, backup21, profile12, tester20; verifier guard11/adapter9,3mutants | Image adapter chỉ LAB; kho ngoài máy, host restore và production custody chưa nghiệm thu |
| 01A / W-0494 | M8 auth audience/lifetime, HEALTHY→UNKNOWN→fresh; Contract24, mappedIntegration149,5mutants, verifier focused5 + mutant; E2E mới đầy đủ bên dưới | Chỉ M8/mock; phiên m34 tiếp tục sở hữu phần M3 thật, không suy kết quả bên m34 từ hồ sơ này |

Không cộng các bộ kiểm chồng nhau. 03A tester bắt T1/T2, hai guard v2 đóng lỗi và cùng20test chuyển17/20→20/20. Full-secret237+5skip/Windows5 là lịch sử v1, không nhận là v2.

## Kiểm cuối trên bản sao 055b9a9

| Kiểm | Kết quả được nhận |
|---|---|
| Nguồn / build | 4.423 tệp public khớp Git; bỏ3private inputs không đọc/copy. Locked restore/npm ci, Release build0warning/0error, tool restore đạt |
| .NET | 2.459 ca riêng biệt có suite cuối đạt: Unit1.631, Integration782, Contract24, Chaos8, Media14;0skip |
| Python | 8 bộ đạt: monitoring153; backup-contract12; backup-independent20; secret-backup12; DB-backup4; DB-unit112; cutover116; VM112. Không cộng thành tổng duy nhất |
| Default gates | 51/51 đạt;39skip theo manifest. Không thay release/extended/hosted gates |
| Mock E2E | 2/2vòng,46tasks,7fault scenarios;0failures/0open findings; PostgreSQL riêng đã xóa; cổng5117/18187/55497 không còn listener |
| Độ ổn định | 4.423 source hashes nguyên; lượt kiểm lại bảo vệ thêm361binary, tổng4.784. Không đổi source/assertion/timeout hoặc runner settings |

Lượt full solution đầu trên bản sao có Unit1.627 đạt/4timeout. Verifier không kết luận được nguyên nhân. Chạy đúng hai vòng, từng method riêng (15executions/vòng), rồi toàn Unit một lượt độc lập với runner mặc định: tất cả đạt. Bốn lỗi đầu vẫn lưu; đây không phải tuyên bố lượt đầu toàn solution xanh hoặc đã sửa nguyên nhân timeout. Theo dõi lại rủi ro này khi đóng candidate.

Lượt main trước đó báo2.459PASS nhưng bị loại vì source/binary bị phiên khác sửa giữa chừng. Lỗi Dashboard cũ, fixture Python, setup E2E và phép thử reuse assembly bị từ chối đều giữ lịch sử; không dùng để thay kết quả cố định mới. Verifier chốt hồ sơ độc lập và PII scope cuối được lưu trong delivery; không nhận global secret-clean.

## Sổ và vận hành

Board ghim055:0/4,482work items,121EVIDENCE_SUBMITTED,11gate BLOCKED_EXTERNAL. Sẵn sàng tăng46,5→47,0% do backup40→50 khi đã nối quyền và integrated restore LAB; các trọng số khác giữ nguyên, không tự ACCEPTED.

Tracker cập nhật một lần M8-002/IN_PROGRESS, nhắc M8-003/M8-001; đã đồng bộ Sheet. Commit chỉ lấy mục nhật ký của mình bằng index riêng, giữ byte working nhật ký và staging khác. Build-server shutdown một lần thành công. Container/port riêng đã dọn.

Automatic approval review từ chối xóa archive `m8-wp02e`, lý do `blocked by policy`; dừng cleanup archive và giữ02E/03A/01A/bản sao cuối. Các block trước tại01A `W-0494/temp/r1` và `wp03a-independent-kav0y_b_` vẫn giữ nguyên. Không retry bằng công cụ khác hoặc xóa cha. Raw diagnostic riêng không đọc/hash/copy vào delivery. Vì vậy cleanup filesystem **chưa hoàn tất**; xem `final-cleanup.json` trong bằng chứng.

`.61` dùng tạm cho khóa LAB. Kho/người giữ/khôi phục production chốt trước cấp production/release. `REAL_CUSTOMER_CALL_ALLOWED=NO`, `production_accepted=false`, `deployable=false`.

Bước kế tiếp: nhận đầu vào07V-L (nội dung/pháp lý/artifact được duyệt), rồi07B-L đóng đúng candidate;02F cần inventory/quyền/custody/cửa sổ. Chưa tự chạy sóng kế.
