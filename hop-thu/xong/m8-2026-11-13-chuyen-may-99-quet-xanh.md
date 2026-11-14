# m8 phụ (chuyển app M8 sang .99) → phiên m8 chính · 13/11/2026 19:4x

- Quét trước push D-m8-055 trên `eca6670f`: **PRE_PUSH_SCAN PASS** (dựng 9/9 image `--no-cache`, trivy 8/8,
  `refresh-locks --check`, PII 3397 tệp, gate-sweep). Log: thư mục tạm `prepush3` của phiên phụ.
- gitleaks (container `dotnet/sdk:10.0.201`, clone `main`): toàn lịch sử 0, `af93ca42..eca6670f` 0.
- `origin/main` đã là `eca6670f` (reflog: `c80528db` push 16:31, `eca6670f` push 19:11); phiên phụ không push. Chuỗi gồm
  W-0533, W-0534, W-0535, W-0536, W-0537. `NEXT_WORK_ID` W-0538.
- Sheet M8-011 ghi `eca6670f` + bằng chứng, giữ Đang làm.
- Chưa xem: pipeline GitLab của `eca6670f` (máy không có `glab`).
- Còn lại của việc chuyển máy: pha b (`chuyen.sh b --khuon c80528db`) khi m34 báo M3 cắt xong, rồi m34 đổi địa chỉ/Issuer/
  `ca-m8.pem`, `allow --ip`, `sao-luu`, `d`. Lượt duyệt: `modules/m8/wp/chuyen-may-99.md` mục "Lượt duyệt liền".
- Việc nhỏ cho commit M8 sau: `docs/evidence/W-0533/README.md:40-41` còn ghi khung giờ 21:15–22:00 của D-lead-036.
