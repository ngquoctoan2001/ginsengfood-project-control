#!/usr/bin/env bash
# Cầu callback M8 → M3 trên .99 cho ca E05/E06-B: bash cau-m8-99.sh trang-thai|dung|bat
# trang-thai chỉ đọc; dung/bat là việc ghi trên .99 (Toàn duyệt). Web M3 :80 không bị ảnh hưởng.
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
LOG="$NHAT_KY_LOCAL/cau-m8-99-$(moc).log"
{
  tieu_de "cầu M8 .99: $*"
  chay 99 r-cau-m8-99.sh "$@"
} 2>&1 | tee "$LOG"
