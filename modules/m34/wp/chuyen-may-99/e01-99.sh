#!/usr/bin/env bash
# Ca E01 trên .99 (phần M3): 4 lệnh kiểm + 3 yêu cầu intake bị từ chối (uat-e01-khong-token-99, uat-e01-token-rac-99, uat-e01-sai-nguon-99).
# Không đặt đơn, không bật lịch M8. Chạy: bash "C:/Projects/Project Control/modules/m34/wp/chuyen-may-99/e01-99.sh"
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
LOG="$NHAT_KY_LOCAL/e01-99-$(moc).log"
{
  tieu_de "E01 .99: 4 lệnh kiểm + 3 yêu cầu intake bị từ chối (từ container be)"
  chay 99 r-e01-99.sh
} 2>&1 | tee "$LOG"
