# M8-WP02J — Diễn tập tắt khẩn + cảnh báo thử trên Prometheus .61 (phần tắt khẩn)

Trạng thái: **ĐẠT trên .99 17/11** (D-m8-126): `canh-bao` 10:50–10:54 (FIRING sau 101 s, RESOLVED sau 92 s) + `tat-khan` 10:58:18–10:59:25 (sau khi sửa `X-Service-Scope`, W-0546 `fb20f6c3`) · trước đó: ĐÃ GỘP W-0525 `64bd51ba` (đã lên GitLab + GitHub 11/11 15:17, không do phiên này; chưa chạy trên .61) · Rủi ro: R2 · Chế độ: A · Mốc: 13/11
Hạng mục nâng: Vận hành/giám sát G6 (chỉ phần tắt khẩn + cảnh báo nổ; người nhận cảnh báo gác lại, D-m8-075) · Sheet: M8-002 · Ước lượng: 6 giờ
Chỗ làm: `C:\Projects\_wt\m8\M8-WP02J` (bản sao archive, repo tạm commit `goc` bb8b251) · Base SHA: `10f335de` · Chỗ kiểm: cùng bản sao
Quyết định: D-m8-075 (m8.73 gác lại: không cấu hình kênh/người nhận cảnh báo). Chạy trên .61 cần lệnh Lead riêng.

## Brief
1. Repo · thư mục: bản sao archive của `ginsengfood-ivr` @ `10f335de` tại `C:\Projects\_wt\m8\M8-WP02J` (repo tạm có commit `goc`; KHÔNG commit thêm).
   Repo gốc `C:\Projects\ginsengfood-ivr` chỉ đọc.
2. Mục tiêu: Lead có hai cuộc diễn tập chạy được trên .61 (khuôn `~/m8`), đã thử local:
   a) **Tắt khẩn:** một lệnh diễn tập bật tắt khẩn bằng đúng cơ chế mà worker thật sự tôn trọng (đọc mã để chọn giữa cờ `global_dial_kill_switch`
      — `src/Ivr.Api/Admin/FeatureFlagEndpoint.cs:55-72` — và `queue:pause`/`queue:resume` — `src/Ivr.Api/Admin/IvrAdminEndpoints.cs:56-60`; trích `tệp:dòng`
      chỗ worker kiểm), chứng minh trong lúc bật không có job mới được giao/không cuộc gọi mới (đếm trước–sau bằng SELECT chỉ đọc hoặc API đọc),
      rồi mở lại có kiểm (lý do, actor, audit, endpoint xác minh kill-switch trả đúng). Quyền admin Danger lấy theo cơ chế sẵn có của .61
      (tìm trong `deploy/m8/` và tài liệu; không tạo lối tắt, không in token). Biên bản JSON không bí mật, không PII.
      Lưu ý .61 đang `Ivr__Scheduler__Enabled=false` (`deploy/m8/compose.yml`): diễn tập phải chứng minh chặn có hiệu lực theo cách không dựa vào
      việc lịch gọi đang tắt (ví dụ đọc trạng thái cờ/hàng đợi + từ chối giao việc), ghi rõ giới hạn nếu không thể.
   b) **Cảnh báo thử nổ:** cách gây một cảnh báo có kiểm soát trên Prometheus .61 (cổng 19090) — ví dụ dừng ngắn collector `ivr-operations`
      để `IvrOperationsCollectorMissing` nổ, hoặc một luật diễn tập riêng bật/tắt được — thấy FIRING ở `/api/v1/alerts`, khôi phục, thấy RESOLVED;
      luật mới (nếu thêm) có `promtool test rules` trong `deploy/operations/operations.rules.test.yml`. Không cấu hình Alertmanager/người nhận (D-m8-075).
   Tiêu chí đạt: tắt khẩn → không job mới, mở lại có kiểm; một cảnh báo thử nổ (local: mô phỏng đầy đủ, .61: CHƯA CHẠY); test viết đỏ trước rồi xanh;
   `promtool test rules` đạt bằng image Prometheus đúng digest repo ghim; lệnh từ chối chạy khi `REAL_CUSTOMER_CALL_ALLOWED` khác `NO`; không in token;
   `bash -n` mọi `.sh` mới; `python -B -X utf8 -m unittest` vùng mới + `deploy/operations/test_operations.py` đạt (ghi số).
