# M12 — Xử lý 63 ca nghiệm thu chưa đạt (10 không đạt + 53 bị chặn), mở 25/11

Lệnh: Toàn 25/11 "rà soát kiểm tra và fix cái này, tổng cộng 63 cái" (bảng 10 không đạt + 53 bị chặn của báo cáo 14–24/11).
Nguồn số: sổ `ginsengfood-ops-core/docs/evidence/27-10-14-30-uat-chay-nhanh/results-2710.jsonl` (dòng cuối mỗi ca thắng; cục bộ, không đưa git) + `tools/uat/function-catalog/catalog.json`; tính lại 24/11: 1.737 đạt · 10 KĐ · 53 BC · 58 KAD · 468 chưa chạy. Trạng thái: **XONG 25/11 14:30** (62 ca Đạt, 1 ca Không áp dụng; xem `ra-soat/2026-11-25-63-ca-ket-qua.md`).

## Nhóm việc

| Nhóm | Ca | Số | Cách xử lý |
|---|---|---|---|
| A. Lỗi phần mềm (sửa code rồi chạy lại ca) | E04-F04-T01, E04-F05-T01, E04-F09-T01 (phiếu cấp đông/sấy tự sinh trống, FRM-28/29) | 3 | coder `uat63-frm28` |
| | F03-F02-T01, F03-F02-T05 (+ F03-F02-T04 đang bị chặn): R-QA-REL không bật trang công khai (S2) | 2 + 1 | coder `uat63-qarel` |
| | E02-F04-T01 (Gán tôi ghi nhật ký trùng), G01-F05-T04 (lưu lý do QC ngắn), G02-F05-T04 (lập phiếu phát hành từ NONE) | 3 | coder `uat63-small` |
| | F01-F03-T02 (GTIN 13 số) đã sửa `2508575d7` | 1 | chỉ chạy lại ca |
| B. Hoãn theo quyết định | E01-F06-T01 in lệnh sản xuất (hoãn cùng in tem, D-m12-002/006) | 1 | ghi sổ Không áp dụng (theo tiền lệ D-m12-103), kèm dòng sổ nêu rõ; phiên chính |
| C. Kết quả đạt cũ hết giá trị vì luật chú Dũng lần 3 (chạy lại với luật mới) | D01-F03-T01/T02/T04/T05 (4), D01-F12-T01…T07 (7), D03-F14-T01/T04/T05/T06/T07 (5) | 16 | lab + fixture + tester |
| D. Chỉ kiểm được một phần trên màn | C05-F02-T07…T12 (6 mức cảnh báo MRP, thiếu fixture "tồn giữa thô và sau đệm"); D01-F10-T02/T03; D01-F15-T03/T04/T07 (app quét phiếu); D03-F18-T02…T06 (giá bao bì); F03-F02-T04; G02-F02-T01/T04/T05/T06/T07 (phê duyệt phát hành); G02-F04-T07 | 23 | lab + fixture + tester |
| E. Thiếu dữ liệu/môi trường/fixture | dữ liệu: C04-F03-T02, C05-F03-T02, C06-F03-T01/T04, C06-F04-T02, C06-F08-T04 (6); môi trường: C02-F03-T01 (worker nền tắt), E08-F04-T05 (app xưởng 3201), O07-F06-T99/T100/T101 (cần khoá dịch vụ thử, đã có công cụ xoay WP21) (5); fixture: C02-F05-T90, C02-F07-T90 (2); worker tắt: H05-F04-T02 (1) | 14 | lab + dịch vụ nền + fixture + tester |

## Thứ tự

1. Sóng A (đang chạy): 3 coder sửa lỗi phần mềm song song, test lọc + đột biến + Governance; phiên chính đọc diff, commit theo đường dẫn.
2. Sóng B: dựng lab trên checkout chính (không worktree, D-lead-063): `docker start ginsengfood-postgres-local`, `lab.ps1` (`RepoRoot` mặc định là checkout chính, artifacts `.artifacts/dotnet/<tên>`), áp migration 160 + seed bản mới (`lab-update-db.ps1`), dựng fixture theo `tools/uat/lab-fixtures`; sau mỗi lần chạy trả `next-env.d.ts`/`tsconfig.json` của admin-web đúng từng tệp.
3. Sóng C: tester chạy lại 53 + 9 ca theo nhóm (một lab một tester; lab 2 `lab2.ps1` nếu cần song song), ghi sổ bằng collector (dòng mới, không sửa dòng cũ), bằng chứng từng ca.
4. Chốt: tính lại tổng từ sổ, cập nhật `TRANG_THAI.md`, nhật ký, Sheet; ca nào vẫn không chạy được thì ghi rõ vì sao và ai gỡ.

## Quy tắc

Chưa chạy ghi CHƯA CHẠY; không chuyển KHÔNG ĐẠT/BỊ CHẶN thành ĐẠT khi chưa có bằng chứng chạy lại; kiểm lại đúng bản (ghi SHA lab). Ca KAD chỉ theo quyết định đã có.

## Cập nhật 25/11 10:0x

- Lab dựng xong trên HEAD `a0ccc740e` (lab 1 cổng 5200/3200/3201/5299, lab 2 cổng 5202/3202); 47/62 ca SẴN SÀNG, 15 THIẾU (bảng ở `UAT63-lab-ready.md`, cục bộ). Tester nhóm A xong: 10/10 ĐẠT (25/11 10:26). Đang chạy: tester nhóm C1 và coder dựng fixture 15 ca thiếu.
- **D-m12-135 (Toàn "Đúng, giữ"):** "ký FRM-21 kết luận tạm giữ rồi mới phê duyệt" là đúng nghiệp vụ; ca G02-F02-T01/T05/T06/T07 chạy theo đường đó, sổ tay sửa theo (không đổi mã).
- E01-F06-T01 (in lệnh sản xuất): ghi sổ Không áp dụng khi chốt cuối (sau khi lab/tester xong, vì thư mục bằng chứng đang được ghi).
- G02-F05-T04: không tái hiện được trên code mới; chạy lại ở nhóm A để kết luận.

## Kết quả cuối 25/11 14:30

- Sổ: 1.799 đạt · 0 không đạt · 0 bị chặn · 59 không áp dụng · 468 chưa chạy (tổng 2.326). 62/62 ca chạy lại ĐẠT; E01-F06-T01 → Không áp dụng. Còn lại để lên chạy thật: các sửa giao diện `466245762`, `4b3655cc3` chưa lên .99; 39 ca cần sửa sổ tay; quyết m12.230–224.
