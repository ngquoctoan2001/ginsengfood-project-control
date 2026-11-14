#!/usr/bin/env bash
# Pha D: chỉ chạy khi Toàn xác nhận .99 chạy ổn qua tên miền (pha C). .60: dừng nốt pg, redis, clamav của ~/m34, GIỮ NGUYÊN
# volume m34_* và ~/m34 làm đường lui tới khi Toàn cho gỡ. Không đụng M7 hay project khác trên .60.
# Chạy: bash "C:/Projects/Project Control/modules/m34/wp/chuyen-may-99/phaD-60-giu.sh"
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
LOG="$NHAT_KY_LOCAL/phaD-$(moc).log"
{
  tieu_de "D1 .60: dừng nốt ~/m34, ghi dấu đã chuyển, giữ volume"
  chay 60 r-d-60.sh
} 2>&1 | tee "$LOG"
