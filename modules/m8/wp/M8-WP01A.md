# M8-WP01A — Chuẩn bị và nghiệm thu phần M8 trong luồng xác nhận đơn

Trạng thái: ĐẠT LOCAL — phía M8/mock; M3 thật do phiênm34 sở hữu · Rủi ro: R2 · Chế độ: A · Mốc: 05/11 chuẩn bị M8; 10/11 nghiệm thu tích hợp khi có bàn giao
Hạng mục nâng: Nối M3 40 giữ nguyên với mock; 75 chỉ sau đủ ca thật và evidence hai phía · Sheet: M8-001 · Làn: L1
Ước lượng: 8 giờ công AI (5 coder + 3 verifier; chưa gồm thời gian phía M3); dự toán, chưa phải cam kết thời gian chờ ngoài.
Chỗ làm: `C:\Projects\_wt\m8\m8-wp01a` · Base sóng 2: `a625d6943dff9d4736422c71484bcf2c4765aef7`.
Chỗ kiểm: bản sao/checkout cố định của đúng bộ byte; không build trên checkout đang có coder sửa. Trước /song kiểm lại HEAD và phạm vi.

## Brief

1. Repo: `C:\Projects\ginsengfood-ivr`, chỉ `main`; phiên chính chuẩn bị bản sao git archive, không worktree/nhánh mới.
2. Mục tiêu: Chuẩn bị và nghiệm thu phần M8 trong luồng xác nhận đơn. Tiêu chí đạt:
   - 1. Lập mapping ca E01–E10 với test đã có; chỉ bổ sung ca thiếu, không viết lại harness chỉ để tăng số test.
   - 2. M8/mock có bằng chứng auth-deny, idempotency/conflict, retry/replay, stale/revoke, actor/audit, UNKNOWN→recovery trên một SHA.
   - 3. Phiếu nhận evidence có SHA/image M8+M3, môi trường, actor đã ẩn danh, correlation, expected/actual; mock không sửa CHƯA TEST M3 thành PASS.
   - 4. Khi phiên m34 bàn giao môi trường cô lập, kiểm phía M8 và đối soát; thiếu phần UI/producer M3 thì giữ thiếu, không gọi API tay thay bằng chứng của họ.
3. Phạm vi ghi: ca Contract/Integration .NET liên quan nhận task/callback/auth/replay/audit và harness M3-mock phía IVR, chỉ bổ sung phần thiếu sau mapping. Parent lập allowlist tệp cụ thể trước giao coder. Loại deploy/production-window, deploy/backup, deploy/operations/migration và test của WP03A/02E; không sửa cấu hình build chung. m3-e2e.md chỉ thêm kết quả đúng môi trường khi được phép.
   Tệp nóng: Không sửa OpenAPI draft.45/baseline/r2, repo M3, UI/BFF M3, credential S5; generated traceability do phiên chính.
   Cấm: secret thật, .env*, sheet.json, OpenAPI/baseline/hash niêm phong ngoài scope; không commit/push/merge/PR/deploy hoặc đổi cờ production.
