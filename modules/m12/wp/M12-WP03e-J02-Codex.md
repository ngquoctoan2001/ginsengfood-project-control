# M12-WP03e-J02 — UAT xem trước truy xuất công khai (Codex)

Trạng thái: CHẶN · Rủi ro: R2 · Mode: TEST_ONLY · Sheet: M12-009 (toàn task vẫn Đang làm).

- Lead đã chọn ngày 02/11/2026: “Chạy tiếp nhóm UAT không trùng Claude”.
- Phạm vi: J02-F01-T01/T02/T03 và J02-F02-T01, kiểm chéo cùng QR trên trang public trace. Không nhận E01/E05/E08 của Claude.
- Nguồn: catalog hiện hành và `docs/evidence/27-10-14-30-uat-chay-nhanh/packets/J02.txt`; quy tắc ghi kết quả tại kế hoạch UAT §6.
- Candidate: `ac6ce4c7f4302341cba78b2f4940d6e3b6ce5874` thuộc lịch sử main; detached checkout `C:\Projects\_wt\m12\uat-codex-0211` chỉ để build/test.
- Lab riêng dự kiến: API `127.0.0.2:5203`, admin `127.0.0.2:3203`, public trace `127.0.0.2:3303`, DB `ginsengfood_uat_codex0211_lab`.
- Chỉ dùng dữ liệu giả của lab; không sử dụng hoặc reset DB/lab Claude, không đụng cổng Lead 5100/3000.
- Bằng chứng mỗi ca: actor, candidate, URL, QR/fixture, quan sát UI, kiểm chéo public, ảnh; T03 kiểm màn 768px và sáng/tối.
- T02 chỉ Đạt khi xác minh fixture thực sự có dữ liệu nội bộ cần bảo vệ. Không thấy dữ liệu trong fixture không đủ chứng minh chống lộ.
- Kết quả: Đạt / Không đạt / Bị chặn theo từng ý expected; không đổi expected để làm ca đạt. J03 chỉ kiểm chéo, không tính thêm ca mới đóng.
- Phạm vi ghi: thư mục `.artifacts/uat-codex-0211/`, thư mục bằng chứng riêng J02, phiếu này; nối sổ UAT và tracker một lần cuối sau kiểm độc lập.
- Không sửa code sản phẩm hoặc các sổ điều phối Claude đang dùng. Lỗi phát hiện ghi rõ mức, bằng chứng và vùng cần xử lý.
- Cuối lượt dừng đúng PID/ledger do Codex tạo, kiểm cổng riêng, dọn detached checkout sau khi lưu bằng chứng ra ngoài.

## Kết quả hiện tại — 03/11/2026

- Đã đăng nhập đúng `yen.tth` qua UI và chạy hai ca. Verifier độc lập xác nhận **J02-F01-T01 Đạt, J02-F02-T01 Đạt**; đã nối sổ, đọc lại: **2 Đạt / 2 Bị chặn**. Giữ nguyên lượt và bằng chứng 02/11.
- Preview, public cùng QR và dòng mẻ nội bộ khớp sản phẩm, QR đã phát hành, lô P06, xuất xưởng, nguồn DEV. `Xóa` làm trống ô/bản xem trước; nhập lại cùng QR khôi phục dữ liệu gốc.
- Public ẩn media theo quyết định 27/10 vì không khai allowlist; không tự thêm điều kiện ảnh tải được của J03-F03 vào T01. Khả năng tải tệp fixture .test chưa xác minh, không nghiệm thu media/J03.
- T02 còn thiếu fixture nội bộ; T03 chưa có phiên `admin`, chưa chạy lại 768px/sáng–tối. Đã yêu cầu đăng nhập trực tiếp, không thay bằng phiên yen.tth hoặc login API.
- Tiếp tục cùng exact SHA `ac6ce4c7f`; checkout build/test riêng `C:/Projects/_wt/m12/uat-codex-0311`; dùng lại DB Codex0211, chỉ SELECT kiểm 152 migration và fixture, không reset/migrate/seed. API build 0 lỗi/cảnh báo; các endpoint lab trả 200.
- Báo cáo: `C:/Projects/ginsengfood-ops-core/docs/evidence/27-10-14-30-uat-chay-nhanh/j02-codex-03-11/03-11-01-49-j02-codex-review.md`. Toàn M12-009 vẫn Đang làm; chưa tính lại tổng 958.
- Cuối lượt: đã dừng 8 PID Codex, ba cổng lab đóng, bốn tab IAB đã đóng. Giữ checkout/bản build 0311 và DB riêng để tiếp tục ca admin chưa xong; không đụng thư mục dư 0211 hoặc WIP mới của Claude. Tracker đã ghi đúng hai ca Đạt, phần còn lại Bị chặn.

## Lịch sử kết quả — 02/11/2026

- 4 ca J02 đã ghi **Bị chặn**, execution `NOT_RUN_ADMIN_AUTH_REQUIRED`; **0 ca Đạt**. Chưa có phiên UI yen.tth/admin. Verifier độc lập xác nhận hồ sơ ghi trung thực, không phải nghiệm thu UAT đạt.
- T02 còn thiếu fixture NCC liên kết, QC lỗi, hao hụt dương, snapshot giá vốn và dữ liệu kế toán/MISA. Không gọi thiếu fixture là lỗi sản phẩm.
- Đã chạy public UI bổ sung: QR hợp lệ, ô trống, mã không tồn tại, QR chưa công khai và URL QR. Chưa kiểm chéo J02/mẻ nội bộ trên UI nên không chấm PASS J03; chưa xác minh lịch sử J03 trong baseline cũ.
- API build 0 cảnh báo/lỗi; DB riêng đã migrate 152; health và hai web trả 200. Không sửa source sản phẩm, không commit/push/deploy.
- Đã tạo đủ bốn `case-evidence/<ID>.json`, nối bốn dòng vào `results-2710.jsonl` bằng ghi độc quyền; giữ toàn bộ lịch sử. Tracker đã đồng bộ M12-009 Đang làm và nối X.
- Đã dừng đúng 8 PID thuộc API/web Codex; cổng 5203/3203/3303 không còn nghe. Đã gỡ đăng ký worktree; còn thư mục apps/node_modules do lệnh xóa phần dư bị bộ duyệt tự động chặn (`blocked by policy`), không thử cách khác. Giữ DB fixture riêng để tiếp tục.
- Hai tab lab không đóng được do mất phiên điều khiển trình duyệt; lab đã tắt. Viewport đã reset sau lỗi chụp 768px, không xác nhận ca màn hẹp.
- Bằng chứng: `C:\Projects\ginsengfood-ops-core\docs\evidence\27-10-14-30-uat-chay-nhanh\j02-codex-02-11\02-11-19-55-j02-codex-review.md`; cleanup: `.artifacts/uat-codex-0211/cleanup.json`.
