#!/usr/bin/env bash
# Chạy thử MỌI PHA trên host giả (không mạng, không ssh thật), trong container Linux:
#   docker run --rm -v "C:/Projects/Project Control/modules/m34/wp/chuyen-may-99:/kb:ro" \
#     -v "C:/Projects/ginsengfood-business-platform:/va:ro" python:3.12-slim bash /kb/thu-gia.sh
# (/va = repo; git giả đọc bản vá "toandeptrai" từ cây làm việc /va/deploy/m34.)
# .60 ở ~/m34; .99 ở /data/ginsengfood-business-platform (D-lead-037), sao lưu /data/sao-luu/ginsengfood-business-platform.
# K1: 0 -> A -> M (m12 cắt xong: .60 gọi M12 ở .99) -> B -> C -> (.99 ghi thêm: lui bị chặn) -> D -> (lui bị chặn; Toàn quyết co: lui được).
# K2: nền còn ~/m34 cũ; B hỏng ở B6 -> .99 không vào được lúc lui (vẫn lui) -> cắt lại (crontab .60 mới được lưu) -> B4 dừng -> lui.
# K3: pha M không tới .99:5000 -> dừng trước khi sửa; chặn bán M12 bật, be .99 không tới M12 -> B6 dừng -> lui; lui lần 2 giữ dòng cron mới.
# K4–K6: dump lệch sha256 (B3), số dòng lệch (B5), volume lệch (B4) -> dừng -> lui. K7: sai máy. K8: chưa có thư mục (chưa sudo mv).
# K9: pha M với .env symlink + export. K10: awk đổi giờ cron hỏng ở B7. K11: pha M đọc giá trị be nhận (tắt OPS_CORE / override đặt đè).
# K12: B0b — volume .99 có tệp .60 không có y hệt -> dừng trước B1; chỉ có tệp trùng (be tự sinh ở A8) -> B4 làm rỗng rồi chép.
set -Eeuo pipefail
export LC_ALL=C
KB=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
VA=${M34_VA_GOC:-/va}
BI_MAT=GIA_BI_MAT_KHONG_DUOC_IN
# override giả có dòng gắn cổng .60 (không phải chú thích): mọi pha B mặc định coi như đã xem; K1 thử riêng cổng chặn B0.
export M34_OVERRIDE_DA_XEM=co
D99=/data/ginsengfood-business-platform
SL99=/data/sao-luu/ginsengfood-business-platform
loi=0
kiem() { if eval "$2"; then echo "  ĐẠT  $1"; else echo "  HỎNG $1"; loi=1; fi; }

