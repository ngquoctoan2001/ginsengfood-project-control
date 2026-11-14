# Pipeline `main` đỏ — chẩn đoán 3 job (04/11)

Mốc 04/11/2026 11:10 UTC+7 · Sheet M8-002 · Lead báo đỏ trên `e79fec71`: `gate_sweep`, `image_selftest`, `tts_candidate_selftest`.
Không xem được log GitLab (repo riêng tư). Ba subagent dựng lại từng job trên bản xuất sạch, chạy trong đúng image của job với docker-in-docker
hoặc socket Docker, rồi so với `caaa8f65` (trước W-0497). Bản xuất và log ở `C:\Projects\_wt\m8\ci-{gate,img,tts}-{e79,caa}\_log\`.

**Kết luận: cả ba đều không do W-0497/W-0498.** Có hai lỗi có sẵn và một lỗi phát sinh theo thời gian. Lỗi `.npm` làm đỏ hai job.

| Job | Bước đỏ | Nguyên nhân | Loại | Bằng chứng |
|---|---|---|---|---|
| `tts_candidate_selftest` | bước 1 `tts-provenance-gate.mjs --selftest` | `.gitlab-ci.yml:30` `npm_config_cache: $CI_PROJECT_DIR/.npm` → `npm ci` tạo `.npm` ở gốc checkout; `tts-provenance-gate.mjs:81-82` từ chối mục gốc không có trong `deploy/ci/governance/tts-repository-paths.json` | có sẵn từ W-0380 `18a2cedf` (28/09) | đúng như CI: có cache đỏ, đưa cache ra ngoài thì PASS; `caaa8f65` y hệt. 8 bước sau chạy riêng đều xanh |
| `gate_sweep` | 49/51: `tts-provenance-gate` (như trên) + `tts-container-selftest` `ETIMEDOUT` đúng 180 s | thứ hai: mặc định `gate-sweep.mjs:32` 180 s, mục `gate-invocations.json:177` không đặt `timeoutMs`; dind trống phải kéo image + `uv pip sync` | có sẵn + môi trường (ngân sách thời gian) | chạy trên chính máy runner, dind 29.6.2 mới mỗi lượt: đỏ y như hộp thư 03/11; riêng gate container không hạn → PASS sau 230 s |
| `image_selftest` | `IT-IMG-SCAN-04` trivy | HIGH `GHSA-p3jp-9v83-76w9` trong .NET runtime 10.0.13 của base `aspnet:10.0-noble-chiseled@sha256:84def277…`; sửa ở 10.0.14 | theo thời gian: advisory đăng 03/11 17:33Z | job của `1bc8ee6d` xong trước giờ đó nên xanh; job của `e79fec71` chạy sau nên đỏ; `caaa8f65` chạy local đỏ y hệt |

## Đề xuất sửa (W-0499, gói 02G, R2: coder + verifier; chưa áp dụng)

1. `tts-repository-paths.json`: thêm `.npm` và `.nuget` (biến `NUGET_PACKAGES` cũng nằm trong checkout). Theo ghi chú của tệp, thêm mục chỉ mở rộng tập từ chối, không cấp duyệt.
   Tệp này được đóng vào image TTS (`Dockerfile.tts:52`, `verify-model.py`), nên phải chạy lại `tts-container-selftest` và test `deploy/tts`. Không dời cache ra ngoài checkout, vì cache GitLab cần đường dẫn trong project.
2. `tts-container-selftest` trong `gate_sweep`: **A** = đặt `timeoutMs: 600000` · **B** = `sweepable: false`, runner `tts.gitlab-ci.yml` (job này chạy đúng gate đó ở `tts.gitlab-ci.yml:29`, `allow_failure: false`, trong cùng pipeline). **Đề xuất B**: không dựng image TTS hai lần trên runner chỉ chạy 1 job một lúc.
3. Đổi `RUNTIME_IMAGE` sang `mcr.microsoft.com/dotnet/aspnet:10.0.14-noble-chiseled@sha256:<digest kiểm lại lúc làm>` ở 6 tệp đang ghim `84def277`:
   `deploy/docker/Dockerfile.{api,worker,migrate,ops}`, `deploy/media-sync/Dockerfile`, `deploy/telephony-vm/l35/run_worker_sip_lab.py`. Không dùng `.trivyignore`.
   Không đụng `deploy/release-candidate/components.lock.json` (candidate đã niêm phong) và `deploy/sandbox-m3/Dockerfile.runtime` (vùng M3 của phiên khác).
4. Kiểm: dựng lại cả 3 job như lượt chẩn đoán (script `job*.sh` ở `ci-gate-e79\_log\`), `image-selftest` chạy hết tới SBOM-06/E2E-05, test api/worker trên runtime mới, PII, bằng chứng `docs/evidence/W-0499`.
   Ghép vào main như W-0497/W-0498; push cần lệnh riêng. Pipeline xanh thì `publish_images` mới chạy và có image `:<commit>` cho CD.

Ghi chú: `image_selftest` sẽ đỏ lại mỗi khi có advisory HIGH mới. Đó là đúng ý của gate; khi đó cần một commit đổi digest như mục 3.

## Cần Lead quyết

- m8.36 Làm W-0499 sửa CI theo mục 1–4: **A** = `timeoutMs` 600 s cho `tts-container-selftest` trong sweep · **B** = `sweepable: false` (chạy ở `tts_candidate_selftest`). **Đề xuất B.**

Cập nhật 13:26: đã sửa trong W-0499 `4791030a` (ghép local) — [kết quả](2026-11-04-ci-w0499-ket-qua.md). Bản xuất `ci-*` đã dọn; `_log` chuyển sang `C:\Projects\_wt\m8\prep-w0499\chan-doan\`.
