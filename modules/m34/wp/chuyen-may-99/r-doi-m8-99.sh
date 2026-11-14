# r-doi-m8-99.sh (.99): M3 trên .99 gọi M8 ở .99 sau khi m8 cắt (tin m8 phụ 14/11 07:46). Đối số 1 = vân tay SHA-256 DER (hex thường)
# mong đợi của ca-m8.pem mới; tệp mới đã chép sẵn vào m8-that/bi-mat/ca-m8.pem.moi (doi-m8-99.sh). Làm:
# lưu bản cũ (.env, ca-m8.pem, be.env), đặt ca-m8.pem mới, M8_ORIGIN=https://192.168.1.99:8443 (issuer/token/jwks/intake theo đó),
# tao-chung-thu-cau.sh tính lại be.env (giữ CA cầu + chứng thư cầu), up --wait (m8that-bi-mat chép lại, be + cầu tạo lại ~1 phút),
# kiểm; hỏng thì tự chép lại bản cũ và up lại. Cuối: gọi thử M8 /health/live từ mạng m34_app để m8 đọc IP nguồn (403) rồi allow.
# M8_ALLOW_IP (nguồn callback vào cầu) CHƯA đổi: đo ở bước sau. Không in .env, khoá, bí mật.
cd "$G"
MOI=https://192.168.1.99:8443
BM=m8-that/bi-mat
VT_CAN=${1:?thiếu vân tay mong đợi}
[[ $VT_CAN =~ ^[0-9a-f]{64}$ ]] || dung "vân tay mong đợi sai dạng"
[ -n "$(docker compose ps -q --status running be)" ] || dung "be .99 không chạy (pha B chưa xong?)"
[ -s "$BM/ca-m8.pem.moi" ] || dung "thiếu $BM/ca-m8.pem.moi"
! grep -q PRIVATE "$BM/ca-m8.pem.moi" || dung "ca-m8.pem mới có khoá riêng"
[ "$(grep -c 'BEGIN CERTIFICATE' "$BM/ca-m8.pem.moi")" = 1 ] || dung "ca-m8.pem mới phải có đúng một chứng thư"
vt=$(openssl x509 -in "$BM/ca-m8.pem.moi" -outform DER | sha256sum | cut -d' ' -f1)
[ "$vt" = "$VT_CAN" ] || dung "vân tay ca-m8.pem mới ($vt) khác vân tay m8 báo ($VT_CAN)"
openssl x509 -in "$BM/ca-m8.pem.moi" -noout -checkend 2592000 > /dev/null || dung "ca-m8.pem mới hết hạn trong 30 ngày"
echo "ca-m8.pem mới: vân tay khớp m8 báo; $(openssl x509 -in "$BM/ca-m8.pem.moi" -noout -enddate)"

ts=$(date -u +%Y%m%dT%H%M%SZ)
cp -p -- .env ".env.truoc-m8-99-$ts"; chmod 600 ".env.truoc-m8-99-$ts"
cp -p -- "$BM/ca-m8.pem" "$BM/ca-m8.pem.truoc-m8-99-$ts"
cp -p -- "$BM/be.env" "$BM/be.env.truoc-m8-99-$ts"
echo "bản cũ: .env.truoc-m8-99-$ts, $BM/{ca-m8.pem,be.env}.truoc-m8-99-$ts"
lui_lai() {
  echo "-- TỰ LÙI: chép lại bản cũ, up lại"
  cp -p -- ".env.truoc-m8-99-$ts" .env
  cp -p -- "$BM/ca-m8.pem.truoc-m8-99-$ts" "$BM/ca-m8.pem"
  cp -p -- "$BM/be.env.truoc-m8-99-$ts" "$BM/be.env"
  docker compose up -d --no-build --wait || true
  docker compose ps --format '  {{.Service}} {{.State}} {{.Health}}'
}

