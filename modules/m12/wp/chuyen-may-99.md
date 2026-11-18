# chuyen-may-99 — Chuyển M1–M2 từ .61 sang 192.168.1.99 (D-lead-035/036/037/038)

Trạng thái: ĐANG LÀM — **M1–M2 CHẠY TRÊN .99 từ 13/11 19:15:26** (push `ec5264296`, pha a/tập/b xong, dữ liệu khớp 213 bảng / 585.855 dòng; dừng ghi ~40 giây). Sao lưu .99 PASS + cron 22:00 (20:26), pha d xong (.61 dừng hẳn, CD .61 bị chặn, 20:27), push `714efab72`, push `cf44eae22` sửa CI (14/11). 14/11: khoá CD .99 cài + thử đạt (07:43), biến `M12_99_SSH_KEY` + `M12_99_KNOWN_HOSTS` có (File, Protected, `m12-99`), sao lưu ngoài máy trên máy Lead đăng ký lại trỏ .99 (23:30, chạy thử 0, bản 13/11 đã kéo). Phần phiên phụ XONG. Còn (phiên chính/khác): tầng test `main` đỏ → kho chưa có image; WP17 lên .99 rồi bấm `deploy-99` lần đầu (CD xanh = tiêu chí xong); Anh Tuấn đổi nginx. **D-m12-060 (14/11 13:09):** pipeline cho `deploy-99` chạy trên runner Linux `.63` (phiếu `ci-linux-63.md`), không chạy trên máy Windows của Lead; sau 15/11 16:59Z cần thêm WP20 · Rủi ro: R3 (dữ liệu thật, máy thật) · Chế độ: S (phiên phụ, sửa trên `main`) · Mốc: không khung giờ (D-lead-038: xong lúc nào đưa lên lúc đó), m12 trước m34
Hạng mục nâng: hạ tầng chạy thật M1–M2 (máy mới, CD, sao lưu) · Sheet: CHƯA GHI (sheet-sync ghi kèm `docs/weekly-tracking/nguyen-quoc-toan.md` đang dở của phiên chính → phiên chính ghi khi gộp) · Ước lượng: 0,5 ngày + cắt ~20 phút
Chỗ làm: checkout chung `C:\Projects\ginsengfood-ops-core` `main` · Base SHA: `d114b52de` · Prompt: `modules/lead/may-chu/2026-11-13-chuyen-may-99/2-m12.md`

## Đích trên .99 (tin lead 14:55 + 15:10, D-lead-037)
- `/data/ginsengfood-ops-core` (thư mục thật, KHÔNG `~/m12`) · sao lưu `/data/sao-luu/ginsengfood-ops-core` · project compose `m12` (`name: m12` có sẵn trong compose .61).
- Caddy `192.168.1.99:8012` (tường lửa mở cho LAN `192.168.0.0/23`; `M12_FRONT_PROXY_CIDR=192.168.0.0/23`, Toàn chốt không xin IP nginx — `ec5264296`) · API `:5000` (tường lửa: chỉ .60, .98) · máy UTC · Docker 29.9.3, Compose 5.7.1, ssv trong nhóm docker, sudo cần mật khẩu (phiên không dùng).
- DNS `ops./pwa./trace.` Anh Tuấn trỏ nginx → `.99:8012` sau pha b.

## Pha 0 (THẬT, 13/11 15:56, Toàn duyệt "Chạy pha 0", thoát 0)
- .61 chạy `87acc810db88244cdee90ce2078466d6cb88240b`. Compose + Caddyfile = commit `11fbf6ba1` (WP16, **chưa WP17**): không `secrets/`, không allowlist trong compose, API `ASPNETCORE_ENVIRONMENT=Development`, nạp thêm env_file ngoài `~/m12`: `/home/ssv/.config/ginsengfood/ops-pilot-session.env`.
- CSDL `ginsengfood_operational` **323 MB** (không phải ~15 MB như ghi trước), vai trò `ginsengfood`; `du-lieu/` 420K (uid 10001).
- Sao lưu: cron `0 15 * * *` (22:00 VN) `daily-backup.py`, đường thư mục + tên hộp PG nằm ở `sao-luu/hardening_common.py` (không có trong repo); bản cuối 12/11 15:00.
- .99: `/data/ginsengfood-ops-core` rỗng, ssv ghi được, không `~/m12`, kéo được registry.

