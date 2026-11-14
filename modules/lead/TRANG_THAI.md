# Trạng thái — lead

Mốc dữ liệu: 05/11/2026 10:05 (+07) · git fetch so mốc 03/11 13:51; Sheet (10:06), PR, sổ Tài (origin `82d63efa`) đọc qua 2 scout chỉ đọc. Chưa chạy test/deploy.
ops-core `main a5dec72d0` = origin = gitlab (bẩn 1) · BP `toandeptrai c45c64fe7` = origin, `dev 3c9993b36`, `dev015 0711249b8`, `PhucApu 3cbf857de`
· M4-PLAN local `2eba5075`, origin `82d63efa` · M5 `e54ac02` · M6 `2ffa505` · M7 `c17722e` = origin (bẩn 1) · M8 `e5d5aa8c` = origin (15 sửa + 8 mới)
· contracts `08585c1`/origin `a7832a4`, merge dở 41 xung đột (giữ nguyên) · deploy `225c586` (1 tệp lạ cũ 18/07 `seed_test_live_session.py`).

## Tình hình

- Toàn hệ thống ĐỎ cho đủ phạm vi 15/11; 0/11 điểm nối có bằng chứng đầu-cuối (SAN_SANG lead còn BẢN NHÁP 31/10). Mốc A 07/11 còn 2 ngày.
- Bậc: M12 44% VÀNG · M3 36% ĐỎ · M3 VC–TT, M4 VÀNG · M5 11% cũ VÀNG · M6 11,7% cũ VÀNG · M7 2,2% ĐỎ · M8 47% ĐỎ · M9 (anh Mạnh, trong BP): PR #148 rà 05/11 CẦN SỬA; PR #149 `df1f82e6c` + #150 `01d255cf1` rà 06/11: gộp được (ghép `dev` chỉ đỏ lớp đỏ sẵn, đột biến bắt đủ); trước khi mở cho kế toán: menu 2 màn mới, quyền/cấu hình soát thuế. Tin đề xuất anh Mạnh tự gộp PR M9 theo điều kiện (`ra-soat/2026-11-06-phan-hoi-manh-pr150.md` §4). **Hạn M9 09/11** (6 ngày từ 04/11, tin Toàn gửi), gồm MISA + ngân hàng + đặc tả còn lại.
- M12: 33 commit tới `a5dec72d0` (WP12b/12c, WP13, WP15 ĐẠT); WP03c giao diện đợt 2: 20 Đạt / 6 Không đạt / 31 Bị chặn; WP02c (CD lên .61) hôm nay, chặn bởi việc của bạn.
- M3→M8 (bạn): D-m34-025 gộp `toandeptrai` vào `dev` không qua PR; lab đêm `6e798cfa` cohort 20/23 (3 FAIL do harness); U13 chưa commit; gói .60 `~/m34` dời 05/11 ≤ 12:30.
- Phúc: `PhucApu` +50 commit (tìm SKU, E2E lượt 7), không PR; 11 task M3 quá hạn. Tài: `dev015` +76 (M4-008 DONE 10:04); M5 172 commit, PR #44–#61;
  M6 202 commit, PR #39–#46; PR #146 `dev015→dev` vẫn mở từ 31/10, CONFLICTING, 0 check, bạn không có trong người review.
- M7: 20 commit tới `c17722e` đã lên origin (push không do phiên nào ghi, bình thường). M8: `e5d5aa8c` đã lên remote; pipeline đỏ `security_scan` + `pii_scan`.
- Hạn mức API: 04/11 14:15–22:35 hết hạn mức tuần, 05/11 00:39–02:21 giới hạn 5 giờ → subagent m34 dừng, M3-071…100 trễ. 4 luồng code chạy cùng lúc (m12, m34, m7, m8) > ngân sách 2.
- Sheet 532 task: Hoàn thành 141, Chờ review 37, Đang làm 39, Chưa bắt đầu 295, Bị chặn 16, Huỷ 4; Lead duyệt Đạt 98 / Cần sửa 40. 88 task mở hạn ≤ 05/11
  (M3 38 gồm 27 của bạn M3-071…100; M6 34; M5 13). `can-ra`: 75 cần rà (bạn 19, Tài 48, Phúc 8), 5 chờ người làm sửa.
