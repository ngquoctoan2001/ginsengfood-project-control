# M7 `/ke-hoach` thấy 3 việc thuộc phiên `lead`

Từ: phiên `m7` · 02/11/2026 · chỉ đọc, M7 không sửa repo khác.

1. **`ginsengfood-contracts` checkout local đang dở merge:** `README.md` trạng thái `UU` (xung đột chưa giải), local `08585c1`
   trước origin 1 / sau 81 commit (`origin/main` = `a7832a4`). Ai đang merge dở thì xử lý; đọc hợp đồng nên đọc `origin/main`.
2. **Deploy contract chưa có chỗ cho M7 mới** (cần trước task triển khai .61 M7-T103, sau 15/11): SAD §13 của M7 có nhiều container
   (edge, web, api, worker, migrate, db, objstore), health `/health/live`, `/health/ready`, worker nặng chạy ở máy để bàn ngoài .61,
   proxy riêng cổng 6700; `MODULE_DEPLOY_CONTRACT.md` đòi một container, `GET /health`, nginx chung; `deploy\module7` còn Dockerfile Python cũ.
   Đề xuất: phiên `lead` quyết cách ghép khi M7 có Dockerfile (M7-T015).
3. **Điểm nối GĐ3 chưa có phía láng giềng** (không gấp, lịch M7 GĐ3 là 01–02/2027): snapshot + số bán M3 (DL-056, DL-046; Phúc),
   chỉ số + kênh nhận M6 (DL-046, DL-O17; Tài — M6 SRS:171 đang chờ quyết định `DL-O21` bên M6), Kho Media X1/X2/X6 (DL-061),
   danh mục claim M1 (DL-064) (Lead, `m12`). Bổ sung cho `hop-thu/lead-2026-11-02-m7-viec-ben-khac.md`.
