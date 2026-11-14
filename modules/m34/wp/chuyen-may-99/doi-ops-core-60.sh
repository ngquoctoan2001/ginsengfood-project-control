#!/usr/bin/env bash
# Pha M (một lần, ngay sau tin "m12 cắt xong" ở cuối hop-thu/m34-2026-11-13-m12-sang-99.md, TRƯỚC pha B):
# M3 trên .60 chuyển sang gọi M1–M2 ở .99: OPS_CORE_BASE_URL=http://192.168.1.99:5000 trong ~/m34/.env, tạo lại be (~1 phút),
# thử be -> M12. Pha B (B3b) chép .env này sang .99. Không chạy khi .60 đang trong cửa sổ cắt (be/nginx dừng) hay đã qua pha D.
# Bí mật client M3 không đổi (m12: CSDL M12 chép nguyên từ .61). Danh sách nguồn phía M12 và kiem-token là việc của m12.
# Chạy: bash "C:/Projects/Project Control/modules/m34/wp/chuyen-may-99/doi-ops-core-60.sh"
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
LOG="$NHAT_KY_LOCAL/doi-ops-core-$(moc).log"
{
  tieu_de "M .60: OPS_CORE_BASE_URL -> http://192.168.1.99:5000 (m12 đã cắt xong), tạo lại be, thử be -> M12"
  chay 60 r-doi-ops-core-60.sh
  tieu_de "PHA M XONG (dòng trên: đã đổi, hoặc KHÔNG CẦN vì be .60 không bật gọi M12); pha B (B3b) chép .env này sang .99"
} 2>&1 | tee "$LOG"
