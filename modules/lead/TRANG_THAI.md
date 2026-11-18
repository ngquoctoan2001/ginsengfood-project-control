# Trạng thái — lead

Mốc dữ liệu: 16/11/2026 20:26 (+07, thứ Hai) · tài khoản Claude mới (Toàn đổi 20:2x, `ban-giao/2026-11-16-chuyen-tai-khoan.md`) · `git_tong_quan --fetch lead` + sổ các luồng + 2 scout (Sheet, sổ Tài, PR).
ops-core `origin/main` = gitlab `668b29e0d` (local `27b7a658a` +5 chưa push) · BP `origin/dev` `b2568a319`, local `toandeptrai` `d3d91686d` (+6 so `dev`, chưa push), `dev015` `d8202cc31`
· module5 `origin/main` `6ee2bedc` (local sau 55) · M7 `765eaa6` · ivr `main` `680508c7` · contracts `origin/main` `a7832a4`, `origin/m12-noi-m3` `5b90c0b` (FF được) · M4-PLAN origin `fdc7e78b`.

Kế hoạch tuần: [ke-hoach-tuan/2026-11-16_2026-11-21.md](ke-hoach-tuan/2026-11-16_2026-11-21.md).

## Tình hình

- **Tài khoản mới 20:3x:** phiên lead tạo 6 phiên cùng cấp (không fork) theo lời Toàn: Phien M12, M34, M5, M6, M7, M8, mỗi phiên nhận khối bàn giao §3 + dữ kiện git 20:26 và chạy `/phien <mã>`.
  Phiên "M7 trên .63" chưa tạo lại: Toàn đăng nhập Claude trên .63 rồi tự mở (khối §3.7). Phiên phụ cũ không mở lại.
- ops-core: gộp nhánh chú `ea8f8d5d2` + sửa sau rà; pipeline tay #3072542878 trên `668b29e0d` xanh 13/13; **`deploy-99` chờ Toàn** (bước 1 nối M12 ↔ M3). Lab UAT tắt từ 16:31.
- ivr: `main` `680508c7` (2 commit chú + draft.47, NSwag sinh lại); pipeline `3072568426` chưa rõ kết quả. Buổi E 16/11 dời (không có đơn thử 14:14–18:00), M8 đã trả lại, lịch TẮT.
- BP: Phúc gộp `PhucApu` vào `dev` (+44 commit); PR #162 `dev015 → dev` (Tài) chờ Phúc, 3 check đỏ, lệch `dev` 15/19.
  Sổ Tài: buổi sếp test M4 18–19/11 cần khung chat .99 (image build `NEXT_PUBLIC_AI_ADVISOR_WIDGET_ENABLED=false`) + trả lời Q4a–e về .99 trước chiều 17/11.
- module5: PR #120–#126 gộp (#125 M6-042 JWT thật, #126 M5-142); không PR mở. PM Tài dự báo No-go pilot ≤ 20/11. RAM .98 3322 MiB < trần M5 3,5 GiB.
- Nhánh chú mới sau lượt rà sáng: ops-core 1 (`ke-toan-dong-phieu-nhap…`), ivr 1 (`khung-goi-lai…`), BP 4 (m3 ×2, m4, m9 — việc Phúc).
- Hợp đồng: PR #2 `order-channel-state` vẫn OPEN, chưa review từ 13/11 (Phúc + Tài chốt trước 17/11). Checkout contracts vẫn kẹt merge 41 xung đột.
- lead.h1 xong 11:02 (gỡ 2 dòng cổng tạm .99). .63 chạy lại, runner `may-63` 2 job. Dọn máy 20:27: không dừng gì.
- Sheet 20:25: 822 task; 37 Chờ review chờ Lead (Phúc 19, Tài 10, Toàn 8); 11 Bị chặn (M12-005/006/007 cũ từ 07/11); 61 task Toàn quá hạn theo cột hạn (phần lớn 60–95%, hạn chưa dời).
- Báo cáo tuần 16–21/11: chưa có thư mục kỳ. Kỳ 9–14/11 đã có tổng hợp gửi Chú; cột "đã gửi" trên Sheet còn "Chưa gửi" cả 9 dòng.
- Sổ Project Control: 181 mục chưa commit từ `ccb5bb7` (14/11), repo công khai.