3. Phạm vi ghi: `deploy/m8/tat-khan/**` (mới), `deploy/m8/tests/test_tat_khan_*.py` (mới), `deploy/operations/prometheus.yml`,
   `deploy/operations/operations.rules.yml`, `deploy/operations/operations.rules.test.yml`, `deploy/m8/README.md` (một mục mới),
   `deploy/m8/compose.yml` (chỉ khi bắt buộc, ghi lý do), `docs/evidence/W-PENDING-02J/**`.
   Cấm: `src/**` (cần sửa mã sản phẩm → dừng, ghi đề xuất), migration, `docs/release/*`, `deploy/m8/noi-m3/**`, `deploy/m8/nghiem-thu-m3/**` (của 01C),
   `deploy/operations/m34_mock_agent.py`, `deploy/operations/test_m34_mock_agent.py`, `.gitleaks*`, `deploy/ci/**`.
4. Đọc trước: `CLAUDE.md`, `AGENTS.md`; `FeatureFlagEndpoint.cs`, `IvrAdminEndpoints.cs`, chỗ worker đọc cờ/hàng đợi (GitNexus `context`/`impact` chỉ đọc,
   không `analyze`); `deploy/operations/README.md`, `prometheus.yml`, `operations.rules.yml`, `operations.rules.test.yml`, `test_operations.py`;
   `deploy/m8/compose.yml` (prometheus, ivr-operations, cổng 19090/19091), `deploy/m8/README.md` (mục ảnh ghim 64-68, khuôn thư mục).
5. Được chạy: python unittest; `promtool` trong image Prometheus đúng digest repo ghim (đã có local thì dùng; chưa có thì kéo đúng digest đó, không tag trôi);
   Docker local nhỏ tiền tố `m8w02j-` (`--memory 1g`, không cổng ra ngoài, xoá khi xong); không chạy Docker khi có container nhãn
   `com.gitlab.gitlab-runner.type`; `dotnet test` chỉ khi thật cần và chỉ `--filter` hẹp (không chạy bộ đủ). Test của lệnh diễn tập dùng docker/curl giả qua
   PATH: trước khi chạy test, kiểm `type docker` và `type curl` trỏ vào shim; không bao giờ chạm container/Prometheus thật project `m8`.
   KHÔNG: ssh/scp, gọi .60/.61/.64, sheet-sync, cấp W-ID, sửa repo gốc.
