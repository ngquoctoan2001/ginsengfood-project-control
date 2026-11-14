# Từ phiên phụ m8 (chuyển app M8 sang .99) · 13/11/2026 · xong phần mã, chờ Toàn duyệt push

- **Commit local `7f12ddaf` trên `main`** (cha `af93ca42`), **W-0533**, Sheet **M8-011** (Đang làm: pha máy chưa chạy).
  29 tệp, đưa vào bằng `GIT_INDEX_FILE` riêng; không đụng `docs/weekly-tracking/nguyen-quoc-toan.md` và
  `deploy/operations/m34_mock_agent*.py` (vẫn dở trong checkout). Index thật đã đồng bộ, `git status` chỉ còn ba tệp đó.
- Register: dòng W-0533, `NEXT_WORK_ID: W-0534`; `gate-status.yaml`/`readiness-board.md` sinh lại. Commit tiếp theo của
  phiên chính dùng **W-0534**.
- Nội dung: `deploy/m8/may-99/` (kịch bản theo pha `kiem`/`a`/`mo-64`/`b`/`allow --ip`/`d`/`quay-lui`/`sao-luu`, runbook),
  `M8_DIA_CHI` + profile `s5-lab` trong khuôn, CD `deploy_m8_99` (`/data/ginsengfood-ivr/trien-khai.sh`), `deploy_m8_61`
  chỉ bấm tay, `git` trong container `deploy/m8/tests`. Bằng chứng: `docs/evidence/W-0533/README.md`.
- Kiểm: `test_may_99` 30 OK (Windows + container CI), đột biến 5/5, các tệp `deploy/m8/tests` OK, selftest CD/CI/docs PASS,
  `DOCUMENT_LINKS_PASS`, gitleaks 0/0. Quét trước push D-m8-055: KẾT_QUẢ_QUÉT.
- **Chưa push.** Toàn duyệt push `7f12ddaf` riêng. Nếu phiên chính commit thêm trước khi push, push sẽ mang cả hai.
- .64 đã mở cầu ARI cho .99 (16:08, Toàn tự chạy sudo). Thêm bước kiểm ARI bằng chứng thư thật sau pha a:
  `C:\Projects\_wt\m8\chuyen-may-99\kiem-ari-99.sh` (gửi qua `ssh … bash -s`, chỉ in mã HTTP; ngoài repo).
- D-lead-038 đã áp: bỏ khung giờ; bước 1–4 làm được ngay, pha b sau khi m34 cắt xong (m12 → m34 → m8). Phiếu
  `modules/m8/wp/chuyen-may-99.md` có bảng **lượt duyệt liền** (push `7f12ddaf:refs/heads/main` → `kiem` → `a` → `mo-64`
  → nhắn nhóm → `b` → m34 đổi địa chỉ → `sao-luu` → `d`), chỗ chụp CSDL .61 (b7 `dump-giu` lúc dừng ghi) và câu nhắn nhóm.
- `deploy/m8/may-99/README.md:138` và `docs/evidence/W-0533/README.md:40` còn ghi khung giờ cũ; sửa ở commit M8 sau
  (không đụng `7f12ddaf`).
- Việc .61 trong cửa sổ m34 14/11 (`hop-thu/m8-2026-11-13-m3-sang-99-cau-callback.md`) vẫn thuộc phiên chính.

Đọc xong chuyển sang `hop-thu/xong/`.
