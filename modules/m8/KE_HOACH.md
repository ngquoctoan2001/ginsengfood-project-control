# Kế hoạch hoàn thiện M8 — 25/11 → 30/11/2026 (và sau)

Lập: 25/11/2026 bởi phiên m8 theo lời Toàn ("làm tới đâu cập nhật trạng thái tới đó, spawn nhiều sub agent, sau khi có file tôi qua account khác tiếp tục").
**Một người ghi file này: phiên chính luồng m8** (subagent báo kết quả về phiên chính, không tự sửa tệp này). Ngày giờ hiện tại: chạy `date`, không đoán.
Nguồn khảo sát (3 scout chỉ đọc 25/11, mọi `tệp:dòng` ở dưới đã được scout ghi): giọng đọc/API trong `ginsengfood-ivr`, màn quản trị trong `ginsengfood-business-platform`, trần cuộc + tổng đài .64 + nợ nhóm C.

## 0. Cách dùng file này (dành cho phiên mới ở tài khoản khác)

1. Mở Claude tại `C:\Projects\Project Control`, gõ `/phien m8` (phần Module 3 thì mở phiên khác `/phien m34`). Đọc theo thứ tự: `CLAUDE.md`, `chung/CACH_LAM.md` §3–§5, `modules/m8/PHIEN.md`, `modules/m8/TRANG_THAI.md`, **file này**, `modules/m8/cong-nguy-hiem.md`. Tài liệu khác chỉ đọc đoạn cần (grep).
2. Câu dán vào phiên mới (đủ để làm tiếp, không cần hỏi lại):
   `Mình vừa chuyển tài khoản. Đọc modules/m8/KE_HOACH.md, chạy date, kiểm git (ivr main, BP toandeptrai) rồi làm tiếp: chọn các WP SẴN SÀNG theo §5 (sóng hiện tại), mỗi sóng tối đa 3 agent nặng, khai khoá tệp bằng tools/khoa_tep.py, chỉ phiên chính commit theo đường dẫn. Push, lên .99, đổi cờ, ssh ghi vào máy chủ, chạy lệnh trên .64 chỉ khi mình nói đúng việc đó trong phiên này.`
3. **Cách cập nhật trạng thái (bắt buộc, từng bước):** sau mỗi việc xong/đổi trạng thái: (a) sửa dòng WP ở §3 (cột Trạng thái, SHA, ngày) và một dòng vào §8; (b) `modules/m8/nhat-ky/<ngày>.md`; (c) `node tools/task-tracker/sheet-sync.mjs log …` (chạy từ `C:\Projects\ginsengfood-ivr`; Sheet ghi tên "Nguyễn Quốc Toàn"); (d) `TRANG_THAI.md` giữ ≤ 60 dòng, ghi đè. Quyết định mới → `QUYET_DINH.md` (một dòng một mục, số tiếp theo D-m8-161) hoặc `/quyet`. Câu hỏi cho Toàn đánh số `m8.<n>` tiếp từ **m8.120**.
4. Mỗi WP có phiếu `wp/<tên>.md` theo `chung/MAU.md` §1, tạo **trước khi giao** và cập nhật mỗi vòng. Mã `W-NNNN` do phiên chính cấp từ `docs/release/work-register.md` (NEXT_WORK_ID hiện **W-0563**).
5. **Luật không đổi:** một checkout, không worktree/bản sao (D-lead-063); khai khoá `python "C:\Projects\Project Control\tools\khoa_tep.py" khai --repo <ivr|business-platform> --chu m8/<WP> --tep …`; chỉ phiên chính commit theo đường dẫn, cấm `add -A`/`commit -a`/stash/reset/clean/rebase; kiểm hai mức (D-lead-064: gói Thường = coder + phiên chính đọc diff + chạy lại test lọc; gói Nguy hiểm = thêm verifier độc lập một lần ở cổng); không đọc/in `.env*`, `sheet.json`, khoá, token, số điện thoại; **không push, merge, deploy, đổi cờ production, chạy migration/lệnh trên .99/.98/.64, gọi nhà mạng** trừ khi Toàn nói đúng việc đó; `REAL_CUSTOMER_CALL_ALLOWED` giữ NO; lên .99 phần Module 3 chỉ Phúc (D-lead-060).
6. **Ngân sách song song (CACH_LAM §5):** mỗi phiên tối đa 3 agent nặng (`coder`, `verifier`, tester) + 4 agent chỉ đọc (`scout`, `auditor`); chỉ 2 phiên chạy sóng code cùng lúc. Muốn nhiều tay hơn: phần Module 3 giao cho phiên `m34` (repo khác, tệp khác, chạy song song thật), không mở thêm agent nặng ở phiên m8.

## 1. Trạng thái xuất phát (25/11, trước khi bắt đầu kế hoạch này)

| Mục | Giá trị |
|---|---|
| Repo ivr (`C:\Projects\ginsengfood-ivr`, chỉ nhánh `main`) | HEAD local `f375bfaf`; remote (origin + GitHub) đang ở `6ed2d535`; **chưa push**: `30ceb19c` (W-0560), `15e5a6bb` (W-0561), `f375bfaf` (W-0562). Dirty không phải của m8: `docs/weekly-tracking/nguyen-quoc-toan.md`, `deploy/operations/m34_mock_agent.py` + `test_m34_mock_agent.py` |
| .99 | M8 `f8e29b46` (21/11), MOCK, lịch gọi TẮT, `REAL_CUSTOMER_CALL_ALLOWED=NO`; chưa kiểm lại 25/11 |
| .64 | Asterisk 22.11.0, ufw 5060 chỉ SBC MobiFone (02I xong 20/11); chưa luật RTP; CDR tắt; chứng thư lá ARI hết hạn 13/01/2027 |
| Hợp đồng M3 ↔ M8 | draft.49 hash CUỐI `af5b19204447276de55aa8f4f53a80364818ed46f74d782f95700cc2ff322e47`, callback `323ba1d2…` không đổi; M3 còn ghim draft.48 `978b0db4…` (`IvrContractPinTest.java:27`) |
| Repo bán hàng (`C:\Projects\ginsengfood-business-platform`) | `toandeptrai` = `d109369c2`; `origin/dev` hơn 59 commit (lần fetch cũ); migration cao nhất V409 (**V410 trống**); GitLab CI chạy khi push `dev`/`toandeptrai` |
| Cổng Nguy hiểm vùng 1 (lịch gọi + intake chế độ luật) | L-05/L-07/L-11 đã qua verifier 25/11 (ĐẠT, chờ bộ đủ); vùng 2 (quay số thật, cước, đích) chưa vào cổng |
| Số hiệu đang dùng ở sổ m8 | số W tới W-0562; quyết định tới D-m8-159; Sheet tới M8-029; không còn khoá tệp |

## 2. Quyết định của Toàn 25/11 (ghi D-m8-160) và cách hiểu để làm

