# W-0574 — Ghim lại gói tổng đài .64 sau W-0572 (CDR): `components.lock.json`, `window.py`, test cửa sổ cắt

Trạng thái: ĐANG LÀM (26/11) · Mức: Thường (chỉ ghim/hằng số đối chiếu; không đổi hành vi) · Mốc: trước cửa sổ bảo trì .64
Ước lượng: 2 giờ · Khoá tệp: agent tự khai `m8/W-0574`

## Brief
1. Quy tắc chung [giong-doc-quy-tac-agent.md](giong-doc-quy-tac-agent.md) (build .NET không cần; không `--artifacts-path`). Bối cảnh: W-0572 (`b5c1824a`) đổi `deploy/telephony-vm/vm_deploy.py`, `config/cdr.conf`, `config/modules.conf`, thêm `config/cdr_custom.conf`, `cdr_tong_hop.py`, `cdr_giu.py`; bằng chứng `docs/evidence/W-0572/README.md` (mục "cần phiên chính nối").
2. Cần làm, mỗi mục chạy test liên quan đỏ-trước/xanh-sau:
   - `deploy/release-candidate/components.lock.json` (~dòng 232-295): cập nhật `bytes` + `git_blob_sha256` của `deploy/telephony-vm/vm_deploy.py`, `config/cdr.conf`, `config/modules.conf` (tính từ BLOB trong git: `git show HEAD:<đường dẫn> | sha256sum`, đếm byte theo blob LF, KHÔNG theo bản làm việc CRLF), thêm mục cho `config/cdr_custom.conf` (và `cdr_tong_hop.py`, `cdr_giu.py` nếu lock liệt kê các tệp công cụ cùng thư mục — kiểm các mục lân cận); nếu có công cụ sinh lock (tìm trong `deploy/release-candidate/` hoặc `deploy/ci/`), dùng nó thay vì sửa tay; đối chiếu `deploy/release-candidate/tests`.
   - `deploy/production-window/cutover/window.py:77` `VM_CONFIG_NAMES` thêm `cdr_custom.conf` (và mọi chỗ đối chiếu `SOURCE_PINS` ở `:801-805` + `deploy/production-window/cutover/tests/test_wp02d_independent.py`, các fixture sinh bộ ba dịch vụ vì `compose()` của `vm_deploy.py` nay thêm volume `cdr`). Chạy toàn bộ test dưới `deploy/production-window` và `deploy/release-candidate` (đặt `PYTHONUTF8=1`, TMP/TEMP sang đường dài như `C:\Temp\m8tmp` vì tên 8.3 làm vài test hỏng), so với trước khi sửa (chạy một lượt NGAY ĐẦU để biết ca đỏ có sẵn, rồi chỉ sửa ca do W-0572).
   - Không sửa `vm_deploy.py`/`config/*`/công cụ CDR (nếu thấy lỗi ở đó: báo, đừng sửa). Không nới assertion, không skip.
3. Phạm vi ghi: `deploy/release-candidate/components.lock.json`, `deploy/production-window/**` (chỉ hằng số/ghim/fixture/test nói trên), `docs/evidence/W-0574/README.md` (≤ 60 dòng: ghim cũ → mới, số ca, ca đỏ có sẵn không do gói). Cấm: `src/**`, `deploy/m8/**`, `deploy/telephony-vm/**`, hợp đồng, `docs/release/*`, `docs/traceability-tests.md`.
4. Báo cáo cuối ≤ 30 dòng.

## Diễn biến
- 26/11 phiên chính: tạo phiếu, giao coder.