dung_the_gioi() {
  GIA_GOC=$(mktemp -d)/gia; export GIA_GOC
  rm -rf /data/m34 /data/sao-luu "$D99"; mkdir -p "$SL99"
  # Nền .99 (D-lead-037): thư mục thật rỗng có sau lệnh sudo mv của Toàn; "chua-mv" giả lúc Toàn chưa chạy lệnh đó.
  if [ "${1-}" != chua-mv ]; then mkdir -p "$D99"; fi
  local h60="$GIA_GOC/may60/home" h99="$GIA_GOC/may99/home"
  mkdir -p "$h60/m34" "$h99" "$GIA_GOC/may60/vol" "$GIA_GOC/may99/vol" "$GIA_GOC/git-bin"
  # "co-m34-cu": nền cũ còn ~/m34 trên .99 (D-lead-037 bỏ): kịch bản chỉ báo, không dùng, không xoá.
  if [ "${1-}" = co-m34-cu ]; then mkdir -p "$h99/m34"; echo cu > "$h99/m34/dau-cu"; fi
  # ---- ~/m34 giả trên .60
  cd "$h60/m34"
  cat > .env <<EOF
M34_KHO=ghcr.io/phucapu/ginsengfood-business-platform
M34_BAN=f9e179a450915ff2fafa69ca55484a6f47f55101
COMPOSE_FILE=compose.yml:compose.override.yml:compose.m8-that.yml
M34_BIND_IP=192.168.1.60
CORS_ALLOWED_ORIGINS=http://192.168.1.60,https://ginsengfood.vn
POSTGRES_PASSWORD=$BI_MAT
JWT_SECRET=${BI_MAT}_2
POSTGRES_USER=ginsengfood_app
POSTGRES_DB=ginsengfood
M8_ORIGIN=https://192.168.1.61:8443
OPS_CORE_BASE_URL=http://192.168.1.61:5000
EOF
  chmod 600 .env
  echo "f9e179a450915ff2fafa69ca55484a6f47f55101 2026-11-13" > PHIEN_BAN
  echo "services: {}" > compose.yml
  mkdir -p nginx; printf '# nginx cũ của .60\nserver { listen 80; }\n' > nginx/m34.conf
  printf 'services:\n  be:\n    environment:\n      GIA_KHOA: GIA_GIA_TRI_OVERRIDE\n  nginx:\n    ports:\n      - "192.168.1.60:8080:8080"\n    # chú thích có 192.168.1.60\n' > compose.override.yml
  mkdir -p -m 700 secrets m8-that/bi-mat sao-luu nhat-ky m8-gia-lap .docker
  echo "$BI_MAT" > secrets/ops_core_client_secret
  echo "$BI_MAT" > m8-that/bi-mat/ca-m3-key.pem
  echo '{"auths":{"ghcr.io":{"auth":"'"$BI_MAT"'"}}}' > .docker/config.json
  printf '#!/usr/bin/env bash\necho "CHUNG-THU-CAU: giả, SAN IP:$(sed -n "s/^M3_CB_BIND_IP=//p" .env)"\n' > m8-that/tao-chung-thu-cau.sh
  echo "dump cũ" > sao-luu/truoc-trien-khai-20261113T000000Z-f9e179a4.dump
  echo "log cũ" > nhat-ky/trien-khai.log
  for f in canh-bao.sh cong-tac-khan.sh m8-gia-lap/lam-moi-ton-thu.sh trien-khai.sh cd-entry.sh; do
    echo "# bản cũ của .60: ~/m34 cứng" > "$f"; chmod 755 "$f"
  done
  printf '# bản cũ .60\nexport DOCKER_CONFIG="${HOME:?}/m34/.docker"\n' > sao-luu/sao-luu.sh
  # ---- dữ liệu .60: CSDL (TSV bảng/số dòng), volume, crontab, dịch vụ đang chạy
  printf 'customers\t41\norders\t312\nflyway_schema_history\t350\n' > "$GIA_GOC/may60/db"
  mkdir -p "$GIA_GOC/may60/vol/m34_uploads/media/2026" "$GIA_GOC/may60/vol/m34_mail" "$GIA_GOC/may60/vol/m34_redis/appendonlydir" "$GIA_GOC/may60/vol/m34_clamav"
  echo anh1 > "$GIA_GOC/may60/vol/m34_uploads/media/2026/a.jpg"; echo anh2 > "$GIA_GOC/may60/vol/m34_uploads/media/2026/b.png"
  mkdir -p "$GIA_GOC/may60/vol/m34_uploads/seed"; echo seed1 > "$GIA_GOC/may60/vol/m34_uploads/seed/s1.png"   # be .60 cũng tự sinh tệp này
  echo thu > "$GIA_GOC/may60/vol/m34_mail/otp.eml"; echo aof > "$GIA_GOC/may60/vol/m34_redis/appendonlydir/x.aof"
  echo cvd > "$GIA_GOC/may60/vol/m34_clamav/main.cvd"
  mkdir -p "$GIA_GOC/may60/vol/m34_pg"
  printf '%s\n' '30 22 * * * PATH=/usr/local/bin:/usr/bin:/bin /home/ssv/m34/sao-luu/sao-luu.sh >>/home/ssv/m34/nhat-ky/sao-luu-cron.log 2>&1' \
    '*/5 * * * * bash ~/m34/m8-gia-lap/lam-moi-ton-thu.sh >> ~/m34/nhat-ky/lam-moi-ton-thu.log 2>&1' \
    '0 3 * * 1 cd /home/ssv/m34 && bash canh-bao.sh  >> nhat-ky/tuan.log 2>&1' \
    '0 */6 * * * $HOME/m34/ops-core/sau-gio.sh' \
    '45 1 * * * ${HOME}/m34/ops-core/dem.sh' \
    '0 3 1 * * /home/ssv/m34/dau-thang.sh' \
    '15 3 * * * /home/ssv/m7/sao-luu.sh' > "$GIA_GOC/may60/crontab"
  printf '%s\n' pg redis clamav be fe nginx m8that-bi-mat m8that-cb > "$GIA_GOC/may60/chay"
  # ---- git giả phía máy Toàn: đọc bản vá từ cây làm việc của repo
  cat > "$GIA_GOC/git-bin/git" <<'EOF'
#!/usr/bin/env bash
[ "$1" = -C ] && shift 2
case "$1" in show) cat "$M34_VA_GOC/${2#toandeptrai:}" ;; rev-parse) echo gia0000 ;; *) exit 1 ;; esac
EOF
  printf '#!/usr/bin/env bash\necho 200\n' > "$GIA_GOC/git-bin/curl"   # curl phía máy Toàn (B8, pha C)
  chmod +x "$GIA_GOC/git-bin/git" "$GIA_GOC/git-bin/curl"
  export M34_VA_GOC="$VA" PATH="$GIA_GOC/git-bin:$PATH"
  export M34_THU_GIA=1 M34_SSH="$KB/gia/ssh" M34_NHAT_KY="$GIA_GOC/nhat-ky-chay" M34_REPO=/khong-dung
  unset M34_H60 M34_H99
  G60="$GIA_GOC/may60"; G99="$GIA_GOC/may99"
  cd "$KB"
}
# pha <tên> <tệp ra> [biến=giá trị...]: chạy một pha, phải XONG; hỏng thì in đuôi và dừng cả bộ thử.
pha() { local t=$1 ra=$2; shift 2; env "$@" bash "$KB/$t" > "$GIA_GOC/$ra" 2>&1 || { tail -n 40 "$GIA_GOC/$ra"; echo "$t hỏng (mong XONG)"; exit 1; }; }
# pha_dung <tên> <tệp ra> <chuỗi phải có> [biến=giá trị...]: pha phải DỪNG (mã khác 0) và in chuỗi đó.
pha_dung() { local t=$1 ra=$2 chuoi=$3; shift 3; ! env "$@" bash "$KB/$t" > "$GIA_GOC/$ra" 2>&1 && grep -qF -- "$chuoi" "$GIA_GOC/$ra"; }
du_8() { [ "$(wc -l < "$1/chay")" = 8 ]; }
toi_duong_vao() { ! grep -qxE "be|fe|nginx|m8that-cb" "$1/chay"; }

