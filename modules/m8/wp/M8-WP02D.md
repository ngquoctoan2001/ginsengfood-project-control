# M8-WP02D — Điều phối ba dịch vụ tổng đài và khép nợ sóng 1

Trạng thái: ĐẠT phần công cụ/lab; đã ghép local, full gate cuối sóng 51/51 đạt · Rủi ro: R3 · Chế độ: A · Mốc: 03/11 lab; dự phòng đến 04/11
Hạng mục nâng: Cài bản thật 50 → 50 (đủ công cụ cho bước chạy thử 75) · Sheet: M8-002 · Làn: L2
Ước lượng: 12 giờ công AI (6 coder + 3 tester độc lập + 3 verifier); dự toán, chưa phải cam kết thời gian chờ ngoài.
Chỗ làm: `C:\Projects\_wt\m8\m8-wp02d` · Base sóng 1: `c9f0cd188f4966d07aafb3155039656b1b451034`.
Chỗ kiểm: bản sao/checkout cố định của đúng bộ byte; không build trên checkout đang có coder sửa. Trước /song kiểm lại HEAD và phạm vi.

## Brief

1. Repo: `C:\Projects\ginsengfood-ivr`, chỉ `main`; phiên chính chuẩn bị bản sao git archive, không worktree/nhánh mới.
2. Mục tiêu: Điều phối ba dịch vụ tổng đài và khép nợ sóng 1. Tiêu chí đạt:
   - 1. Quản đúng ba dịch vụ Asterisk/receiver/proxy: apply → verify → rollback đúng project/image/volume; không nhận ngầm tài nguyên cũ, chạy lại không restart thừa.
   - 2. Lỗi ở từng pha, drift, lock và có 1 active call phải chặn hoặc quay lui đúng trạng thái; không báo thành công khi còn lỗi.
   - 3. Ràng đăng nhập DB postgres đúng bước check; thêm ca symlink vào thư mục con Git, ca active-call của cutover; giữ mọi kiểm âm sẵn có.
   - 4. Bộ R3 độc lập tái hiện lỗi trước, kiểm fail-closed và bắt đột biến; cập nhật hash dẫn công cụ bằng nội dung thực, không sửa candidate niêm phong.
3. Phạm vi ghi: deploy/telephony-vm/vm_deploy.py và tests/; deploy/production-window/{db,secrets,cutover}/ và tests liên quan; evidence mới của WP.
   Tệp nóng: db_provision.py, secret_stage.py, window.py và tham chiếu hash công cụ: một mình WP02D ghi trong sóng 1.
   Cấm: secret thật, .env*, sheet.json, OpenAPI/baseline/hash niêm phong ngoài scope; không commit/push/merge/PR/deploy hoặc đổi cờ production.
4. Đọc trước: deploy/production-window/cutover/README.md:140-146; docs/evidence/W-0486/README.md:192-196; các phiếu WP02A/B/C và docs/evidence/W-0487, W-0488.
   Thêm `AGENTS.md`, `CLAUDE.md` repo; `modules/m8/PHIEN.md`, `SAN_SANG.md`, bản rà `ra-soat/2026-11-02-ke-hoach-m8.md`.