1. **Giọng đọc tự phục vụ:** làm API + màn hình quản trị để **nghe thử và tuỳ chỉnh giọng đọc cho từng vùng miền**; sau đó không cần Chú duyệt lời thoại/tên nữa, Toàn nghe và chọn. Kèm các chức năng liên quan (duyệt/đọc lại cụm tên địa bàn, làm nóng, lịch sử, quay lại).
2. **Trần số cuộc mỗi ngày** cấu hình trên UI.
3. **Khung bảo trì tổng đài .64:** ufw cho âm thanh (RTP), ghi cước (CDR), đổi chứng thư ARI (hết hạn 13/01/2027).
4. Làm cả nhóm C (nợ kỹ thuật), D (kiểm + hồ sơ), B (việc cần Toàn nói) theo kế hoạch này.

Cách hiểu (phiên mới giữ, không tự mở rộng):
- **MVP kịp 30/11 = chọn trong 3 giọng đã chốt + chỉnh tốc độ từng vùng + nghe thử + duyệt cụm.** Mở thêm 11 giọng ứng viên (giai đoạn 2, G-11) phải sửa 3 tầng ghim (sidecar `backend.py:141`, bộ câu dựng sẵn, validator) nên **để sau 30/11**.
- Câu chữ lời thoại (kịch bản v6) vẫn cố định và vẫn bốn mắt (người tạo ≠ người duyệt, Content ≠ Privacy/Legal; `ScriptContentContracts.cs:225-255`); tính năng này chỉ đổi **giọng, tốc độ, cách đọc cụm**, không đổi chữ nói với khách. Kích hoạt giọng là **một người** (Toàn) với lý do bắt buộc + audit + kiểm sẵn sàng; có thể bật hai người sau.
- **Cổng pháp lý của mô hình giọng (`MODELS.lock`: `PENDING_SEP_SIGNATURE`, `production_activation_allowed=false`) nằm ngoài phần mềm**: UI/API không gỡ được. Ghi thành điều kiện bật thật (X-03) để Toàn tự chốt; không bỏ.

## 3. Bảng trạng thái (cập nhật cột Trạng thái khi làm)

Chú giải trạng thái: CHƯA LÀM · SẴN SÀNG · ĐANG LÀM · CHỜ KIỂM · ĐẠT · CHẶN (ghi ai/việc chặn) · CẦN TOÀN. Mức: **T** Thường, **NH** Nguy hiểm (qua cổng trước khi bật thật). Cỡ: nhẹ/vừa/nặng. Phiên: m8 (repo ivr) hoặc m34 (repo bán hàng). Cột Sóng ở §5.

