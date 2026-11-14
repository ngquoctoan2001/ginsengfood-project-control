#!/usr/bin/env bash
# Pha 0 (CHỈ ĐỌC, cả hai máy): hiện trạng ~/m34 trên .60, nền .99 và /data/ginsengfood-business-platform; chạy thử đổi cron. Không đổi gì.
# Chạy: bash "C:/Projects/Project Control/modules/m34/wp/chuyen-may-99/pha0-kiem.sh"
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
REPO=${M34_REPO:-C:/Projects/ginsengfood-business-platform}
LOG="$NHAT_KY_LOCAL/pha0-$(moc).log"
{
  tieu_de "0.1 .60 ~/m34 (chỉ đọc)"; chay 60 r-kiem-60.sh
  tieu_de "0.2 .60 cron gói m34 đổi sang .99 (chạy thử, chỉ đọc)"; chay 60 r-cron-thu.sh
  tieu_de "0.3 .99 nền + $D99 (chỉ đọc)"; chay 99 r-kiem-99.sh
  tieu_de "0.4 nginx/m34.conf: .60 (<) so với toandeptrai (>) sẽ đặt lên .99 ở A5b (realip LAN /23, khối by-code M3-181); không có bí mật"
  git -C "$REPO" show "toandeptrai:deploy/m34/nginx/m34.conf" \
    | lenh 60 'f=~/m34/nginx/m34.conf; if [ -f "$f" ]; then d=$(diff "$f" - || true); printf "  %s dòng khác\n" "$(printf "%s\n" "$d" | grep -c "^[<>]" || true)"; printf "%s\n" "$d" | grep -v "^[<>][[:space:]]*#" | grep "^[<>]" | head -n 60 | sed "s/^/    /" || true; else cat > /dev/null; echo "  .60 không có nginx/m34.conf"; fi'
  tieu_de "PHA 0 XONG"
} 2>&1 | tee "$LOG"
