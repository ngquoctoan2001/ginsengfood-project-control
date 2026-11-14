# Pipeline CI M8 (ivr) — phân tích và đề xuất tối ưu (05/11)

Mốc 05/11/2026 13:30 UTC+7 · nguồn `main` `2acfd7e6`: `.gitlab-ci.yml` + 11 tệp `deploy/ci/*.gitlab-ci.yml` (956 dòng),
`deploy/ci/gate-invocations.json`, cấu hình runner trên máy Lead (chỉ đọc dòng `concurrent`/`limit`, không đọc token).
Thời gian từng job: **CHƯA ĐO** (dự án GitLab private, API 404; sự kiện Docker cũ đã mất). Đang ghi sự kiện container của pipeline `2acfd7e6` để đo.

## 1. Hiện trạng

- 34 job khai báo; push `main` tạo **32**: 29 tự chạy + 3 bấm tay (`publish_aux_images`, `deploy_m8_61`, `registry_push_pull_smoke`).
  Theo stage: validate 21 · build 1 · test 4 · security 1 · privacy 1 · publish 3 · deploy 1.
- **Runner `ivr-docker-winhost` đặt `limit = 1`** (`C:\GitLab-Runner\config.toml`; `concurrent = 3` chia cho 3 runner) → 29 job chạy **tuần tự từng cái**.
  Thời gian pipeline = tổng thời gian mọi job, cộng mỗi job: kéo image, lấy mã (pack 56 MB, 5.105 tệp, 3.049 tệp bằng chứng), khởi động dind.
- M8 nhỏ thật (9 project .NET + 4 project test), nhưng pipeline lặp lại cùng một việc nhiều lần:

| Loại lặp | Job | Lặp gì |
|---|---|---|
| Chạy lại test đã có | `chaos_suite`, `contract_suite`, `e2e_flow_suite`, `schema_compat_gate`, `observability_contract` | `build_test_dotnet` chạy `dotnet test Ivr.sln` không lọc = cả Unit, Integration, Contract, Chaos. 5 job này chạy lại tập con, mỗi job tự restore + build + (3 job) dind |
| Build .NET | 11 job dùng `dotnet/sdk` | ~8 lần build solution/project mỗi pipeline; NuGet cache khoá theo **tên job** (`dotnet-$CI_JOB_NAME`), 6 job không cache |
| Build image Docker | `image_selftest`, `observability_runtime`, `publish_images` (+ `tts_candidate_selftest`) | api/worker build 3 lần trên dind mới (không có layer cache); trivy 2 lần; ảnh TTS (~4,7 phút) mỗi pipeline dù không ai dùng |
| Selftest Node nhỏ | 11 job: `cd_`, `progressive_`, `capacity_`, `compliance_pack_`, `gate_status_mirror`, `observability_staging_contract`, `review_gate_` (chạy node trong image .NET), `dr_`, `ci_config_`, `api_docs_verify`, `openapi_lint` | Mỗi job vài giây việc thật, phần lớn thời gian là dựng container + `npm ci` |
| Quét chồng | `gate_sweep` | 50 gate, **~30 trùng** job riêng hoặc npm script (kể cả `scan-pii.sh docs/evidence` mà `pii_scan` cũng chạy) |

## 2. Đề xuất — ba lớp, làm theo thứ tự

**Lớp 1 — runner (không đổi nội dung kiểm).** Nâng `limit` của `ivr-docker-winhost` 1 → 2 (máy 16 nhân) và thêm `needs:` để job nhẹ không chờ stage.
Rủi ro: RAM khi hai job Testcontainers chạy cùng lúc; gate nhạy thời gian (`lab-converter-selftest` 180 s). Sửa cấu hình máy → Lead làm hoặc cho phép.

**Lớp 2 — gộp job (W-0503, R2, ~1 ngày công AI): 32 → 10.**

| Job mới | Gộp từ | Ghi chú |
|---|---|---|
| `governance` (node + python) | 11 selftest Node, `m8_selftest`, `gate_sweep`, phần npm của `openapi_lint`/`api_docs_verify` | một `npm ci`; gate-sweep thành nơi duy nhất chạy gate offline, bỏ trùng |
| `api_contract_diff` | giữ | cần image oasdiff |
| `observability_rules` | giữ | cần promtool |
| `dotnet` (sdk + dind) | `lint_dotnet`, `build_test_dotnet`, 5 job tập con, `globalization_invariant_gate` | restore 1 lần (cache chung theo lockfile) → nswag drift → format → build có analyzer → test cả solution có coverage → lượt Unit invariant `--no-build`; tách junit theo TestId thành bằng chứng schema/e2e/contract/chaos/obs như cũ |
| `security_scan` | giữ, chạy song song từ đầu | |
| `images` (docker + dind) | `image_selftest`, `observability_runtime`, `publish_images` | build 4 image **một lần**, trivy một lần, compose smoke, kiểm observability runtime; trên `main` push `:<commit>` |
| `pii_scan` | giữ | `needs: dotnet, governance` |
| Bấm tay | `publish_aux_images`, `deploy_m8_61`, `tts_candidate_selftest` (chuyển sang bấm tay/chạy khi `deploy/tts/**` đổi) | |
| Bỏ | `registry_push_pull_smoke` (bằng chứng W-0061 cũ; `images` đã push thật), `api_docs_pages` (luôn `never`) | |

Phải sửa kèm: `ci-config-selftest.mjs`, `docs-selftest.mjs` (bảng tên job), `OpenApiDocumentTests.cs`, cột `runner` trong `gate-invocations.json`.
Không bớt kiểm nào: mọi lệnh/gate cũ vẫn chạy, chỉ chạy một lần. Verifier kiểm từng lệnh cũ có chỗ chạy mới; cần một pipeline thật trên runner (push).

**Lớp 3 — chạy theo thay đổi.** `rules: changes`: commit chỉ đổi `docs/**`, sổ, bằng chứng (phần lớn commit của M8) chỉ chạy `governance`, `security_scan`, `pii_scan`;
`dotnet`/`images` chỉ khi `src/**`, `tests/**`, `*.sln`, `Directory.*`, `deploy/docker/**`… đổi; thêm lượt đầy đủ hằng đêm (schedule).
Hệ quả: commit tài liệu không có image `:<commit>` riêng → `trien-khai.sh` dùng commit mã gần nhất.

## 3. Ước lượng (chưa đo, sẽ thay bằng số đo pipeline `2acfd7e6`)

Lớp 1 rút thời gian chờ khoảng một nửa. Lớp 2 bỏ ~5 lượt build .NET, 2 lượt build image, ~20 lần dựng container và `npm ci`.
Lớp 3 làm commit tài liệu chỉ còn vài phút. Con số cụ thể chỉ nêu sau khi đo.

## 4. Cần Lead quyết

- m8.45 Nâng `limit` runner `ivr-docker-winhost` 1 → 2: A bạn tự sửa `C:\GitLab-Runner\config.toml` rồi `gitlab-runner restart` · B cho phiên này sửa. Đề xuất A.
- m8.46 Làm W-0503 gộp job (lớp 2), ghép local, push lệnh riêng? Đề xuất làm ngay sau `pii_scan` (m8.39) để không lẫn hai nguyên nhân đỏ.
- m8.47 Lớp 3: A commit tài liệu bỏ `dotnet`/`images` + lượt đầy đủ hằng đêm · B giữ chạy đủ mọi push `main`. Đề xuất A.