| ID | Việc | Mức · cỡ | Phiên | Phụ thuộc | Sóng | Trạng thái | SHA / bằng chứng |
|---|---|---|---|---|---|---|---|
| **G-01** | Thiết kế giọng + cụm + nghe thử + trần (phiếu `wp/giong-doc-thiet-ke.md`), chốt phạm vi MVP | T · vừa | m8 | — | 0 | CHƯA LÀM | |
| **G-02** | Hợp đồng draft.50 (YAML + baseline + manifest + NSwag + freeze + docs) — viết TRƯỚC để M3 làm song song | T · vừa | m8 | G-01 | 1a | CHƯA LÀM | |
| **G-03** | Migration một lần cho G + T + N-03 (bảng `ivr_voice_profiles`, `ivr_voice_previews`, `ivr_cost_ceilings`, chỉ mục duy nhất sự cố tạm dừng) + entity + store | NH · vừa | m8 | G-01 | 1a | CHƯA LÀM | |
| **G-04** | `RegionalVoiceMap` đọc hồ sơ ACTIVE từ kho (cache ≤ 5 giây, rơi về `appsettings`), giữ validator | NH · vừa | m8 | G-03 | 1b | CHƯA LÀM | |
| **G-05** | API giọng: danh mục, hồ sơ hiện hành/lịch sử, nháp, `PUT`, `:activate`, `:rollback`, `readiness` | NH · vừa | m8 | G-02, G-03 | 1b | CHƯA LÀM | |
| **G-06** | Nghe thử: bảng previews + việc nền worker + `GET …/audio` (`audio/wav`) + nghe clip bank/cụm | NH · vừa–nặng | m8 | G-03 | 1b | CHƯA LÀM | |
| **G-07** | API kho cụm (thay CLI + thay "Chú duyệt 455 tên"): danh sách, nghe, duyệt/từ chối, đọc lại, làm nóng, tiến độ, xuất CSV | NH · vừa | m8 | G-02, G-03 | 1b | CHƯA LÀM | |
| **G-08** | M3 BE: thao tác + controller/service giọng/cụm + nhánh nhị phân audio + quyền V410 + ghim draft.50 | NH · nặng | m34 | G-02 | 1b | CHƯA LÀM | |
| **G-09** | M3 FE: trang `/admin/ivr/voices` + `/admin/ivr/phrases` | T · nặng | m34 | G-02 (fixtures) | 1b–2 | CHƯA LÀM | |
| **G-10** | Kiểm tích hợp hai phía + cổng Nguy hiểm vùng 3 (lời nói với khách) | NH · vừa | m8 + verifier | G-04…G-09 | 3 | CHƯA LÀM | |
| G-11 | Giai đoạn 2: mở 11 giọng ứng viên / giọng mới (sidecar, bank, gate, `MODELS.lock`) | NH · nặng | m8 | pháp lý (X-03) | sau 30/11 | CHƯA LÀM | |
| **T-01** | M8: guard trần đọc DB (rơi về options), API `GET/PUT cost-ceilings` + mức đã dùng hôm nay, audit | NH · vừa | m8 | G-03, G-02 | 1b | CHƯA LÀM | |
| **T-02** | M3 BE + FE: thẻ "Trần gọi mỗi ngày" (trần, đã dùng, trạng thái tạm dừng, sửa có lý do, mở lại hàng đợi) + quyền `IVR.COST.EDIT` | NH · vừa | m34 | G-02 | 1b–2 | CHƯA LÀM | |
| **T-03** | Toàn nhập số trần trên UI sau khi lên .99 | — | Toàn | T-01, T-02, B-02 | 4 | CẦN TOÀN | |
| **H-01** | Đọc (không sudo): hạn chứng thư lá ARI bằng `openssl` từ .99; tìm nơi giữ khoá CA; (sudo, Toàn gõ) `ufw status verbose` | T · nhẹ | m8 + Toàn | — | 0 | CHƯA LÀM | |
| **H-02** | Soạn kịch bản bảo trì `.64` (`buoc3`): ufw RTP + log, CDR, đổi chứng thư; có `lui`; thử trên host giả | NH · vừa | m8 | H-01 | 1a | CHƯA LÀM | |
| **H-03** | CDR tối giản: cấu hình + volume bền + cập nhật hash ghim `vm_deploy.py` + `verify` + test + trình tổng hợp đối soát (không số điện thoại) | NH · vừa–nặng | m8 | H-02 | 1b | CHƯA LÀM | |
| **H-04** | Cửa sổ bảo trì .64 (ngoài khung gọi, Toàn gõ sudo): thứ tự ở §4.H | NH · vừa | m8 + Toàn | H-02, H-03, (X-01 để chốt RTP) | 3–4 | CHẶN (H-02, H-03) | |
| **H-05** | Đổi chứng thư ARI (bundle mới, trước ~14/12; làm cùng cửa sổ nếu sẵn) | NH · vừa | m8 + Toàn | H-01 (khoá CA) | 3–4 | CHƯA LÀM | |
| **N-01** | Sửa số dòng ghim 5 ca đỏ `deploy/m8/tests` + `test_tat_khan_tinh.py:27-29` | T · nhẹ | m8 | — | 0 | SẴN SÀNG | |
| **N-02** | Mẫu `closed-profile.example.json` thêm `PlaybackCallLimitSeconds: 120` + ghim `components.lock.json:194-196` | T · nhẹ | m8 | — | 0 | SẴN SÀNG | |
| **N-03** | API tạm dừng/mở lại chịu nhiều hàng OPEN (`InternalAdminApiService.cs:320,373`) + chỉ mục duy nhất (vào migration G-03) | NH · nhẹ–vừa | m8 | G-03 (chỉ mục) | 0/1a | SẴN SÀNG (phần mã) | |
| **N-04** | Gỡ `allow 172.29.0.1` nginx 8443: đo log vài ngày rồi quyết; mặc định GIỮ | T · nhẹ | m8 | ssh .99 chỉ đọc (Toàn nói) | 4 | CẦN TOÀN | |
| **N-05** | Test biên 20:53:29/30/31 mức nhận đơn bản v3 | T · nhẹ | m8 | m8.127 | 0 | CẦN TOÀN | |
| **N-06** | GRANT `ivr_capacity_incidents` cho `ivr_monitor` (`monitor-grants.sql:15`, hash `db_provision.py:54`) — chốt còn dùng không | T · nhẹ | m8 | m8.128 | 0 | CẦN TOÀN | |
| **N-07** | Lịch đêm 03:30 (`tao-lich-dem.sh --chay`) | T · nhẹ | m8 | token + id GitLab (X-08) | 4 | CHẶN (X-08) | |
| **N-08** | Quét trước push bằng Docker (gitleaks `zricethezav/gitleaks:v8.30.0`, PII Linux, oasdiff với baseline thật `2a14e2bd`) | T · nhẹ | m8 | — | 3 | CHƯA LÀM | |
| **N-09** | Nợ nhẹ sau cổng: `SchedulerCapacity` job mất khoá, ca bản chép hỏng, ca xem trước `JobKeysCleared`, N1 (`RULES_ALLOWED` thiếu muối → lỗi lúc khởi động), N3 (chốt cấp đơn task không `recall_of_task_id`), `:validate` chặn tầm xa ≤ 120 giây | T/NH · vừa | m8 | — | 2 | CHƯA LÀM | |
| **N-10** | Dọn sổ: 4 thư cũ `hop-thu/m8-*` → `xong/`; `_wt/m8` (chuyển `_wt/_luu/m8`, Toàn gật); 2 tệp `m34_mock_agent*` (W-0519: nhận hay bỏ) | T · nhẹ | m8 | Toàn quyết W-0519 | 4 | CẦN TOÀN | |
| **K-01** | Cổng Nguy hiểm vùng 2 (quay số thật, cước, đích: W-0550, W-0551): một verifier, một vòng, ≤ 5 đột biến | NH · vừa | m8 + verifier | — | 3 | CHƯA LÀM | |
| **K-02** | Cổng vùng 3 mới: giọng/cụm (G), trần tiền (T), .64 (H) — `cong-nguy-hiem.md` thêm vùng 3 trước | NH · vừa | m8 + verifier | G-10, T-01, H-03 | 3 | CHƯA LÀM | |
| **K-03** | Bộ đủ một lần dưới `@bo-kiem-du` (unit + tích hợp + `deploy/m8/tests` + gate-sweep) trên SHA cuối trước khi báo lên .99 | T · vừa | m8 | G/T/N xong | 3 | CHƯA LÀM | |
| **K-04** | Hồ sơ phát hành 07F: rà 161 mục `EVIDENCE_SUBMITTED`, danh sách chữ ký, sinh lại board; đối chiếu 11 gate `BLOCKED_EXTERNAL` | T · vừa | m8 | K-03 | 4 | CHƯA LÀM | |
| **K-05** | Chấm lại mức sẵn sàng + cổng G1–G8 (`SAN_SANG.md` còn mốc 14/11); bảng cổng; sửa các dòng cũ (02I, W-0549, E07/E08, hash draft.49) | T · nhẹ | m8 | K-01…K-04 | 4 | CHƯA LÀM | |
| **B-01** | Push 3 commit local (+ các commit sau): quét trước push → `git push origin main` | T · nhẹ | m8 | Toàn nói; N-08 | 3 | CẦN TOÀN | |
| **B-02** | Lên .99 (pipeline web `M8_FAST_DEPLOY=true` + `deploy_m8_99`): nạp luật mặc định, muối `phone_key` (bí mật, ≥ 16 ký tự), `Ivr:CallRules:IntakeMode=RULES_ALLOWED`, migration | NH · vừa | m8 | K-01…K-03; Toàn nói | 4 | CẦN TOÀN | |
| **B-03** | L-10: chạy đầu–cuối M3 ↔ M8 trên .99 (MOCK) với luật mới + E01–E10; M3 ghim hash cuối, Phúc lên bản `dev` (V405–V410) | NH · vừa | m8 + m34 + Phúc | B-02, G-08 | 4 | CẦN TOÀN | |
| **B-04** | 01D: gọi số nội bộ thật cùng callback M3 trên .99 | NH · vừa | m8 | B-02, H-04, X-07 | 4 | CHẶN (X-07) | |
| **B-05** | WP08: đo tải thật, chốt quy mô | NH · vừa | m8 | X-01, B-04 | 4 | CHẶN (X-01) | |
| **B-06** | WP02F: lên production bằng `trien-khai.sh` + phiếu kiểm (viết lại cho .99) | NH · vừa | m8 | B-04, B-05, K-01…K-05 | 5 | CHẶN | |
| **X-01** | MobiFone: hẹn gọi thử qua trunk, xin xác nhận kênh/grant, hỏi khối tính cước + chặn quốc tế | — | Toàn | — | ngay | CẦN TOÀN | |
| **X-02** | Giấy định danh → nhà mạng thứ hai (WP06; ngoài trọng số, không chặn gọi MobiFone) | — | Toàn | — | — | CHẶN (bên ngoài) | |
| **X-03** | Điều kiện pháp lý giọng đọc (VieNeu, `MODELS.lock`): Toàn tự chốt cách ghi nhận | — | Toàn | — | trước bật thật | CẦN TOÀN | |
| **X-04** | Kênh nhận cảnh báo ngoài giờ + người trực (đang ghi Toàn) | — | Toàn | — | trước bật thật | CẦN TOÀN | |
| **X-05** | Cất khoá media-token/ARI/khoá CA (phiếu `wp/custody-khoa-m8.md`), xoay token Sheet cũ, đổi mật khẩu đã lộ chat (.61) | — | Toàn + lead | — | 28/11 | CẦN TOÀN | |
| **X-07** | Số điện thoại nội bộ thật cho 01D | — | Toàn | — | trước B-04 | CẦN TOÀN | |
| **X-08** | Token GitLab (phạm vi `api`) + project id cho lịch đêm | — | Toàn | — | — | CẦN TOÀN | |
| **X-09** | Anh Tuấn/Toàn: khung bảo trì .64 và sudo | — | Toàn | — | trước H-04 | CẦN TOÀN | |

