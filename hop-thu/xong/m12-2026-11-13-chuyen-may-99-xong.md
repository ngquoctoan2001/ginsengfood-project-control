# Từ phiên phụ `m12 · chuyển M1–M2 sang .99` · 13/11/2026 19:20 · ĐÃ CẮT, còn vài bước sau cắt

Đọc xong chuyển sang `hop-thu/xong/`. Phiếu: `modules/m12/wp/chuyen-may-99.md`; nhật ký: `modules/m12/nhat-ky/2026-11-13-chuyen-may-99.md`.

## Đã xong (Toàn duyệt "ok m12.c1")
- **M1–M2 chạy trên `192.168.1.99` từ 19:15:26**, thư mục `/data/ginsengfood-ops-core` (project compose `m12`), bản `87acc810db88244cdee90ce2078466d6cb88240b`.
  Dữ liệu `.61` lúc 19:14:46 khớp 213 bảng / 585.855 dòng, `du-lieu` 5 tệp. Dừng ghi ~40 giây. `.61` còn `pg-ops` + dữ liệu (đường lui `lui-61`).
- Commit trên `main`, đã push: `3e26b61be` `8817e6b86` `2a2023678` `a682eb950` `0ee3737e6` `ec5264296` (deploy/m12, `.gitlab-ci.yml` job `deploy-99`, test, runbook
  `docs/runbooks/release/13-11-15-00-chuyen-m12-sang-99-runbook.md`). Không sửa mã app.

## Phiên chính cần biết NGAY
- **Chưa chạy CD `deploy-61`** cho tới khi xong pha d: CD `.61` sẽ bật lại app cũ trên CSDL `.61` đã cũ → hai nơi ghi.
- `.99` là bản chép y `.61` = compose **WP16** (`11fbf6ba1`, Development, env_file `cau-hinh-ngoai/ops-pilot-session.env`), KHÔNG phải WP17.
  Đưa WP17 (Production, `secrets/`) lên `.99` vẫn là việc của phiên chính; đường mới là `/data/ginsengfood-ops-core`, không `~/m12`.
- Allowlist `/v1` trên `.99` = **không giới hạn** (như `.61`). Mục 5 của `hop-thu/m12-2026-11-13-canh-bao-allowlist-cho-phien-phu.md`
  (`M12_SOURCE_ALLOWLIST_2`) không áp cho bản WP16; khi lên WP17 mới cần 3 mục (`_0/_1/_2`, xem runbook WP17).
- `SEC-19.patch` sửa compose → áp `--3way` sau (đụng dòng AllowedHosts/cổng/allowlist mới).
- Kho GitLab KHÔNG có `ops-core-migrate:87acc810…` (pha a hỏng lần 1); đã chép 5 image từ `.61` sang `.99` bằng `docker save | docker load`.
- TargetId/nhãn trong tracker vẫn ghi `m12-61` ở vài nơi; Sheet chưa ghi task này (tệp `docs/weekly-tracking/nguyen-quoc-toan.md` đang dở của phiên chính).

## Còn lại (phiên phụ làm tiếp nếu Toàn duyệt)
- ~~m34 pha M trên `.60`~~ BỎ: `.60` KHÔNG phải đổi: m34 kiểm `be` trên `.60` để `OPS_CORE_ENABLED=false` nên M3 không gọi M1–M2 (tin lead-nen-99 13/11 tối).
- Anh Tuấn trỏ nginx `ops./pwa./trace.` → `192.168.1.99:8012`.
- Pha d (dừng hẳn app `.61`, chặn CD `.61`, tắt cron `.61`); `sao-luu-99` (vá `hardening_common.py`: `RELEASE/DEPLOY/PRIVATE_ENV`); `khoa-cd-99` (Toàn đặt `M12_99_SSH_KEY`, `M12_99_KNOWN_HOSTS`);
  tác vụ sao lưu ngoài máy trỏ `/data/sao-luu/ginsengfood-ops-core/ops-pilot/daily` (Toàn, runbook §6).

## Cập nhật 13/11 20:28 (Toàn duyệt "ok m12.c2")
- Sao lưu .99: cron 22:00 VN trên .99, bản thử `ops-pilot-daily-20261113T132630Z-050c24b8` PASS trong `/data/sao-luu/ginsengfood-ops-core/ops-pilot/daily`.
- Pha d xong: .61 dừng hẳn, `trien-khai.sh` đổi tên → CD `deploy-61` bị chặn (thoát 3); cron .61 tắt; volume + `du-lieu` giữ (đường lui `chuyen-99.sh lui-61`).
  Mục "Chưa chạy CD deploy-61" ở trên nay đã được chặn bằng máy; vẫn đừng chạy job đó.
- Push `714efab72` (vá đường `hardening_common.py`). Main hiện `714efab72`.
- Còn: `khoa-cd-99` (Toàn đặt `M12_99_SSH_KEY`, `M12_99_KNOWN_HOSTS`), tác vụ sao lưu ngoài máy (Toàn), Anh Tuấn đổi nginx. (Bỏ việc `.60`: `OPS_CORE_ENABLED=false`.)

## Cập nhật 13/11 22:37 (tin lead-nen-99: phiên phụ làm cho xong)
- **Test governance `ComposeSamples` ĐỎ — phiên chính sửa:** do `a682eb950` (compose đòi `M12_SOURCE_ALLOWLIST_1/_2`) mà dict `ComposeSamples` trong
  `tests/governance/Ginsengfood.Operational.Governance.Tests/M12ProductionHardeningStaticGuardTests.cs` chưa có hai khoá đó → thêm giá trị mẫu cho `_1`, `_2`.
  Pipeline `main` còn đỏ thì `build-images` (cần `runtime-summary`) không chạy.
- **Kho GitLab thiếu image — gốc:** `build-images` chung điều kiện `M12_CD_FROM_MAIN` với nút deploy, biến chưa từng đặt → không pipeline nào đẩy image.
  Sửa ở `cf44eae22` (CHƯA push): `build-images` chạy mọi pipeline `main`; nút `deploy-61/99` giữ điều kiện. M12CD01 126/126, M12CD02 476/476.
  Pha a tự chép image từ .61: BỎ.
- **Lượt lệnh của Toàn:** `modules/m12/wp/chuyen-may-99-lenh-toan.md` (khoá CD .99, biến `M12_99_SSH_KEY`/`M12_99_KNOWN_HOSTS`, `M12_CD_FROM_MAIN=true`, tác vụ sao lưu ngoài máy).
- **Trước lần bấm `deploy-99` đầu tiên:** .99 đang WP16 (Development); bản `main` mới cần WP17 trên `/data/ginsengfood-ops-core` — việc phiên chính.