cat -- "$BM/ca-m8.pem.moi" > "$BM/ca-m8.pem"; chmod 600 "$BM/ca-m8.pem"
KHOA_RE='^(export[[:space:]]+)?M8_ORIGIN='
if grep -Eq "$KHOA_RE" .env; then
  sed -i --follow-symlinks -E "s#${KHOA_RE}.*#\\1M8_ORIGIN=$MOI#" .env
else
  printf 'M8_ORIGIN=%s\n' "$MOI" >> .env
fi
[ "$(sed -nE "s/${KHOA_RE}//p" .env | sort -u)" = "$MOI" ] || { lui_lai; dung "sửa M8_ORIGIN trong .env không ăn"; }
echo "-- tao-chung-thu-cau.sh: tính lại be.env (CA cầu + chứng thư cầu giữ nếu còn hợp lệ)"
bash m8-that/tao-chung-thu-cau.sh | grep -E 'SAN|hết hạn|CA M8 sha256|CA cầu sha256' || true
grep -qx "APP_IVR_AUTH_TLS_PINNED_CA_SHA256=$VT_CAN" "$BM/be.env" || { lui_lai; dung "be.env chưa ghim vân tay mới"; }
cfg=$(docker compose config)
grep -qF "app.ivr-auth.issuer=$MOI" <<< "$cfg" || { lui_lai; dung "cấu hình be chưa có issuer $MOI"; }
grep -qF "app.ivr-task-client.intake-uri=$MOI/v1/ivr/order-confirmation/tasks" <<< "$cfg" || { lui_lai; dung "cấu hình be chưa có intake $MOI"; }
echo "-- up --wait (m8that-bi-mat chép lại ca-m8.pem; be + cầu tạo lại, nginx :80 khởi động lại theo be ~1 phút)"
moc_up=$(date -u +%Y-%m-%dT%H:%M:%SZ)
docker compose up -d --no-build --wait || { lui_lai; dung "up --wait chưa khoẻ (đã tự lùi)"; }
docker compose ps --format '  {{.Service}} {{.State}} {{.Health}}'
ca_vol=$(docker run --rm --network none -v m34_m8that-bm-be:/v:ro --entrypoint cat postgres:17 /v/ca-m8.pem < /dev/null)
[ "$ca_vol" = "$(cat "$BM/ca-m8.pem")" ] || { lui_lai; dung "ca-m8.pem trong volume be chưa phải bản mới (đã tự lùi)"; }
dong=$(docker compose logs --no-log-prefix --since "$moc_up" be 2>&1 | grep -m 1 'IVR-AUTH-CONFIG' || true)
echo "  ${dong:-(chưa thấy dòng IVR-AUTH-CONFIG)}"
grep -q 'tls=PINNED token-client=ON callback-verifier=ON' <<< "$dong" || { lui_lai; dung "be không báo tls=PINNED token-client=ON callback-verifier=ON (đã tự lùi)"; }
printf '  /api/health/ready %s · /vi %s · /admin %s\n' "$(ma_http http://192.168.1.99/api/health/ready)" "$(ma_http http://192.168.1.99/vi)" "$(ma_http http://192.168.1.99/admin)"
echo "-- gọi thử M8 /health/live từ mạng m34_app (đúng đường be đi ra) để m8 đọc IP nguồn"
dai=$(docker network inspect m34_app --format '{{range .IPAM.Config}}{{.Subnet}} {{end}}'); dai=${dai%" "}
gio=$(date '+%Y-%m-%d %H:%M:%S %z')
ma=$(docker compose exec -T be curl -sk -o /dev/null -w '%{http_code}' --max-time 10 "$MOI/health/live" < /dev/null 2>/dev/null) || ma=''
cach=be
if ! [[ $ma =~ ^[0-9]{3}$ ]] || [ "$ma" = 000 ]; then
  ma=$(docker run --rm --network m34_app curlimages/curl:8.11.1 -sk -o /dev/null -w '%{http_code}' --max-time 10 "$MOI/health/live" < /dev/null 2>/dev/null) || ma=000
  cach="container curl trên m34_app"
fi
echo "GOI_THU_M8 giờ=$gio mã=$ma cách=$cach dải_m34_app=$dai"
echo M8_99_XONG