## 4. Chi tiết từng nhóm (đọc khi giao việc)

### G — Giọng đọc (nghe thử, chọn, tuỳ chỉnh theo vùng)

**Hiện trạng đã khảo sát (ivr `main` `f375bfaf`):**
- Production **không tổng hợp lúc đang gọi** (luật N1): cuộc gọi chỉ phát file dựng sẵn (bank clip `sound:ivr-clips/<sha>` + kho cụm `sound:ivr-phrases/<sha>`); `ITtsProvider` ở production là `RuntimeSynthesisForbiddenTtsProvider` (`SpeechServiceCollectionExtensions.cs:520-526`). VieNeu thật chỉ chạy nền ở worker qua sidecar (`deploy/tts/shim/backend.py`, `127.0.0.1:8090`). → **đổi giọng ≠ tức thì**: giọng/vùng mới phải có đủ bank + cụm dựng sẵn trước khi kích hoạt.
- Giọng theo vùng: `RegionalVoiceMap.Resolve(delivery_area)` (`RegionalVoiceMap.cs:77-102`), cấu hình `Ivr:Speech:Tts:RegionalVoices:{North,Central,South}` đọc **một lần lúc khởi động**; vùng suy từ tỉnh (`DeliveryRegionResolver.cs:162-216`; 3.321 phường/xã → 3.318 cụm: Bắc 1.368, Trung 1.096, Nam 854); **chưa có bảng DB** giữ lựa chọn giọng. Ba giọng đã chốt: `v3t-north-ngoc-linh`, `v3t-central-ngoc-tran`, `v3t-south-my-duyen`; khoá cứng ở 3 tầng (`backend.py:141-142`, `PrerenderedSpeechCatalog.cs:127,145-146`, `SpeechServiceCollectionExtensions.cs:441-450`). Mỗi cuộc gọi đã ghi `voice_id`/`voice_region` thật.
- Cụm: bảng `ivr_speech_phrase_clips` (region, voice_id, clip_id); review UNREVIEWED/APPROVED/REJECTED (UNREVIEWED vẫn phát, chỉ REJECTED bị chặn); duyệt/đọc lại hiện **chỉ qua CLI** `tools/Ivr.Ops/PhraseCommands.cs:22-99`; **không có HTTP**; **không có route nào trả audio**; WAV 8 kHz PCM16 mono của kho cụm phát được trong trình duyệt, bank clip là PCM thô cần bọc WAV; API mount `phrases` chỉ đọc (`deploy/m8/compose.yml:74`), worker ghi (:115).
- "455 tên chờ duyệt" chỉ là gói đối chiếu tên (`deploy/tts/ward-review/goi-duyet-chu-2026-11-10.md`), âm thanh vẫn `PENDING_OWNER`. Từ điển cách đọc có 3 chỗ rời nhau (từ điển cứng 2 mục `SpeechSynthesisService.cs:48-53`, `pronunciation_hints` theo đơn, `render_text` theo cụm `SpeechPhraseStore.cs:481-508`).
- **Phía Module 3:** M8 không có màn hình (Helm `deployment-ui.yaml` báo lỗi nếu bật). Admin web Module 3: Next.js 16 App Router (`front-end/src/app/admin/ivr/*`, màn con `features/ivr/admin/components/`), menu `IVR_NAV` (`IvrAdminShared.tsx:19-24`), BE Java `back-end/.../ivr/` (`IvrAdminOperation.java` danh mục đóng, `IvrCallRuleAdminController/Service` khuôn mẫu, `IvrAdminHttpClient/Transport` **chỉ JSON, trần 1 MiB, timeout 5 giây** → audio cần nhánh nhị phân riêng), quyền M3 `IVR.RULE.*` thêm bằng migration V407 và **không gán sẵn**. Chưa trang nào phát âm thanh; `FileViewer.tsx:143,266-272` có nhánh `<audio>` nhận URL, xác thực bearer trong bộ nhớ nên phải tải blob rồi `createObjectURL` (mẫu `useAdminProductVideoUrl.ts`).

**Thiết kế đề xuất (G-01 chốt, không đổi âm thầm):**
- Bảng `ivr_voice_profiles` (id, `region` North/Central/South, `voice_id`, `rate` 0.5–2.0, `status` DRAFT/ACTIVE/RETIRED, `version`, `created_by/at`, `activated_by/at`, `reason_digest`, `row_version`); **một ACTIVE mỗi vùng**; lịch sử = các bản cũ. Theo khuôn `CallRuleSetEntity.cs` + `PostgresCallRuleSetStore.cs` (`If-Match`, `Idempotency-Key`, `reason` bắt buộc, audit chỉ digest).
- `RegionalVoiceMap` đọc ACTIVE từ kho (cache ≤ 5 giây), **validator cũ giữ**: ba giọng khác nhau, rate 0.5–2.0, chỉ giọng đã chốt; cờ về `appsettings` khi cần (giữ `RegionalVoices.Enabled=false` làm đường lui đã có). **G-01 phải chốt:** lỗi kho → rơi về `appsettings` hay giữ cuộc gọi; hành vi khi một cụm chưa READY lúc đang gọi (hiện kho cụm: UNREVIEWED vẫn phát; chưa dựng thì ?).
- **Điều kiện kích hoạt (`readiness`):** bank của giọng đủ + kho cụm `READY` cho (vùng, giọng, rate) **đủ 100%** (số thiếu, danh sách thiếu); chưa đủ thì không cho kích hoạt, có nút "làm nóng" (tái dùng `PhraseRequestPlanner`, `PhraseCommands.cs:127-165`; ≈ 1,75 giờ máy/bộ 3.318 cụm, chưa chạy thật — `deploy/tts/README.md:206`).
- **Nghe thử:** bảng riêng `ivr_voice_previews` (KHÔNG dùng `ivr_speech_phrase_clips` vì bảng đó được phát thật khi trùng giọng; KHÔNG `MediaReplicaJournal.PublishAsync` — `SpeechPhraseStore.cs:417-418`); chữ chỉ lấy từ **câu cố định** của kịch bản v6 (`FinalConfirmationSpeech.cs`) + danh sách tên địa bàn có sẵn, qua `SpeechPrivacyGuard`/`SpokenTextGuard`; render bằng worker (`ISpeechPhraseSynthesizer`), không dựng đường tổng hợp trong API; trả `audio/wav`, `Cache-Control: no-store`, ≤ 2 MiB; hết hạn dọn (retention). Nghe được: câu thử, một cụm tên địa bàn, một clip bank (bọc WAV), so sánh A/B hai giọng cùng câu.
- **Quản lý cụm (thay Chú duyệt tên):** liệt kê/lọc (vùng, trạng thái, review, tên), nghe, `APPROVE/REJECT` (người nghe = actor), `respell` (`render_text`), yêu cầu dựng, tiến độ, xuất CSV chưa duyệt. **Không có endpoint xoá qua HTTP** (`docs/compliance/phrase-deletion.md`). Duyệt cụm đã là tự phục vụ ở mức mã (`SetReviewAsync` chỉ cần tên người nghe, `SpeechPhraseStore.cs:466-479`).
- **Quyền (header kiểu `X-Call-Rule-Permissions`, tối đa 16 mục):** `IVR_VOICE_EDIT`, `IVR_VOICE_ACTIVATE`, `IVR_PHRASE_REVIEW`; phía M3 `IVR.VOICE.EDIT/ACTIVATE`, `IVR.PHRASE.REVIEW`, `IVR.COST.EDIT` thêm ở **V410**, không gán sẵn (Toàn tự gán). `privileged-user-id` trên .99 cố ý không đặt nên không dùng `IVR.DANGER/AUDIT/EXPORT` (như luật gọi).
- **Việc không được làm mất:** bộ chặn PII; N1 (không tổng hợp lúc gọi); bốn mắt kịch bản; `voice_id` ghi theo cuộc; `MODELS.lock`/`voices.json`/`acceptance.py`/`backend.py` không sửa ở MVP (ghim hash).