5. Lệnh kiểm/phạm vi được dự kiến cho /song: Python unittest tại deploy/telephony-vm/tests và ba thư mục deploy/production-window/*/tests; Linux/container lab cô lập theo README, tên tiền tố m8-wp02d-. Không chạy vm_deploy trên .64.
   Lượt /ke-hoach CHƯA chạy các lệnh này. Runtime/công cụ cũ giữ nguyên; dependency chỉ cài trong nơi cô lập khi brief /song cho phép.
6. Bằng chứng: SHA nguồn + image/tool/artifact hash thích hợp, môi trường, lệnh, số pass/fail/skip, kiểm âm/đột biến, phạm vi thiếu; không dữ liệu/giá trị bí mật.
   R2: test đỏ trước → coder → verifier độc lập. R3: thêm tester độc lập và Lead duyệt diff trước ghép. Không tự ký nghiệm thu hay gọi test lab là production.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Parent giữ tracker/W-ID/generated files và tích hợp tuần tự; tối đa 3 agent nặng.
   GitNexus index lúc khảo sát stale `00b9004`, query thiếu FTS: trước sửa symbol parent xử lý index/impact theo luật repo; không scout tự analyze.
8. Đầu ra ≤25 dòng: đạt/chưa xong/chặn, tệp đổi, bằng chứng, việc còn lại/tệp xung đột; tracker và commit để phiên chính.

## Phụ thuộc và ranh giới

Không phụ thuộc custody production; chỉ lab. Sau khi ghép mới mở WP03A.
D-m8-010: .61 chỉ là kho tạm LAB, không chặn code/lab; custody production vẫn chốt trước cấp production/release.
D-m8-008: phần M3 do phiên m34 tự xử lý; m8 chỉ đọc để biết, không giao việc hoặc soạn/gửi hợp đồng cho M3.
Rủi ro/ước lượng phải đánh giá lại khi tái hiện lỗi, scope hoặc HEAD thay đổi; phát hiện thiếu quyền thì làm tiếp phần lab độc lập.

## Diễn biến

- 02/11 /ke-hoach: tạo phiếu từ 3 scout chỉ đọc và đối chiếu nguồn; chưa giao coder, chưa tạo bản sao, chưa chạy test/host.

## Bước kế tiếp chính xác

/song tạo bản sao từ HEAD sạch đã kiểm lại, giao coder rồi tester/verifier R3.

- 02/11 11:29 /song: Lead duyệt D-m8-011; parent chuẩn bị và điều phối sóng 1. Dành số W-0489; evidence docs/evidence/W-0489/. Archive LF từ c9f0cd18, loại .env* và sheet.json theo luật bí mật; full history gate chỉ ở main.
- 02/11 11:37 · Archive đã tạo, hash tar64a91ff4721a01f1e7f92421f6b998bf0dad71db522e8492d8370e013ae93114; coder đã nhận brief đầy đủ. GitNexus index-only PASS136s, c9f0cd18 up-to-date; không đổi AGENTS/CLAUDE.
- 02/11 12:36 · Coder chốt ba tool hash và 11 assertion Docker lab; tester độc lập 84/84, bắt 3/3 mutation. Đã sửa lỗi thật nhận danh sách service trùng. Verifier độc lập đang chạy lại đủ bộ, DB Docker còn chạy; chưa ghép R3. Parent thêm thuộc tính LF hẹp cho tool/config ghim hash và giữ nguyên byte evidence.
- 02/11 12:49 · Verifier vòng 1 CẦN SỬA V1: reprepare/apply sau đổi token tự nhận fingerprint mới. Probe độc lập 1 FAIL/0 ERROR. Các bộ đạt: VM57/cutover93/DB179/secrets226+5skip (Windows5)/independent84; mutation2/2; 89/89 byte ổn định. Freeze51files SHA6db4b3de; đã giao original coder OPS sửa vòng 2, nested lab kiểm lại source mới.
- 02/11 13:26 · Verifier vòng 2 frozen CẦN SỬA V2: path ARI khác/cùng byte bị chặn sau host_preflight, probe1FAIL; V1 đã đóng. VM108/cutover116/independent84/nested11 đạt, mutation3/3,177hashổnđịnh. Đã dừng theo giới hạn hai vòng và soạn diff hẹp ở ra-soat/2026-11-02-wp02d-v2-xin-vong-hep.md; chưa ghép.
- 02/11 13:26 · Lead duyệt m8.15 A/D-m8-013; giao OPS sửa đúng guard trước host_preflight và regression, Voice kiểm hẹp sau freeze. Không tự ghép hoặc mở vòng tiếp.
- 02/11 13:44 · Verifier vòng hẹp ĐẠT: VM112/cutover116, probesV1/V2, nested11 và mutation guard đều đạt;244hash nguyên. Lead m8.16A/D-m8-014 cho ghép đúngpatch33340dbb vàcommitlocal; parent bắt đầu tích hợp, khôngpush/deploy.
- 02/11 14:04 · D-m8-014: patch33340dbb ghép đúng236/236 byte. Main VM112/cutover116,84 độc lập chạy riêng và probesV1/V2 đạt; verifier nested11 trên cùngtoolSHAf9711766. Commit1ef80eb2, khôngpush/deploy.
- 02/11 14:18 · Main 1ef80eb2: VM112/cutover116, các bộ độc lập và V1/V2 đạt; default gate 51/51, 39 skip manifest. Bằng chứng a625d694, main sạch. D-m8-014 đã thực hiện; chưa push/deploy.
