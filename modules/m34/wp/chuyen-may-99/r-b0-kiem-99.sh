# r-b0-kiem-99.sh (.99, CHỈ ĐỌC): .99 đủ điều kiện nhận TRƯỚC khi .60 ngừng phục vụ ở B1 (hỏng ở đây thì .60 chưa đổi gì).
[ -d "$G" ] && [ ! -L "$G" ] && [ "$(readlink -f "$G")" = "$G" ] || dung "$G không phải thư mục thật"
cd "$G"
[ -f .env ] || dung "thiếu .env trong $G (pha A chưa chạy?)"
[ "$(doc_env M34_BIND_IP)" = 192.168.1.99 ] || dung ".env .99 chưa đổi M34_BIND_IP (A3 chưa chạy?)"
[ -n "$(docker compose ps -q --status running pg)" ] || dung "pg trên .99 không chạy (pha A chưa xong?)"
for s in be fe nginx m8that-cb; do
  [ -z "$(docker compose ps -q --status running "$s" 2>/dev/null)" ] || dung "$s đang chạy trên .99 (A8 phải tắt)"
done
if grep -qF "$D99" <<< "$(crontab -l 2>/dev/null || true)"; then dung "crontab .99 đã có dòng của $D99 (lượt cắt trước chưa gỡ? lui-60.sh gỡ)"; fi
[ -d "$SL99/chuyen-may" ] && [ -w "$SL99/chuyen-may" ] || dung "$SL99/chuyen-may chưa có hoặc không ghi được"
con=$(df -P /data | awk 'NR == 2 {print $4}')
[ "${con:-0}" -ge 5242880 ] || dung "/data còn dưới 5 GiB"
echo "  .99 sẵn: $G, pg chạy, đường vào tắt, /data còn $((con / 1048576)) GiB"
# compose.override.yml (ngoài repo, chép từ .60) còn 192.168.1.60: in loại dòng / tên khoá (không in giá trị). Còn dòng KHÔNG phải chú thích
# thì dừng (trước B1, .60 chưa đổi gì) trừ khi đối số 1 = co (phaB-cat.sh truyền M34_OVERRIDE_DA_XEM).
if [ -f compose.override.yml ] && grep -q '192\.168\.1\.60' compose.override.yml; then
  echo "  compose.override.yml còn 192.168.1.60 (loại dòng / tên khoá, không giá trị):"
  grep -n '192\.168\.1\.60' compose.override.yml | sed -E "s/^([0-9]+):[[:space:]]*#.*/  dòng \1: chú thích/;t;s/^([0-9]+):[[:space:]]*-?[[:space:]]*[\"']?([A-Za-z_][A-Za-z0-9_.-]*)[[:space:]]*[=:].*/  dòng \1: khoá \2/;t;s/^([0-9]+):[[:space:]]*-?[[:space:]]*[\"']?[0-9].*/  dòng \1: gắn cổng\/IP/;t;s/^([0-9]+):.*/  dòng \1: (khác)/" || true
  khac=$(grep -n '192\.168\.1\.60' compose.override.yml | grep -cvE '^[0-9]+:[[:space:]]*#' || true)
  if [ "${khac:-0}" -gt 0 ] && [ "${1:-khong}" != co ]; then
    dung "compose.override.yml còn $khac dòng có 192.168.1.60 không phải chú thích (loại ở trên); .60 chưa đổi gì. Khoá trỏ M7/.60 thật: giữ, chạy lại với M34_OVERRIDE_DA_XEM=co. URL của chính M3: sửa trên .99 trước"
  fi
fi
echo B0_99_XONG
