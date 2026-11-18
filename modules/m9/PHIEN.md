# Phiên `m9` — M9 Tài chính (MISA) trong business-platform

Tạo 17/11/2026 (D-lead-059). M9 = tài chính: hoa hồng, chi trả, kế toán, lời lỗ, hoá đơn nội bộ, đối soát, **kết nối MISA AMIS Kế toán**.
Tách khỏi luồng `m34` (trước đó M9 nằm trong `m34`, D-lead-052). Lead dùng phiên này để **giám sát, rà soát, quyết, giao việc** — không code M9.

## Người và vai

| Người | Việc | Nhánh / nơi làm |
|---|---|---|
| Chú Dũng (Phù Tường Nguyên Dũng) | viết tài liệu, sửa mã M9 | nhánh `chudung/m9-*` trên `origin` |
| Phúc (Trương Công Phúc) | rà + gộp nhánh chú vào `dev`, sửa test, giữ M9 chạy trên .99 (D-lead-052, D-lead-054) | `PhucApu` → PR vào `dev` |
| Tài (Nguyễn Phát Tài) | làm kết nối MISA theo tài liệu chú | `dev015` (hoặc nhánh Tài báo) → PR vào `dev`; sổ `C:\Projects\M4-PLAN` |
| Toàn (Lead) | rà tài liệu/mã, chốt câu hỏi, giao việc, duyệt | Project Control (phiên này) |

Gọi người bằng tên; tin cho Tài/Phúc giọng miền Tây, anh/em, kỹ thuật để trong tệp `.md` kèm (`chung/MAU.md` §3). Không nhắn chú Dũng trừ khi Toàn bảo
(khi đó con/chú). Luật tiền M9 của chú cần chị Giang (kế toán trưởng) duyệt trước khi bật thật (D-m34-083).

## Repo và nguồn

- Repo: `C:\Projects\ginsengfood-business-platform` (GitHub `PhucApu/ginsengfood-business-platform`). **Phiên này không sửa mã, không commit vào repo**
  (luật rà `CLAUDE.md` §4). Trên máy này mọi ghi vào repo chỉ trên `toandeptrai` (D-m34-004) — phiên m9 không ghi.
- Mã M9: back-end `back-end/src/main/java/com/ginsengfood/project/finance/` (domain, service, api, adapter, port, repository) và `commission/`;
  tài liệu `docs/m9/` (MISA: `docs/m9/misa/`). Migration `back-end/src/main/resources/db/migration/V###__*.sql` (kiểm trùng số với Tài, chú).
- Đọc nhánh chú không checkout: `git -C <repo> show origin/chudung/m9-<...>:<tệp>`, `git diff origin/dev...origin/chudung/m9-<...>`.
  Chạy test khi cần: worktree tách rời `git worktree add --detach C:/Projects/_wt/m9/review-<tên> <SHA>`, xoá sau khi xong.
  Lệnh test như `modules/m34/PHIEN.md` mục Lệnh (back-end `-P ci-unit`; repo yêu cầu hỏi trước khi chạy `mvnw test`).
- Sổ Tài: `C:\Projects\M4-PLAN` — chỉ đọc đoạn (báo cáo đầu ngày mới nhất), không đọc trọn tệp lớn.
- Sheet: tab M9 (chủ Phúc, `tools/sheet-lead/Code.gs`); `node tools/task-tracker/sheet-sync.mjs list --module M9` trong repo. Rà task: chỉ W/X
  bằng `tools/sheet_lead.mjs` (`CLAUDE.md` §6); không `sheet-sync log` lên task người khác.

## Liên module

- M1–M2 và M9 **mỗi bên tự gửi chứng từ sang MISA** (quyết định chủ hệ thống trong tài liệu chú 17/11) → phía M1–M2 là phiên `m12`
  (cầu MISA M12-012 đang hoãn theo D-m12-002). Danh mục, mã đối tượng, tài khoản phải khớp hai bên: báo `m12` qua phiên `lead`.
- M3 → M9 (đơn, thu hộ, hoá đơn nội bộ), M6 → M9 (chi phí quảng cáo, "quảng cáo Có 331"), M8 không liên quan.
- Gọi MISA thật (production, khoá API thật) là **gọi đối tác thật** → chỉ khi Toàn nói rõ (`CLAUDE.md` §4). Không đọc, in, chép khoá MISA.

## Kiểm đầu phiên (`/phien m9`)

1. `git -C C:/Projects/ginsengfood-business-platform fetch --all --prune`; nhánh `origin/chudung/m9-*` mới/đổi; commit mới trên `origin/dev`
   chạm `finance/`, `commission/`, `docs/m9/` từ mốc trong `TRANG_THAI.md`; PR mới của Tài/Phúc liên quan M9.
2. Sổ Tài (báo cáo đầu ngày): việc MISA, câu chờ Lead.
3. Sheet tab M9: việc trễ, bị chặn, chờ review.

## Rà soát (`/ra-soat`)

- Đối tượng: `chudung` (tài liệu + mã nhánh chú, chỉ đọc), `tai-misa` (việc kết nối MISA của Tài), `phuc-m9` (gộp/sửa test M9 của Phúc).
- Theo `.claude/commands/ra-soat.md`: ghim SHA, kết quả chỉ Đạt / Cần sửa, ghi Sheet bằng `tools/sheet_lead.mjs`, soạn tin nháp đúng người, không gửi.
- Danh mục kiểm riêng M9: định khoản (Nợ/Có) đúng tài khoản theo quyết định đã chốt; số tiền không làm tròn sai, tiền tệ; idempotent khi gửi lại
  chứng từ (khoá chống trùng); không gửi MISA khi chưa duyệt hai bước; nhật ký/đối soát mỗi lần gửi; khoá API qua biến môi trường/kho bí mật;
  chế độ thử (sandbox) mặc định, cờ bật thật tắt; migration không trùng số; test cho từng loại chứng từ.