echo "##### K1: 0 -> A -> B -> C -> D, lui bị chặn đúng lúc"
dung_the_gioi
pha pha0-kiem.sh k1-0.out
kiem "0: in khoá compose.override.yml, không in giá trị" 'grep -q "^  services$" "$GIA_GOC/k1-0.out" && grep -q "dòng 7 có .60" "$GIA_GOC/k1-0.out" && ! grep -q "GIA_GIA_TRI_OVERRIDE" "$GIA_GOC/k1-0.out"'
kiem "0: thư mục .99 thật, ~/m34 .99 không có" 'grep -q "$D99: thư mục thật" "$GIA_GOC/k1-0.out" && grep -q "~/m34: không có" "$GIA_GOC/k1-0.out"'
kiem "0: in khác biệt nginx .60 / toandeptrai (không in chú thích)" 'grep -q "dòng khác" "$GIA_GOC/k1-0.out" && grep -q "> set_real_ip_from 192.168.0.0/23;" "$GIA_GOC/k1-0.out" && ! grep -q "^    > #" "$GIA_GOC/k1-0.out"'
kiem "0: chạy thử đổi cron, báo dòng không đổi được" 'grep -qF ".99: 30 15 * * * PATH=" "$GIA_GOC/k1-0.out" && grep -qF "KHÔNG ĐỔI ĐƯỢC (B7 bỏ qua, sửa tay): 0 3 1 * * $D99/dau-thang.sh" "$GIA_GOC/k1-0.out"'
pha phaA-dung-99.sh k1-A.out
kiem "A: $D99 là thư mục thật, ~/m34 .99 không tạo" '[ -d "$D99" ] && [ ! -L "$D99" ] && [ ! -e "$G99/home/m34" ]'
kiem "A: .60 vẫn chạy đủ dịch vụ, không đổi crontab" 'du_8 "$G60" && grep -q "/home/ssv/m34/sao-luu" "$G60/crontab"'
kiem "A: .99 chỉ còn pg/redis/clamav(+bí mật) chạy" 'toi_duong_vao "$G99"'
kiem "A: .env .99 đổi M34_BIND_IP, M3_CB_BIND_IP, CORS" 'grep -qx M34_BIND_IP=192.168.1.99 "$D99/.env" && grep -qx M3_CB_BIND_IP=192.168.1.99 "$D99/.env" && grep -qx "CORS_ALLOWED_ORIGINS=http://192.168.1.99,https://ginsengfood.vn" "$D99/.env"'
kiem "A: .env .99 giữ bí mật + M8/ops-core như .60" 'grep -qx "POSTGRES_PASSWORD=$BI_MAT" "$D99/.env" && grep -qx OPS_CORE_BASE_URL=http://192.168.1.61:5000 "$D99/.env"'
kiem "A: không chép dump/nhật ký cũ sang .99" '[ -z "$(find "$D99/sao-luu" -name "*.dump" ! -path "*/hang-ngay/*")" ] && [ ! -e "$D99/nhat-ky/trien-khai.log" ]'
kiem "A: hang-ngay -> $SL99/hang-ngay" '[ "$(readlink -f "$D99/sao-luu/hang-ngay")" = "$SL99/hang-ngay" ]'
kiem "A: 6 script .99 là bản đường .99 của toandeptrai" 'for f in canh-bao.sh cong-tac-khan.sh m8-gia-lap/lam-moi-ton-thu.sh cd-entry.sh trien-khai.sh sao-luu/sao-luu.sh; do cmp -s "$D99/$f" "$VA/deploy/m34/$f" || exit 1; done; grep -qF "$D99" "$D99/canh-bao.sh"'
kiem "A5b: nginx .99 = bản toandeptrai (realip), bản .60 giữ .tu-60" 'cmp -s "$D99/nginx/m34.conf" "$VA/deploy/m34/nginx/m34.conf" && grep -q "nginx cũ của .60" "$D99/nginx/m34.conf.tu-60" && grep -q "nginx cũ của .60" "$G60/home/m34/nginx/m34.conf"'
kiem "A: chữ ký ClamAV sang .99" '[ -f "$G99/vol/m34_clamav/main.cvd" ]'
kiem "A: in dải m34_app + thử be -> M12" 'grep -q "m34_app 172.24.8.0/22 · OPS_CORE 192.168.1.61:5000 thông" "$GIA_GOC/k1-A.out"'
kiem "A: báo còn .60 trong compose.override.yml" 'grep -q "CÒN 192.168.1.60 trong compose.override.yml (ngoài repo) ở dòng: 7 " "$GIA_GOC/k1-A.out"'
# m12 cắt xong giữa pha A và B (D-lead-038): pha M đổi OPS_CORE_BASE_URL trên .60; giả thêm bí mật client ops-core mới (B3b phải chép)
pha doi-ops-core-60.sh k1-M.out
kiem "M: .60 OPS_CORE_BASE_URL -> .99:5000, bản .env trước 600, đủ dịch vụ, thử be -> M12" 'grep -qx OPS_CORE_BASE_URL=http://192.168.1.99:5000 "$G60/home/m34/.env" && f=$(ls "$G60/home/m34"/.env.truoc-doi-ops-core-* | head -n 1) && grep -qx OPS_CORE_BASE_URL=http://192.168.1.61:5000 "$f" && [ "$(stat -c %a "$f")" = 600 ] && [ "$(stat -c %a "$G60/home/m34/.env")" = 600 ] && du_8 "$G60" && grep -q "OPS_CORE 192.168.1.99:5000 thông" "$GIA_GOC/k1-M.out" && grep -qx M_XONG "$GIA_GOC/k1-M.out"'
kiem "M: chạy lại thì không sửa .env nữa" 'pha doi-ops-core-60.sh k1-M2.out && grep -q "đã là http://192.168.1.99:5000" "$GIA_GOC/k1-M2.out" && [ "$(ls "$G60/home/m34"/.env.truoc-doi-ops-core-* | wc -l)" = 1 ]'
echo "${BI_MAT}_MOI" > "$G60/home/m34/secrets/ops_core_client_secret"
kiem "B0: override còn dòng .60 không phải chú thích -> dừng trước B1, .60 chưa đổi" 'pha_dung phaB-cat.sh k1-B0.out "M34_OVERRIDE_DA_XEM=co" M34_OVERRIDE_DA_XEM=khong && du_8 "$G60" && [ ! -e "$G60/home/m34/_chuyen-may/b6-bat-dau" ] && grep -q "dòng 7: gắn cổng/IP" "$GIA_GOC/k1-B0.out" && grep -q "dòng 8: chú thích" "$GIA_GOC/k1-B0.out" && ! grep -q "8080:8080" "$GIA_GOC/k1-B0.out"'
pha phaB-cat.sh k1-B.out
kiem "B0b: tệp be tự sinh ở A8 trùng hệt .60 -> B4 làm rỗng rồi chép" 'grep -q "đều trùng hệt .60" "$GIA_GOC/k1-B.out" && grep -q "m34_uploads .99: đã làm rỗng 1 tệp" "$GIA_GOC/k1-B.out"'
kiem "B0: phân loại dòng .60 trong compose.override.yml, không in giá trị" 'grep -q "dòng 7: gắn cổng/IP" "$GIA_GOC/k1-B.out" && grep -q "dòng 8: chú thích" "$GIA_GOC/k1-B.out" && ! grep -q "8080:8080" "$GIA_GOC/k1-B.out"'
kiem "M trong cửa sổ cắt (be .60 dừng): dừng, không đụng .env" 'cp -p "$G60/home/m34/.env" "$GIA_GOC/env60.truoc-M3" && pha_dung doi-ops-core-60.sh k1-M3.out "không chạy (đang trong cửa sổ cắt?)" && cmp -s "$G60/home/m34/.env" "$GIA_GOC/env60.truoc-M3"'
kiem "B: .env + secrets .99 theo .60 sau khi m12 cắt, vẫn IP .99" 'grep -qx OPS_CORE_BASE_URL=http://192.168.1.99:5000 "$D99/.env" && grep -qx M34_BIND_IP=192.168.1.99 "$D99/.env" && grep -qx M3_CB_BIND_IP=192.168.1.99 "$D99/.env" && cmp -s "$G60/home/m34/secrets/ops_core_client_secret" "$D99/secrets/ops_core_client_secret" && grep -qx OPS_CORE_BASE_URL=http://192.168.1.99:5000 "$D99/.env.tu-60"'
kiem "B: B2 chạy hết (pg_dump không nuốt phần còn lại của script)" 'grep -qx B2_XONG "$GIA_GOC/k1-B.out" && grep -q "^DEM=" "$GIA_GOC/k1-B.out"'
kiem "B6: thử be -> M12 cùng máy" 'grep -q "OPS_CORE 192.168.1.99:5000 thông" "$GIA_GOC/k1-B.out"'
kiem "B: CSDL .99 = .60" 'cmp -s "$G60/db" "$G99/db"'
kiem "B: tệp tải lên .99 = .60" 'diff -r "$G60/vol/m34_uploads" "$G99/vol/m34_uploads" > /dev/null'
kiem "B: redis .99 chỉ có dữ liệu .60" 'diff -r "$G60/vol/m34_redis" "$G99/vol/m34_redis" > /dev/null'
kiem "B: .60 dừng be/fe/nginx/cầu" 'toi_duong_vao "$G60"'
kiem "B: crontab .60 hết dòng gói m34, giữ dòng m7" '! grep -q /m34 "$G60/crontab" && grep -q m7 "$G60/crontab"'
kiem "B7: 22:30 VN -> 15:30 UTC, đường mới, M34_HOST_IP + M34_HOME" 'grep -q "^30 15 \* \* \* PATH=/usr/local/bin:/usr/bin:/bin $D99/sao-luu/sao-luu.sh >>$D99/nhat-ky/sao-luu-cron.log 2>&1$" "$G99/crontab" && grep -qx M34_HOST_IP=192.168.1.99 "$G99/crontab" && grep -qx "M34_HOME=$D99" "$G99/crontab"'
kiem "B7: */5 giữ, ~/m34 -> đường mới" 'grep -qxF "*/5 * * * * bash $D99/m8-gia-lap/lam-moi-ton-thu.sh >> $D99/nhat-ky/lam-moi-ton-thu.log 2>&1" "$G99/crontab"'
kiem "B7: 03:00 thứ 2 VN -> 20:00 Chủ nhật UTC, lệnh giữ nguyên từng ký tự" 'grep -qxF "0 20 * * 0 cd $D99 && bash canh-bao.sh  >> nhat-ky/tuan.log 2>&1" "$G99/crontab"'
kiem "B7: giờ */6 VN -> 5,11,17,23 UTC" 'grep -qxF "0 5,11,17,23 * * * $D99/ops-core/sau-gio.sh" "$G99/crontab"'
kiem "B7: dòng \${HOME}/m34 cũng gỡ ở .60 và chuyển: 01:45 VN -> 18:45 UTC" 'grep -qxF "45 18 * * * $D99/ops-core/dem.sh" "$G99/crontab" && ! grep -qF "{HOME}/m34" "$G60/crontab"'
kiem "B7: dòng không đổi được thì không cài, có báo" '! grep -q dau-thang "$G99/crontab" && grep -q "CHƯA CÀI" "$GIA_GOC/k1-B.out"'
kiem "B7: crontab .99 không còn /m34, không có dòng m7" '! grep -v "^#" "$G99/crontab" | grep -q "/m34" && ! grep -q m7 "$G99/crontab"'
kiem "B: sao lưu hằng ngày nằm ở $SL99/hang-ngay" '[ -n "$(ls "$SL99/hang-ngay/")" ]'
kiem "B: dump chuyển máy ở $SL99/chuyen-may" '[ -n "$(ls "$SL99/chuyen-may/")" ]'
kiem "B: .99 chạy đủ dịch vụ" 'du_8 "$G99"'
kiem "Lui sau pha B trọn vẹn (trước C, số dòng khớp): dừng, đòi cờ" 'pha_dung lui-60.sh k1-LB.out "cổng vào có thể đã trỏ .99" && du_8 "$G99" && toi_duong_vao "$G60"'
pha phaC-kiem-cong-vao.sh k1-C.out
kiem "C: in IP kết nối nginx .99" 'grep -q "C2_XONG" "$GIA_GOC/k1-C.out" && grep -q "192.168.1.10" "$GIA_GOC/k1-C.out"'
kiem "C1b: curl giả trả 200 -> CHÚ Ý nối/chuyển nguyên XFF; C0 giữ dấu cuối B" 'grep -q "CHÚ Ý (200): nginx của Anh Tuấn NỐI" "$GIA_GOC/k1-C.out" && grep -q "C0_XONG dấu từ" "$GIA_GOC/k1-C.out"'
kiem "Lui sau pha C, số dòng còn khớp: vẫn dừng, đòi cờ Toàn" 'pha_dung lui-60.sh k1-L0.out "cổng vào có thể đã trỏ .99" && du_8 "$G99" && toi_duong_vao "$G60"'
# .99 nhận ghi sau khi cổng vào trỏ về (đơn mới)
sed -i 's/^orders\t312$/orders\t313/' "$G99/db"
kiem "Lui sau khi .99 đã ghi: dừng trước khi tắt gì, in bảng lệch" 'pha_dung lui-60.sh k1-L1.out ".99 đã ghi sau cắt" && grep -q "orders" "$GIA_GOC/k1-L1.out" && du_8 "$G99" && toi_duong_vao "$G60"'
pha phaD-60-giu.sh k1-D.out
kiem "D: .60 dừng hết, giữ volume, có tệp dấu" '[ ! -s "$G60/chay" ] && [ -d "$G60/vol/m34_pg" ] && [ -f "$G60/home/m34/DA_CHUYEN_SANG_99.txt" ]'
kiem "M sau pha D: từ chối, không đụng .env .60" 'cp -p "$G60/home/m34/.env" "$GIA_GOC/env60.truoc-MD" && pha_dung doi-ops-core-60.sh k1-MD.out ".60 đã qua pha D" && cmp -s "$G60/home/m34/.env" "$GIA_GOC/env60.truoc-MD"'
kiem "Lui sau pha D: dừng ở L0a, .99 vẫn phục vụ" 'pha_dung lui-60.sh k1-L2.out ".60 đã qua pha D" && du_8 "$G99" && grep -q "$D99" "$G99/crontab"'
pha lui-60.sh k1-L3.out M34_LUI_SAU_GHI=co
kiem "Lui có cờ Toàn: .60 bật lại, tệp dấu đổi tên, .99 tắt đường vào + gỡ cron" 'du_8 "$G60" && [ ! -e "$G60/home/m34/DA_CHUYEN_SANG_99.txt" ] && ls "$G60/home/m34/" | grep -q "DA_CHUYEN_SANG_99.txt.da-lui-" && toi_duong_vao "$G99" && ! grep -q "$D99" "$G99/crontab" && grep -q "/home/ssv/m34/sao-luu" "$G60/crontab"'
kiem "Không in bí mật ra nhật ký/đầu ra" '! grep -rq "$BI_MAT" "$GIA_GOC"/k1-*.out "$GIA_GOC/nhat-ky-chay"'
kiem "ssh giả chỉ tới .60/.99" '! grep -qv -e " ssh 60: " -e " ssh 99: " "$GIA_GOC/ssh.log"'
kiem "Chạy lại pha A khi .99 đã có dữ liệu thì dừng" 'pha_dung phaA-dung-99.sh k1-A2.out "pha A đã chạy rồi"'
K1="$GIA_GOC"