## Mã (commit trên `main`; tới `714efab72` đã push, kể cả `ec5264296` FRONT_PROXY và `714efab72` đường `hardening_common.py`)
- `3e26b61be` compose (AllowedHosts `.99`, `M12_HTTP_PORT`), `Invoke-M12Deploy61.ps1 -Target`, job `deploy-99`, `deploy/m12/chuyen-99/{chuyen-99.sh,may.sh}`, test giả, Pester.
- `8817e6b86` runbook `docs/runbooks/release/13-11-15-00-chuyen-m12-sang-99-runbook.md` + README.
- `2a2023678` chép cấu hình bằng root trong hộp pg (`secrets/*` giữ 10001:10001 0400; thử THẬT busybox 1.37).
- `a682eb950` đường .99 theo D-lead-037 (script tính đường từ thư mục của chính tệp, allowlist compose WP17 mục 1, 2 bắt buộc, cron/sao lưu sang `/data`, `--lam-lai`).
- `0ee3737e6` chụp CSDL .61 ngay trước dừng ghi (D-lead-038) + sửa theo pha 0: mang env_file ngoài vào `cau-hinh-ngoai/`, allowlist theo đúng kiểu .61 (WP17 / env_file / không giới hạn; luôn cho .98), vá đường sao lưu ở `hardening_common.py`, kiểm trùng subnet `edge`. Test giả dựng .61 đúng hình thật (`11fbf6ba1`) 50/50; đoạn chép env ngoài chạy thật trong busybox `postgres:18-alpine` trên máy Lead (chủ/quyền giữ đúng).

## Pha (mỗi pha một lệnh; mặc định chỉ in kế hoạch)
0 `kiem-ke` ✔ · a `pha-a --ban 87acc810… --cong 8012` · tập `tap` · b `pha-b` (chụp CSDL → dừng ghi → dump → chép → nạp → so đếm → bật .99) · c Anh Tuấn trỏ nginx · d `pha-d` · `sao-luu-99` · `khoa-cd-99` (sau push + biến GitLab `M12_99_SSH_KEY`, `M12_99_KNOWN_HOSTS`).

## Bước kế tiếp chính xác
(1) ✔ Push `cf44eae22` (14/11, Toàn duyệt; main = `cf44eae22`). (2) Toàn làm một lượt `wp/chuyen-may-99-lenh-toan.md` (khoá CD .99, biến GitLab, `M12_CD_FROM_MAIN=true`, tác vụ sao lưu ngoài máy); bước `khoa-cd-99 --thuc-hien` phiên chạy khi Toàn duyệt. (3) Phiên chính sửa test `ComposeSamples` đỏ (do `a682eb950`) để pipeline `main` xanh → kho có đủ 5 image. (4) Phiên chính đưa WP17 lên `/data/ginsengfood-ops-core` rồi mới bấm `deploy-99` lần đầu. Pha a tự chép image từ .61: BỎ (tin lead-nen-99 13/11 tối) — sửa gốc ở CI thay vào đó.

## Vì sao kho GitLab thiếu image (13/11 22:00)
- `build-images` cùng điều kiện với nút deploy: chỉ chạy khi pipeline ứng viên hoặc `M12_CD_FROM_MAIN == "true"` — biến này chưa từng đặt → không pipeline `main` nào đẩy image. 5 image `87acc810` dựng tay trên máy Lead 11/11 rồi `docker save|load` vào .61, không qua kho.
- Thêm: `build-images` cần `runtime-summary` + `pester-security-static`; test governance `ComposeSamples` đỏ từ `a682eb950` (compose đòi `M12_SOURCE_ALLOWLIST_1/_2` nhưng dict `ComposeSamples` trong `tests/governance/Ginsengfood.Operational.Governance.Tests/M12ProductionHardeningStaticGuardTests.cs` chưa có) → pipeline đỏ thì cũng không đẩy image.
- Sửa (D-lead-017): `build-images` chạy trên MỌI pipeline `main` (trừ lịch); nút `deploy-61/99` vẫn giữ điều kiện cũ. Test M12CD01/M12CD02 sửa theo.

## Còn lại / CẦN QUYẾT
- `.60` KHÔNG phải đổi: m34 kiểm `be` trên `.60` để `OPS_CORE_ENABLED=false` nên M3 không gọi M1–M2 (tin lead-nen-99 13/11 tối); khi M3 bật lại ops-core thì trỏ `http://192.168.1.99:5000` (hoặc M3 đã ở `.99`).
- .99 là bản chép y .61 (WP16, Development) — WP17 (Production, secrets) vẫn là việc của phiên chính, áp sau trên .99.
- Không áp `SEC-19.patch`/`SEC-14b.patch` vào cuộc cắt; SEC-19 sửa compose → áp `--3way` sau.
- Tác vụ sao lưu ngoài máy (máy Lead): đăng ký lại `-RemoteHost ssv@192.168.1.99 -RemoteDirectory /data/sao-luu/ginsengfood-ops-core/ops-pilot/daily` (Toàn, runbook §6).
- DNS (tin lead-nen-99): ops./pwa./trace. → 14.224.139.101, bản ghi `api-ops` đã xoá; trong máy M12 vẫn dùng `api-ops.ginsengfood.vn` làm Host (AllowedHosts, Caddy) — không phải đổi.
