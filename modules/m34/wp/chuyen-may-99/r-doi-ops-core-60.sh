# r-doi-ops-core-60.sh (.60): sau tin "m12 cắt xong": M3 trên .60 gọi M1–M2 ở .99. Thử TCP tới địa chỉ mới TRƯỚC (từ mạng m34_app, đúng
# đường be đi); thông mới đổi đúng một khoá OPS_CORE_BASE_URL trong .env (bản trước lưu cạnh, 600; .env là symlink thì sửa tệp đích),
# tạo lại be (nginx khởi động lại theo depends_on restart: true, ~1 phút), thử lại; hỏng thì tự chép lại bản trước và tạo lại be.
# be ĐANG CHẠY không bật OPS_CORE_ENABLED (đọc bằng docker inspect, tính cả compose.override.yml) thì không cần đổi: không sửa, không
# tạo lại be. Sau khi tạo lại, be phải nhận đúng địa chỉ mới (override đặt đè thì tự lùi). Không in .env, không đụng secrets/.
cd "$G"
MOI=http://192.168.1.99:5000
KHOA_RE='^(export[[:space:]]+)?OPS_CORE_BASE_URL='
[ ! -e DA_CHUYEN_SANG_99.txt ] || dung ".60 đã qua pha D: đổi trên .99, không phải ở đây"
for dv in be nginx; do
  [ -n "$(docker compose ps -q --status running "$dv")" ] || dung "$dv trên .60 không chạy (đang trong cửa sổ cắt?): không đổi ở đây"
done
cu=$(sed -nE "s/${KHOA_RE}//p" .env | tail -n 1)
echo "OPS_CORE_BASE_URL trong .env: ${cu:-(chưa đặt)}"
# Giá trị be ĐANG CHẠY nhận (cả compose.override.yml): docker inspect, chỉ in đúng khoá hỏi.
be_env() {
  local id; id=$(docker compose ps -q --status running be)
  [ -n "$id" ] || return 0
  { docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' "$id" 2>/dev/null || true; } | sed -n "s/^$1=//p" | tail -n 1
}
en=$(be_env OPS_CORE_ENABLED); ub=$(be_env OPS_CORE_BASE_URL)
echo "be đang nhận: OPS_CORE_ENABLED=${en:-(trống)} · OPS_CORE_BASE_URL=${ub:-(trống)}"
if [ -f compose.override.yml ]; then
  echo "compose.override.yml, dòng có OPS_CORE hoặc 192.168.1.60 (chỉ tên khoá):"
  grep -nE 'OPS_CORE|192\.168\.1\.60' compose.override.yml \
    | sed -E 's/^([0-9]+):[[:space:]]*-?[[:space:]]*"?([A-Za-z_][A-Za-z0-9_.-]*).*/  dòng \1: khoá \2/;t;s/^([0-9]+):.*/  dòng \1: (không tách được tên khoá)/' || true
fi
if [ "${en,,}" != true ]; then
  echo "be .60 không bật gọi M12 (OPS_CORE_ENABLED không phải true): pha M KHÔNG CẦN, không sửa .env, không tạo lại be"
  echo M_XONG
  exit 0
fi
echo "-- thử trước, chưa sửa gì: be -> M12 ở địa chỉ mới"
thu_ops_core "$MOI" || dung "chưa sửa gì: từ m34_app trên .60 chưa tới được 192.168.1.99:5000 (tường lửa .99 mở :5000 cho .60? M12 .99 đã lên?)"
bk=""
if [ "$cu" = "$MOI" ]; then
  echo "đã là $MOI, không sửa .env"
else
  bk=".env.truoc-doi-ops-core-$(date -u +%Y%m%dT%H%M%SZ)"
  cp -p -- .env "$bk"; chmod 600 "$bk"
  if grep -Eq "$KHOA_RE" .env; then
    sed -i --follow-symlinks -E "s#${KHOA_RE}.*#\\1OPS_CORE_BASE_URL=$MOI#" .env
  else
    printf 'OPS_CORE_BASE_URL=%s\n' "$MOI" >> .env
  fi
  [ "$(sed -nE "s/${KHOA_RE}//p" .env | sort -u)" = "$MOI" ] || dung "sửa .env không ăn (bản trước: $G/$bk; chưa tạo lại be)"
  echo "đã đổi; bản trước: $G/$bk"
fi
lui_lai() {
  [ -n "$bk" ] || return 0
  echo "-- TỰ LÙI: chép lại $bk, tạo lại be"
  cp -p -- "$bk" .env
  docker compose up -d --no-build --wait be || true
  docker compose ps --format '  {{.Service}} {{.State}} {{.Health}}'
}
echo "-- tạo lại be, chờ health"
docker compose up -d --no-build --wait be || { lui_lai; dung "be chưa khoẻ sau khi đổi (đã tự lùi nếu có sửa)"; }
ub=$(be_env OPS_CORE_BASE_URL)
[ "$ub" = "$MOI" ] || { lui_lai; dung "be tạo lại vẫn nhận OPS_CORE_BASE_URL=${ub:-(trống)}, không phải $MOI (compose.override.yml đặt đè?) (đã tự lùi nếu có sửa)"; }
echo "be nhận OPS_CORE_BASE_URL=$ub"
docker compose ps --format '  {{.Service}} {{.State}} {{.Health}}'
echo "-- be -> M12 (OPS_CORE_ENABLED=$(doc_env OPS_CORE_ENABLED), GATE_ENFORCE=$(doc_env OPS_CORE_GATE_ENFORCE)):"
thu_ops_core "$MOI" || { lui_lai; dung "sau khi đổi be .60 không tới được 192.168.1.99:5000 (đã tự lùi nếu có sửa)"; }
printf '  /api/health/ready %s\n' "$(ma_http http://192.168.1.60/api/health/ready)"
echo M_XONG