**Tiêu chí đạt (rút gọn, chi tiết ở phiếu):**
- G-03 migration **chỉ thêm** (test kiểu `CallRuleSetMigrationTests`, rolling-deploy), `database-docs.mjs --write`, phân loại dữ liệu + `PersonalDataInventory` (không PII).
- G-04 ba vùng đổi giọng/tốc độ có hiệu lực ≤ 5 giây cho cuộc gọi MỚI, cuộc đã dựng không đổi; test kiểu `RegionalVoiceRoutingTests`; fallback đúng.
- G-05/G-06/G-07 test API kiểu `CallRuleAdminApiTests` (quyền, replay, `If-Match`, xung đột, audit không lộ chữ); `GET audio` trả WAV hợp lệ; không có endpoint tổng hợp.
- G-08/G-09 test BE kiểu `IvrCallRuleAdmin*Test`, FE vitest kiểu `call-rules-*`, `IvrAdminOpenApiContractTest` (đếm path), snapshot/fixtures/`docker-tests.txt`; ui-kit-v2, chữ tiếng Việt có dấu.
- G-10 điều phải đúng (cổng vùng 3): production không tổng hợp lúc gọi; ACTIVE chỉ thuộc giọng đã chốt và ba vùng khác giọng; kích hoạt chỉ khi `readiness` đủ; rollback phục hồi đúng bản trước; cuộc gọi ghi `voice_id` thật; nghe thử không bao giờ phát cho khách; chữ nghe thử chỉ từ câu cố định; quyền + audit đủ; lỗi kho không làm cuộc gọi đổi giọng bất ngờ.

**Tệp nóng ivr (chỉ phiên chính ghi, trong một bước ghép mỗi sóng):** migration + Designer + `IvrDbContextModelSnapshot.cs` (178 KB), `PersistenceModelConfiguration.cs`, `IvrDbContext.cs`, `PersistenceInvariantValidator.cs`, `IvrAdminEndpoints.cs:84-91`, `InternalAdminApiServiceCollectionExtensions.cs:85-91`, `ServiceCollectionExtensions.cs:145-175`, `IvrPermissions.cs`, `AdminTokenAuthenticationHandler.cs`, `Ivr.Worker/Program.cs:92-95`, hợp đồng (`ivr-order-confirmation.v1.yaml`, baseline, `contract-manifest.json`, `changelog-baseline.json`, `IvrServerModels.g.cs`, `contract-freeze-verifier.mjs`, `docs/api/*`), `docs/traceability-tests.md`, `work-register.md`, `gate-status.yaml`, `readiness-board.md`. Agent chỉ ghi **tệp mới** (thư mục riêng, ví dụ `src/Ivr.Api/Admin/Voice/`, `src/Ivr.Infrastructure/Voice/`, `Cost/`) và test dạng `partial`; phiên chính nối DI/route/hợp đồng.

### T — Trần cuộc mỗi ngày (UI)

**Hiện trạng:** trần "cuộc/số điện thoại/ngày", "cuộc/đơn/ngày", "tổng cuộc" nằm trong bộ luật (`max_calls_per_phone_per_day` 1–50, `max_calls_per_day_per_order` 1–10, `max_total_calls` 1–10; `CallRuleValidator.cs:393-395`) và **M3 đã có trang Luật gọi** để sửa. Trần **cuộc/ngày cả hệ thống** chỉ là cấu hình `Ivr:Telephony:DailyBudget` (`Enabled`, `MaxDialsPerDay`, `MaxAnsweredSecondsPerDay`, `UtcOffsetMinutes`; `DailyDialBudget.cs:25-38`, mặc định false/0/0/420; bắt buộc ở đường quay thật `:64-82`), đọc bằng `IOptions` lúc khởi động (đổi phải khởi động lại worker; trên .99 sửa env hoặc `du-lieu/worker/appsettings.json`); **chưa API ghi, chưa API đọc**. Chạm trần → worker tự `QUEUE_PAUSE` (`DAILY_BUDGET_EXCEEDED`, có `admin_actions` + `audit_log`, `DailyDialBudget.cs:301-354`), chỉ `queue:resume` (tầng danger) mở lại. Đo cước `ivr_call_usage_daily` + API chỉ đọc (W-0551) không chặn. Trần 120 giây/cuộc: `Ivr:Telephony:Asterisk:PlaybackCallLimitSeconds` (bắt buộc ở production; mẫu chưa có — N-02).

