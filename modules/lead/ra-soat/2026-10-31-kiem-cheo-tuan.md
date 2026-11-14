# Kiểm chéo báo cáo tuần 26/10–31/10/2026 (phiên lead, chỉ đọc, chạy lúc 31/10 14:25)
Phạm vi: 6 báo cáo trong `C:\Projects\bao-cao-tuan\2026-10-26_2026-10-31\`. Chưa có M3 bán hàng (Phúc; `PhucApu` không có commit mới từ 30/10 09:35) và M7.
Nguồn: `git_tong_quan.py --fetch --tu "2026-10-31 11:00"`, `git log/show/grep/branch -r --contains` trên remote. Không chạy test, không ssh.

## 1. Commit sau giờ chốt của từng báo cáo
| Module (giờ chốt) | Commit | Làm sai câu nào |
|---|---|---|
| M5 (13:59, `751d110`) | module5 `19b901f` 14:12 Tài: gộp PR #15 (M5-022), 10 commit vào `main` | SAI: "M5-022 PR #15 chưa gộp" (§1 hạng mục 2, §2.2, §4 #9, §5.1 T2); 14 → 15 PR; 57 → 67 vào main; hạng mục 2: 20 → 25, tổng 11% → 12% |
| M5 (13:59) | M4-PLAN `41c289fc` 14:23 Tài: rà độc lập M5-040 | SAI: "M5-040 chưa có rà độc lập". Bản rà: 2 lỗi Cao (câu nhạy cảm ngoài từ vựng không chuyển người; từ troll mới làm câu hỏi mua bị coi là troll = hồi quy). "Gộp 040 ngày 02/11" phải thêm bước vá |
| M5 (13:59) | M4-PLAN `226dc4dd` 14:13, `39f0c544` 14:20: Coder M5-030, M5-061 | Không sai (M5-030 sang "Coder xong"; M5-061 chưa rà độc lập) |
| M3 VC–TT (13:59) | business-platform `dev015` → `dc6acdef5`, `f672fa1ff` 14:19; M4-PLAN `fbbc1c4f` 14:20 Judge ACCEPTED | SAI: "`dc6acdef5` chỉ ở worktree", "Judge đang chạy", §5.1 T2. Nay ở `origin/dev015`, chưa vào `dev`; kiểm Postgres khoá đơn chưa chạy → hạng mục 7 giữ bậc 40 |
| M4 (14:02) | sổ M4-PLAN + nhật ký `f672fa1ff` (M4-002 vẫn Đang làm) | Không sai |
| M6 (13:57, `ee47894`) | 4 commit tài liệu Lead 11:38–13:35 (DL-051…054) | Không sai (trước giờ chốt) |
| M12 (11:15) · M8 (11:06) | 0 commit sau 11:00 | Không sai |
| Bỏ qua | business-platform `f29bf2667` (tracker); M7 `f24ab08` 13:19 (tài liệu) | — |

## 2. Chỗ nối giữa hai module
| Câu trong báo cáo | Kết quả | Bằng chứng |
|---|---|---|
| M8: "M3 chưa nối lần nào; E01–E10 chưa test M3" | Khớp | ivr `deploy/rollouts/production-window-20261027/m3-e2e.md:27-36` |
| M8: "callback tắt vì M3 chưa cấp URL" | Lệch (nhẹ hơn thực tế) | `dev` không có đầu nhận `/api/v1/internal/orders/{orderId}/ivr-result-callbacks`, không có mã gọi `/tasks`; `project/ivr/` chỉ 19 tệp xác thực. M3 còn phải viết mã |
| M8: hợp đồng IVR | Lệch hai nơi | ivr `1.0.0-draft.45`; contracts `ivr-order-confirmation.v1.yaml` vẫn `1.0.0` (21/09), không có `revoke` |
| M12 H5: "thiếu C37, chưa có ISSUED" | Khớp | ops-core `docs/decisions/hop-dong-module-ngoai.md:26`; `StateTransitionRegistry.cs:280-283` |
| M12 H8: "26 route, 13 sự kiện, webhook chưa bật .61, 0/11 ca" | Khớp tài liệu; .61 chưa kiểm chứng | `docs/reviews/27-10-16-30-ket-noi-module-3-truc-quan-review.html` |
| M12: "Phúc cùng chạy 11 ca" | Lệch (nhẹ hơn thực tế) | M3 chỉ gọi `/v1/availability/check` (`OpsCoreAvailabilityHttpAdapter.java:25`); không gọi `POST /v1/inventory/allocations`, không nhận webhook; `GoldenHourReservationServiceImpl.java:226` trả `HOLD_NOT_READY` |
| Hợp đồng M1–M2↔M3 (N8) | Lệch | business-platform ghim contracts `a3b4bbf` (08/06), kém origin 50 commit, chưa có `inventory/allocations`; ops-core ghim `a7832a4` |
| M5, M4: "hợp đồng M5↔M4 đã gộp (#11)" | Khớp, nằm sai chỗ | module5 `docs/05-reference/m4-channel-advise-contract.md`; contracts `ai-advisor.v1.yaml` khác hẳn |
| M4: "đường M5 gọi M4 có mã, 5 commit, chưa lên nhánh" | Chưa kiểm chứng | 5 commit không có trong repo máy này; `dev` chỉ có DTO `ai/runtime/api/channel/`, không controller |
| M4: "hạn chờ 8 giây ở M5" | Khớp hợp đồng, mã chưa theo | M5 mặc định 3000 ms (`outbound-dispatcher.ts:647`), chưa có `AI_ADVISOR_MODE` |
| M4: "giả định M5 đi qua `/turn`" | Lệch câu chữ | hợp đồng `:39` "Không dùng `/turn`" |
| M5: "client M4 vẫn là bản giả" · "gọi M7 mặc định noop" | Khớp | `adapters/mock/mock-ai-advisor.ts`; `m7-dispatch-mode.ts:16`, `env-reader.ts:32` vẫn nhận `real` |
| M7→M5 | Chưa kiểm chứng | không báo cáo nào nói; M7 chưa có mã |
| M5, M6: M6 bản giả, chưa nhận M3, chưa có client ops-core | Khớp (contracts có `ads-measurement.v1.yaml` 21/09) | `evidence-report.module.ts:25`; `recall_risk_mapper.py:4`; M6 cần secret ops-core từ Lead (M6-115), M12 không nhắc |
| M5, M6 (CH21) băm PSID | Khớp | `always-on-posture.ts:15`; `psid_hash.py` |
| M3: VNPAY PR #139, V257; GHN/VTP tắt; VTP chỉ ở `dev015` | Khớp; SIT 6/6 chưa kiểm chứng | `ece0a3dd3` trên `dev`; `application.yml:455,547,556` |
| M3: "C10 phụ thuộc ops-core C36 (Lead)" | Khớp; M12 bỏ sót | ops-core plan 25-09 `:180,201` QĐ-T10, QĐ-S4 "CHỜ QĐ" từ 28/09 |

## 3. Lead cần quyết khi viết báo cáo gửi Chú
1. 3 câu báo cáo Tài sai 15–25 phút sau giờ chốt → giữ số đã chốt, thêm dòng "cập nhật sau giờ chốt".
2. N5 (M3↔M8), N8 (M3↔M1–M2): phía M3 chưa có mã nối, Phúc chưa nộp → báo Chú ĐỎ cho mốc B; nhắn Phúc trước 02/11.
3. Hợp đồng chung chưa là nguồn thật → ghi "lấy theo repo chủ sở hữu", xếp lead.1 vào tuần 02–07/11.
4. Việc Lead nợ rải trong báo cáo Tài (CH21, hạ tầng M4/M5, người soát PR tiền, người thay chief, C36, secret ops-core M6, tên dùng chung M6, bộ chữ v1) → bảng "Lead quyết trước 03/11".
5. Giờ Tài không đủ (M6 tuần tới 57,75 giờ / 48 giờ cho M4–M6) → M5 trước, M4 phạm vi (a), M6 lùi staging (phương án b).
