# WP02F D-m8-020 — diff R3 đã được duyệt

Cập nhật21:48 +07: m8.69A đã duyệt; ghép đúng patch bên dưới thành W-0518 local `005bc43d`. [Kết quả sau ghép và hiệu chỉnh phạm vi PII](2026-11-09-02f-rollback-pre-ket-qua.md). Nội dung tiếp theo giữ mốc trước duyệt; chưa push/deploy.

**ĐẠT kiểm công cụ/FIXTURE/LAB; chưa ghép, chưa commit/push/deploy.** Lead09/11 “tiếp tục nhé”; nguồn `main=140bcb48a27e9dcda947243a965a85b29f41a519`, bản sao archive có gốc `46bc2a341a5d1db35004f6385755c9ba25b8a478`. Không đổi host trong lượt này. Đây là phần D-m8-020; D-m8-021/024 và candidate thật còn riêng.

## Vấn đề và kết quả

Khi quay lui trước bước chuyển receiver, hoặc receiver production đã chết lúc thu đầu ra R3, công cụ hiện tại luôn báo LỖI vì thiếu `media-epoch-post`. Bản sửa thêm lựa chọn tường minh `--rollback-reference pre`; mặc định vẫn dùng post và không tự cho qua chứng cứ thiếu/hỏng.

Nhánh pre buộc media baseline đầy đủ, container .64 trước/sau khớp ID/image/trạng thái theo inventory, bankPin bằng pre, auth/cờ đóng gọi đúng. HTTP phải đúng kiểu int; highWater nguyên không âm và không lùi nếu cùng epoch. Cả ba báo cáo media phải là một JSON object hợp lệ, không khóa trùng/noise/REFUSED. Post có mặt phải NO/secret=false; nếu post200 có epoch thì vẫn cấm epoch hiện tại trùng post. Receipt ghi lựa chọn và giới hạn.

## Diff cụ thể

[Patch R2 đã kiểm](2026-11-09-02f-rollback-pre-bang-chung/rollback-pre-r2.patch), SHA256 **`34529bf63cdcb967bcfe3b661403b667b380cd6729d237837f12a0b98af25525`**. Ba tệp,413 dòng thêm/21 dòng bớt:

| Tệp | Thay đổi |
|---|---|
| [window.py](2026-11-09-02f-rollback-pre-bang-chung/source-r2/deploy/production-window/cutover/window.py) | Thêm tham số/API/CLI, helper strict JSON và chấm theo pre, receipt JSON/Markdown; giữ mặc định post và plan/R6. SHA `a8943d9fbb236bcc897ddc9e2c7529b17b1a240f0270ff05561e4ab455e62b97`. |
| [README.md](2026-11-09-02f-rollback-pre-bang-chung/source-r2/deploy/production-window/cutover/README.md) | Cách chọn pre, điều kiện từ chối, giới hạn chứng cứ. |
| [test_rollback_pre_reference.py](2026-11-09-02f-rollback-pre-bang-chung/source-r2/deploy/production-window/cutover/tests/test_rollback_pre_reference.py) |25 test mới; không sửa test/fixture cũ hoặc engine giám sát. |

## Kiểm trên đúng byte R2

| Kiểm | Kết quả |
|---|---|
| Windows Python3.13.13 full cutover |188 ca:180 đạt,8 bỏ qua POSIX có sẵn,0 hỏng |
| Linux Python3.10.22, uid1000, mạng tắt, source chỉ đọc |**188/188 đạt,0 bỏ qua**,51,531giây |
| Bộ độc lập v3 viết trước sửa, verifier Windows |**39/39 đạt**,0 bỏ qua |
| Cùng bộ độc lập v3 trên Linux |**39/39 đạt**,0 bỏ qua,5,611giây; đây là chạy lại cùng39ca, không cộng thành78 |
| Verifier R2 và thử đột biến |**ĐẠT;9/9 lỗi gài bị bắt** bằng assertion,0 lỗi thực thi/skip. [Review độc lập](2026-11-09-02f-rollback-pre-bang-chung/verifier-r2/review.md). |
| PII trên Linux LF |PASS3/3 tệp thay đổi; không nhận là quét toàn bộ repo/lịch sử |
| Tính áp dụng patch |`git diff --check` PASS; `git apply --check --3way` sạch trên main140, không sửa checkout |

Image kiểm: `python@sha256:6ff506466f8b1e981719b468cc0023b8ef000b983cdec0eafe119d01f379e31d`. Test cũ `IndependentPlanBoundary` dùng candidate lịch sử66d9045d ởG: qua mount chỉ đọc; hash bundle trước/sau `e4f23a53713dfa87a1018cb0a0504d3ac2501daff7a9449ec300934dc33a924f` không đổi. Không gọi đó là nghiệm thu candidate140.

Lịch sử giữ nguyên: R1 được verifier yêu cầu sửa vì float200.0/401.0 lọt ở current/baseline; parent chốt thêm kiểm NO/secret cho post200. Bộ độc lập đã tái hiện6ca đỏ trước coderR2. Lượt Linux đầu lỗi mount fixture (harness gắn quá nông; full suite thiếu mount candidate lịch sử); sửa cấu hình chạy, không sửa/bỏ test. R2 full suite cuối đạt đủ. Raw logs và hai vòng review còn trong bộ chứng cứ.

## Giới hạn và phần tiếp

- Chỉ xác minh hành vi công cụ với fixture: bankPin không chứng minh nội dung bank/ACK ledger; kiểm container theo tên trong grader hiện có, không xác nhận mọi tiến trình đổi tên. Mode pre thiếu post không chứng minh so epoch với receiver production.
- D021 chưa thể làm bằng đổi executable: adapter cũ bắt systemd/project cũ, không phù hợp topology m8; staging HOME cũng không qua yêu cầu root-owned của wrapper. [Phụ thuộc và thứ tự](2026-11-09-02f-phu-thuoc-khuon-m8.md).
- Giữ `REAL_CUSTOMER_CALL_ALLOWED=NO`, `production_accepted=false`, `deployable=false`, readiness47%. Không SSH/thay .61/.64, không push/deploy. Main giữ WIP tracker/mock m34. Chưa cấp W-ID/sửa NEXT_WORK_ID; kiểm và cấp số còn trống khi ghép sau duyệt.

M8.69 đề nghị duyệt ghép **đúng patch SHA trên** vào main và commit local kèm hồ sơ/W-ID theo luật repo; chưa push/deploy. Phiếu [WP02F](../wp/M8-WP02F.md), brief mục6 quy định: **“R3: thêm tester độc lập và Lead duyệt diff trước ghép.”** Đây là bước duyệt cuối sau khi đã sửa và kiểm xong.

[Manifest85 tệp](2026-11-09-02f-rollback-pre-bang-chung/sha256.json), SHA `5cc485a546a1c86c730875c75cd57875501478769b035bd2304b3b15d707e082`; [receipt kiểm phiên chính](2026-11-09-02f-rollback-pre-bang-chung/parent-checks-r2.json).
