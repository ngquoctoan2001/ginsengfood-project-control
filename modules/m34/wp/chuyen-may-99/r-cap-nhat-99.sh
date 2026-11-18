# r-cap-nhat-99.sh (.99): m34.99 bước 3 (D-m34-076). Cài các tệp bộ triển khai bản <sha40> (cap-nhat-99.sh đã giải nén vào $G/_cap-nhat),
# sao lưu bản cũ, kiểm `docker compose config`, chạy ./trien-khai.sh <sha40> (tự pg_dump, đổi image be/fe, kiểm, tự về bản cũ nếu hỏng),
# khởi động lại nginx :80 để nhận m34.conf mới, rồi kiểm sau đổi. Không đụng .env, secrets/, m8-that/bi-mat/, stack M8/ops-core.
SHA=${1:?thiếu sha40}
[[ $SHA =~ ^[0-9a-f]{40}$ ]] || dung "sha40 sai dạng"
cd "$G"
N="$G/_cap-nhat"
[ -f "$N/compose.yml" ] && [ -f "$N/nginx/m34.conf" ] || dung "thiếu $N (chưa giải nén)"
B="$G/_chuyen-may/tu-truoc-cap-nhat-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$B"
echo "U1 sao lưu tệp cũ vào ${B#$G/} + liệt kê khác biệt (chỉ tên)"
( cd "$N" && find . -type f | sort ) > "$B/.danh-sach"
while read -r f; do
  f=${f#./}
  if [ -f "$G/$f" ]; then
    mkdir -p "$B/$(dirname "$f")"; cp -p "$G/$f" "$B/$f"
    cmp -s "$G/$f" "$N/$f" && echo "  giữ  $f" || echo "  ĐỔI  $f"
  else
    echo "  MỚI  $f"
  fi
done < "$B/.danh-sach"
echo "U2 cài tệp mới (ghi đè tại chỗ, giữ inode cho bind mount)"
while read -r f; do
  f=${f#./}
  mkdir -p "$G/$(dirname "$f")"
  cp --preserve=mode "$N/$f" "$G/$f"
done < "$B/.danh-sach"
tra_lai() {
  echo "  TRẢ LẠI tệp cũ từ ${B#$G/}"
  while read -r f; do f=${f#./}; if [ -f "$B/$f" ]; then cp -p "$B/$f" "$G/$f"; else rm -f "$G/$f"; fi; done < "$B/.danh-sach"
}
if ! docker compose config -q 2>"$B/.config-loi"; then
  sed -n '1,5p' "$B/.config-loi" | sed 's/^/  /'
  tra_lai; dung "docker compose config hỏng với tệp mới"
fi
echo "  compose config: OK · biến mới trong be: $(docker compose config 2>/dev/null | grep -cE '^ +(ADMIN_ALLOWED_EMAIL_DOMAINS|ADMIN_SAMPLE_ACCOUNT_DOMAINS|AUTH_M4_CHANNEL_ADVISE_ENABLED|M4_CHANNEL_SERVICE_TOKEN|AUTH_M5_ORDER_STATE_ENABLED|M5_ORDER_STATE_SERVICE_TOKEN):' || true)/6 khoá"
rm -rf "$N"
echo "U3 ./trien-khai.sh $SHA (bản đang chạy: $(doc_env M34_BAN))"
rc=0
./trien-khai.sh "$SHA" < /dev/null > "$B/trien-khai.log" 2>&1 || rc=$?
tail -n 25 "$B/trien-khai.log" | sed 's/^/  | /'
[ "$rc" = 0 ] || dung "trien-khai.sh thoát $rc (xem ${B#$G/}/trien-khai.log; tệp bộ triển khai mới vẫn giữ, image tự về bản trước nếu hỏng ở bước đổi)"
echo "U4 khởi động lại nginx :80 (nhận nginx/m34.conf mới)"
docker compose restart nginx > /dev/null
for i in $(seq 1 30); do [ "$(docker inspect -f '{{.State.Health.Status}}' "$(docker compose ps -q nginx)")" = healthy ] && break; sleep 2; done
NG=$(docker compose ps -q nginx)
docker exec "$NG" nginx -T > "$B/.nginx-T" 2>/dev/null || true
echo "  nginx: $(docker inspect -f '{{.State.Health.Status}}' "$NG") · khối chặn /api/v1/internal/: $(grep -c 'location \^~ /api/v1/internal/ ' "$B/.nginx-T" || true) · by-code: $(grep -c 'location \^~ /api/v1/internal/orders/by-code/' "$B/.nginx-T" || true)"
rm -f "$B/.nginx-T" "$B/.config-loi"
echo "U5 kiểm sau đổi"
docker compose ps -a --format '  {{.Service}} {{.State}} {{.Status}}'
BE=$(docker compose ps -q be)
echo "  image be: $(docker inspect -f '{{.Config.Image}}' "$BE" | sed 's/.*://') · M34_BAN=$(doc_env M34_BAN)"
for p in /nginx-health /api/health/ready /vi /admin; do printf '  %s %s\n' "$p" "$(ma_http "http://192.168.1.99$p")"; done
printf '  /api/v1/internal/ai/x (phải 404): %s\n' "$(ma_http http://192.168.1.99/api/v1/internal/ai/x)"
printf '  by-code từ máy .99 (phải 403, chỉ .98): %s\n' "$(ma_http http://192.168.1.99/api/v1/internal/orders/by-code/GF-TEST-9999/channel-state)"
printf '  /api/v1/internal;x/ai/x (phải 404): %s\n' "$(ma_http 'http://192.168.1.99/api/v1/internal;x/ai/x')"
printf '  advise qua :80 (phải 404, M5 chỉ đi cửa 8446): %s\n' "$(ma_http http://192.168.1.99/api/v1/m4/channel/advise)"
u=$(doc_env POSTGRES_USER); db=$(doc_env POSTGRES_DB); u=${u:-ginsengfood_app}; db=${db:-ginsengfood}
echo "  flyway (tổng|hỏng|bản cuối): $(docker compose exec -T pg psql -U "$u" -d "$db" -X -A -t -F '|' -c "select count(*), count(*) filter (where not success), (select version from flyway_schema_history order by installed_rank desc limit 1) from flyway_schema_history" < /dev/null)"
docker logs "$BE" > "$B/.be.log" 2>&1 || true
echo "  be từ lúc khởi động: ERROR $(grep -c ' ERROR ' "$B/.be.log" || true) · dòng IVR (tls/token/callback): $(grep -E 'tls=PINNED|token-client=ON|callback-verifier=ON' "$B/.be.log" | head -n 1 | grep -oE 'tls=[A-Z]+|token-client=[A-Z]+|callback-verifier=[A-Z]+' | tr '\n' ' ')"
echo "  tên biến môi trường be có ADMIN_*: $(docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' "$BE" | cut -d= -f1 | grep -cE '^ADMIN_(ALLOWED_EMAIL|SAMPLE_ACCOUNT)_DOMAINS$' || true)/2"
rm -f "$B/.be.log"
echo "  cầu M8 8445: $(docker inspect -f '{{.State.Health.Status}}' "$(docker compose ps -q m8that-cb)")"
echo "CAP_NHAT_XONG $SHA (sao lưu tệp cũ: ${B#$G/})"
