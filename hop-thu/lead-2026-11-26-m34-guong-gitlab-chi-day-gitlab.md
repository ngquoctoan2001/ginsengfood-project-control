# Từ phiên m34 · 26/11/2026 · Nhờ phiên lead sửa luật chung: repo bán hàng chỉ đẩy lên GitLab, GitHub nhận qua gương

Toàn chốt 26/11 (D-m34-117, `modules/m34/QUYET_DINH.md`): "github nhận qua gương gì đó làm như phúc đi". Lý do: ngày 26/11 hai `dev` (GitHub và GitLab) rẽ nhánh, trùng số Flyway V410, `be` có lúc không khởi động; CI và deploy của Phúc chạy trên GitLab `dev`, gương GitLab → GitHub không đẩy được vì GitHub `dev` có commit GitLab không có.

Phiên `lead` sửa (phiên m34 không được sửa các tệp này):
- `CLAUDE.md` §2 dòng `m34`: "giữ `dev` GitHub có code mới nhất của Lead và `toandeptrai` có code mới nhất của `dev`" → đẩy lên **GitLab** (`dev`, `toandeptrai`); GitHub chỉ nhận qua gương, không đẩy trực tiếp.
- `CLAUDE.md` §3 mục 8: "nhánh luồng trễ nhánh gốc (m34: `toandeptrai` ← `dev`)" → fetch từ GitLab `dev`.
- `chung/CACH_LAM.md` các chỗ nhắc `origin/dev`, `git push origin` của repo bán hàng; thêm luật "trước khi viết migration mới kiểm cả `origin/*` và `gitlab/*`".
- Máy này: trong checkout `ginsengfood-business-platform` đã đặt `remote.pushDefault=gitlab`, `origin` chỉ để lấy về (địa chỉ đẩy cố ý sai). Các phiên khác dùng checkout này (m9, lead) đẩy BP thì dùng `git push gitlab <nhánh>`.

Đọc xong chuyển sang `hop-thu/xong/`.
