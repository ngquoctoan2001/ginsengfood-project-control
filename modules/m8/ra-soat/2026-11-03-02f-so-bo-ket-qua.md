# 02F sơ bộ LAB (W-0496) — kết quả ghép

Mốc 03/11/2026 13:00 UTC+7 · Sheet M8-002 · R3 · Lead duyệt "ok 18A 19B 20B 21A 22" (D-m8-018…022).
Commit `caaa8f65` trên `main` (cha `17ef92fe`), **đã push** theo lệnh Lead "Push main" (GitLab + GitHub = `caaa8f65`); chưa deploy/SSH/gọi thật. Không phải receipt 07B-L, không phải cửa sổ thật.

## Đã làm sau khi Lead duyệt

| Việc | Kết quả |
|---|---|
| m8.18 A — phiên chính thêm test regex | Thêm `'a$b'`, `'$W'`, `'a/b'` vào ca từ chối và `a$W` vào ca plan; không thêm vòng coder/verifier |
| Chạy lại (vòng 4) | Windows cutover 163 OK skip 3; độc lập 99 OK; Linux Py3.10 uid1000 163/163; V06/V07/V09 đều **KILLED**, `window.py` khớp hash trước/sau |
| Hồ sơ | README §11 sửa câu mode 0300, thêm §12 (vòng 4 + D-m8-019/020/021); `.gitattributes` giữ byte; `MANIFEST.sha256` 69 tệp, kiểm lại trên main **MANIFEST_OK** |
| Ghép main | Patch `git diff --binary 4502bfa d403e05` + bản `git archive` cho thư mục bằng chứng (tránh autocrlf); 75 tệp khớp byte repo tạm |
| Sổ repo | `W-0496` EVIDENCE_SUBMITTED, `NEXT_WORK_ID: W-0497`; gate-status/readiness-board sinh lại: 484 work items/123 EVIDENCE_SUBMITTED, GATE_STATUS_PASS |
| Commit | Private index, allowlist 78 tệp (cutover, `docs/evidence/W-0496`, work-register, gate-status, readiness-board); GitNexus detect_changes trước commit (rủi ro cao chỉ đến từ WIP callback của phiên khác) |
| WIP phiên khác | 21 mục (M3 sandbox/callback/admin API/weekly) giữ nguyên trước = sau, không stage |
| Tracker | M8-002 `log` một lần, ok, "Đã đồng bộ"; sổ tuần `nguyen-quoc-toan.md` chỉ nối thêm cuối (nội dung phiên kia giữ nguyên, chưa commit tệp này) |
| Dọn | Xoá bản sao `m8-wp02f`, `-tester`, `-verify`, `-verify2` sau khi đối chiếu; giữ patch/log ở `C:\Projects\_wt\m8\prep-w0496\` |

## Còn lại / nợ

- 02F phần chính vẫn CHẶN: cần 07B-L candidate, inventory/quyền host (Tuấn), custody production, cửa sổ.
- D-m8-021: F5/R5 production đi qua `authorized_handoff.py` (02E) — làm trước 09/11.
- D-m8-020: lượt 09–10/11 thêm nhánh chấm quay lui theo `pre` khi không có post.
- D-m8-019: nợ `sudo python3` không `-I` (vm_deploy, host_audit, db_provision, probe, F5/R5).
- Lệnh máy chủ phải chạy bằng bash; token receiver suy từ `Media__TokenFile`, inventory chưa thu env receiver.
- Readiness giữ **47%**: sơ bộ LAB không nâng bậc. REAL_CUSTOMER_CALL_ALLOWED=NO; deployable=false.