echo "##### K2: nền còn ~/m34 cũ; B hỏng ở B6; .99 không vào được lúc lui; cắt lại giữ dòng cron mới của .60"
dung_the_gioi co-m34-cu
pha phaA-dung-99.sh k2-A.out
kiem "A: báo ~/m34 cũ trên .99, không đụng" 'grep -q "CHÚ Ý: ~/m34 vẫn có trên .99" "$GIA_GOC/k2-A.out" && [ -f "$G99/home/m34/dau-cu" ] && [ -f "$D99/.env" ]'
kiem "B hỏng ở B6 thì dừng, không cài cron .99" 'pha_dung phaB-cat.sh k2-B.out "DỪNG" GIA_HONG_UP=99 && ! grep -q "$D99" "$G99/crontab" 2>/dev/null'
kiem "Lui khi .99 không vào được mà đã qua B6: dừng, đòi cờ, .60 chưa đổi" 'pha_dung lui-60.sh k2-L0.out "be .99 đã bật từ" GIA_99_CHET=1 && toi_duong_vao "$G60"'
pha lui-60.sh k2-L.out GIA_99_CHET=1 M34_LUI_SAU_GHI=co
kiem "Lui có cờ khi .99 không vào được: vẫn bật lại .60, có CẢNH BÁO" 'du_8 "$G60" && grep -q "/home/ssv/m34/sao-luu" "$G60/crontab" && grep -q "CẢNH BÁO: không kiểm được .99" "$GIA_GOC/k2-L.out" && grep -q "CẢNH BÁO: L1 hỏng" "$GIA_GOC/k2-L.out"'
echo '20 4 * * * /home/ssv/m7/moi.sh' >> "$G60/crontab"
kiem "Cắt lại: B0b thấy volume .99 (lượt trước chép) trùng hệt .60; dump lệch -> dừng ở B3" 'pha_dung phaB-cat.sh k2-B2.out "lệch sha256" GIA_HONG_CHEP=1 && grep -q "đều trùng hệt .60" "$GIA_GOC/k2-B2.out"'
kiem "Cắt lại: B1 đổi tên dấu B6 của lần trước" 'ls "$G60/home/m34/_chuyen-may/" | grep -q "^b6-bat-dau.cu-"'
kiem "Cắt lại: B1 lưu crontab mới (giữ dòng m7 mới)" 'grep -q m7/moi.sh "$G60/home/m34/_chuyen-may/crontab.60.truoc" && grep -q m7/moi.sh "$G60/crontab" && ! grep -q /m34 "$G60/crontab"'
pha lui-60.sh k2-L2.out
kiem "Lui lần 2: .60 đủ, crontab có cả dòng m34 lẫn dòng m7 mới" 'du_8 "$G60" && grep -q m7/moi.sh "$G60/crontab" && grep -q "/home/ssv/m34/sao-luu" "$G60/crontab" && toi_duong_vao "$G99"'

