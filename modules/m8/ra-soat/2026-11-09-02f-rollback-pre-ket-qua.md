# WP02F/D020 — ghép và commit local W-0518

Mốc 09/11/2026 21:48 +07. Lead duyệt m8.69 **A — Ghép và commit local** (D-m8-067). Đã ghép đúng patch R3 và commit trên `main`: **`005bc43dcc12c17c49f3a630ce1e889e621c1629`**, cha `140bcb48a27e9dcda947243a965a85b29f41a519`. Chưa push/deploy, không SSH hoặc đổi host.

`--rollback-reference pre` là lựa chọn tường minh cho trường hợp không có epoch production. Mặc định post không đổi, không tự fallback. Ba tệp nguồn/test đúng byte R2 đã duyệt, patch SHA256 `34529bf63cdcb967bcfe3b661403b667b380cd6729d237837f12a0b98af25525`.

| Kiểm sau ghép | Kết quả |
|---|---|
| Linux Python 3.10.22, uid1000, mạng tắt, nguồn chỉ đọc | 188/188, không skip, 49,261 giây |
| Windows Python 3.13.13 | 180 đạt + 8 skip POSIX cũ = 188 ca, không lỗi, 52,470 giây |
| Bộ độc lập v3 trên Linux | 39/39, không skip, 5,352 giây |
| Đột biến của verifier R2 | 9/9 bị bắt trước ghép; không chạy lại vì nguồn sau ghép trùng hash R2 |
| Document links / generated gate status | PASS; active_missing=0; 506 work item, 11 gate ngoài, không nhận thêm nấc |
| GitNexus detect-changes trước commit | LOW, 23 symbol, 0 affected process; 22 tệp văn bản, commit có thêm 1 ZIP |
| PII bộ bằng chứng đưa vào commit | PASS: 13 tệp văn bản, 1 ZIP bỏ qua; scanner/pattern lấy từ blob LF của 140 |
| PII mở rộng toàn bộ gói giải nén + nguồn | FAIL 3 dòng do từ chỉ đường dẫn tệp trong cùng đoạn README cũ; đối chiếu thủ công là mô tả kỹ thuật, không địa chỉ cá nhân. Giữ log đỏ, không thêm ngoại lệ hoặc sửa patch |
| Commit / WIP | 23 đường dẫn đúng allowlist; 3 hash nguồn, 15 hash bằng chứng và 86 mục ZIP đúng; index thật không còn staged change |

Kết quả PII3tệp PASS trong hồ sơ trước ghép được giữ như lịch sử; không dùng kết quả đó để kết luận nguồn sạch PII. Lượt sau ghép dùng script và pattern LF lấy trực tiếp từ Git, ghi rõ ba false positive ở README hiện tại dòng213 và hai bản lưu R1/R2 dòng211/213. Chỉ kết quả quét phạm vi tương ứng trong bảng được xác nhận.

Hai tệp WIP `deploy/operations/m34_mock_agent.py`, `deploy/operations/test_m34_mock_agent.py` giữ nguyên SHA256. Toàn bộ tracker WIP trước lượt này còn nguyên byte; chỉ dòng mới của m8.69 được commit bằng index riêng. Tracker M8-002 đã đồng bộ một lần, vẫn IN_PROGRESS vì 02F còn candidate/production.

Bằng chứng đã commit: [README W-0518](C:/Projects/ginsengfood-ivr/docs/evidence/W-0518/README.md), [manifest](C:/Projects/ginsengfood-ivr/docs/evidence/W-0518/MANIFEST.sha256), [receipt kiểm](C:/Projects/ginsengfood-ivr/docs/evidence/W-0518/merge-validation.json). [Receipt sau commit](C:/Projects/_wt/m8/m8-02f-pre-evidence-20261109/local-commit-receipt.json). Bộ gốc [85 tệp đã duyệt](2026-11-09-02f-rollback-pre-bang-chung/sha256.json) không đổi; ZIP đưa vào commit SHA256 `05572fd3f1276360d0245c2ba23feb21553eb7525a87acb3ed18608e0960b8c2`.

Automatic approval review chặn xóa bản sao bằng chứng cục bộ, chỉ trả `blocked by policy`. Bản sao được giữ tại `docs/evidence/W-0518/reviewed/`, ignore khỏi commit; không thử xóa lại. ZIP giữ nguyên byte và các tài liệu nguồn bên trong không bị đổi liên kết.

Chỉ chốt D020 ở mức công cụ/FIXTURE/LAB. Chưa chạy hosted CI cho `005bc43d`; kết quả deploy .61 trước đó thuộc nguồn140. Không nghiệm thu dữ liệu bank/ACK ledger hoặc cửa sổ candidate. Readiness47%, REAL_CUSTOMER_CALL_ALLOWED=NO, production_accepted=false, deployable=false. D024 contract/adapter m8 → D021 authority/staging F5/R5 → candidate07B-L/cửa sổ02F còn tiếp. Quét trước push và gitleaks lịch sử theo PHIEN.md chỉ thực hiện khi chuẩn bị lượt push riêng.
