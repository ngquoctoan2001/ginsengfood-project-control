# ivr-cuoc-goi — M3 ghim hợp đồng IVR draft.48 + proxy API đo cước gọi + tab "Cước gọi" trong Báo cáo xác nhận

Trạng thái: ĐẠT (bộ đủ 15:4x chỉ đỏ sẵn trên base; build OK) · ĐÃ VÀO DEV (PR #170, merge `826aee599`, 18/11 15:2x) · Sheet M3-204 Hoàn thành, Lead duyệt CHỜ TOÀN (máy chặn phiên tự ghi Đạt) · lên .99 chờ Phúc · Rủi ro: R2 (chỉ đọc, không tiền, không ghi dữ liệu; thêm route quản trị cùng quyền sẵn có) · Chế độ: A (worktree tách rời → patch → phiên chính áp + commit `toandeptrai`) · Mốc: 18/11
Nguồn: D-m8-135 (API), D-m8-141 (Toàn ở phiên m8 14:03: "bắn qua m34 làm tab cước gọi đi. cho xong luôn nhé"), hộp thư `hop-thu/m34-2026-11-18-m8-api-do-cuoc-draft48.md`.
Chỗ làm: `C:\Projects\_wt\m34\cuoc-goi` (HEAD tách `0d941de79` = `origin/dev` = `toandeptrai`; `front-end/node_modules` là junction tới checkout chính — KHÔNG xoá, KHÔNG `npm install`) · Patch: `C:\Projects\_wt\m34\cuoc-goi.patch`
M8: `C:\Projects\ginsengfood-ivr` `main` = `origin/main` = `4218d4eb` (draft.48 trong `feeca2ac`), sha256 `ivr-order-confirmation.v1.yaml` = `978b0db49a31607001bc9d1dabf23a37781913818978df3540006a8fb79b14b0`, callback không đổi (`323ba1d2…`).
Push / PR / gộp `dev`: chờ Toàn nói ở phiên m34. Lên .99: Phúc (D-m34-108).

## Brief
1. Repo `C:\Projects\ginsengfood-business-platform` CHỈ ĐỌC · làm trong `C:\Projects\_wt\m34\cuoc-goi` (HEAD tách `0d941de79`) · luật chung `C:\Projects\_wt\m34\_tools\BRIEF_CHUNG_SUA_NKB.md`
   (đọc trước; thay base = `0d941de79`, chỗ làm = `_wt/m34/cuoc-goi`). Repo M8 `C:\Projects\ginsengfood-ivr` CHỈ ĐỌC bằng `git -C C:/Projects/ginsengfood-ivr show 4218d4eb:<đường dẫn>` (không checkout, không fetch, không sửa).
   KHÔNG commit (phiên chính commit). KHÔNG ssh, không gọi máy .99/.63/.98, không gọi M8 thật.
2. Mục tiêu và tiêu chí đạt:
   (a) **Ghim draft.48** theo đúng khuôn lần ghim draft.47 (`git show 76ef7d060` — đọc trước): `specs/api/openapi/ivr-order-confirmation.v1.yaml` lấy nguyên byte từ M8 `4218d4eb`
       (sha256 phải = `978b0db4…14b0`), `contract-manifest.json`/các chỗ M3 ghim hash + phiên bản (grep `c0b81180`, `draft.47` trong `back-end/`, `specs/`, `docs/integration/m3-m8/`, `integration-requirements/`),
       `back-end/src/main/resources/ivr/admin-response-schemas.json`: đổi `source_sha256` + THÊM các schema response mới mà M3 dùng (`IvrCallUsage*` — lấy từ YAML draft.48, đừng tự chế),
       `IvrContractPinTest` (hash mới; đỏ trước khi đổi, xanh sau). Callback giữ nguyên. Mô tả `recall_of_task_id` chỉ đổi chữ, M3 không đổi logic.
   (b) **Proxy 2 route** theo khuôn các operation `/analytics/*` sẵn có trong `back-end/src/main/java/com/ginsengfood/project/ivr/domain/IvrAdminOperation.java` (SUMMARY, TREND, …, EXPORT) và `IvrAdminController`/`IvrAdminService`:
       `GET /analytics/call-usage` (JSON, quyền như SUMMARY = `IVR.VIEW`) và `GET /analytics/call-usage/export` (`format=csv` mặc định | `json`; quyền như EXPORT = `IVR.EXPORT`; trả CSV đúng content-type + tên tệp như route export sẵn có).
       Tham số cho qua đúng danh sách của YAML draft.48 (from/to, nhóm ngày|tháng, kênh/chế độ…); tham số lạ bị từ chối như các route khác; lỗi 400 của M8 (quá 31 ngày / 50 000 dòng) chuyển về rõ ràng.
       Đường M3 cho FE theo cùng tiền tố route quản trị IVR sẵn có (xem controller). Không đổi hành vi route cũ.
   (c) **Tab "Cước gọi"** trong màn Báo cáo xác nhận (`front-end/src/features/ivr/admin/components/IvrReportsScreen.tsx`, cùng kiểu ui-kit-v2 như các tab báo cáo sẵn có):
       chọn khoảng ngày (mặc định tháng hiện tại, tối đa 31 ngày), nhóm theo ngày | tháng; bảng tổng theo kênh: lượt quay, cuộc nghe, giây nghe, giây tính cước (+ dòng tổng);
       nút "Tải CSV tháng" gọi route export; lỗi quá giới hạn hiện thông báo tiếng Việt dễ hiểu; không có quyền `IVR.EXPORT` thì ẩn nút. Ý nghĩa cột, khối tính cước 6 s + 1 s: `C:\Projects\ginsengfood-ivr\docs\operations\call-usage.md` (đọc).
       Chữ giao diện tiếng Việt có dấu. API client + kiểu TS theo khuôn `front-end/src/features/ivr` sẵn có.
   (d) Tài liệu: `docs/integration/m3-m8/**` ghi draft.48 + hai route mới + tab; README mục liên quan nếu có danh sách route quản trị IVR.
3. Phạm vi ghi: `specs/api/openapi/**` (chỉ tệp ghim IVR), `back-end/src/main/resources/ivr/admin-response-schemas.json`, `back-end/src/main/java/com/ginsengfood/project/ivr/**` (domain/controller/service/dto cho hai route),
   test tương ứng trong `back-end/src/test/**`, `front-end/src/features/ivr/**` (+ test), `front-end/src/api/**` nếu client IVR nằm đó, `contracts/openapi/latest.json` + `contracts/api-snapshots/*` NẾU repo có test bắt khớp (chạy lệnh sinh sẵn có, không sửa tay),
   `docs/integration/m3-m8/**`. CẤM: `order/**` (logic đơn, callback, watchdog), `OrderIvrCallbackParser*`, `IvrTaskHttpClient.java`, migration, `deploy/**`, `security/SecurityConfig.java` (nếu cần mở đường mới mà khuôn sẵn có không bao → dừng, ghi `CẦN QUYẾT`), ops-core, repo M8.
4. Đọc trước: `git show 76ef7d060` (khuôn ghim), `git -C C:/Projects/ginsengfood-ivr diff c0b81180..4218d4eb` KHÔNG dùng được (hash là blob) → dùng `git -C C:/Projects/ginsengfood-ivr show feeca2ac -- specs/api/openapi/ivr-order-confirmation.v1.yaml`;
   `IvrAdminOperation.java`, `IvrAdminController.java`, `IvrAdminService.java`, test `IvrAdmin*Test`; `IvrReportsScreen.tsx` + `front-end/src/features/ivr/__tests__/`; `docs/operations/call-usage.md` của M8.
5. Lệnh kiểm nhanh (tầng 1–2):
   BE: `bash C:/Projects/_wt/m34/_tools/mvn-lock.sh C:/Projects/_wt/m34/cuoc-goi/back-end test -P ci-unit -Dtest='IvrAdmin*Test,IvrContractPinTest,<lớp test mới>' -DfailIfNoTests=false -Dsurefire.failIfNoSpecifiedTests=false` (timeout 600000 ms; `JAVA_TOOL_OPTIONS=-XX:MaxRAMPercentage=40`).
   FE (trong `C:\Projects\_wt\m34\cuoc-goi\front-end`): `npx vitest run src/features/ivr` · `npx tsc --noEmit -p .` (so số lỗi với base, không thêm) · `npx eslint src/features/ivr`.
   Bộ kiểm đủ — chỉ phiên chính, sau khi áp: vitest toàn FE + `npm run build`, ci-unit vùng `ivr` + `order` một lần.
6. Bằng chứng: patch `git -C C:/Projects/_wt/m34/cuoc-goi diff --binary > C:/Projects/_wt/m34/cuoc-goi.patch` (gồm tệp mới: `git add -N` trước khi diff); bảng hash cũ → mới; danh sách tệp; số test đỏ trước / xanh sau; đột biến ≤ 3
   (đổi 1 ký tự hash → test ghim đỏ; bỏ kiểm quyền export → test đỏ; đổi tên cột → test FE đỏ).
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra ≤ 25 dòng theo brief chung; báo cáo dài `C:/Projects/_wt/m34/cuoc-goi-bao-cao.md`.

## Diễn biến
- 18/11 14:1x tạo worktree `_wt/m34/cuoc-goi` (`0d941de79`) + junction `front-end/node_modules`, giao coder.
- 18/11 14:4x coder ĐẠT: patch 26 tệp +1444/−49; BE 16 đỏ trước → 111/0; vitest ivr 22 hỏng → 154/154; tsc = base; eslint 0; đột biến 3/3.
  Hai điểm hỏi, m34 chốt: chỉ ghim hash (khuôn `76ef7d060`, BP không có `specs/`); CSV do BFF viết từ JSON M8, trần 20 MiB + maxItems 50000 riêng route export.
- 18/11 15:0x verifier ĐẠT (chờ bộ đủ): chạy lại 111/0, 154/154, tsc 4 = base, eslint 0; tự diff 6 schema `IvrCallUsage*` khớp YAML (trừ maxItems đã chốt);
  quyền đúng; CSV 15 cột RFC 4180 + chống injection như M8; phạm vi cấm không chạm; đột biến 3/3. Ghi chú không chặn: câu lỗi khi M8 400 do from > to;
  hạn chờ 5 s với thân 20 MiB chưa đo trên .99; CSV BFF không qua PiiGuard cả tệp; chữ dạng mã unicode trong `ivrOperationsModel.ts`.
- 18/11 15:1x áp patch → commit `7c3910714` + Sheet M3-204 (`sheet-sync log`) + tracking `9f9aef5f1` trên `toandeptrai` (chưa push). Gỡ worktree coder (junction trước);
  worktree kiểm `_wt/m34/kiem-cuoc-goi` @ `7c3910714`; bộ đủ chạy nền (`_tools/bo-du-cuoc-goi.sh`, log `_wt/m34/bo-du-cuoc-goi/`).