echo "##### K3: chặn bán theo M12 bật, be .99 không tới được M12 -> B6 dừng -> lui-60.sh"
dung_the_gioi
cp -p "$G60/home/m34/.env" "$GIA_GOC/env60.truoc-M"
kiem "M: .99:5000 không thông -> dừng trước khi sửa, .env và be giữ nguyên" 'pha_dung doi-ops-core-60.sh k3-M.out "chưa sửa gì" GIA_OPS_KHONG_THONG=1 && cmp -s "$G60/home/m34/.env" "$GIA_GOC/env60.truoc-M" && ! ls "$G60/home/m34"/.env.truoc-doi-ops-core-* > /dev/null 2>&1 && du_8 "$G60"'
kiem "M: up be hỏng sau khi sửa -> tự lùi .env" 'pha_dung doi-ops-core-60.sh k3-M2.out "đã tự lùi" GIA_HONG_UP=60 && grep -q "TỰ LÙI" "$GIA_GOC/k3-M2.out" && cmp -s "$G60/home/m34/.env" "$GIA_GOC/env60.truoc-M"'
rm -f "$G60/ops-dem"
kiem "M: thử trước thông, thử sau hỏng -> tự lùi .env" 'pha_dung doi-ops-core-60.sh k3-M3.out "đã tự lùi" GIA_OPS_THONG_LAN=1 && grep -q "TỰ LÙI" "$GIA_GOC/k3-M3.out" && cmp -s "$G60/home/m34/.env" "$GIA_GOC/env60.truoc-M" && du_8 "$G60"'
echo OPS_CORE_GATE_ENFORCE=true >> "$G60/home/m34/.env"
pha phaA-dung-99.sh k3-A.out
kiem "B6 dừng khi chặn bán bật mà không tới M12" 'pha_dung phaB-cat.sh k3-B.out "chặn bán theo M12" GIA_OPS_KHONG_THONG=1 && ! grep -q "$D99" "$G99/crontab" 2>/dev/null'
pha lui-60.sh k3-L.out
kiem "Lui (k3): .60 chạy lại đủ" 'du_8 "$G60"'
echo '5 5 * * * /home/ssv/m7/them.sh' >> "$G60/crontab"
pha lui-60.sh k3-L2.out
kiem "Lui lần 2 (không cắt lại): giữ dòng cron mới, không nhân đôi dòng m34" 'grep -q m7/them.sh "$G60/crontab" && [ "$(grep -c "/home/ssv/m34/sao-luu" "$G60/crontab")" = 1 ] && du_8 "$G60"'