4. Đọc trước: deploy/rollouts/production-window-20261027/m3-e2e.md:7-39; specs/api/openapi/*.yaml hiện hành; work-register.md:597-599.
   Thêm `AGENTS.md`, `CLAUDE.md` repo; `modules/m8/PHIEN.md`, `SAN_SANG.md`, bản rà `ra-soat/2026-11-02-ke-hoach-m8.md`.
5. Lệnh kiểm/phạm vi được dự kiến cho /song: Các test .NET Contract/Integration và pnpm e2e:mock trong môi trường riêng theo repo; không chạy compose chung/port cố định khi agent khác dùng, không test đơn/khách thật.
   Lượt /ke-hoach CHƯA chạy các lệnh này. Runtime/công cụ cũ giữ nguyên; dependency chỉ cài trong nơi cô lập khi brief /song cho phép.
6. Bằng chứng: SHA nguồn + image/tool/artifact hash thích hợp, môi trường, lệnh, số pass/fail/skip, kiểm âm/đột biến, phạm vi thiếu; không dữ liệu/giá trị bí mật.
   R2: test đỏ trước → coder → verifier độc lập. R3: thêm tester độc lập và Lead duyệt diff trước ghép. Không tự ký nghiệm thu hay gọi test lab là production.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Parent giữ tracker/W-ID/generated files và tích hợp tuần tự; tối đa 3 agent nặng.
   GitNexus index lúc khảo sát stale `00b9004`, query thiếu FTS: trước sửa symbol parent xử lý index/impact theo luật repo; không scout tự analyze.
8. Đầu ra ≤25 dòng: đạt/chưa xong/chặn, tệp đổi, bằng chứng, việc còn lại/tệp xung đột; tracker và commit để phiên chính.

## Phụ thuộc và ranh giới

Chuẩn bị M8/mock độc lập. E01–E10 thật phụ thuộc đầu vào bàn giao từ phiên m34; không khảo sát/giao/nhắc việc M3.
D-m8-010: .61 chỉ là kho tạm LAB, không chặn code/lab; custody production vẫn chốt trước cấp production/release.
D-m8-008: phần M3 do phiên m34 tự xử lý; m8 chỉ đọc để biết, không giao việc hoặc soạn/gửi hợp đồng cho M3.
Rủi ro/ước lượng phải đánh giá lại khi tái hiện lỗi, scope hoặc HEAD thay đổi; phát hiện thiếu quyền thì làm tiếp phần lab độc lập.

## Diễn biến

- 02/11 /ke-hoach: tạo phiếu từ 3 scout chỉ đọc và đối chiếu nguồn; chưa giao coder, chưa tạo bản sao, chưa chạy test/host.

## Bước kế tiếp chính xác

Sóng 2 chuẩn bị phần M8. Chỉ nhận đầu vào từ phiên m34, không chủ động soạn/gửi gói hợp đồng (D-m8-008).
- 02/11 14:28 · D-m8-015 cho chạy sóng 2 và commit local. Parent chuẩn bị archive lọc .env*/sheet.json; main sạch a625d694, GitNexus đang refresh. Dành W-0494 cho bằng chứng mới; không tự ghi sổ chung.
- 02/11 14:31 · Đã giao coder core, archive a625d694/3.950 tệp, lọc .env*/sheet.json; GitNexus refresh xong219,1s. 01A mapping trước allowlist code; 03A giữ slot Docker đầu, 02E unit/source trước. Không sửa main.
- 02/11 14:40 · Parent chốt allowlist sau mapping: TaskIntakeApiTests.cs (audience/expired/not-yet-valid ở ingress) và OperationsApiTests.cs (HEALTHY→UNKNOWN→recovery cùng app/actor), cùng evidence W-0494. Không sửa runtime/harness/Contract; ca hiện có giữ và chạy lại, mutant chứng minh coverage mới.
- 02/11 14:47 · Baseline93/93 TaskIntakeApi+OperationsApi+ServiceTokenEndpoint đạt trước thêm coverage. Parent cho mutation compile qua copy/.targets tạm riêng, không sửa src hoặc build chung; mỗi mutant phải đỏ vì assertion, sau đó rebuild bản thường và kiểm715hash bảo vệ. Chưa chạy mock E2E.
- 02/11 15:11 · Agent bị model at capacity; parent gọi resume đúng archive và kiểm process/state trước tiếp tục, không xóa/rerun kết quả vô cớ.
- 02/11 15:22 · Normal Rebuild đạt, Contract24/24; mapped Integration148/149 với1ERR_MODULE_NOT_FOUND yaml do archive chưa npm ci deploy/ci. Coder cài theo lock đã được phép, chạy lại cùng filter; 5/5 mutants bị bắt đúng assertion,715hash đang kiểm. E2E chuyển parent, PARENT_PENDING.
- 02/11 15:27 · Cleanup W-0494/temp/r1 (10 fixture compile-copy) bị automatic approval review từ chối trước thực thi, reason blocked by policy; giữ ngoài delivery allowlist, không xóa thư mục cha hoặc dùng công cụ khác. Archive01A phải giữ vì chứa target bị chặn.
- 02/11 15:36 · Coder freeze65tệp, manifest1bbf2c814ce49e898584f065c214a7687623893c544057a347fedfcda7f8d843; Contract24/24,Integration149/149,5mutants,format,PII đạt. Parent nhận E2E trên source frozen, runner ngoài repo wave2-parent/run_wp01a_e2e.py, session99679; mới build/setup, chưa có verdict.
- 02/11 15:55 · Parent E2E attempt1 dừng preflight vì fixture thiếu dev-seed, giữ log; attempt2 dùng seed.sql hiện có, không sửa runtime/harness. E2E exit0,2/2rounds,46tasks,0failures,51callbacks/0inconsistent; đang đối chiếu open_findings/sourcehash/cleanup trước verifier. Mock không đóng E01–E10 phía M3.
- 02/11 16:02 · E2E xác minh đủ7faults,open_findings/failures rỗng,3950hash+coder manifest nguyên,ownPG đã dọn. Parent bổ sung19tệp immutable riêng, manifest58bde2b1200bbee58ab3cdc17875043dd51beeba8ae1e1bf6db62bf81c806c97, PII19/0exception đạt. OPS nhận verifier R2 độc lập trên đúng coder+parent manifests; chưa ghép.
- 02/11 16:12 · Verifier OPS ĐẠT M8/mock:5/5 focused trước/sau normal rebuild, mutant độc lập bỏ no-store bị2assertion bắt;3950source và84coder/parent delivery paths nguyên. PII19tệp đạt, manifest verifier ce83e82b62d4f2c52dfb80372fcceb3b1fb75cc5c3b279507fd8e3cab1ea0864. Real E01–E10 vẫn CHƯA TEST M3; chờ ghép cùng sóng và kiểm main.
- 02/11 16:51 · Ghép5fa00ccd cùng sóng2, chỉ2testC# đổi. Parent giữ rawcode-change.patch context whitespace bằng exact-file attribute, không sửa patch lịch sử. Toàn delivery433hash đã khớp sau sửa CRLF do Git apply trên Windows; PII406đạt. Đang fullmain checks; E01–E10 thật vẫn CHƯA TEST M3.
- 02/11 17:14 · Full main phát hiện DashboardContractTests đọc cả prose DB role ivr_api; baseline a625 tái hiện1/1FAIL, test và20artifact nguyên byte giữa a625/5fa. Follow-up chỉ1testfile, không nới telemetry allowlist; coder24/24PASS, format/PII đạt, manifest8001df65. OPS nhận verifier độc lập; chưa ghép follow-up. Phạm vi bổ sung cần thiết để đóng kiểm cuối theo D-m8-015.
- 02/11 17:31 · Verifier ĐẠT24/24, mutant6assertions,3977hash nguyên,PII23. Patch62746f0c áp sạch51paths; parent CURRENT/register thêm2paths, commit055b9a9. Build mới đạt, binary có commit metadata mới nên bỏ dự định nối suite cũ, chạy lại full .NET và mainE2E cùngSHA. Chưa chốt gate tổng.

