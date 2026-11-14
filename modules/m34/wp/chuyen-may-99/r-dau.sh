# ---- r-dau.sh: đầu chung, chạy TRÊN MÁY ĐÍCH trước mọi r-*.sh (chung.sh ghép vào stdin, bọc cả khối trong một hàm) ----
set -Eeuo pipefail
export LC_ALL=C
umask 077
MAY=${1:?thiếu số máy}; shift
dung() { printf 'DỪNG[.%s]: %s\n' "$MAY" "$*" >&2; exit 1; }
[ "$(id -un)" = ssv ] || dung "sai tài khoản $(id -un)"
case " $(hostname -I) " in *" 192.168.1.$MAY "*) ;; *) dung "không phải máy 192.168.1.$MAY" ;; esac
# Thư mục triển khai (D-lead-037): .60 giữ ~/m34 (đường lui); .99 theo tên repo, thư mục thật dưới /data, không có ~/m34.
D99=/data/ginsengfood-business-platform
SL99=/data/sao-luu/ginsengfood-business-platform
case $MAY in
  60) G="$HOME/m34" ;;
  99) G=$D99 ;;
  *) dung "máy lạ: $MAY" ;;
esac
export DOCKER_CONFIG="$G/.docker"
unset COMPOSE_FILE COMPOSE_PATH_SEPARATOR
# Dòng cron thuộc gói m34 trên .60: có ~/m34, $HOME/m34, ${HOME}/m34 hoặc /home/ssv/m34 (theo sau là /, khoảng trắng, ; & | hoặc hết dòng).
CRON_M34='(~|\$HOME|\$\{HOME\}|/home/ssv)/m34([/[:space:];&|]|$)'
# doc_env <TÊN>: giá trị dòng cuối TÊN= trong .env của thư mục triển khai. CHỈ gọi với tên KHÔNG bí mật.
doc_env() { sed -n "s/^$1=//p" "$G/.env" | tail -n 1; }
ma_http() { curl -s -m 5 -o /dev/null -w '%{http_code}' "$1" 2>/dev/null || echo 000; }
# dem_bang: số dòng CHÍNH XÁC mọi bảng của schema public (chỉ tên bảng + số, không dữ liệu khách), sắp xếp theo tên.
dem_bang() {
  local u db
  u=$(doc_env POSTGRES_USER); db=$(doc_env POSTGRES_DB); u=${u:-ginsengfood_app}; db=${db:-ginsengfood}
  docker compose exec -T pg psql -X -q -At -F "$(printf '\t')" -U "$u" -d "$db" -v ON_ERROR_STOP=1 -c \
    "SELECT c.relname, (xpath('/row/n/text()', query_to_xml(format('SELECT count(*) AS n FROM public.%I', c.relname), false, true, '')))[1]::text
       FROM pg_class c JOIN pg_namespace s ON s.oid = c.relnamespace
      WHERE s.nspname = 'public' AND c.relkind IN ('r','p') ORDER BY 1" < /dev/null
}
# ke_volume <tên volume>: băm (tên tệp + nội dung, sắp xếp) và số tệp; không in tên tệp. Volume không có: in KHONG_CO_VOLUME, trả 1
# (không để `docker run -v` tự tạo volume rỗng rồi hai máy "khớp" nhau ở 0 tệp).
ke_volume() {
  docker volume inspect "$1" > /dev/null 2>&1 || { echo KHONG_CO_VOLUME; return 1; }
  docker run --rm --network none -v "$1:/v:ro" --entrypoint sh postgres:17 -c \
    'cd /v && printf "so_tep=%s " "$(find . -type f | wc -l)" && find . -type f -print0 | sort -z | xargs -0r sha256sum | sha256sum | cut -c1-64' < /dev/null
}
# thu_ops_core: dải mạng m34_app + thử TCP từ mạng đó tới máy:cổng của OPS_CORE_BASE_URL (be gọi M12). M12 cùng nằm trên .99 thì
# gói đi vòng chuỗi DOCKER-USER với IP nguồn là dải m34_app (CHUYEN_MAY_99.md mục 2). Chỉ thử mở kết nối, không gửi gì.
# Trả 0: thông hoặc chưa đặt URL; 1: không thông. Danh sách nguồn của M12 (mức ứng dụng) phía m12 xác nhận.
# thu_ops_core [url]: không đưa url thì đọc OPS_CORE_BASE_URL trong .env.
thu_ops_core() {
  local url hp h p dai
  dai=$(docker network inspect m34_app --format '{{range .IPAM.Config}}{{.Subnet}} {{end}}' 2>/dev/null || true); dai=${dai%" "}
  url=${1:-$(doc_env OPS_CORE_BASE_URL)}
  if [ -z "$url" ]; then echo "  m34_app ${dai:-?} · OPS_CORE_BASE_URL chưa đặt"; return 0; fi
  hp=${url#*://}; hp=${hp%%/*}; h=${hp%:*}; p=${hp##*:}
  if [ "$h" = "$hp" ]; then case $url in https:*) p=443 ;; *) p=80 ;; esac; fi
  [[ $h =~ ^[A-Za-z0-9.-]+$ && $p =~ ^[0-9]+$ ]] || { echo "  OPS_CORE_BASE_URL dạng lạ, không thử"; return 1; }
  if docker run --rm --network m34_app --entrypoint bash postgres:17 -c "timeout 5 bash -c 'exec 3<>/dev/tcp/$h/$p'" > /dev/null 2>&1; then
    echo "  m34_app ${dai:-?} · OPS_CORE $h:$p thông"; return 0
  fi
  echo "  m34_app ${dai:-?} · OPS_CORE $h:$p KHÔNG THÔNG (DOCKER-USER cho dải m34_app tới :$p? M12_SOURCE_ALLOWLIST?)"; return 1
}
# doi_cron_99: stdin = dòng cron gói m34 của .60 (giờ VN) -> stdout = dòng cho .99 (múi UTC, thư mục $D99). Chỉ đổi đường và trường
# GIỜ (cộng 17 mod 24 = trừ 7); phút, ngày, tháng, lệnh giữ nguyên từng ký tự. Giờ lùi qua nửa đêm UTC thì thứ trong tuần lùi một ngày;
# lùi ngày khi trường ngày/tháng cố định, hoặc giờ dạng khoảng a-b, hoặc @hourly/@daily...: không tự đổi, in "LOI_DOI_GIO <dòng>" ra
# stderr và trả 1 (các dòng khác vẫn ra stdout). Dòng VAR=..., chú thích, @reboot: chỉ đổi đường.
doi_cron_99() {
  sed -E "s#(~|\\\$HOME|\\\$\\{HOME\\}|/home/ssv)/m34([/[:space:];&|]|\$)#$D99\\2#g" | awk '
    function bao(l) { print "LOI_DOI_GIO " l > "/dev/stderr"; loi = 1 }
    function ds_gio(   h, s) { s = ""; for (h = 0; h < 24; h++) if (co[h]) s = s (s == "" ? "" : ",") h; return s }
    /^[[:space:]]*(#|$)/ || /^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*=/ || /^[[:space:]]*@reboot[[:space:]]/ { print; next }
    /^[[:space:]]*@/ { bao($0); next }
    {
      dong = $0; sub(/^[[:space:]]+/, "", dong)
      # mawk (Ubuntu 22.04) không có {n}: viết đủ 5 trường
      if (!match(dong, /^[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+/)) { bao($0); next }
      dau = substr(dong, 1, RLENGTH); con = substr(dong, RLENGTH + 1)
      split(dau, f, /[[:space:]]+/)
      phut = f[1]; gio = f[2]; ngay = f[3]; thang = f[4]; thu = f[5]
      if (gio == "*") { print; next }
      split("", co); lui = 0; giu = 0
      if (gio ~ /^\*\/[0-9]+$/) {
        buoc = substr(gio, 3) + 0
        if (buoc < 1 || buoc > 23) { bao($0); next }
        for (h = 0; h < 24; h += buoc) { co[(h + 17) % 24] = 1; if (h < 7) lui++; else giu++ }
      } else if (gio ~ /^[0-9]+(,[0-9]+)*$/) {
        k = split(gio, gs, ","); hong = 0
        for (i = 1; i <= k; i++) { g = gs[i] + 0; if (g > 23) hong = 1; co[(g + 17) % 24] = 1; if (g < 7) lui++; else giu++ }
        if (hong) { bao($0); next }
      } else { bao($0); next }
      thu_moi = thu
      if (lui) {
        if (ngay != "*" || thang != "*") { bao($0); next }
        if (thu != "*") {
          if (giu || thu !~ /^[0-7](,[0-7])*$/) { bao($0); next }
          k = split(thu, ts, ","); thu_moi = ""
          for (i = 1; i <= k; i++) thu_moi = thu_moi (i > 1 ? "," : "") ((ts[i] + 6) % 7)
        }
      }
      print phut " " ds_gio() " " ngay " " thang " " thu_moi " " con
    }
    END { exit loi }'
}
# ---- hết r-dau.sh ----
