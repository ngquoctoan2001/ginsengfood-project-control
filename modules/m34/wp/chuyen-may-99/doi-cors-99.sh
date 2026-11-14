#!/usr/bin/env bash
# Trước/khi Anh Tuấn trỏ cổng vào: thêm https://ginsengfood.vn, https://www.ginsengfood.vn vào CORS_ALLOWED_ORIGINS của M3 trên .99
# (14/11 08:10 đo: preflight Origin https://ginsengfood.vn ra 403, LAN ra 200 → đăng nhập/POST qua tên miền sẽ hỏng). Tự kiểm, tự lùi.
# Chạy: bash "C:/Projects/Project Control/modules/m34/wp/chuyen-may-99/doi-cors-99.sh"
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
LOG="$NHAT_KY_LOCAL/doi-cors-99-$(moc).log"
{
  tieu_de "CORS .99: thêm tên miền ginsengfood.vn (+ www), giữ LAN; tạo lại be ~1 phút"
  chay 99 r-cors-99.sh
  tieu_de "CORS XONG"
} 2>&1 | tee "$LOG"
