# Kế hoạch dùng .63 làm máy dev · 14/11/2026 · ĐỀ XUẤT, chờ Toàn chốt (lead.86)

Mục tiêu: việc nặng (job CI GitLab, test M7) chạy trên máy công ty, máy Lead chỉ còn điều phối. Không đụng máy chạy thật .98/.99/.60.

## Danh sách việc (đánh dấu `[x]` khi xong, ghi giờ)

**Chuẩn bị**
- [x] Kiểm .63 chỉ đọc: tài nguyên, Docker, mạng ra ngoài, bản thử cũ — phiên lead · 14/11 10:05
- [x] Viết kế hoạch, rủi ro, đường lui (tệp này) — phiên lead · 14/11
- [ ] Chốt lead.86 = dùng .63 làm máy dev — **Toàn**
- [ ] Gửi tin Anh Tuấn (mục cuối tệp) — **Toàn**
- [ ] Anh Tuấn trả lời: cho mượn .63? .63 có chung máy vật lý với .98/.99? — **Anh Tuấn** (ghi câu trả lời vào đây)

**Giai đoạn 1 — chuyển runner GitLab sang .63**
- [ ] Soạn `kich-ban/runner-63.sh` + `config.toml` mẫu (1 job một lúc, 6 nhân, 16 GB, nhãn riêng) — phiên lead
- [ ] Thử cú pháp kịch bản trên máy Lead, không chạy thật — phiên lead
- [ ] Xem tag của 3 runner máy Lead trên GitLab, ghi vào đây — **Toàn**
- [ ] Tạo runner `may-63` cho ops-core, cùng tag — **Toàn** (GitLab)
- [ ] Tạo runner `may-63` cho ivr, cùng tag — **Toàn** (GitLab)
- [ ] Dán mã đăng ký vào lệnh đăng ký soạn sẵn trên .63 (phiên không nhìn mã) — **Toàn**
- [ ] Khởi động container runner trên .63, kiểm `may-63` online trên GitLab — phiên lead
- [ ] Pause 3 runner máy Lead (job đang chạy để chạy nốt) — **Toàn** (GitLab)
- [ ] Job đầu tiên chạy trên .63 và đạt — phiên lead theo dõi
- [ ] Đo tải .63 và máy Lead sau job đầu, ghi số vào đây — phiên lead
- [ ] Cài dọn image theo nhãn runner mỗi đêm + báo khi ổ > 80% — phiên lead
- [ ] Ghi sổ: `KIEM_KE_MAY_CHU.md`, `chung/MAY_CHU.md`, nhật ký, `/quyet` — phiên lead
- [ ] Chạy ổn 1–2 ngày → sang giai đoạn 2 — Toàn xác nhận

**Giai đoạn 2 — phiên M7 chạy trên .63**
- [ ] Cài Claude Code trong tài khoản `ssv` trên .63 (không sudo) — phiên lead
- [ ] Clone repo M7 vào `/home/ssv/dev/`, cài công cụ build/test theo repo — phiên lead
- [ ] Thêm kết nối SSH `ssv@192.168.1.63` trong Claude Desktop — **Toàn**
- [ ] Đăng nhập Claude trên .63 một lần — **Toàn**
- [ ] Mở phiên M7 trên .63, chạy một lượt test, báo kết quả về phiên `m7` ở máy Lead — Toàn mở, phiên m7 làm
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
| 1 | .63 có thể chung máy vật lý với .98/.99 → CI nặng làm chậm máy chạy thật | runner nhận **1 job một lúc**, mỗi job tối đa **6 nhân, 16 GB**; hỏi Anh Tuấn (tin dưới) |
| 2 | Đụng bản thử cũ `stg_*` | không bao giờ `docker system prune`; dọn rác chỉ theo nhãn của runner; không động container/volume `stg_*` |
| 3 | Job CI chạy bằng Docker (tương đương quyền root trên .63) và giữ biến bí mật lúc chạy (vd khoá deploy .99) | runner **riêng cho đúng 2 project** của Toàn (ops-core, ivr), không chia sẻ cho group/instance; chế độ privileged chỉ giữ như runner máy Lead đang có (job cần docker-in-docker) |
| 4 | Ổ đầy vì image/cache CI | thư mục `/home/ssv/dev/gitlab-runner`, dọn image cũ theo nhãn runner mỗi đêm, báo khi ổ > 80% |
| 5 | Mạng ra ngoài bị chặn về sau | job lỗi rõ ràng → bật lại runner máy Lead (đường lui) |
| 6 | .63 khởi động lại | container runner `--restart unless-stopped`, tự lên lại |
| 7 | Có người khác đang dùng .63 | không ai đăng nhập (0 users), bản thử đứng yên; vẫn hỏi Anh Tuấn một câu |

**Đường lui (bất kỳ lúc nào, dưới 5 phút):** trên GitLab bấm Resume 3 runner máy Lead; trên .63 `docker stop gitlab-runner-63`.
Không mất dữ liệu, không đụng .98/.99/.60, không đụng bản thử cũ.

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

```text
Dạ anh Tuấn, máy .63 hồi trước làm máy thử, giờ tụi em đang để không. Em mượn máy này làm máy dev, chạy mấy job dựng code với test được hông anh? Em giới hạn để nó không ăn hết máy. Mà .63 có nằm chung máy vật lý với .98, .99 hông anh, để em canh mấy máy chạy thật không bị chậm. Em cảm ơn anh nha.
```

Tin xin máy ảo dev mới (`2026-11-14-tin-anh-tuan-may-dev.md`) tạm giữ, chỉ gửi khi .63 không đủ.
