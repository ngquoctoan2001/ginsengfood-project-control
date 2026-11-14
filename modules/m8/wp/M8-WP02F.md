# M8-WP02F — Diễn tập rồi thực hiện cửa sổ đóng gọi và nghiệm thu vận hành

Trạng thái: Sơ bộ LAB xong (W-0496 `caaa8f65`); phần candidate/thật CHẶN · Rủi ro: R3 · Chế độ: A · Mốc: sơ bộ công cụ trước 07/11; diễn tập đúng candidate sau 07B-L ngày09–10/11; cửa sổ thật trước 12/11; release 14/11 khi đủ gate
Lượt09/11 21:48: **D-m8-020 đã ghép và commit local W-0518 `005bc43d` theo m8.69A/D-m8-067**. Ba tệp đúng patch34529bf6; sau ghép Linux188/188, độc lập39/39, Windows180 đạt+8skip POSIX cũ; verifier R2 trước ghép bắt9/9 đột biến. Chọn pre tường minh, giữ default post. Không push/deploy, WIP phiên khác nguyên. [Kết quả và giới hạn PII](../ra-soat/2026-11-09-02f-rollback-pre-ket-qua.md). D021 phụ thuộc adapter/topology D024; [đối chiếu](../ra-soat/2026-11-09-02f-phu-thuoc-khuon-m8.md).
Hạng mục nâng: Cài bản thật 50 → 75/90; backup40/50 →75 khi restore ngoài máy đạt · Sheet: M8-002 · Làn: L2
Ước lượng: 8 giờ công AI (4 chuẩn bị + 2 tester độc lập + 2 verifier; cửa sổ90 phút +30 dự phòng, reboot riêng); dự toán, chưa phải cam kết thời gian chờ ngoài.
Chỗ làm: dự kiến `C:\Projects\_wt\m8\m8-wp02f` (chưa tạo) · Base khảo sát: `c9f0cd188f4966d07aafb3155039656b1b451034`.
Chỗ kiểm: bản sao/checkout cố định của đúng bộ byte; không build trên checkout đang có coder sửa. Trước /song kiểm lại HEAD và phạm vi.

## Brief

1. Repo: `C:\Projects\ginsengfood-ivr`, chỉ `main`; phiên chính chuẩn bị bản sao git archive, không worktree/nhánh mới.
2. Mục tiêu: Diễn tập rồi thực hiện cửa sổ đóng gọi và nghiệm thu vận hành. Tiêu chí đạt:
   - 1. Trước07/11 chỉ diễn tập sơ bộ công cụ với artifact ghi rõ phiên bản, không nghiệm thu final. Sau 07B-L (dự kiến09–10/11), diễn tập candidate hoàn chỉnh từ inventory/profile, kiểm drift/STOP khi thiếu đầu vào; chỉ lượt sau làm đầu vào cửa sổ thật.
   - 2. Trước lượt thật: custody và recovery reference độc lập đã chốt; phát mới bí mật production, không tái dùng lab; CA rời host trước stage đúng runbook.
   - 3. Kiểm DB policy v4, quyền/mTLS, ba dịch vụ .64, giám sát/ACK/media epoch, positive/negative auth; giữ scheduler/trunk/callback đóng trong cửa sổ đóng gọi.
   - 4. Lỗi hoặc quá thời gian dừng/quay lui đúng gói; không tự kéo dài bật gọi. Offhost restore/reboot có lịch riêng và receipt người vận hành; không ghi SIGKILL là reboot.
   - 5. Chỉ mở bước release 14/11 sau G1–G8 và nghiệm thu C 12/11 đạt trên đúng bộ, quyền cụ thể từ Lead.
3. Phạm vi ghi: Hồ sơ rollout mới, inventory đã lọc, plan/receipt/quay lui và evidence mới; không sửa bundle đã niêm phong tại chỗ.
   Tệp nóng: Hai host, DB, state giám sát, secret staging và controller chỉ một người điều phối; không có WP khác chạy host trong cửa sổ.
   Cấm: secret thật, .env*, sheet.json, OpenAPI/baseline/hash niêm phong ngoài scope; không commit/push/merge/PR/deploy hoặc đổi cờ production.
4. Đọc trước: deploy/production-window/cutover/README.md; rollout27/10 README/cutover/rollback; quy trình DB/secrets/backup và WP07D.
   Thêm `AGENTS.md`, `CLAUDE.md` repo; `modules/m8/PHIEN.md`, `SAN_SANG.md`, bản rà `ra-soat/2026-11-02-ke-hoach-m8.md`.
5. Lệnh kiểm/phạm vi được dự kiến cho /song: Lab unittest/rehearsal trước; trên host chỉ bộ lệnh được duyệt cho đúng cửa sổ. Không tự chạy host scripts trong /ke-hoach hoặc /song code.
   Lượt /ke-hoach CHƯA chạy các lệnh này. Runtime/công cụ cũ giữ nguyên; dependency chỉ cài trong nơi cô lập khi brief /song cho phép.