echo "##### K4–K6: dữ liệu lệch trong cửa sổ -> dừng -> lui"
for ca in "K4|GIA_HONG_CHEP=1|lệch sha256" "K5|GIA_HONG_NAP=1|số dòng .99 lệch .60" "K6|GIA_HONG_VOL=1|volume hai máy lệch"; do
  IFS='|' read -r ten bien chuoi <<< "$ca"
  dung_the_gioi
  pha phaA-dung-99.sh "$ten-A.out"
  kiem "$ten: $bien -> B dừng ($chuoi)" 'pha_dung phaB-cat.sh "$ten-B.out" "$chuoi" "$bien" && ! grep -q "$D99" "$G99/crontab" 2>/dev/null && toi_duong_vao "$G99"'
  echo "7 7 * * * /home/ssv/m7/$ten.sh" >> "$G60/crontab"
  pha lui-60.sh "$ten-L.out"
  kiem "$ten: lui về .60 đủ" 'du_8 "$G60"'
  kiem "$ten: crontab đổi sau B1 -> giữ dòng mới, nối dòng m34 một lần" 'grep -q "m7/$ten.sh" "$G60/crontab" && [ "$(grep -c "/home/ssv/m34/sao-luu" "$G60/crontab")" = 1 ] && grep -q "nối lại dòng gói m34" "$GIA_GOC/$ten-L.out"'
