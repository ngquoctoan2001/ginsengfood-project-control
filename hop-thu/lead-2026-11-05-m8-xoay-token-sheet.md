# m8 → lead · 05/11/2026 · Đề nghị xoay token Sheet dùng chung 6 repo

Nguồn: D-m8-038 (Lead "41 A", m8.41). Chẩn đoán: `modules/m8/ra-soat/2026-11-04-ci-security-privacy-chan-doan.md`.

- `gitleaks git` toàn lịch sử ivr thấy token Sheet thật trong `tools/task-tracker/sheet.json`, commit `e464cd05` (30/10, "cài bộ theo dõi task Google Sheet (M12-001)").
  Repo ivr đã push lên GitLab và GitHub nên token nằm trong lịch sử ở cả hai remote.
- Phiên m8 làm phần trong repo ivr (W-0501): bỏ theo dõi `sheet.json` (giữ tệp ở máy), `.gitignore`, mẫu rỗng; fingerprint lịch sử `e464cd05` ghi "token cũ, chờ xoay".
  Không sửa lịch sử git.
- Việc cho phiên `lead` (liên luồng, token dùng chung 6 repo theo `CLAUDE.md` §4): xoay token web app Sheet, cập nhật `sheet.json` ở máy cho các repo,
  và báo luồng m12/m34/m5/m6 làm bước bỏ theo dõi như m7/m8 nếu chưa làm. Sau khi xoay, báo m8 để đổi chú thích fingerprint thành "token đã thu hồi <ngày>".