- 02/11/2026 20:31 UTC+7 · Chốt sóng2 theo D-m8-016 trên bản sao055b9a9: .NET2459 có suite cuối đạt (Unit đầu4timeout giữ lịch sử; toànUnit1631 rerun đạt),8Python,default51/51+39manifestskip,E2E2/2vòng46tasks;4.423source+361binary nguyên. ĐẠT phía M8/mock; M3 thật do phiênm34 sở hữu. Hồ sơ commit `f14a6a256d0a69f1edaef2512015d6bd372f3628`; WIP phiênkhác giữ nguyên, chưa push/deploy. [Kết quả](../ra-soat/2026-11-02-song2-m8-ket-qua.md). Cleanup archive bị automatic approval review chặn, chưa hoàn tất.

## W-0502 — mock cắt cuộc kết thúc ngay (D-m8-039, D-m34-024) · R2 · A · Sheet M8-001

- Trạng thái: **ĐẠT, ghép local `2acfd7e6`** (cha `e2662d0d`, 05/11), chưa push. Bản sao HEAD `8199ad8` (goc f337b94); verifier vòng 1 CẦN SỬA (test có thể treo, assertion thứ tự nói quá, chưa ghim chờ capture), vòng 2 ĐẠT. Trên clone sạch `2acfd7e6`: build 0 cảnh báo, unit 1635/1635; traceability sinh trên cây sạch 1373; gitleaks toàn lịch sử 0; PII 21 PASS. Đã báo m34: `hop-thu/m34-2026-11-05-m8-mock-cat-cuoc-da-sua.md`.
- Lỗi: `MockSchedulerDispatchGateway.CaptureDtmfOrTerminationAsync` (`MockTelephonyDispatchGateway.cs:519-522`) gọi `HangupAsync` rồi `await capture`; capture SIM giả chờ
  đủ `CaptureDelayMilliseconds` (lab 120 s) → lab 04/11 cắt cuộc mất 113 s, E35 cần `ended_at` ≤ 10 s. GitNexus impact: HIGH (1 caller `DispatchAsync`, 21 test gián tiếp).
- Tiêu chí đạt: test đỏ trước trên `e5d5aa8c` (capture trễ lớn, lệnh huỷ → lượt kết thúc trong vài chu kỳ poll, dùng thời gian giả nếu có); sau sửa xanh; capture bị huỷ
  không thành lỗi không quan sát; câu trả lời bấm phím sau lệnh huỷ vẫn bị bỏ; kết quả raw/normalized và retry kỹ thuật giữ nguyên (W-0111, W-0339);
  mọi test Mock*/TaskRevocation*/FakeSim*/DispatchDeadline xanh; đường Asterisk thật không đổi.
- Sau ghép: thả `hop-thu/m34-…` báo SHA để m34 chạy lại E35.
