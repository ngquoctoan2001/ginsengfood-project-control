# Tin cho Tài · 16/11/2026 tối · kết quả rà + D-m5-049/050 (ĐÃ GỬI — Toàn báo 16/11 21:55)

Một tin Zalo gộp (thay phần (a) của `2026-11-16-tin-tai-2.md`), kèm **hai tệp**: tệp (b) dưới đây (kết quả rà) và tệp (b) của `2026-11-16-tin-tai-2.md`
(`2026-11-16_lead_m5-dl230-route-admin.md`, DL-230 + hai route admin). Nguồn: [bản rà](2026-11-16-tai-2.md), Sheet ghi 16/11 21:0x (12/12 khớp).

## (a) Tin Zalo

```text
Tài ơi, anh rà xong 12 task M5 em mới cập nhật nha. Đạt 2 cái: nhịp gõ nhãn AI với probe thoát sạch. 10 cái kia vẫn cần sửa, phần lớn vì chưa chạy trên .98 (chờ kênh CSKH với cảnh báo thật) hoặc phần sửa sổ còn nằm ở nhánh chưa gộp. Em mở PR nhánh sửa sổ đó, chạy CI cho đạt rồi gộp liền, gỡ được mấy task một lúc. Task nào chưa chạy .98 thì đừng để Hoàn thành 100% nghen.
Bộ triển khai .98 bản mới sửa gần hết rồi, còn thiếu bước dời dữ liệu đang chạy, em ghi vô runbook rồi mới chạy dời nha.
DL cách tính SMK anh duyệt rồi, thêm hai chỗ anh ghi trong file. Em gỡ hai đường admin cũ trước khi anh Tuấn bật HTTPS, hạn thứ Tư 18/11. Thêm vô điều kiện họp: webhook sai chữ ký đừng ghi DB mỗi lần, đăng nhập quản trị mỗi người một token riêng, hạn ngắn, thu hồi gấp được.
Chi tiết anh để trong hai file, em coi rồi làm luôn nghen.
```

## (b) Tệp kèm — `2026-11-16_lead_m5-ra-soat-toi.md`

```markdown
Gửi Tài · 16/11/2026 · từ Toàn
Việc: kết quả rà lượt 16/11 tối 12 task M5 (em cập nhật dòng Sheet 14:35–16:17) + soát PR #123 bộ triển khai .98.
Vì sao: rà trên main 6ee2bedc (PR #126); Lead duyệt + Ghi chú Lead trên Sheet đã ghi 16/11 21:0x, mỗi task có việc phải làm trong cột Ghi chú Lead.

Đạt (2): M5-142 (PR #126, GATE=ĐẠT đúng đỉnh PR; máy anh Node 24.19 chạy 9 probe đã sửa 36/36 PASS), M5-055 (PR #80 đủ mô tả + migration + GATE=ĐẠT đúng head).
Cần sửa (10), tóm việc — chi tiết trong cột Ghi chú Lead:
- M5-016: khoá công khai + iss/aud + claim vai (anh Tuấn), ký DL-228, chạy 200/403 + CLI 0/3 trên .98. Thống nhất luật iat với M6 (M5 chưa bắt iat; M6 bắt iat, exp−iat ≤ 30 ngày) trong DL-228.
- M5-036: gộp M5-141 (nhánh chưa có PR), ký DL-217 + DL-231, chạy data-deletion-cli với token thật trên .98, rồi mới khai callback lên Meta.
- M5-042: chạy .98 token Page thật (cần M5-104/081B qua cổng always-on-posture.ts:116-117); sửa TEST_STRATEGY:596 và DL-206 từ .60 sang .98.
- M5-043: 3 ca chế độ phạm vi trên .98 (hỏi giá đúng 1 tin; gửi lại/sửa không gửi lần 2; tắt private reply thì BLOCKED), dán log.
- M5-051: sao lưu khoá kho tách khỏi dump (RU-19); ký DL-217 (5) rồi lập lịch purge-vault; gửi thử trên .98. (Mô tả PR #75 coi như xong, vault.env đã có trên .98.)
- M5-053: token System User 60 ngày, chạy tools/ops/page-token.cjs trên .98, ghi ngày/hạn/người làm (không ghi giá trị).
- M5-056: chạy M5_INGEST_PIPELINE=full trên .98; chốt DL-224 ý (2), (5); điền cột nhánh/bằng chứng.
- M5-122: chốt DL-222; gộp nhánh A để main ghi Toàn duyệt chữ 3.4 + bỏ "nhánh chưa gộp" ở text-set-v1.md; sửa ghi chú "CI đạt" (PR #94 GATE=KHÔNG ĐẠT).
- M5-133: gộp nhánh A (bỏ status ci-local ở DL-211, SPRINT_PLAN:136/:209, CLAUDE.md/AGENTS.md:105); thêm job typecheck/lint/vitest web/ vào scripts/ci-local/run.cjs + probe.
- M5-139: làm bước 4 AppShell (AppShell.tsx:54, 156, 164) hoặc xin anh tách task + sửa tiêu đề; sau M5-133 (2) chạy CI_LOCAL có job web/ và dán vào PR #95.
Chờ em sửa, chưa cập nhật dòng nên anh chưa rà (12): M5-002, 007, 017, 060, 074, 101, 103, 104, 112, 114, 121, 135.

PR #123 (bộ triển khai .98): 4/5 lỗi Cao của #118 đã xử lý (GATE, /data/m5-/data/m6, chỗ sao lưu, containerd cho máy cài mới). Còn:
1. Cao: runbook chưa có bước dời dữ liệu đang chạy (runbook:406). Đổi M5_PG_DATA rồi m5.sh deploy sẽ dựng DB rỗng, không quay lui được. Ghi đủ dừng → dump → khôi phục → đếm dòng (B5/B6 trong kế hoạch lệnh) vào runbook trên main trước khi chạy.
2. runbook:406, 441-442 còn ghi 129cf96f + named volume; khảo sát của em ghi 6bbbaab8 + bind /data/m5, /data/m6 → gộp PR #127.
3. containerd trên .98: chưa có lệnh dời trong runbook. Tự quay lui chưa có (runbook:839). Ký DL-227…231.
4. Nhỏ: app.env.template:5, 39 còn .60; RU-07 còn /opt/ginsengfood/m5; dump đặt quyền 700/600; commit 616e237c (sửa theo rà PM) chưa được rà lại.

Việc chung trước họp Go/No-go: mở PR nhánh A có GATE=ĐẠT rồi gộp; M5-104/081B đi trước cụm chạy .98; sửa trạng thái Sheet task còn phần .98/chờ ký (043, 056, 122, 133, 139 đang ghi Hoàn thành); M5-142 việc sau: probe ai-eval, m4-reply-raw-to-guard còn process.exit sau fetch thật.
Xong khi: từng task theo Ghi chú Lead; đổi dòng Sheet sau khi sửa để anh rà lại.
Hạn: hai route admin 18/11; còn lại trước họp Go/No-go (chậm nhất 20/11) · báo lại bằng: PR + dòng Sheet.
```