## Cần Lead quyết (bảng đầu phiên 20:3x)

| Mã | Nội dung | Đề xuất | Hạn |
|---|---|---|---|
| lead.92 | Nâng số bảo đảm hạn giữ trong hợp đồng `m12-noi-m3` 60 phút → 26 giờ (m12 sửa, push hỏi Toàn) | có | 17/11 |
| lead.93 | Fast-forward `main` hợp đồng lên đầu `m12-noi-m3` (sau lead.92) bằng push refspec, không đụng checkout kẹt | có | 17/11 |
| lead.94 | `deploy-99` ops-core: Phien M12 soát trước (seed, env giữ hàng, R-BOD) rồi Toàn bấm | sáng 17/11 | 17/11 |
| lead.95 | Giờ buổi E07 → E02 + E03 → E08 trên .99 (Toàn đặt đơn thử) | 17/11 09:00 | 17/11 |
| lead.96 | `toandeptrai` `d3d91686d` đã lên GitHub (push 20:27, khuôn xanh); còn PR vào `dev` + gộp khi CI xanh = m34.113 | có | 17/11 |
| lead.97 | M4 buổi sếp test: m34 soạn trả lời Q4a–e của Tài + bật cờ khung chat trên image .99 (Toàn duyệt) | có | chiều 17/11 |
| lead.98 | Commit sổ Project Control sau quét bí mật (không push) | có | 16/11 |
| m7.WP31 | T222/WP31 (~98 giờ) trong Mốc 1 (A) hay sau 30/11 (B) | B | 17/11 |
| m12/m8 | Bật lại lab UAT m12 · m8.92 thêm chú vào `m8-builders.json` · m7.174 | có · có · có | 17/11 |

Không gấp: m12.100 A, m12.109 A, m5.20 giữ. Tồn từ 05/11: lead.1/45, lead.44, lead.53, lead.56, lead.64; m34.7.

## Việc Toàn tự làm

Dán `tools/sheet-lead/Code.gs` 1.5.2 + deploy · gửi tin Phúc (bàn giao m34), Tài (`tin/2026-11-16_tai_m5-m6-m4.md`, trả lời cờ seed), Anh Tuấn (`mkt.`) ·
CA + cổng 8446 cho Tài · DL-230 SMK (18/11) · chọn Page Facebook thật cho pilot (18/11) · xoá 2 nhánh `chudung/m12-*` GitHub · M7 .63: đăng nhập Claude + Codex, chép 5 ảnh, duyệt T222.

## Việc ngoài gần hạn

**D-lead-057 (17/11):** cổng vào HTTPS chuyển sang bên mình — proxy Caddy trên .98, tên giữ như cũ và public hết. **Kế hoạch chuẩn một lần + checklist + tin 14 câu chốt Anh Tuấn:**
`may-chu/2026-11-17-ke-hoach-ten-mien-public.md` (đích chạy thật 18/11, chậm nhất 19/11). **D-lead-058:** chứng chỉ wildcard Mắt Bão (Toàn mua), RAM .98 trên 8 GB, việc tự làm được không hỏi Anh Tuấn (.64, khoá tổng đài, JWT, staging, sao lưu). Tin 5 việc nhờ + Excel: Toàn gửi.
Go/No-go M4/M5/M6 ≤ 20/11 · cổng NK-b + rà lại M3 20/11 · Phúc M3-181 21/11 · Tài M5-144 24/11 · MobiFone trunk ~24/11 · Chú: lời thoại 3 miền + 455 tên, tài liệu M9.
