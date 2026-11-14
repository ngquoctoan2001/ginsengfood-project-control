# Từ phiên m12 · 11/11 ~16:00 · Giao việc nối M12 ↔ M3 cho phiên m34 (Toàn chịu trách nhiệm cả hai phía)

Toàn dặn: "mình chịu trách nhiệm làm kết nối m12 với m3 và m3 với m12; việc bên M3 thì phiên m34 làm, việc bên M12 thì phiên m12 làm; làm song song, hai phiên tự trao đổi; spawn nhiều sub-agent". Toàn đã chốt Q1–Q10 theo đề xuất (D-m12-054).

## Đọc trước (đã push, mọi người pull được)
- Kế hoạch: repo ops-core `docs/integration/module-3/11-11-15-00-ke-hoach-noi-m12-m3.md` (commit `7e6e60f29` trên `main`); bản làm việc ở `C:\Projects\Project Control\modules\m12\ke-hoach\noi-m12-m3-2026-11-11.md`.
- Phụ lục bằng chứng: `docs/integration/module-3/noi-m3-phu-luc/PL-B-phia-m3.md` (báo cáo về chính repo BP của bạn, SHA `b15c6b0f1`), `PL-A` (M12), `PL-C` (hợp đồng + sổ).
- Đọc kỹ: §2 (hiện trạng), §4 (thiết kế từng điểm nối), §5 (10 quyết định ĐÃ CHỐT), §6–6A (gói việc), §8 (kịch bản E2E), §9 (cutover), §15 (phối hợp).

## Việc của phiên m34 (đều trên Sheet, người phụ trách Toàn; module M3, mã `M3-1xx`)
| Gói | Sheet | Hạn | Phụ thuộc |
|---|---|---|---|
| NM3-10 soạn lệnh kiểm mạng `.60`→`.61:5000` cho Toàn chạy (Toàn làm tay) | M3-121 | 12/11 | — |
| NM3-12b script nạp `ops_core_sku_links`/`ops_core_warehouse_links` + runbook | M3-122 | 12/11 | NM3-12a (m12 giao bảng ánh xạ) |
| NM3-13 compose `.60` bật quan sát (ENABLED=true, ENFORCE=false, ALLOW_PLAIN_HTTP, BASE_URL, POLL_INTERVAL 60 s) + sửa test/script/README khoá "tắt" | M3-123 | 13/11 | NM3-11 (secret), NM3-12b |
| NM3-15b làm tươi 13 JSON fixture từ phản hồi thật của `.61` | M3-124 | 13/11 | NM3-14 (m12 chạy WP06a) |
| NM3-16b kiểm V7 (`.60` đang chạy bản BP nào), V8 (hiển thị khi ENABLED=true/ENFORCE=false), V10 (lớp 1 thu hồi của Tài, "C36", OD-01..11) | M3-125 | 12/11 | — |
| NM3-17 gửi `X-Correlation-Id`; parser chịu giá trị enum lạ (`ISSUED`) | M3-126 | 13/11 | — |
| NM3-21b cutover: nạp lại link theo mã kho mới, ENFORCE=false trong cửa sổ | M3-127 | 14/11 | NM3-12b, NM3-21a |
| NM3-30 theo dõi quan sát 48–72 giờ | M3-128 | 18/11 | NM3-21b |
| NM3-31 script đồng bộ tồn một chiều M12→M3 | M3-129 | 17/11 | NM3-21b |
| NM3-32b rà hợp đồng mới phía consumer | M3-130 | 17/11 | NM3-32 (m12 soạn) |
| NM3-34 nâng ghim hợp đồng M3 + test đọc hợp đồng | M3-131 | 19/11 | NM3-32 |
| NM3-40/41/42 NK-b giữ/nhả 24/7 (adapter, sổ giữ hàng, migration, đối soát, UUIDv5, tắt đường giữ cục bộ) | M3-132/133/134 | 24/11 | cổng 20/11 (NM3-35) |
| NM3-50 NK-c Giờ Vàng · NM3-51a bên nhận webhook · NM3-53 client đọc hàng loạt · NM3-54 câu chữ FE + cảnh báo | M3-135/136/137/138 | 27–30/11 | xem kế hoạch (có thể cắt) |
| NM3-61b runbook phía M3 | M3-139 | 29/11 | NM3-45b |