**Thiết kế đề xuất (chốt ở G-01):** bảng `ivr_cost_ceilings` một hàng `scope=GLOBAL` (mở rộng `PROGRAM:<mã>`/`SIM:<id>` sau không đổi schema): `max_dials_per_day`, `max_answered_seconds_per_day`, `updated_by/at`, `row_version`; `Enabled` và `UtcOffsetMinutes` vẫn ở options. Guard đọc hàng ở mỗi lượt kiểm trước claim (đệm ≤ 5 giây), **hiệu lực tức thì**; rơi về options nếu chưa có hàng; **đường quay thật mà không có trần > 0 từ đâu cả thì không quay** (fail-closed). Endpoint: `GET /cost-ceilings` (Read; trần, đã dùng hôm nay, trạng thái tạm dừng), `PUT /cost-ceilings/{scope}` (tầng Danger + `X-Actor-Id` + `X-Action-Reason` + `If-Match`; audit cùng giao dịch theo mẫu `DailyDialBudget.cs:314-354`; chặn PII trong `reason`). Hạ trần thấp hơn mức đã dùng → lượt claim kế tự tạm dừng (hành vi sẵn có); nâng trần khi đang tạm dừng vẫn cần `queue:resume` (cân nhắc `resume_if_below` để API tự đóng sự cố `DAILY_BUDGET_EXCEEDED`, G-01 chốt). Số trần cụ thể: **Toàn nhập trên UI** (D-m8-138); gợi ý khởi đầu thấp = số đơn dự kiến ngày đầu × số cuộc tối đa mỗi đơn.

### H — Tổng đài .64 (khung bảo trì)

**Hiện trạng (scout, chưa ssh):** ufw `5060/udp` chỉ SBC MobiFone (02I xong 20/11, `wp/M8-WP02I.md:53`) + `18089/tcp` cho .61/.99; mặc định deny incoming; **chưa luật RTP 10000–10999**; dải IP nguồn RTP của MobiFone **không thấy ở đâu trong repo**; nguồn SIP sau NAT **không xác minh được** (công khai `:7070` → VM `5060`; nếu router SNAT thì ufw thấy IP router và luật 5060 chặn nhầm). CDR: `cdr.conf`/`cel.conf` `enable=no` (hash ghim `vm_deploy.py:33-34`), `modules.conf:5-7` noload cdr/cel (hash `:36`), `vm_deploy verify` đang đòi CDR "disabled" (`:652`), `/var/log/asterisk` là tmpfs + rootfs chỉ đọc (`:249-251`) nên tệp CDR mất khi tạo lại container nếu không thêm volume; không mã nào đọc `billsec`. Chứng thư lá ARI SAN `ivr-ari.internal` hết hạn **13/01/2027** (lá 90 ngày, CA 365 ngày; README yêu cầu thay trước hạn ≥ 30 ngày → **trước ~14/12**); tệp ở .64 `/opt/ivr/ari-link-v1/tls/`, `/opt/ivr/input/ari-tls`, .99 `du-lieu/ari/tls`; **khoá CA: không rõ nơi giữ** ("kho riêng có sao lưu", `custody-khoa-m8.md` không có dòng).

**Thứ tự cửa sổ bảo trì H-04** (ngoài khung gọi 08:00–21:08, ví dụ 22:30–07:30; gọi thật đang NO nên hiện giờ nào cũng được): (1) từ .99 đọc hạn chứng thư: `echo | openssl s_client -connect 192.168.1.64:18089 -servername ivr-ari.internal 2>/dev/null | openssl x509 -noout -enddate` (không sudo, H-01); (2) tìm khoá CA (H-01); (3) trên .64 (Toàn sudo) `sudo ufw status verbose`, `sudo ufw logging low`, `sudo tcpdump -ni any 'udp port 5060 or portrange 10000-10999'` để thấy nguồn SIP/RTP — **cần một cuộc gọi thử qua MobiFone (X-01)** để chốt luật RTP đúng; (4) thêm luật ufw RTP; (5) bật CDR bằng `vm_deploy apply` (cùng lượt sudo; ~11 giây gián đoạn như 02I, từ chối nếu còn cuộc đang gọi); (6) đổi chứng thư bằng bundle mới (`deploy/telephony-link/link_bundle.py prepare/verify-bundle/check-host`, không sửa bundle cũ); khi tạo lại container có ~3 lượt 502 tự lành ~35 giây, hàng đợi bền không mất; (7) kiểm: `/healthz` 200, `/ari/asterisk/info` 401, `vm_deploy verify`, một cuộc MOCK trước và sau; ghi sổ. **Lùi:** `sudo bash /opt/ivr/sao-luu-02i/buoc2.sh lui` (ufw); giữ bundle và thư mục `tls` cũ (lá cũ dùng được tới 13/01). Nếu chưa có cuộc gọi thử MobiFone trước cửa sổ: làm các bước (1)–(2), (5)–(6), hoãn bước (4) (**m8.124**).

**CDR tối giản (D-m8-136):** chỉ mã cuộc, giờ, `billsec`, kết quả, mã lượt M8, **không số điện thoại**; làm nguồn giây thứ hai đối soát hoá đơn nhà mạng; cần sửa cấu hình + hash ghim + `verify` + test + volume bền + trình tổng hợp. Đây là việc vừa–nặng, vì vậy nếu thiếu thời gian: làm sau go-live nhưng **vẫn nằm trong kế hoạch** (Toàn đã yêu cầu).

### N — Nợ kỹ thuật nhóm C (tệp:dòng do scout; làm được ngay, không cần ai trừ ghi chú)