- Báo cáo: kỳ 26–31/10 không thấy dấu đã gửi Chú; kỳ 02–07/11 chưa có thư mục (hạn thứ Bảy 07/11).
- Hộp thư mới 04/11 (chưa xử lý): `lead-…-m34-anh-ton-kho-wms` (điểm nối mới N12 M2→M3, lead.53), `lead-…-m34-m8-mock-cat-cuoc` (chuyển m8). 4 tệp 03/11 vẫn giữ.
- Đóng: m12.70 · lead.46 phần máy (D-m34-027) · lead.78–80 (D-lead-034: M5 + M6 lên máy mkt 192.168.1.98 ngay, Tài dựng, giữ mật khẩu) · lead.43 còn mở (D-m34-025 ngoại lệ một lần).

## Cần Lead làm / quyết (giữ mã luồng; xếp theo hạn)

| Mã | Nội dung / đề xuất | Hạn |
|---|---|---|
| m34.44–47 | Gói .60: GitLab CI/registry A · CSDL mới sạch A · commit gói lên `toandeptrai`: có · đẩy GitLab `dev`: có | hôm nay 12:30 |
| lead.1 · lead.45 | Gói contracts trên worktree mới từ `origin/main` (C37 `ISSUED` + release, 8 mã `COMMON.*` M7), Phúc review: A | quá 03/11, cần 08/11 |
| lead.44 | Phụ lục M7 + bảng .60 (`~/m34` theo D-m34-027, `~/m5` 65xx, `~/m6` 66xx, `~/m7` 67xx): A | quá 04/11 |
| lead.53 | N12 ảnh tồn kho WMS M2→M3 (D-m34-023): A Phúc gộp vào adapter kéo tồn 08/11 · B bạn làm cả hai phía (m12 + `toandeptrai`). Đề xuất B | trước mốc B |
| lead.54 | Tới 07/11 chỉ m34 + m12 chạy sóng code ban ngày; m7 chạy đêm khi hai luồng kia nghỉ; m8 chỉ việc phiên chính: có | ngay |
| lead.55 | PR #146: Tài gộp `dev`→`dev015` giải `SecurityConfig`; phiên m34 trả Tài ý định `setEnabled(false)` ở `bdd220147`; m34 rà PR khi hết xung đột: có | 05/11 |
| lead.56 | CH21 `HOP_DONG_BAM_PSID_V1.md` đã phát hành 14/10 (M6-OD-021), nhạy cảm, cấm commit (module5 SOURCES.md:70) → không viết mới; bạn tìm bản gốc (`D:/9 module/M6/_SPEC/`, kênh `fix/2026-10-14/`; máy này không có) và đưa Tài bản chỉ đọc ngoài repo | 05/11 |
| lead.57 | Đã quyết A (D-m5-018). Đổi 13/11 theo D-m5-034: Page pilot **có** AI, M4 dùng Claude API soạn tin riêng qua cửa gửi chung + FinalGuard M5, chỉ giờ có người trực; bật khi có văn bản pháp chế đợt 2 (D-m5-037), NCC A1–A6, P0 M4, chữ M5-101 khai AI. Báo giá/nháp đơn chặn suốt pilot (D-m5-039). Đã báo m34 (`hop-thu/m34-2026-11-13-m5-ai-pilot.md`, D-m34-064) | đã quyết |
| chuyển .99 | D-lead-035–038. **Nền .99 xong 13/11 14:49**: vào bằng khoá, Docker 29.9.3, Compose v5.7.1, data-root `/data/docker`, thư mục theo tên repo `/data/ginsengfood-ops-core|business-platform|ivr` (bạn chạy 1 lệnh `sudo mv`), chặn cổng `gf-tuong-lua` (`KIEM_KE_MAY_CHU.md` §10); 3 tin `hop-thu/{m12,m34,m8}-2026-11-13-nen-99-san-sang.md`. Lịch cắt (D-lead-038): không chờ giờ, luồng nào sẵn cắt ngay, thứ tự m12 → m34 → m8 (.64 đã mở cho .99 16:08, Toàn tự chạy). **m12 đã cắt sang .99 19:15** (bản 87acc810, .61 dừng hẳn 20:27, giữ volume để lùi; khoá CD .99 + sao lưu ngoài máy 23:30 xong 14/11 08:10; còn phiên m12 chính: test main xanh → image lên kho → WP17 → `deploy-99`); M3 trên .60 không gọi M12 (`OPS_CORE_ENABLED=false`) nên không đổi gì. **m34 cắt xong 14/11 07:36** (lượt 3), **m8 cắt xong 08:50** (.61 dừng hết, giữ dữ liệu); vòng M3 ↔ M8 trên .99 đạt (đơn MOCK 577 CONFIRMED 08:49). Còn: CD m8 .99 (biến CI + khoá, bạn), xoá luật tạm 8443(.60)/8445(.61) sau 15/11. Tin Anh Tuấn **đã gửi 14/11** (bản 7), chờ Anh Tuấn làm HTTPS + chuyển theo tên (`may-chu/2026-11-13-chuyen-may-99/tin-anh-tuan-99.md`; không xin IP nginx: 80/8012 mở cả LAN; .64 bạn tự mở xong; DNS Mắt Bão đủ, đã xoá `admin`, `api-ops`); bước sudo trên .99 bạn tự chạy. HTTPS `mkt.` vẫn chờ Anh Tuấn | khi sẵn |
| lead.59–62 | M9: anh Mạnh làm PR mới sửa P0+P1, gán `FINANCE.*` sau khi rà lại Đạt: có · nguồn quảng cáo mặc định tắt: A · anh Mạnh kiểm .63: có · lead.62 đã quyết: MISA trong hạn 08/11 (`ra-soat/2026-11-05-ra-soat-m9-pr148.md`) | gửi tin 05/11 |
| lead.64 | vai trò FINANCE.* + chính sách TNCN: chú Dũng chốt, kế toán xác nhận (lead.65, .66 đã quyết D-lead-023) (`ra-soat/2026-11-05-m9-viec-con-lai-production.md`) | 06/11 |
| lead.51 · 52 | Soát L1 M6 + Tài xin soát M6-023/024/025/037/038/071, duyệt cờ M6-039 → `/ra-soat m6` | hôm nay |
| M4 §9 (Tài) | ~~M4 không trả tin riêng Page pilot~~ (thay bởi D-m5-034, xem lead.57) · sức khoẻ mới mặc định chuyển người · nhánh cấp cứu `/turn` trước M4-009 · pilot chỉ giờ có người trực: có cả 4 · credit Claude API: bạn quyết nạp | 05/11 |
| m5 | M5-101 repo GitHub Pages + duyệt chữ · App Review 06/11: giữ hay pilot chỉ người có vai trò · m5.13 `/ra-soat m5` có · m5.6 · m5.7 A | 05–06/11 |
| m12.68 · 69 | Ref máy chủ + NRE: A gói R2 sóng này · khoá `actorRef` DemandMrp khác: A sau 14/11 | sóng 8 |
| m8.39–41 | Log `pii_scan` hoặc dựng lại · W-0501 miễn gitleaks: có · `sheet.json` A | trước cắt .61 |
| m7.73–87 | 15 câu (L12-Q, guard, phân hạng R2, T008 R3…); đề xuất của m7 có hết | phiên m7 |
| m34.41 · 48 · lead.43 · lead.13 | rememberMe A · U13 duyệt 1–3,5, 4 có · áp D-m34-019 vào luật chung: có · bản tuần 26–31/10 đã gửi Chú chưa | 07/11 |