6. Bằng chứng: `docs/evidence/W-PENDING-02J/README.md` (lệnh + số, đỏ trước/xanh sau, giới hạn, CHƯA CHẠY trên .61); không lập MANIFEST.
   Tránh chữ khớp mẫu địa chỉ của `deploy/ci/pii-patterns.txt` (dòng 2) trong mọi tệp mới; dùng "lối"/`loi`/path.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra: tin nhắn cuối ≤ 25 dòng theo LUAT_SUBAGENT mục 10.

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- 11/11 10:18 giao coder v1 (sóng 2, Lead "làm tiếp").
- 11/11 11:06 coder v1 xong (tự báo ĐẠT): tắt khẩn dùng `queue:pause`/`resume` (claim chặn bằng `NOT EXISTS … ADMIN_QUEUE_PAUSE`, `PostgresSchedulerStore.cs:288-293`; cờ `global_dial_kill_switch` chỉ lối Asterisk `DispatchGate.cs:42`, chỉ đọc trước/sau); cảnh báo thử = dừng ngắn `ops-metrics` → `IvrOperationsCollectorMissing` FIRING→RESOLVED. Mới `deploy/m8/tat-khan/{dien-tap.sh,README.md}`, 2 tệp test (26/26 OK, đỏ trước 26), sửa `operations.rules.test.yml` (+45, promtool 9 ca SUCCESS, 2 đột biến FAILED), `deploy/m8/README.md` mục 12 (+15). `test_operations.py` 10/10, `test_khuon.py` 11/11. Không đụng `src`/compose/prometheus.yml/rules.yml. Giới hạn: lịch gọi .61 tắt → bằng chứng chặn là mệnh đề claim đọc từ CSDL + `GET queue`. Giao verifier R2.
- 11/11 11:29 verifier R2: **CẦN SỬA** (26/26, test_operations 10, test_khuon 11, promtool SUCCESS + 3 đột biến FAILED; cơ chế pause đúng, mọi cuộc gọi qua `SchedulerRuntime.cs:229/247`). Lỗi: (1) `dien-tap.sh:624-634` lỗi sau khi đã pause → bẫy EXIT chết ở `T0`/`MA_SU_CO` unbound, không resume, sự cố OPEN, in sai "có lệnh dừng khác" (tái hiện được); (2) `:496-504` đọc CSDL hỏng trước mở lại không in "hàng đợi còn DỪNG" + lệnh `mo-lai`; (3) 5 đột biến sống (READ ONLY 2 câu, actor/lý do, resume + bật ops-metrics trong bẫy). Nhỏ: README nói cờ chỉ DispatchGate đọc (còn `InternalAdminApiService.cs:1096`), epoch 10 chữ số trong test, `cho_no` không thử lại. Giao coder vòng 2 (cùng agent).
- 11/11 12:01 coder vòng 2 xong: `moc_dung` gán `T0`/`MA_SU_CO` ngay sau `DA_DUNG=1` (`dien-tap.sh:670`), biến khởi tạo trước bẫy + bẫy `set +eu`; mọi lối thoát trước mở lại qua `con_dung` in "hàng đợi còn DỪNG" + lệnh `mo-lai`; kiểm READ ONLY trong `chay()`; thêm ca GET queue 500/audit thiếu/actor lệch/`stop-hong`; `cho_no`/`cho_tat` hỏi lại; bỏ chuỗi 10 chữ số; câu chữ cờ thêm `InternalAdminApiService.cs:1096`. Đỏ trước 31/11 lỗi → xanh 31/31; test_operations 10, test_khuon 11; 5 đột biến cũ đều chết. Giao verifier R2 lượt 2.
- 11/11 12:27 verifier R2 lượt 2: **CẦN SỬA** — 6/7 lỗi lượt 1 đạt (lỗi giữa chừng: đúng 1 resume + RESOLVED + mã 1; `con_dung` 6 lối; 5 đột biến cũ chết; trích dẫn đúng; không chuỗi ≥10 số; PII; hỏi lại có hạn), 31 OK, test_operations 10, test_khuon 11, không hồi quy. Còn: (1) Ctrl-C/TERM sau khi dừng: resume đúng nhưng biên bản `DAT` mã 0 (`dien-tap.sh:697`, `don_dep :288`) — không kẹt hàng đợi; (2) khe < 1 giây giữa bước [2/6] `:641` và POST pause `:652`: người khác pause trong khe → API dùng lại sự cố mở (`InternalAdminApiService.cs:311-331`) → kịch bản mở hộ (sửa: `dt:moc-dung` đòi `before_state_json->>'status' = RUNNING`); (3) độ chặt test: đột biến N3/N4/N11 sống. Theo luật hai vòng → **dừng WP, trình Lead m8.77**.

- 11/11 13:55 Lead "Duyệt" m8.79 + m8.77 A (D-m8-078/080): phiên chính tự sửa `dien-tap.sh`: ngắt INT/TERM ghi `KHONG_DAT` mã 1 (vòng giữ + bẫy EXIT); `dt:moc-dung` đọc `before_state_json->>'status'` và đòi `RUNNING` (khe người khác dừng trước: không mở hộ); thêm ca test khe, sự cố lạ, ngắt INT/TERM, `psql-hong-moc-dung`. Đột biến N3, N4, N11, R1, R2b, R3 đỏ (R2 tương đương, hai lớp ghi lỗi ngắt). Trên cây ghép: `test_tat_khan_*` `Ran 34` OK, test_operations 10, test_khuon 11, promtool check 3 luật + test 9 ca SUCCESS. Thư mục bằng chứng đổi thành `docs/evidence/W-0525`; PII PASS, gitleaks dir sạch. **Commit local `64bd51ba`** (W-0525, 10 tệp +2505). Chưa push.

## Bước kế tiếp chính xác
Push khi Lead ra lệnh. Chạy hai cuộc diễn tập trên .61 khi Lead cho lệnh (m8.80: cách chạy trên .61).

## Còn lại / CẦN QUYẾT
- Chạy hai cuộc diễn tập trên .61: cần lệnh Lead (và cách chạy lệnh trên .61).
- Người nhận cảnh báo: gác lại (D-m8-075, m8.73).
- Coder đề xuất (trình Lead cuối sóng): (1) chạy `tat-khan` trong lượt thử `noi-m3` (lịch gọi bật, MOCK) để có bằng chứng worker bị chặn thật — đề xuất có;
  (2) gói nhỏ test .NET khẳng định `TryClaimDueDispatchAsync` không trả job khi có `ADMIN_QUEUE_PAUSE` (repo chưa có test này) — đề xuất có;
  (3) diễn tập cờ `global_dial_kill_switch` (bốn mắt, vô ích ở MOCK) — đề xuất không.
