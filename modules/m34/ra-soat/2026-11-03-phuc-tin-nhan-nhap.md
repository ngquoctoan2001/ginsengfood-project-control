# Tin nháp gửi Phúc — rà M3-040, M3-043 (03/11/2026) · CHƯA GỬI

Người nhận: Trương Công Phúc. Lead xem, sửa rồi tự gửi. Báo cáo: `modules/m34/ra-soat/2026-11-03-phuc.md`.

---

Phúc ơi, anh rà xong M3-040 và M3-043 trên `dev` `f5159ac03`. Cả hai **Cần sửa**, phần lõi chạy đúng.

**Đã ổn:** anh chạy lại test của em trên Postgres thật, 040 là 43/43, 043 là 117/117. Anh thử 4 đột biến, đều bị test bắt. Khoá sau 5 lần sai,
báo lỗi trung tính, trang khách không đếm, `noRollbackFor`, chặn tự mở khoá, khoá thì thu hồi phiên: đều đạt.

**Cần sửa:**
1. M3-043: admin mở khoá chỉ xoá `locked_until`, bộ đếm vẫn giữ (`AdminIamUserServiceImpl.java:277-282`, `LoginLockoutService.java:122-129`)
   → mở xong gõ sai 1 lần là khoá lại, gửi mail mới. Em sửa cho mở khoá đặt lại bộ đếm, thêm test Postgres "mở khoá rồi sai 1 lần không bị khoá".
2. M3-043: mail báo khoá đang gửi đồng bộ trong `afterCommit` → lần sai thứ 5 chậm theo SMTP. Em chuyển sang bất đồng bộ.
   Nếu bộ phát sự kiện lỗi thì lần sai thứ 5 đang trả 500: em bắt lỗi phát, vẫn khoá và trả câu trung tính.
3. M3-040: thêm test Postgres cho `assignUserRoles` (rollback thì không còn ROLE_*/audit; gán lại đúng tập cũ thì không phát)
   và ít nhất một ca đi qua bộ tạo gói sự kiện thật với registry seed thật (test hiện giả lập `EventPackageFactoryPort`).
4. Cả hai là R3: cần một tester độc lập viết test trước và một verifier chạy đột biến (không phải phiên viết mã), ghi bằng chứng
   vào execution note. Sửa luôn dòng "chưa push/chưa commit" trong execution note và sổ tuần cho đúng.
5. Chạy lại `gitnexus analyze` rồi `detect_changes` như em đã ghi.

**Về gộp `dev` — cần làm trước:** hai commit R3 này đã lên `dev` lúc 09:29 bằng đẩy thẳng `PhucApu`, không PR nên CI chưa chạy, trong khi
Sheet "Lead duyệt" còn Chưa duyệt. Theo thoả thuận (D-m34-010 mục 9), task R3 chỉ vào `dev` khi Lead duyệt = Đạt. Anh quyết **gỡ hai commit
này khỏi `dev`** (D-m34-017): em tạo commit revert trên `PhucApu`, không sửa lịch sử, rồi **gộp `dev` qua PR**:
- `git revert --no-commit 7c5f5db6a e261827c1` (043 trước, 040 sau). Anh đã thử trên `dev` `f5159ac03`: không xung đột, biên dịch
  main + test đạt, không còn chỗ nào gọi `IdentityEventPublisher`/`LoginLockoutService`.
- Giữ lại sổ tuần và 2 execution note (revert sẽ xoá chúng): `git restore --source=HEAD --staged --worktree docs/weekly-tracking/truong-cong-phuc.md`
  và hai tệp `m3-040-…`, `m3-043-…-execution-note.md`; sửa dòng trạng thái thành "đã gỡ khỏi dev 03/11, chờ sửa + Lead duyệt".
- Commit, push `PhucApu`, mở PR `PhucApu` → `dev`, báo anh số PR.
Sửa xong mục "Cần sửa" ở trên và anh duyệt = Đạt thì em đưa lại bằng revert của commit revert + phần sửa, cũng qua PR.
Từ nay mọi lần gộp `dev` đi qua PR.

**Sheet:** em báo "xong 39–59" nhưng git mới có commit cho 039 (tài liệu), 040, 043; Sheet đang ghi 039 Đang làm, 040/043 Chờ review,
044 Bị chặn, 17 thẻ chưa bắt đầu. Em cập nhật Sheet đúng thực tế giúp anh, việc nào xong thì có SHA đã push.

Các ý em nhờ xác nhận trong execution note §4, anh đã ghi ý kiến từng điểm ở báo cáo; hai điểm cần làm là bộ đếm khi mở khoá và
bắt lỗi phát sự kiện ở lần sai thứ 5. Ghi chú chi tiết anh để ở cột "Ghi chú Lead" của hai thẻ.
