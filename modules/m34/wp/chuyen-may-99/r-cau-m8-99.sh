# r-cau-m8-99.sh (.99): dừng / bật / xem cầu callback M8 → M3 (m8that-cb, :8445) cho ca E05/E06-B.
#   trang-thai   CHỈ ĐỌC: cầu chạy hay dừng, cổng 8445 có nghe không, lượt chặn/lượt vào 30 phút qua
#   dung         dừng riêng m8that-cb (web M3 :80 không ảnh hưởng); callback M8 tới .99:8445 sẽ bị từ chối kết nối
#   bat          bật lại m8that-cb, chờ healthy, kiểm cấu hình đang chạy còn allow M8_ALLOW_IP
cd "$G"
LENH=${1:?thiếu lệnh trang-thai|dung|bat}
tt() {
  docker compose ps -a --format '  {{.Service}} {{.State}} {{.Health}} {{.Status}}' m8that-cb
  printf '  cổng 192.168.1.99:8445: %s\n' "$(ss -ltnH | awk '{print $4}' | grep -c '^192.168.1.99:8445$' | sed 's/^0$/KHÔNG nghe/;s/^1$/đang nghe/')"
  nk=$(docker compose logs --no-log-prefix --since 30m m8that-cb 2>&1 || true)
  printf '  30 phút qua: POST vào %s · bị chặn (403) %s\n' "$(grep -c '"POST ' <<< "$nk" || true)" "$(grep -c 'access forbidden' <<< "$nk" || true)"
}
case $LENH in
  trang-thai) tt ;;
  dung)
    docker compose stop m8that-cb
    tt
    [ -z "$(docker compose ps -q --status running m8that-cb)" ] || dung "cầu vẫn chạy"
    echo "CAU_DA_DUNG $(date '+%F %T %z')"
    ;;
  bat)
    docker compose up -d --no-build --wait m8that-cb || dung "bật cầu chưa khoẻ"
    ip=$(doc_env M8_ALLOW_IP)
    dang=$(docker compose exec -T m8that-cb sh -c 'cat /etc/nginx/conf.d/*.conf' < /dev/null 2>/dev/null || true)
    grep -qE "^[[:space:]]*allow ${ip:-x};" <<< "$dang" || dung "cầu đang chạy không có allow ${ip:-?}"
    tt
    echo "CAU_DA_BAT $(date '+%F %T %z') allow=$ip"
    ;;
  *) dung "lệnh lạ: $LENH" ;;
esac