- **N-01** `deploy/m8/noi-m3/cau-hinh.md:73` + `viec-m34.md:41` ghim `deploy/m8/README.md:266` nhưng câu thật ở `:262`; `test_e_tai_lieu.py:45` ghim `README.md:254`; `SchedulerCapacity.cs:28` (dòng trống) phải thành `:29`; nghi thêm `test_tat_khan_tinh.py:27-29` ghim `PostgresSchedulerStore.cs:427,428,431` nay là `:431,432,435`. Chạy `pytest deploy/m8/tests` lọc để xác định đủ 5 ca (ca đỏ thứ ba của `test_noi_m3_tai_lieu` chưa xác minh được).
- **N-02** thêm `"PlaybackCallLimitSeconds": 120` vào khối Asterisk của `closed-profile.example.json:10-16`, cập nhật `bytes` + `git_blob_sha256` ở `deploy/release-candidate/components.lock.json:194-196`; không thêm `DailyBudget` (chưa có số); `deploy/production-dial/evidence/l33-checks.json` là lịch sử, không sửa.
- **N-03** `InternalAdminApiService.cs:320-323,373-376` dùng `SingleOrDefaultAsync` → hai hàng OPEN làm cả pause lẫn resume lỗi: sửa xử lý mọi hàng OPEN; chỉ mục duy nhất cục bộ (`WHERE status='OPEN' AND scope='ADMIN_QUEUE_PAUSE'`, dọn trùng, bắt 23505) vào migration G-03.
- **N-04** dòng `allow 172.29.0.1` ở `du-lieu/nginx.conf` trên .99 (không ở repo; `tren-99.sh` có `them-allow`/`--tra` nhưng **không có lệnh gỡ**). Kết luận "thừa" 17/11 chưa chắc (14/11 chính dòng này đổi 403 → 200 cho M3, `wp/chuyen-may-99.md:180-181`). Đo log `m8-https` vài ngày rồi quyết; mặc định giữ.
- **N-05** "08:53:30/31" **không xác minh được** là test nào; khả năng là 20:53:30 (vùng giữ 24/7). Đã có cặp 29/30 mức chính sách (`BufferedThreeCallAttemptPolicyTests.cs:16-17`); mức nhận đơn còn mốc cũ 20:53:00 (`IntakeMorningBoundaryTests.cs:196-199`). Hỏi Toàn xác nhận trước khi viết (**m8.127**).
- **N-06** `monitor-grants.sql:15` chỉ cấp 3 bảng; `ivr_monitor` chỉ xuất hiện ở đường `production-window/host61`; trên .99 ops-agent dùng role chủ `ivr`. Có thể không áp dụng — chốt (**m8.128**); nếu làm: thêm bảng vào GRANT, tính lại hash (`db_provision.py:54`), ma trận (`:87,96`), `database-role-check.sql:45-47`, `test_database_roles.py:44`, `BUILD.md:130`.
- **N-07** `sh deploy/ci/scripts/tao-lich-dem.sh --chay` với `GITLAB_API_URL` (https), `GITLAB_PROJECT_ID`, `GITLAB_TOKEN` (phạm vi `api`; chủ token chạy được pipeline trên `main` bảo vệ); cron `30 3 * * *` giờ Hà Nội; chạy lại không trùng; xoá biến `M8_AUTO_DEPLOY` nếu còn.
- **N-08** máy này không có `gitleaks`/`oasdiff` trên PATH nhưng có Docker: gitleaks `docker run --rm -v "${PWD}:/repo" -w /repo zricethezav/gitleaks:v8.30.0 dir . --config .gitleaks.toml --no-banner --redact`; PII phải Linux `docker run … debian:bookworm-slim sh deploy/ci/scripts/scan-pii.sh docs/evidence`; quét đầy đủ `bash deploy/ci/tools/pre-push-scan.sh`; oasdiff chỉ ảnh `tufin/oasdiff:v1.26.1`, baseline draft.49 hiện trùng hệt hợp đồng nên **vô nghĩa** — lấy bản `git show 2a14e2bd:specs/api/openapi/ivr-order-confirmation.v1.yaml` làm baseline tạm.
- **N-10** `hop-thu/m8-*`: 4 thư xử lý xong → `xong/` (`…11-02-so-theo-doi-commit-local`, `…11-03-cung-khuon-m12`, `…11-06-wip-m34-da-vao-main`, `…11-12-tra-loi-noi-m3-xong`); `m8-2026-11-10-m34-mock-agent-w0519.md` chưa xong (2 tệp lạ trong ivr); `_wt/m8`: 42 thư mục + 72 tệp (≤ 21/11).

### K — Kiểm và hồ sơ (nhóm D)

- **K-01** vùng 2 = W-0550 (chỉ quay di động VN `+84[35789]`, trần 120 giây, trần lượt/giây theo ngày + `QUEUE_PAUSE`) + W-0551 (đo cước): bảng tiêu chí ở `cong-nguy-hiem.md` "Vùng 2"; đột biến gợi ý: bỏ kiểm đầu số, bỏ trần 120 giây, bỏ `ADMIN_QUEUE_PAUSE` khỏi claim.
- **K-02** thêm "Vùng 3" vào `cong-nguy-hiem.md` TRƯỚC khi chạy (giọng/lời nói với khách, trần tiền, .64) — mỗi vùng một verifier, một vòng, ≤ 2 giờ, ≤ 5 đột biến dưới `@dot-bien`; lỗi nặng/trung bình sửa ngay (phiên chính chạy lại test), nhẹ vào Nợ.
- **K-03** bộ đủ dưới `@bo-kiem-du`: `dotnet test Ivr.sln` (cần Docker), `pytest deploy/m8/tests`, `node deploy/ci/scripts/gate-sweep.mjs`, `pre-push-scan`; **bộ đủ chưa chạy từ 20/11**.
- **K-04** 07F: rà 161 mục `EVIDENCE_SUBMITTED`, 11 gate repo `BLOCKED_EXTERNAL` (G-CONTRACT, G-SPEECH, G-DIAL, G-AUTH, G-POLICY, G-LAB-SIM, G-ESIM32, G-LEGAL, G-RELEASE, G-GITLAB, G-PLATFORM), danh sách chữ ký.
- **K-05** mức sẵn sàng theo thang chung (`chung/CONG_PRODUCTION.md`): **không** tính bằng số task; ghi "CHƯA CHẠY" nếu chưa chạy; hiện 55 (14/11) chưa chấm lại.

### B — Việc cần Toàn nói (phiên mới KHÔNG tự làm)

Push; lên .99 (M8 `M8_FAST_DEPLOY` + nạp luật + muối + `IntakeMode`); L-10 với M3 (Phúc lên bản M3, M3 ghim hash cuối, bật `M8_RULES`); 01D; đo tải; lên production; mọi thao tác trên .64 (Toàn gõ sudo); bật `REAL_CUSTOMER_CALL_ALLOWED` (cuối cùng, Toàn tự quyết).

### X — Việc ngoài (chờ người/bên khác)

MobiFone gọi thử qua trunk + xác nhận kênh/grant + cước/quốc tế (X-01, hạn 24/11 đã qua); giấy định danh (X-02); điều kiện pháp lý giọng (X-03); cảnh báo + người trực (X-04); cất khoá + xoay token + đổi mật khẩu lộ (X-05); số nội bộ thật (X-07); token GitLab (X-08); Anh Tuấn/sudo .64 (X-09). Giấy định danh **không chặn** gọi khách MobiFone ở 30/11.

## 5. Sóng và lịch (hôm nay 25/11; chỉnh theo thực tế)

Nguyên tắc: **hợp đồng trước, hai phía song song** (G-02 xong thì m34 làm BE/FE bằng fixtures); tệp nóng một người ghi; mỗi sóng ≤ 3 agent nặng ở phiên m8, phiên m34 tự có ngân sách riêng.

