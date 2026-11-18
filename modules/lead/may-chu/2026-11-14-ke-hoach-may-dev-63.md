# Kế hoạch dùng .63 làm máy dev · 14/11/2026 · ĐỀ XUẤT, chờ Toàn chốt (lead.86)

Mục tiêu: việc nặng (job CI GitLab, test M7) chạy trên máy công ty, máy Lead chỉ còn điều phối. Không đụng máy chạy thật .98/.99/.60.

## Danh sách việc (đánh dấu `[x]` khi xong, ghi giờ)

**Chuẩn bị**
- [x] Kiểm .63 chỉ đọc: tài nguyên, Docker, mạng ra ngoài, bản thử cũ — phiên lead · 14/11 10:05
- [x] Viết kế hoạch, rủi ro, đường lui (tệp này) — phiên lead · 14/11
- [x] Chốt lead.86 = dùng .63 làm máy dev — **Toàn** · 14/11 10:30 ("tự làm hết", D-lead-039)
- [ ] Gửi tin Anh Tuấn (mục cuối tệp) — **Toàn**
- [ ] Anh Tuấn trả lời: cho mượn .63? .63 có chung máy vật lý với .98/.99? — **Anh Tuấn** (ghi câu trả lời vào đây)

**Giai đoạn 1 — chuyển runner GitLab sang .63**
- [x] Soạn `may-dev-63/runner-63.sh` + `don-rac-63.sh` (1 job một lúc, 6 nhân, 16 GB) — phiên lead · 10:35
- [x] Thử cú pháp kịch bản trên máy Lead — phiên lead · 10:35
- [x] Xem tag runner máy Lead (phiên lead đọc qua API): ivr `ginsengfood-docker` (docker); ops-core `ops-core-win` (**shell PowerShell trên Windows**, không chuyển sang Linux được) · 10:32
- [—] Runner `may-63` cho ops-core: **bỏ** — CI ops-core chỉ chạy trên Windows; muốn rời máy Lead thì cần máy ảo Windows Server hoặc viết lại CI
- [x] D-lead-040 (14/11 10:49): chuyển CI ops-core sang Linux trên `may-63` — phiên lead thêm tag `ops-core-linux`, mở runner cho ops-core · 10:49
- [x] Gắn bộ SAST đã duyệt vào runner `may-63`: `volumes` thêm `/home/ssv/dev/gitlab-runner/tools/opengrep-1.30.0-gf17:/opt/gfops-sast:ro` (D-m12-059, Toàn "ok m12.c8 A"; m12 phụ nhờ); sha256 engine `f54e82c9…`, luật `dab67718…` khớp; runner tự nạp lại ("Configuration loaded"), thử container: thấy 2 tệp, ghi bị từ chối (chỉ đọc); bản lưu `config.toml.bak-20261114-130930`; `runner-63.sh` (dang-ky) thêm cùng volume, chép lên .63 (bản cũ `.bak-20261114`) — phiên lead · 13:10
- [x] Runner `may-63` lên **2 job một lúc** (m12.c11 bản 2, D-m12-078; m12 phụ nhờ, Toàn "Đổi đi" trong phiên hạ tầng): `concurrent = 2`, `limit = 2`, mỗi job `cpus = "5"`, `memory = "12g"` (trước 1 / 1 / 6 / 16g); `request_concurrency = 2`, privileged, volume SAST, tag giữ nguyên, diff đúng 4 dòng. Bản lưu `config.toml.bak-20261116-140955`. Runner tự nạp ("Configuration loaded … max_builds=2"), job đang chạy không bị ngắt. Kiểm trước 11:13: RAM trống ~30/38 GB, CPU ~40%; lúc đổi load 1 phút 14,9 (1 job). `runner-63.sh` (dang-ky) sửa cùng số, chép lên .63 (bản cũ `.bak-20261116`, sha `f3319632…` khớp). Lui: trả `concurrent`/`limit` về 1 (chép lại bản .bak), không cần đăng ký lại — phiên hạ tầng · 16/11 14:09
- [ ] Phiên m12 phụ chuyển 24 job ops-core sang container Linux (`pwsh`), pipeline xanh trọn 2 lần trên .63 — m12
- [x] Tạm dừng runner Windows `ops-core-win` #54358997 máy Lead **ngay, không chờ Linux xanh** (D-lead-042, Toàn 13:09 "không chạy CI trên máy windows của tôi nữa") — phiên lead (trình duyệt tích hợp, Toàn đăng nhập GitLab) · 13:14: Paused, lúc dừng đang rảnh; `may-63` Active. Máy Lead không còn runner ops-core/ivr nào nhận job. **~13:4x Toàn cho dọn sạch runner máy Lead** (phiên lead chính làm): không Resume nữa; gỡ hẳn cả 3 runner (`ops-core-win`, `ivr-docker-winhost`, `things-docker-winhost`) + dịch vụ + `C:\GitLab-Runner` bằng `C:\Projects\_luu\go-runner-windows.ps1` (Toàn chạy quyền admin, log `go-runner-windows.log`): **đã gỡ 13:22** — unregister 3 runner thành công trên GitLab, dịch vụ gỡ, `C:\GitLab-Runner` xoá, không còn tiến trình (phiên lead chính kiểm 13:3x); bộ SAST đã duyệt chép giữ ở `C:\Projects\_luu\sast-opengrep-gf17-6b93ca\`
- [x] Tạo runner `may-63` #59199848 cho ivr, tag `ginsengfood-docker`, khoá vào ivr — phiên lead (Chrome) · 10:38
- [x] Dán mã đăng ký vào tab terminal — **Toàn** · 10:40 (lỗi quyền `config.toml` thuộc root → phiên lead sửa, kịch bản đã vá)
- [x] Container `gitlab-runner-63` chạy, `may-63` online trên GitLab — phiên lead · 10:41
- [x] Tạm dừng runner ivr máy Lead `ivr-docker-winhost` #55115499 — phiên lead · 10:42 (`ops-core-win` vẫn chạy ở máy Lead; runner `things-docker-winhost` không thuộc ops-core/ivr, chưa đụng) → gỡ hẳn 14/11 cùng 2 runner kia (mục `ops-core-win` ở trên)
- [x] Job đầu tiên chạy trên .63 và đạt: `governance` ivr (job 18027629301) **19 phút** trên .63, trước đó 32 phút trên máy Lead — phiên lead · 11:01
- [x] Đo tải: máy Lead CPU 99% → **36%**, không còn container job trên máy Lead; .63 tải 1,5, RAM trống 31 GB — phiên lead · 10:42
- [x] Cron dọn rác 03:00 + báo khi ổ > 80% (`don-rac-63.sh`, không prune) — phiên lead · 10:36
- [x] Ghi sổ: D-lead-039, `KIEM_KE_MAY_CHU.md`, `chung/MAY_CHU.md`, nhật ký — phiên lead · 10:43
- [ ] Chạy ổn 1–2 ngày → sang giai đoạn 2 — Toàn xác nhận · 14/11 12:57 kiểm (`runner-63.sh kiem`): container lên 2 giờ, rảnh, job cuối 18027932877 (ivr) đỏ `script_failure` 20 giây (lỗi job, runner nhận/trả bình thường), ổ 16%, tải 1,9, RAM sẵn 31 GB, cron dọn còn; chưa thấy job `ops-core-linux` trong log

