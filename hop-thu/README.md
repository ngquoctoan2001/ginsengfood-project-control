# Hộp thư

Chỗ thả việc mới khi chưa muốn mở phiên: lời Chú dặn, tin nhắn của Phúc/Tài/anh Tuấn, ý tưởng chợt nghĩ ra.

- Một việc một tệp: `<mã luồng>-<yyyy-mm-dd>-<chu-de>.md` (ví dụ `m5-2026-11-01-quyen-meta.md`). Chưa biết luồng nào thì dùng `lead-`.
- Nội dung viết tự do, dán nguyên tin nhắn cũng được.
- `/phien <mã>` đọc tệp có tiền tố của luồng và đưa vào bảng đầu phiên; xử lý xong thì phiên đó chuyển tệp sang `hop-thu/xong/`.
- `/phien lead` đọc tệp `lead-`, phân về luồng phù hợp (đổi tiền tố).