| Sóng | Khi | Việc (agent) | Tệp/khoá |
|---|---|---|---|
| **0** | 25/11 chiều–tối | G-01 thiết kế (1 `Plan`/coder) · N-01, N-02 (1 coder, nhẹ) · H-01 (phiên chính, đọc) · xin Toàn trả lời §6 | `modules/m8/wp/giong-doc-thiet-ke.md`; `deploy/m8/**`, `closed-profile.example.json`, `components.lock.json` |
| **1a** | 26/11 sáng | G-02 hợp đồng draft.50 (1 coder, **một người ghi hợp đồng**) · G-03 migration + entity + store (1 coder) · N-03 phần mã · H-02 kịch bản `.64` (1 coder) | hợp đồng + `docs/api/*`; migration/snapshot/`PersistenceModelConfiguration.cs`; `deploy/telephony-*` |
| **1b** | 26/11 chiều–27/11 | m8: G-04, G-05, G-06, G-07, T-01, H-03 (xoay vòng ≤ 3 agent nặng; mỗi agent thư mục mới riêng; phiên chính nối DI/route/hợp đồng cuối sóng) · **m34 song song**: G-08, G-09, T-02 trên `toandeptrai` (đồng bộ `origin/dev` trước, khoá `@dong-bo`) | `src/Ivr.Api/Admin/Voice|Cost`, `src/Ivr.Infrastructure/Voice|Cost`; BP `back-end/.../ivr/**`, `front-end/src/features/ivr/**` |
| **2** | 27/11 | ghép + chạy thử đầu–cuối một máy (API ↔ BFF ↔ UI) trên dữ liệu thử; N-09 nợ nhẹ; sửa lỗi | `@bo-kiem-du` khi chạy DB/cổng |
| **3** | 28/11 | K-01, K-02 (verifier, vùng 2 và 3) · K-03 bộ đủ · N-08 quét · B-01 push (khi Toàn nói) | `@dot-bien` rồi `@bo-kiem-du` (mỗi lúc một khoá) |
| **4** | 28–29/11 | B-02 lên .99 (khi Toàn nói; Phúc lên bản M3) · B-03 L-10 · T-03 Toàn nhập trần · H-04/H-05 cửa sổ .64 tối 27 hoặc 28/11 · K-04, K-05 · N-04, N-07, N-10 | sudo Toàn |
| **5** | 29–30/11 | diễn tập runbook (lead LM-05, 29/11) · B-04…B-06 **chỉ nếu** X-01 xong; nếu không, M8 giữ MOCK ngày 30/11 và gọi thật đến sau | — |

**Thực tế phải nói thẳng:** 30/11 gọi **khách thật** phụ thuộc X-01 (MobiFone thử), X-03 (pháp lý giọng), X-04, B-04 — không do phần mềm. Phần mềm (G/T) kịp **28–29/11** nếu không trượt; nếu trượt, **thứ tự cắt:** (1) mọi thứ giai đoạn 2 (G-11), (2) so sánh A/B + nghe cụm từng tên, (3) `respell` và xuất CSV (giữ duyệt/từ chối + làm nóng), (4) T-02 giữ ở mức thẻ đọc + sửa số (bỏ nút mở lại hàng đợi, vẫn có CLI), (5) CDR (H-03) sang sau go-live. **Không cắt:** kiểm sẵn sàng trước khi kích hoạt giọng, audit, quyền không gán sẵn, fail-closed của trần.

## 6. Câu hỏi cho Toàn (kèm mặc định để phiên mới không phải chờ)

| Mã | Câu hỏi | Mặc định nếu chưa trả lời trước 26/11 sáng |
|---|---|---|
| m8.120 | Phạm vi giọng MVP: A = 3 giọng đã chốt + tốc độ + nghe thử + duyệt cụm (kịp 30/11); B = mở 11 ứng viên ngay (nặng, sau 30/11) | **A** |
| m8.121 | Kích hoạt giọng: A = một người (Toàn) + lý do + audit + kiểm sẵn sàng; B = hai người (người tạo ≠ người kích hoạt) | **A**, công tắc hai người để sau |
| m8.122 | Trần/ngày: A = toàn hệ thống (cuộc quay + giây có người nghe); B = theo chương trình (24/7 và Giờ Vàng) | **A** (schema chừa chỗ cho B) |
| m8.123 | Giờ bảo trì .64: tối 27/11 22:30 hay tối 28/11 22:30 (Toàn gõ sudo; anh Tuấn biết chưa) | **28/11 22:30**, đệm 29/11 |
| m8.124 | Luật ufw RTP: A = chờ cuộc gọi thử MobiFone để biết nguồn rồi khoá (đề nghị); B = mở tạm 10000–10999 cho mọi nguồn khi chưa gọi thật | **A** (bước (4) hoãn nếu chưa có cuộc gọi thử) |
| m8.125 | CDR: làm trong cửa sổ này nếu kịch bản sẵn, hay sau go-live | trong cửa sổ nếu H-03 xong kịp, nếu không thì sau |
| m8.126 | Khoá CA ARI để ở đâu (H-01 chưa tìm ra)? | Toàn nói; chưa có thì H-05 dừng ở bước CSR |
| m8.127 | "Test biên 08:53:30/31" là 20:53:30 vùng giữ 24/7 phải không? | làm theo 20:53:29/30/31, ghi lại giả định |
| m8.128 | `ivr_monitor` GRANT: còn dùng đường production-window/host61 không? | không làm; ghi "không áp dụng trên .99" |
| m8.129 | Hai tệp lạ `m34_mock_agent*` (W-0519): nhận làm hay bỏ? | giữ nguyên, không đụng |

## 7. Rủi ro lớn nhất

1. **Đụng vùng Nguy hiểm số 3 (lời nói với khách + tiền) trong 3 ngày**: hợp đồng, migration, claim/guard, UI hai phía → dễ trượt; giảm bằng hợp đồng trước, tệp mới + một người nối, cổng verifier 28/11, thứ tự cắt ở §5.
2. **Kích hoạt giọng chưa dựng đủ cụm** → cuộc gọi thiếu clip: `readiness` 100% bắt buộc; làm nóng ≈ 1,75 giờ máy mỗi bộ (chưa chạy thật, `.99` dùng chung 6 nhân); G-01 phải chốt hành vi khi thiếu cụm.
3. **Audio qua `IvrAdminHttpClient` dùng chung** (JSON, 1 MiB, 5 giây): nhánh nhị phân riêng, không đổi đường JSON; báo Phúc trước vì lớp này đi lên .99 qua Phúc.
4. **Tệp nóng** (migration/snapshot 178 KB, hợp đồng ghim hash, `IvrAdminOpenApiContractTest` đếm cứng 45 path, hai bộ fixtures, `docker-tests.txt` sinh bằng `docker_tests.py --write`): một người ghi; hợp đồng đổi hash thêm lần (draft.50) → M3 chỉ ghim hash cuối; không sửa baseline tại chỗ lần nữa (oasdiff CI mù).
5. **Pháp lý giọng đọc** (`MODELS.lock`) và MobiFone ngoài tầm phần mềm; không được dùng tính năng tự chọn giọng để coi cổng pháp lý đã đóng.
6. **Lên .99 bản M3 chỉ Phúc**, V410 chạy trên .99 chỉ qua Phúc; migration V410 phải cộng thêm, quyền không gán sẵn.
7. **Tài khoản/hạn mức Claude** (đã đổi 4 lần): mọi việc ghi sổ ngay; phiếu `wp/` là điểm vào của mỗi gói.

## 8. Nhật ký cập nhật kế hoạch (mới nhất ở cuối)

- 25/11 · phiên m8 · lập kế hoạch từ lời Toàn; 3 scout chỉ đọc (ivr giọng/API, BP màn quản trị, trần/.64/nợ C); ghi D-m8-160; chưa giao việc nào. Tất cả WP ở §3 đang CHƯA LÀM / SẴN SÀNG / CẦN TOÀN như bảng.
