# r-m8-cb-99.sh (.99): cầu callback M8 → M3 (m8that-cb, :8445).
#   do [khoảng]           CHỈ ĐỌC: IP nguồn bị cầu chặn (access forbidden) trong khoảng (mặc định 60m) + M8_ALLOW_IP hiện tại
#   dat <ip> [co-172]     đặt M8_ALLOW_IP=<ip> trong .env (bản cũ lưu cạnh), up --wait (m8that-bi-mat kiểm tham số, cầu tạo lại),
#                         kiểm cấu hình cầu có `allow <ip>;`; hỏng thì tự lùi. Từ chối IP = M3_CB_BIND_IP (compose cấm) và dải 172.x
#                         của Docker trừ khi có co-172 (M8_THAT.md: không nới allow sang 172.x khi Toàn chưa quyết).
cd "$G"
LENH=${1:?thiếu lệnh do|dat}
case $LENH in
  do)
    tu=${2:-60m}
    [[ $tu =~ ^[0-9]+[mh]$ ]] || dung "khoảng sai dạng (vd 60m, 2h)"
    echo "-- cầu m8that-cb: nguồn bị chặn trong $tu qua (số lượt, IP)"
    nk=$(docker compose logs --no-log-prefix --since "$tu" m8that-cb 2>&1 || true)
    grep -o 'access forbidden by rule, client: [0-9.]*' <<< "$nk" | sed 's/.*client: //' | sort | uniq -c || true
    echo "  dòng nhật ký cầu trong $tu: $(grep -c . <<< "$nk" || true)"
    echo "M8_ALLOW_IP trong .env: $(doc_env M8_ALLOW_IP) (trống = mặc định 192.168.1.61) · M3_CB_BIND_IP: $(doc_env M3_CB_BIND_IP)"
    echo M8_CB_DO_XONG
    ;;
  dat)
    IP=${2:?thiếu ip}
    [[ $IP =~ ^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}$ ]] || dung "IP sai dạng: $IP"
    [ "$IP" != "$(doc_env M3_CB_BIND_IP)" ] || dung "IP $IP trùng M3_CB_BIND_IP (compose cấm): cần phương án khác, Toàn quyết"
    case $IP in 172.*) [ "${3:-}" = co-172 ] || dung "IP $IP thuộc dải Docker 172.x: chỉ đặt khi Toàn duyệt (co-172)" ;; esac
    ts=$(date -u +%Y%m%dT%H%M%SZ)
    cp -p -- .env ".env.truoc-m8-allow-$ts"; chmod 600 ".env.truoc-m8-allow-$ts"
    KHOA_RE='^(export[[:space:]]+)?M8_ALLOW_IP='
    if grep -Eq "$KHOA_RE" .env; then
      sed -i --follow-symlinks -E "s#${KHOA_RE}.*#\\1M8_ALLOW_IP=$IP#" .env
    else
      printf 'M8_ALLOW_IP=%s\n' "$IP" >> .env
    fi
    lui_lai() { echo "-- TỰ LÙI: chép lại .env.truoc-m8-allow-$ts, up lại"; cp -p -- ".env.truoc-m8-allow-$ts" .env; docker compose up -d --no-build --wait || true; }
    [ "$(sed -nE "s/${KHOA_RE}//p" .env | sort -u)" = "$IP" ] || { lui_lai; dung "sửa M8_ALLOW_IP không ăn"; }
    cfg=$(docker compose config)
    grep -qE "^[[:space:]]*allow $IP;" <<< "$cfg" || { lui_lai; dung "cấu hình cầu chưa có allow $IP"; }
    echo "-- up --wait (cầu tạo lại; bản cũ .env.truoc-m8-allow-$ts)"
    docker compose up -d --no-build --wait || { lui_lai; dung "up --wait chưa khoẻ (đã tự lùi)"; }
    # compose không tạo lại container khi chỉ nội dung configs đổi (14/11: cầu vẫn chạy allow cũ) -> tạo lại cầu, kiểm cấu hình ĐANG CHẠY
    docker compose up -d --no-build --force-recreate --wait m8that-cb || { lui_lai; docker compose up -d --no-build --force-recreate --wait m8that-cb || true; dung "tạo lại cầu hỏng (đã tự lùi)"; }
    dang=$(docker compose exec -T m8that-cb sh -c 'cat /etc/nginx/conf.d/*.conf' < /dev/null 2>/dev/null || true)
    grep -qE "^[[:space:]]*allow $IP;" <<< "$dang" || { lui_lai; docker compose up -d --no-build --force-recreate --wait m8that-cb || true; dung "cầu đang chạy chưa có allow $IP (đã tự lùi)"; }
    docker compose ps --format '  {{.Service}} {{.State}} {{.Health}}'
    printf '  /api/health/ready %s\n' "$(ma_http http://192.168.1.99/api/health/ready)"
    echo "M8_ALLOW_IP=$IP"
    echo M8_CB_DAT_XONG
    ;;
  *) dung "lệnh lạ: $LENH (do|dat)" ;;
esac