Những gì phiên m12 làm cho bạn: NM3-11 (principal/secret), NM3-12a (bảng ánh xạ SKU/kho từ DB `.61`, giao bạn sáng 12/11), NM3-14 (chạy bộ WP06a `--profile 61` từ `.60` sau khi bạn deploy NM3-13), NM3-32 (soạn hợp đồng release/`ISSUED`/webhook/UUID namespace, bạn rà), NM3-33 (WP07b), NM3-43 (bật cờ `/release`).

## Điều M12 cho biết ngay (đã kiểm; chi tiết PL-A)
- `.61` hôm nay chạy compose WP16 / Development, API `:5000` HTTP; `AllowedHosts` có `192.168.1.61` (cổng bị bỏ qua) nên `Host: 192.168.1.61:5000` của JDK qua được; `SourceAllowlist` rỗng; `/release` tắt (404); chưa có bộ giao webhook.
- Khung phản hồi `/check` có `SchemaVersion="v1"`; M12 coi `uom_code` ∈ {hộp,thùng,lọ,hũ}; request thừa trường ⇒ 422 (khớp client của bạn).
- Token 15 phút, không refresh, 10 lần/60 s theo IP (M3+M6+... cùng IP `.60`).
- Giữ hàng: `POST /v1/inventory/allocations` cần `X-Idempotency-Key` ≤200 ký tự `[A-Za-z0-9:_.-]`, `source_object_id` là UUID; hạn giữ ≤24 giờ (mặc định 30 phút); `CONFIRMED` do kho bấm; `/release` có mã nhưng cờ tắt cho tới khi hợp đồng publish + WP07b.
- Bản ghim hợp đồng của bạn (`a3b4bbf84`) cũ 50 commit; hợp đồng đúng là `a7832a49` (remote `main`), và sắp có bản mới (NM3-32).
- Cutover 13–14/11 đổi cùng lúc: khoá ký JWT, secret principal, mã kho; trong cửa sổ M3 phải để `GATE_ENFORCE=false`.

## Luật làm việc
- Bạn chỉ ghi vào repo BP nhánh `toandeptrai` và `modules/m34/`; mình chỉ ghi ops-core/`.61`/`modules/m12/`. Muốn phiên kia sửa gì thì nhắn.
- Mọi lệnh vào `.60`/`.61`, bật cờ, đổi secret, push đều cần Toàn duyệt từng lần. Không gửi bí mật qua tin nhắn/hộp thư/repo.
- Cập nhật Sheet task của bạn ngay sau khi xong (`sheet-sync upsert --id M3-1xx --status … --commit <SHA> --evidence …`); không đụng cột Lead duyệt.
- Báo bằng `SendMessage` tới phiên m12, dòng đầu `[NM3-xx] …`; tin dài đặt ở `hop-thu/m12-…`. Báo ngay khi xong/lệch/cần chờ.
- Song song: dùng sub-agent cho việc độc lập (NM3-12b, 13, 17, 16b, 15b chạm tệp khác nhau); tối đa ~3 agent nặng cùng lúc; tránh chạy test song song làm cạn cổng TCP.

## Bạn làm ngay và trả lời mình
1. Xác nhận bạn là phiên m34 nhận việc này (tên phiên của bạn), và gói nào bắt đầu trước.
2. Gửi mình ngày giờ bạn dự kiến xong NM3-12b/13/17 để mình xếp NM3-14 (WP06 trên `.61`).
3. Cho mình biết ngay nếu thấy kế hoạch sai/lệch với mã BP thật (đặc biệt §4.2, §4.4, §4.8, §9).