6. Bằng chứng: SHA nguồn + image/tool/artifact hash thích hợp, môi trường, lệnh, số pass/fail/skip, kiểm âm/đột biến, phạm vi thiếu; không dữ liệu/giá trị bí mật.
   R2: test đỏ trước → coder → verifier độc lập. R3: thêm tester độc lập và Lead duyệt diff trước ghép. Không tự ký nghiệm thu hay gọi test lab là production.
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`. Parent giữ tracker/W-ID/generated files và tích hợp tuần tự; tối đa 3 agent nặng.
   GitNexus index lúc khảo sát stale `00b9004`, query thiếu FTS: trước sửa symbol parent xử lý index/impact theo luật repo; không scout tự analyze.
8. Đầu ra ≤25 dòng: đạt/chưa xong/chặn, tệp đổi, bằng chứng, việc còn lại/tệp xung đột; tracker và commit để phiên chính.

## Phụ thuộc và ranh giới

02D/E,03A,07D, 02G (khuôn `~/m8`, D-m8-023) và receipt 07B-L đạt lab (không đợi 07B-A nghiệm thu toàn bộ); Lead chốt custody trước cấp production; Tuấn cấp inventory/quyền/kho ngoài máy/cửa sổ; lệnh thực thi riêng của Lead. Evidence host từ 02F trả về 07B-A, tránh vòng chờ.
D-m8-010: .61 chỉ là kho tạm LAB, không chặn code/lab; custody production vẫn chốt trước cấp production/release.
D-m8-008: phần M3 do phiên m34 tự xử lý; m8 chỉ đọc để biết, không giao việc hoặc soạn/gửi hợp đồng cho M3.
Rủi ro/ước lượng phải đánh giá lại khi tái hiện lỗi, scope hoặc HEAD thay đổi; phát hiện thiếu quyền thì làm tiếp phần lab độc lập.

## Diễn biến

- 02/11 /ke-hoach: tạo phiếu từ 3 scout chỉ đọc và đối chiếu nguồn; chưa giao coder, chưa tạo bản sao, chưa chạy test/host.
- 03/11 08:10 · Lead "tiếp tục m8-002". Mở phần sơ bộ LAB (tiêu chí 1) W-0496 R3: nối F0/F5/R5 với toolset 07B, probe ACK/media epoch tự chấm, diễn tập fixture + candidate lịch sử 66d9045d. Bản sao `C:\Projects\_wt\m8\m8-wp02f` từ 17ef92fe (goc 4502bfa0), baseline cutover 116 OK/skip1; impact step_monitoring LOW, probe_commands MEDIUM. Coder đang chạy. [Brief](../ra-soat/2026-11-03-02f-so-bo-brief.md). Profile/inventory máy thật vẫn chờ.
- 03/11 ~08:25 · Phiên trước dừng vì tài khoản hết hạn mức; coder chưa sửa tệp nào (bản sao sạch ở goc 4502bfa). Phiên mới tiếp quản:
  kiểm lại nền 116 OK/skip 1, giao lại coder theo đúng brief. **Phiên cũ không chạy tiếp WP02F trên bản sao này** (tránh hai coder cùng ghi).
- 03/11 11:50 · Phần sơ bộ **CHỜ KIỂM — chờ Lead**: coder-r1 → tester độc lập 99 ca (bắt lỗi gài module) → coder-r2 → verifier v1 CẦN SỬA →
  coder-r3 → verifier v2 CẦN SỬA chỉ thiếu test regex (hết 2 vòng). Linux Py3.10 163/163. Nguồn cố định `267e902` (repo tạm).
  Chưa ghép main. [Diff R3 + m8.18–m8.22](../ra-soat/2026-11-03-02f-so-bo-diff-r3.md).

- 03/11 13:00 · Lead "ok 18A 19B 20B 21A 22" (D-m8-018…022). Phiên chính thêm test regex, vòng 4 đạt (Linux 163/163, V06/V07/V09 chết).
  Ghép main, commit local `caaa8f65`, W-0496 EVIDENCE_SUBMITTED; tracker M8-002 một lần; bản sao 02F đã dọn. Lead "Push main" → đã push, hai remote `caaa8f65`. [Kết quả](../ra-soat/2026-11-03-02f-so-bo-ket-qua.md).

## Bước kế tiếp chính xác

M8.69 đã đóng: W-0518 `005bc43d` local, kiểm sau ghép đạt; chưa push/deploy. Phần pre chỉ là bộ chấm fixture, không phải receipt candidate07B-L.
Tiếp D024 contract/adapter m8 rồi nối F5/R5 qua `authorized_handoff.py` (D021); adapter legacy đòi source project/systemd cũ và staging root-owned nên chưa hỗ trợ host hiện tại. Sau07B-L mới diễn tập đúng candidate từ inventory/profile và trình cửa sổ cụ thể.
D-m8-024: `window.py` đang coi production là project riêng 9443/`/srv/ivr-production` → 02F sửa sang nâng cấp tại chỗ project `m8` (volume CSDL + bí mật production mới, volume S5 giữ lưu trữ) trước 09/11, sau khi 02G xong (xem [02G](M8-WP02G.md)).
