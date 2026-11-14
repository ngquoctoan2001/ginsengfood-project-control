---
description: Ghi một quyết định của Lead và sửa ngay luật/kế hoạch đang hiệu lực bị ảnh hưởng (không chồng ngoại lệ)
argument-hint: <nội dung quyết định>
---

Quyết định: $ARGUMENTS

1. Thêm một dòng vào `modules/<mã>/QUYET_DINH.md`, `<mã>` = luồng mà quyết định thuộc về:
   `D-<mã>-NNN · <dd/mm hh:mm từ date> · "<lời Lead, ngắn>" · hệ quả · đã sửa ở <tệp>` (NNN = số lớn nhất trong tệp + 1).
   - Quyết định toàn hệ thống (nhiều luồng) → `modules/lead/QUYET_DINH.md`, chỉ phiên `lead` ghi; phiên khác thì nhắc Lead.
   - Phiên `lead` quyết việc của luồng khác (ví dụ trả lời `m5.1`) → chỉ **thêm dòng** vào `QUYET_DINH.md` của luồng đó,
     không sửa `TRANG_THAI.md`/`SAN_SANG.md`/`PHIEN.md` của luồng (phiên luồng tự áp ở lần `/phien` hoặc `/cuoi-phien` sau).
2. Sửa thẳng câu luật/kế hoạch đang hiệu lực (trong phạm vi phiên này được ghi) cho khớp. Thay quyết định cũ → sửa câu cũ và ghi
   "thay D-…" trong dòng mới. Không để luật dạng "A, trừ khi B, nhưng từ ngày X thì C".
3. Sửa `CLAUDE.md`, `chung/`, `.claude/` (chỉ phiên `lead`) → nhắc Lead: các phiên đang mở cần `/phien <mã>` lại để nạp luật mới.
4. Repo đích có sổ quyết định riêng (`docs/00-overview/DECISION_LOG.md` ở module5, `m6/docs/00-overview/DECISION_LOG.md` cho M6, golden-hour-video): soạn sẵn dòng
   theo khuôn của sổ đó, hỏi Lead có ghi vào repo không (repo có luật riêng về ai được ghi).
5. Trả lời 2–3 dòng: đã ghi gì, sửa ở đâu, việc nào đổi theo.