done

echo "##### K7: sai máy"
dung_the_gioi
kiem "K7: .99 báo địa chỉ lạ -> r-dau dừng" 'pha_dung pha0-kiem.sh k7-a.out "không phải máy 192.168.1.99" GIA_SAI_IP_99=1'
kiem "K7: M34_H99 đặt nhầm .60 -> dừng trước mọi ssh" 'rm -f "$GIA_GOC/ssh.log"; pha_dung phaB-cat.sh k7-b.out "M34_H99=ssv@192.168.1.60 không phải" M34_H99=ssv@192.168.1.60 && [ ! -e "$GIA_GOC/ssh.log" ]'

echo "##### K8: chưa có thư mục .99 (Toàn chưa chạy sudo mv)"
dung_the_gioi chua-mv
kiem "K8: A1 dừng, chờ sudo mv, không tạo gì" 'pha_dung phaA-dung-99.sh k8-A.out "chờ Toàn chạy lệnh sudo mv" && [ ! -e "$D99" ] && [ ! -e "$G99/home/m34" ] && du_8 "$G60"'

echo "##### K9: pha M với .env là symlink và dòng dạng export"
dung_the_gioi
( cd "$G60/home/m34" && mv .env .env.that && ln -s .env.that .env && sed -i 's#^OPS_CORE_BASE_URL=#export OPS_CORE_BASE_URL=#' .env.that )
pha doi-ops-core-60.sh k9-M.out
kiem "K9: .env vẫn là symlink, đích đổi đúng một dòng export, quyền 600" '[ -L "$G60/home/m34/.env" ] && [ "$(grep -c OPS_CORE_BASE_URL "$G60/home/m34/.env.that")" = 1 ] && grep -qx "export OPS_CORE_BASE_URL=http://192.168.1.99:5000" "$G60/home/m34/.env.that" && [ "$(stat -c %a "$G60/home/m34/.env.that")" = 600 ]'

