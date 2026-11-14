# M8-WP07D — Chốt bản khai triển khai phù hợp kiến trúc M8

Trạng thái: ĐẠT (hồ sơ) · Rủi ro: R1 · Chế độ: S · Mốc: 04/11; trước cửa sổ thật
Hạng mục nâng: Cài bản thật/G5: bổ sung hồ sơ, không nâng bậc tự động · Sheet: M8-007 · Làn: Điều phối
Ước lượng: 5 giờ công AI (4 soạn/đối chiếu + 1 verifier); dự toán, chưa phải cam kết thời gian chờ ngoài.
Chỗ làm: `C:\Projects\Project Control\modules\m8\ra-soat` · Base sóng 1: `c9f0cd188f4966d07aafb3155039656b1b451034`.
Chỗ kiểm: bản sao/checkout cố định của đúng bộ byte; không build trên checkout đang có coder sửa. Trước /song kiểm lại HEAD và phạm vi.

## Brief

1. Repo: `C:\Projects\ginsengfood-ivr`, chỉ `main`; tài liệu chỉ ghi trong modules/m8 của Project Control.
2. Mục tiêu: Chốt bản khai triển khai phù hợp kiến trúc M8. Tiêu chí đạt:
   - 1. Bản khai đủ dịch vụ/host, cổng/health, DB/migration, UID, file secret tham chiếu, network và cách quan sát; chỉ tên, không có giá trị bí mật.
   - 2. Mỗi điểm lệch một-container/8000/env/migration có lý do, chủ sở hữu và cách kiểm tương đương; phân biệt ngoại lệ đề xuất và đã được chốt.
   - 3. Verifier đối chiếu bản khai với render_hosts/test probe và profile hiện hành; không tự gộp container hoặc đưa secret vào env để khớp mẫu.
   - 4. G5 chỉ đóng khi hồ sơ ngoại lệ được Lead chốt và triển khai đúng định danh đã qua kiểm; bản khai riêng không đóng G5.
3. Phạm vi ghi: Chỉ C:\Projects\Project Control\modules\m8\ra-soat\ và phiếu này. Repo deploy dùng chung thuộc phiên lead; chưa được sửa.
   Tệp nóng: Bản khai/ma trận của M8; không sửa shared MODULE_DEPLOY_CONTRACT.md, compose chung hay mã runtime.
   Cấm: secret thật, .env*, sheet.json, OpenAPI/baseline/hash niêm phong ngoài scope; không commit/push/merge/PR/deploy hoặc đổi cờ production.
4. Đọc trước: C:\Projects\deploy\MODULE_DEPLOY_CONTRACT.md:5-10; deploy/release-candidate/README.md:50,83,118-135; rollout README:3-17; secrets README:28-41.
   Thêm `AGENTS.md`, `CLAUDE.md` repo; `modules/m8/PHIEN.md`, `SAN_SANG.md`, bản rà `ra-soat/2026-11-02-ke-hoach-m8.md`.
5. Lệnh kiểm/phạm vi được dự kiến cho /song: Đọc metadata/schema công khai, kiểm liên kết và đối chiếu các trường; không chạy host hay đọc cấu hình có secret.
   Lượt /ke-hoach CHƯA chạy các lệnh này. Runtime/công cụ cũ giữ nguyên; dependency chỉ cài trong nơi cô lập khi brief /song cho phép.
6. Bằng chứng: SHA nguồn + image/tool/artifact hash thích hợp, môi trường, lệnh, số pass/fail/skip, kiểm âm/đột biến, phạm vi thiếu; không dữ liệu/giá trị bí mật.
   R2: test đỏ trước → coder → verifier độc lập. R3: thêm tester độc lập và Lead duyệt diff trước ghép. Không tự ký nghiệm thu hay gọi test lab là production.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Parent giữ tracker/W-ID/generated files và tích hợp tuần tự; tối đa 3 agent nặng.
   GitNexus index lúc khảo sát stale `00b9004`, query thiếu FTS: trước sửa symbol parent xử lý index/impact theo luật repo; không scout tự analyze.
8. Đầu ra ≤25 dòng: đạt/chưa xong/chặn, tệp đổi, bằng chứng, việc còn lại/tệp xung đột; tracker và commit để phiên chính.

## Phụ thuộc và ranh giới

Bảng khác biệt đã có trong ra-soat/2026-11-02-deploy-contract-m8.md; quyết định m8.13 chốt phần khác chuẩn chung.
D-m8-010: .61 chỉ là kho tạm LAB, không chặn code/lab; custody production vẫn chốt trước cấp production/release.
D-m8-008: phần M3 do phiên m34 tự xử lý; m8 chỉ đọc để biết, không giao việc hoặc soạn/gửi hợp đồng cho M3.
Rủi ro/ước lượng phải đánh giá lại khi tái hiện lỗi, scope hoặc HEAD thay đổi; phát hiện thiếu quyền thì làm tiếp phần lab độc lập.

## Diễn biến

- 02/11 /ke-hoach: tạo phiếu từ 3 scout chỉ đọc và đối chiếu nguồn; chưa giao coder, chưa tạo bản sao, chưa chạy test/host.

## Bước kế tiếp chính xác

Hoàn thiện bản khai từ ma trận đã lập; m8.13 chỉ chặn chốt chuẩn production, không chặn hai sóng lab.

- 02/11 11:29 /song: Lead duyệt D-m8-011; parent chuẩn bị và điều phối sóng 1. Parent soạn bản khai trong modules/m8; không ghi repo deploy chung.
- 02/11 11:37 · Parent hoàn thiện [bản khai](../ra-soat/2026-11-02-ban-khai-trien-khai-m8.md): dịch vụ, host, network, health, UID, RAM/CPU, DB/migration, refs/mounts, owner/ngoại lệ/G5. Chờ verifierR1, chưa chạyhost.
- 02/11 11:53 · Verifier R1 vòng1 CẦN SỬA: thiếuhostbackupunits vàbackupmounts/5refs. Parent bổsung, kiểm lại hẹp ĐẠT,20/20sourcepins khớp; [biên bản](../ra-soat/2026-11-02-wp07d-verifier.md). G5 vẫnCHƯA; nohost/deploy.
- 02/11 14:18 · Sóng 1 chốt local 1ef80eb2 + bằng chứng a625d694. Bản khai 20/20 nguồn vẫn gắn c9f0cd18 làm nguồn khảo sát; không tự đổi thành candidate release. G5/custody production chưa đóng.