**Giai đoạn 2 — phiên M7 chạy trên .63**
- [x] Cài Claude CLI 2.1.325 (`~/.local/bin/claude`), .NET SDK 10.0.204 + 10.0.404 (`~/.dotnet`), Node v24.22.3 (`~/.local/node`), PATH trong `~/.profile`, `~/.bashrc` — phiên lead · 10:58
- [x] Khoá deploy riêng `~/.ssh/m7_github` (GitHub deploy key #169840850, ghi được, chỉ repo M7; alias `github-m7`), clone M7 `~/dev/ginsengfood-golden-hour-video` (`cc8473b`) + Project Control công khai `~/dev/project-control` (chỉ đọc) — phiên lead · 11:00
- [x] Build thử M7 trên .63: 0 lỗi (7 phút 20, lần đầu), Domain.Tests 5.175/5.175 đạt (1 phút 22) — phiên lead · 11:10
- [x] Thêm kết nối SSH `may-63` (`ssv@192.168.1.63`, khoá `id_ed25519`, thư mục `~/dev/ginsengfood-golden-hour-video`) vào `sshConfigs` của `~/.claude/settings.json` (bản lưu `.bak-20261114`) — phiên lead · 11:30
- [ ] Đăng nhập Claude trên .63 một lần — **Toàn**
- [x] Phiên M7 máy Lead push T084 `9e8ad9f` (Toàn: "Push, dừng ngay"), dừng sửa mã; gói bàn giao T221/T076d/T085 chép sang `~/dev/ban-giao-m7` (khớp mã băm) — 11:30
- [x] Mở phiên M7 trên .63 `m7-tren-63` (Desktop, kết nối `may-63`) — phiên lead · 11:35
- [ ] Tắt chạy test M7 trên máy Lead, đo lại tải máy Lead — phiên m7

**Nếu có sự cố** → làm theo "Đường lui" bên dưới, ghi lý do vào đây.

## Hiện trạng đã đo (14/11, chỉ đọc)

- **Máy Lead:** 16 nhân / 32 GB, CPU 99%, RAM trống 8 GB. Nặng nhất: job CI GitLab trong Docker của runner máy Lead (≈ 13 nhân).
  3 runner GitLab của máy Lead đang online (ops-core, ivr). CI của business-platform chạy trên GitHub Actions, không dùng máy Lead.
- **.63 (`VPS63`):** máy ảo Hyper-V của công ty, Ubuntu 22.04.4, 10 nhân, 38 GB (trống ~31 GB), ổ 482 GB (trống 400 GB),
  tải 0,3–0,5. Docker 29.1.3; `ssv` thuộc nhóm `docker` (chạy Docker không cần sudo), sudo cần mật khẩu. cgroup v2 có `cpu`, `memory`
  (giới hạn CPU/RAM theo container được). Ra Internet được: gitlab.com, registry.gitlab.com, ghcr.io, nuget, npm, pypi.
  Đang chạy 14 container bản thử cũ, đứng yên 7 ngày: `stg_*` (M3/M4 bản 13/10, `tri_thuc`, `kit`), `stg_m9_*` (M9 của anh Mạnh).
  Luật bản thử (`~/staging/README.txt`): cấm `docker … prune`, cấm `docker compose down -v`; dọn thì xoá đích danh.

## Rủi ro và cách chặn

| # | Rủi ro | Cách chặn |
|---|---|---|
| 1 | .63 có thể chung máy vật lý với .98/.99 → CI nặng làm chậm máy chạy thật | runner nhận **1 job một lúc**, mỗi job tối đa **6 nhân, 16 GB**; hỏi Anh Tuấn (tin dưới). **16/11 14:09: lên 2 job, mỗi job 5 nhân, 12 GB** (D-m12-078) — hai job cùng đỉnh chiếm hết 10 nhân, M7 chậm theo; .63 từng treo 14/11 chưa rõ nguyên nhân → treo lại thì trả về 1 job trước |
| 2 | Đụng bản thử cũ `stg_*` | không bao giờ `docker system prune`; dọn rác chỉ theo nhãn của runner; không động container/volume `stg_*` |
| 3 | Job CI chạy bằng Docker (tương đương quyền root trên .63) và giữ biến bí mật lúc chạy (vd khoá deploy .99) | runner **riêng cho đúng 2 project** của Toàn (ops-core, ivr), không chia sẻ cho group/instance; chế độ privileged chỉ giữ như runner máy Lead đang có (job cần docker-in-docker) |
| 4 | Ổ đầy vì image/cache CI | thư mục `/home/ssv/dev/gitlab-runner`, dọn image cũ theo nhãn runner mỗi đêm, báo khi ổ > 80% |
| 5 | Mạng ra ngoài bị chặn về sau | job lỗi rõ ràng → dựng lại runner bằng `runner-63.sh` trên một máy Linux khác (runner máy Lead gỡ 14/11, không còn là đường lui) |
| 6 | .63 khởi động lại | container runner `--restart unless-stopped`, tự lên lại |
| 6b | .63 treo/tắt (**xảy ra 14/11 sau 20:14**: ARP trống, ssh hết giờ; lúc đó có job ops-core Unit + M7 dev + microk8s; 15/11 11:02 vẫn chưa tự lên; **lên lại 16/11 10:14** sau khi được khởi động lại; nhật ký dừng ngang 20:31:50, không có hết RAM/panic → treo tầng máy ảo; microk8s `kubelite` tự khởi động lại 6 lần trước đó, lead.26) | CI ops-core + ivr đứng (runner duy nhất, D-lead-042); phiên không có quyền Hyper-V → Toàn nhờ Anh Tuấn khởi động lại; lên lại thì xem `journalctl -b -1` tìm nguyên nhân (hết RAM, kernel, host) rồi mới chạy lại job nặng |
| 7 | Có người khác đang dùng .63 | không ai đăng nhập (0 users), bản thử đứng yên; vẫn hỏi Anh Tuấn một câu |

**Đường lui:** ~~trên GitLab bấm Resume 3 runner máy Lead~~ — bỏ: Toàn không chạy CI trên máy Lead nữa (D-lead-042) và runner máy Lead gỡ 14/11.
Runner `.63` hỏng: `bash runner-63.sh chay` dựng lại container (config còn); mất cả .63 thì chạy lại `runner-63.sh chuan-bi/dang-ky/chay` trên máy Linux khác
(cần mã `glrt-` mới do Toàn tạo trên GitLab, và chép bộ SAST `C:\Projects\_luu\sast-opengrep-gf17-6b93ca\` vào `tools/opengrep-1.30.0-gf17`).
Dừng runner .63: `docker stop gitlab-runner-63`. Không mất dữ liệu, không đụng .98/.99/.60, không đụng bản thử cũ.

## Các bước — giai đoạn 1: chuyển runner GitLab (~1 giờ)

| Bước | Ai | Việc |
|---|---|---|
| 0 | Toàn | chốt lead.86 = dùng .63; gửi tin Anh Tuấn (dưới) |
| 1 | phiên lead | kiểm .63 chỉ đọc — **đã xong** (mục trên) |
| 2 | phiên lead | soạn `kich-ban/runner-63.sh` + `config.toml` mẫu: image `gitlab/gitlab-runner` bản cố định, `concurrent = 1`, `cpus = "6"`, `memory = "16g"`, mount `docker.sock`, nhãn riêng, dọn rác theo nhãn; thử cú pháp trên máy Lead |
| 3 | Toàn (~5 phút) | trên GitLab, mỗi project ops-core và ivr: tạo runner mới tên `may-63`, **cùng tag** với runner máy Lead đang dùng; mã đăng ký là bí mật → Toàn tự dán vào lệnh đăng ký phiên soạn sẵn (phiên không nhìn mã) |
| 4 | phiên lead | khởi động container runner trên .63, kiểm runner `may-63` hiện online trên GitLab |
| 5 | Toàn | Pause 3 runner máy Lead trên GitLab (job đang chạy vẫn chạy nốt, chỉ không nhận job mới) |
| 6 | phiên lead | chờ job kế tiếp (hoặc Retry một job nhẹ), xem job chạy trên .63, đo CPU .63 và máy Lead, ghi sổ (`KIEM_KE_MAY_CHU.md`, `chung/MAY_CHU.md`, nhật ký, `/quyet`) |

Kết quả: máy Lead bớt ngay phần CI (~13 nhân lúc chạy job). Pipeline tay ops-core `#3067260417` đang chạy trên máy Lead thì để chạy nốt.

## Giai đoạn 2 (sau khi runner ổn 1–2 ngày): phiên M7 chạy trên .63

- Cài Claude Code trong tài khoản `ssv` (không cần sudo), clone repo M7 vào `/home/ssv/dev/`, công cụ build/test theo repo (cài trong `~`
  hoặc chạy test trong container SDK).
- Toàn thêm kết nối SSH `ssv@192.168.1.63` trong Claude Desktop, đăng nhập Claude trên .63 một lần.
- Sổ `Project Control` chỉ ở máy Lead (không phải git). Đề xuất: phiên trên .63 chỉ làm mã + test, báo kết quả cho phiên `m7` ở máy Lead
  ghi sổ. Cách khác: đưa `Project Control` lên repo git riêng tư (quyết sau).
- Rủi ro thêm: phiên Claude trên .63 dùng tài khoản Claude của Toàn; ai vào được `ssv@.63` thì dùng được → chỉ giữ khoá của Toàn.
- Khi Anh Tuấn cấp máy dev riêng (nếu cần): chạy lại cùng kịch bản ở máy mới, tắt bên .63.

## Tin gửi Anh Tuấn (Toàn tự gửi)

14/11 13:02: tin này đã gộp với tin `mkt.` và RAM .98 thành một tin trong `2026-11-14-tin-mkt-ram-63.md`. 14/11 20:15 bản cuối (D-lead-046): `2026-11-14-tin-anh-tuan-ban-cuoi.md`
(bản 2 20:40, chỉ tin, không tệp kèm) — gửi bản này.

```text
Dạ anh Tuấn, máy .63 hồi trước làm máy thử, giờ tụi em đang để không. Em mượn máy này làm máy dev, chạy mấy job dựng code với test được hông anh? Em giới hạn để nó không ăn hết máy. Mà .63 có nằm chung máy vật lý với .98, .99 hông anh, để em canh mấy máy chạy thật không bị chậm. Em cảm ơn anh nha.
```

Tin xin máy ảo dev mới (`2026-11-14-tin-anh-tuan-may-dev.md`) tạm giữ, chỉ gửi khi .63 không đủ.