Lead tự làm (chặn): GitLab protect `main` + 2 biến File + `M12_CD_FROM_MAIN` và bước .61 `cd-entry` (WP02c hôm nay) · tác vụ sao lưu 23:30 ·
pipeline JWT M12-005 (quá 03/11) · deploy token + khoá SSH CD M8 · credit API M4.

## Việc ngoài gần hạn

05/11: .60 SSH/vhost/HTTPS M5 (Anh Tuấn) — chặn App Review, M4-004 · 06/11: lời thoại M8 (Chú, chưa gửi), App Review (Tài) ·
07/11: runner/ký, DNS/HTTPS .61, kênh cảnh báo, sudo .61/.64 (Anh Tuấn) · sao lưu ngoài .61 cần đăng ký lại tác vụ.

## Đề xuất hôm nay

1. `lead`: lead.1/45 A → `/song` LEAD-WP04 contracts (R2); lead.44 A → LEAD-WP05 deploy contract + bảng .60 (R1); thêm N12 vào SAN_SANG; chuyển hộp thư mock sang m8; `/ke-hoach` sau mốc A.
2. `m34`: trả m34.44–47 → xong gói .60 trước 12:30; rà 12 task M3-072…085 của bạn; PR #146 khi hết xung đột.
3. `m12`: WP02c ngay khi bạn xong GitLab/.61; WP03c đợt 3–4. `m8`: m8.39–41 → pipeline xanh → cắt .61 bằng lệnh riêng.
4. `m6` `/ra-soat m6` (12 task + L1) · `m5` `/ra-soat m5` (16 task) · `m7` chỉ chạy đêm.
