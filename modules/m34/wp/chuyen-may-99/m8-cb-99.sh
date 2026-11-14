#!/usr/bin/env bash
# Cầu callback M8 → M3 trên .99 (sau khi m8 cắt sang .99):
#   bash m8-cb-99.sh do [60m]            CHỈ ĐỌC: IP nguồn M8 bị cầu chặn (để biết đặt M8_ALLOW_IP nào)
#   bash m8-cb-99.sh dat <ip> [co-172]   đặt M8_ALLOW_IP (Toàn duyệt; 172.x cần co-172), tạo lại cầu, tự lùi nếu hỏng
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
LOG="$NHAT_KY_LOCAL/m8-cb-99-$(moc).log"
{
  tieu_de "cầu M8 .99: $*"
  chay 99 r-m8-cb-99.sh "$@"
} 2>&1 | tee "$LOG"