echo "##### K10: awk đổi giờ cron hỏng ở B7 -> dừng, không cài cron .99"
dung_the_gioi
pha phaA-dung-99.sh k10-A.out
kiem "K10: B7 dừng (mã 2), crontab .99 không có dòng gói m34" 'pha_dung phaB-cat.sh k10-B.out "đổi giờ cron hỏng (mã 2)" GIA_HONG_AWK=1 && ! grep -q "$D99" "$G99/crontab" 2>/dev/null'

echo "##### K11: pha M đọc giá trị be thật nhận (docker inspect)"
dung_the_gioi
cp -p "$G60/home/m34/.env" "$GIA_GOC/env60.truoc-M"
kiem "K11: be .60 không bật OPS_CORE -> KHÔNG CẦN, .env giữ nguyên, không tạo lại be" 'pha doi-ops-core-60.sh k11-a.out GIA_OPS_TAT=1 && grep -q "pha M KHÔNG CẦN" "$GIA_GOC/k11-a.out" && cmp -s "$G60/home/m34/.env" "$GIA_GOC/env60.truoc-M" && ! grep -q -- "--wait be" "$G60/docker.log" && ! ls "$G60/home/m34"/.env.truoc-doi-ops-core-* > /dev/null 2>&1'
kiem "K11: in tên khoá override, không in giá trị" 'grep -q "dòng 7: (không tách được tên khoá)" "$GIA_GOC/k11-a.out" && ! grep -q "GIA_GIA_TRI_OVERRIDE" "$GIA_GOC/k11-a.out" && ! grep -q "8080:8080" "$GIA_GOC/k11-a.out"'
kiem "K11: override đặt đè URL -> tự lùi .env, dừng" 'pha_dung doi-ops-core-60.sh k11-b.out "compose.override.yml đặt đè?" GIA_OPS_DE=http://192.168.1.61:5000 && grep -q "TỰ LÙI" "$GIA_GOC/k11-b.out" && cmp -s "$G60/home/m34/.env" "$GIA_GOC/env60.truoc-M" && du_8 "$G60"'

echo "##### K12: B0b — volume .99 có tệp .60 không có y hệt -> dừng trước B1, .60 chưa đổi"
dung_the_gioi
pha phaA-dung-99.sh k12-A.out
kiem "K12: A8 để lại tệp be tự sinh trong m34_uploads .99" '[ -f "$G99/vol/m34_uploads/seed/s1.png" ]'
echo khac > "$G99/vol/m34_uploads/seed/s1.png"
kiem "K12: cùng đường dẫn khác nội dung -> dừng ở B0b, .60 chưa đổi" 'pha_dung phaB-cat.sh k12-B.out "B0b: .99 có 1 tệp" && du_8 "$G60" && grep -q "/home/ssv/m34/sao-luu" "$G60/crontab" && [ ! -e "$G60/home/m34/_chuyen-may/b6-bat-dau" ] && ! grep -q "B1 .60" "$GIA_GOC/k12-B.out"'
echo seed1 > "$G99/vol/m34_uploads/seed/s1.png"; mkdir -p "$G99/vol/m34_mail"; echo la > "$G99/vol/m34_mail/la.eml"
kiem "K12: tệp chỉ .99 có -> dừng ở B0b" 'pha_dung phaB-cat.sh k12-B2.out "B0b: .99 có 1 tệp" && du_8 "$G60"'
pha phaB-cat.sh k12-B3.out M34_XOA_VOL_99=co
kiem "K12: có cờ M34_XOA_VOL_99=co -> B4 làm rỗng cả tệp chỉ .99 có rồi chép, hai máy khớp" 'grep -q "theo cờ M34_XOA_VOL_99=co" "$GIA_GOC/k12-B3.out" && grep -q "m34_mail .99: đã làm rỗng 1 tệp" "$GIA_GOC/k12-B3.out" && [ ! -e "$G99/vol/m34_mail/la.eml" ] && diff -r "$G60/vol/m34_uploads" "$G99/vol/m34_uploads" > /dev/null && diff -r "$G60/vol/m34_mail" "$G99/vol/m34_mail" > /dev/null'

echo "##### đầu ra mẫu: $K1/k1-B.out"
sed -n '1,220p' "$K1/k1-B.out"
[ "$loi" = 0 ] && echo "THU_GIA: ĐẠT HẾT" || { echo "THU_GIA: CÓ HỎNG"; exit 1; }
