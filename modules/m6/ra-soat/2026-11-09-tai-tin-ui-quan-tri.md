# Tin gửi Tài · UI quản trị M6 · 09/11/2026 (CHƯA GỬI)

> Chép phần dưới vạch. Gửi kèm hoặc sau tin gộp 05/11 (`2026-11-05-tai-tin-nhan-gop.md`), tin đó vẫn chưa gửi.

---

Tài ơi, M6 hiện chưa có màn hình quản trị nào, người vận hành chỉ gọi được API. Anh muốn có UI trước 15/11, nên đã thêm 14 task mới, M6-141 tới M6-154, đều giao em. Task đã có trên Sheet tab M6 (Chưa bắt đầu). Thẻ chi tiết ở SPRINT_PLAN §4.15 (lane N mới) và DL-091, anh đã đẩy thẳng lên master (`edd296f`). Lần này chỉ là tài liệu kế hoạch, không có code; anh cũng không đụng nhánh nào của em.

Yêu cầu chính là UI và backend làm song song, không bên nào chờ bên nào:
1. Sáng nay em chốt M6-141: hợp đồng API cho UI (`docs/05-reference/admin-ui-api.md`) và mẫu JSON `web/contract/*.json`. Em chốt luôn công nghệ UI bằng DL. Anh đề xuất Next.js trong `web/` như M5 và M7, xuất tĩnh, FastAPI phục vụ ở `/admin`.
2. Xong hợp đồng thì mỗi cặp mở hai phiên cùng lúc: phiên UI dựng màn trên mock đọc từ mẫu JSON, phiên backend dùng đúng mẫu đó trong test. Dashboard, DQ và campaign–SKU đã có API nên chỉ cần phiên UI.
3. Hợp đồng cần đổi thì sửa hợp đồng trước bằng commit riêng, rồi cả hai phiên cập nhật theo.

| Ngày | Task |
|---|---|
| 09/11 | M6-141 hợp đồng (làm trước) |
| 09–11/11 | M6-142/143 khung + đăng nhập · M6-144 dashboard + DQ · M6-145/146 nhập và duyệt chi phí · M6-147/148 đề xuất và duyệt scale |
| 10–11/11 | M6-149 campaign–SKU · M6-152/153 dead-letter + audit (P1, trễ thì cắt trước) |
| 09–12/11 | M6-150/151 cảnh báo recall + tắt quảng cáo tay (đi cùng M6-077) |
| 12–13/11 | M6-154 nối UI với backend thật, E2E 5 luồng chính trên .60 nội bộ, thêm vào smoke và hướng dẫn vận hành |

Mấy điều giữ cho mọi màn:
- Chỉ mở trong mạng nội bộ, không có nút đổi cờ.
- Không hiện PSID, PII hay bí mật.
- Doanh thu và ROAS thiếu nguồn thì hiện null kèm lý do, không hiện 0.
- Nút duyệt ẩn với người tạo, backend vẫn chặn 403.

Ước lượng: khoảng 25 giờ phiên AI, phần của em khoảng 9 giờ. Nếu thấy không kịp thì báo anh sớm, mình cắt M6-153, M6-152 trước. Em không cần hỏi lại từng bước: chốt hợp đồng xong là chạy luôn các cặp. Xong task nào em chuyển Chờ review như thường lệ.
