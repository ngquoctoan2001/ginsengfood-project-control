# Tin nháp gửi Phúc — gộp rà sáng (M3-040/043) + rà 13:40 (10 task M3) + D-m34-019 · 03/11/2026 · CHƯA GỬI

Người nhận: Trương Công Phúc. Lead xem, sửa rồi tự gửi. Thay cho cả `2026-11-03-phuc-tin-nhan-nhap.md` (tin sáng chưa gửi).
Báo cáo: `modules/m34/ra-soat/2026-11-03-phuc.md`, `modules/m34/ra-soat/2026-11-03-phuc-m3.md`.

---

Phúc ơi, anh rà xong 10 task M3 của em đang Hoàn thành/Chờ review, trên `dev` `527204310`: 5 Đạt, 4 Cần sửa, 1 chưa đủ bằng chứng.
Chi tiết từng thẻ anh ghi ở cột "Ghi chú Lead" trên Sheet.

**1. Quy tắc mới, áp từ hôm nay:** mọi lần đưa mã hay tài liệu vào `dev` đều qua PR: em `PhucApu → dev`, Tài `dev015 → dev`,
anh `toandeptrai → dev`, kể cả sổ tracker. Không đẩy thẳng `dev` nữa. Task R3 chỉ gộp khi anh duyệt = Đạt. Từ PR #145 (30/10) tới nay
`dev` chỉ nhận đẩy thẳng (riêng hôm nay 45 commit lúc 09:29 và 12:4x), nên CI chưa chạy lần nào trên các thay đổi đó.

**2. Gỡ M3-040, M3-043 khỏi `dev` (làm trước):** hai commit R3 này lên `dev` khi anh chưa duyệt. Em tạo commit revert trên `PhucApu`,
không sửa lịch sử, rồi mở PR:
- `git revert --no-commit 7c5f5db6a e261827c1` (043 trước, 040 sau). Anh đã thử: không xung đột, biên dịch main + test đạt.
- Giữ lại sổ tuần và 2 execution note (revert sẽ xoá):
  `git restore --source=HEAD --staged --worktree docs/weekly-tracking/truong-cong-phuc.md` và hai tệp `m3-040-…`, `m3-043-…-execution-note.md`;
  sửa dòng trạng thái thành "đã gỡ khỏi dev 03/11, chờ sửa + Lead duyệt".
- Commit, push `PhucApu`, mở PR `PhucApu` → `dev`, báo anh số PR. Sửa xong và anh duyệt Đạt thì đưa lại bằng revert của commit revert + phần sửa, cũng qua PR.

**3. Cần sửa:**
- **M3-043:** admin mở khoá chỉ xoá `locked_until`, bộ đếm vẫn giữ (`AdminIamUserServiceImpl.java:277-282`, `LoginLockoutService.java:122-129`)
  → mở xong gõ sai 1 lần là khoá lại. Đặt lại bộ đếm khi mở khoá + test Postgres "mở khoá rồi sai 1 lần không bị khoá". Mail báo khoá chuyển
  sang bất đồng bộ (đang gửi đồng bộ trong `afterCommit`). Nếu bộ phát sự kiện lỗi thì lần sai thứ 5 đang trả 500: bắt lỗi, vẫn khoá, trả câu trung tính.
- **M3-040:** thêm test Postgres cho `assignUserRoles` (rollback thì không còn ROLE_*/audit; gán lại đúng tập cũ thì không phát) và ít nhất
  một ca đi qua bộ tạo gói sự kiện thật với registry seed thật (test hiện giả lập `EventPackageFactoryPort`).
- **Cả 040/043 (R3):** cần một tester độc lập viết test trước và một verifier chạy đột biến (không phải phiên viết mã), ghi bằng chứng vào
  execution note; sửa dòng "chưa push/chưa commit"; chạy lại `gitnexus analyze` rồi `detect_changes`.
- **M3-022 (bảng hạng, V259):** V259 tự áp ở mọi CSDL mà bản MEMBERSHIP đang mở còn là baseline V61, kể cả CSDL có khách thật, hiệu lực lùi về
  30/10 — trái câu chú thích "môi trường thật không nhận". Thêm bước kiểm P-1 vào runbook O01, chạy trước mọi deploy lên CSDL có khách; sửa câu chú
  thích ở tài liệu/ODR (V259 đã vào `dev` nên không sửa tệp, cần thì V265+); khoá V259 trong `MigrationVersionLockContractTest`. RE6 chờ anh quyết; SF-05 mở task riêng.
- **M3-061 (đẩy `dev`):** merge `024e924e1` sạch, không mất mã của Tài hay anh; phần cần sửa là đẩy thẳng ở mục 1. Cập nhật ô Commit M3-025
  (đã 18 commit trên `dev`) và M3-026.

**4. Chưa đủ bằng chứng — M3-013 (Flyway V251):** nguyên nhân em nêu đúng, đổi 1 dòng lịch sử 251→258 hợp lý cho docker máy em. Anh cần:
câu SQL đã chạy, truy vấn kiểm trước/sau, tên CSDL/máy, đường dẫn + hash bản sao lưu, log khởi động, và một runbook có người soát cho CSDL khác
đã chạy V251 cũ. Lưu ý: V248 đang nằm dưới V251–V257 nên máy LAN (tắt out-of-order) sẽ không khởi động được. Đừng tự sửa CSDL dùng chung,
gửi anh cách xử lý để anh duyệt.

**5. Đạt:** M3-007 (CLAUDE.md), M3-008 (UI lô 1), M3-012 (UI lô 1B), M3-024 (dọn menu admin bước 1), M3-060 (gộp `dev` → `PhucApu`).
Mã lô 1/1B còn nguyên sau M3-025, test bắt được đột biến; lô 1/1B còn chờ UAT (45 + 46 dòng). Việc nhỏ đi kèm:
- M3-024: sửa tài liệu `/admin/products/imports` (nay 404) ở `phase-02-catalog-sku-contract-matrix.md:160,329` và `catalog-sku-phase-02-diff.md:155`;
  menu còn 60 mục chứ không phải 68; chạy e2e mock trước nghiệm thu.

**6. Sheet:** ô Commit của 007, 008, 012, 013, 022, 060 đang ghi "chưa commit"/HEAD cũ dù mã đã vào `dev`; em sửa đúng SHA (M3-007 ghi
"không có thay đổi git"). Em báo "xong 39–59" nhưng git mới có commit cho 039 (tài liệu), 040, 043; cập nhật Sheet đúng thực tế, việc nào xong
thì có SHA đã push. Bằng chứng Real E2E/ảnh đối chiếu lưu vào repo hoặc thư mục bằng chứng có tên, không để ở thư mục tạm; merge commit ghi mã task.
