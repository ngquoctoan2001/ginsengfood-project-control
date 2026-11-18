# r-thu-flyway-99.sh (.99): THỬ bản be mới trên BẢN SAO CSDL, không đụng CSDL thật, stack m34/M8/ops-core giữ nguyên (m34.99 A, D-m34-076).
# Đối số: <sha40> của image be cần thử. Cần sẵn $G/_thu-flyway/nap.sql + go.sql (thu-flyway-99.sh chép trước).
# Bước: kéo image → pg_dump CSDL thật (chỉ đọc) → pg tạm (tmpfs, mạng internal không ra ngoài) + pg_restore → be mới trỏ pg tạm
#   (tắt IVR/ops-core, không redis, không volume bí mật) chạy tới khi Flyway xong → kiểm lịch sử Flyway + trigger chặn TRUNCATE
#   → dừng be → nạp rồi gỡ 4 đơn thử GF-TEST (phải ra 0|0) → dọn sạch (container, mạng, tệp dump, tệp env có bí mật).
# Không in bí mật: env be chép vào tệp 0600 rồi xoá; chỉ in tên khoá bị thay, số đếm, dòng log Flyway.
SHA=${1:?thiếu sha40}
[[ $SHA =~ ^[0-9a-f]{40}$ ]] || dung "sha40 sai dạng"
cd "$G"
T="$G/_thu-flyway"
[ -s "$T/nap.sql" ] && [ -s "$T/go.sql" ] || dung "thiếu $T/nap.sql hoặc go.sql"
N=m34thu-net; CPG=m34thu-pg; CBE=m34thu-be
for c in $CPG $CBE; do [ -z "$(docker ps -aq -f name="^${c}$")" ] || dung "đã có container $c (lượt trước chưa dọn)"; done
docker network inspect $N > /dev/null 2>&1 && dung "đã có mạng $N"
don() {
  docker rm -f $CBE $CPG > /dev/null 2>&1 || true
  docker network rm $N > /dev/null 2>&1 || true
  rm -f "$T/ban-sao.dump" "$T/be.env" "$T/be.log" "$T/be.loc" "$T/be.in"
  echo "DON_XONG container/mạng/tệp tạm"
}
trap don EXIT
KHO=$(doc_env M34_KHO); KHO=${KHO:-ghcr.io/phucapu/ginsengfood-business-platform}
IMG="$KHO/bp-backend:$SHA"
u=$(doc_env POSTGRES_USER); db=$(doc_env POSTGRES_DB); u=${u:-ginsengfood_app}; db=${db:-ginsengfood}
PGID=$(docker compose ps -q pg); BEID=$(docker compose ps -q be)
[ -n "$PGID" ] && [ -n "$BEID" ] || dung "pg/be thật không chạy"
PG_IMG=$(docker inspect -f '{{.Config.Image}}' "$PGID")
echo "T1 kéo image be $SHA"
docker pull -q "$IMG" > /dev/null || dung "không kéo được $IMG"
echo "T2 pg_dump CSDL thật (chỉ đọc)"
docker exec "$PGID" pg_dump -Fc -U "$u" -d "$db" --lock-wait-timeout=60s > "$T/ban-sao.dump" || dung "pg_dump hỏng"
echo "  dump $(stat -c %s "$T/ban-sao.dump") byte"
echo "T3 pg tạm ($PG_IMG, tmpfs, mạng internal)"
docker network create --internal $N > /dev/null
PW=$(openssl rand -hex 24)
docker run -d --name $CPG --network $N --network-alias pg --tmpfs /var/lib/postgresql/data:size=4g \
  -e POSTGRES_USER=thu -e POSTGRES_PASSWORD="$PW" -e POSTGRES_DB=thu "$PG_IMG" > /dev/null
for i in $(seq 1 60); do docker exec $CPG pg_isready -U thu -d thu -q && break; sleep 2; done
docker exec $CPG pg_isready -U thu -d thu -q || dung "pg tạm không lên"
sleep 3
loi=$(docker exec -i $CPG pg_restore -U thu -d thu --no-owner --no-privileges < "$T/ban-sao.dump" 2>&1 | grep -c 'error:' || true)
echo "  pg_restore: $loi dòng lỗi"
q() { docker exec -i $CPG psql -U thu -d thu -X -A -t -F '|' -v ON_ERROR_STOP=1 -c "$1"; }
echo "  trước: flyway $(q "select count(*), count(*) filter (where not success), (select version from flyway_schema_history order by installed_rank desc limit 1) from flyway_schema_history")"
echo "T4 be mới trỏ pg tạm (không redis, IVR/ops-core tắt)"
docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' "$BEID" \
  | grep -vE '^(SPRING_DATASOURCE_|SPRING_DATA_REDIS_|SPRING_CONFIG_ADDITIONAL_LOCATION=|APP_IVR_|OPS_CORE_ENABLED=|OTP_EMAIL_CAPTURE_DIR=|[A-Z_]*_FILE=)' > "$T/be.env"
{ echo "SPRING_DATASOURCE_URL=jdbc:postgresql://pg:5432/thu?TimeZone=UTC"; echo "SPRING_DATASOURCE_USERNAME=thu"; echo "SPRING_DATASOURCE_PASSWORD=$PW"
  echo "SPRING_DATA_REDIS_HOST=khong-co-redis"; echo "SPRING_DATA_REDIS_PORT=6379"
  echo "APP_IVR_INTEGRATION_ENABLED=false"; echo "OPS_CORE_ENABLED=false"; echo "OTP_EMAIL_CAPTURE_DIR=/tmp/mail-capture"; } >> "$T/be.env"
docker run -d --name $CBE --network $N --env-file "$T/be.env" --memory 2g --cpus 2 "$IMG" > /dev/null
rm -f "$T/be.env"
# Log vào tệp rồi mới grep (grep -q trong ống + pipefail làm docker logs SIGPIPE, điều kiện sai: bài học cong-tac-khan 13/11).
L="$T/be.log"
ket=CHO
for i in $(seq 1 90); do
  sleep 4
  docker logs $CBE > "$L" 2>&1 || true
  if grep -qE 'Successfully applied [0-9]+ migration|Schema .* is up to date' "$L"; then ket=FLYWAY_XONG; break; fi
  if grep -qE 'FlywayException|Migration .* failed|Validate failed' "$L"; then ket=FLYWAY_HONG; break; fi
  [ "$(docker inspect -f '{{.State.Running}}' $CBE)" = true ] || { ket=BE_THOAT; break; }
done
echo "  ket_qua: $ket"
sleep 5
docker logs $CBE > "$L" 2>&1 || true
grep -E 'Flyway|Migrating schema|Successfully applied|Current version|Validate|ERROR' "$L" > "$T/be.loc" || true
sed -E 's/(password|secret|token)=[^ ]*/\1=***/Ig' "$T/be.loc" | cut -c1-220 > "$T/be.in" || true
sed -n '1,30p' "$T/be.in" | sed 's/^/  log: /'
echo "  be tạm: chạy=$(docker inspect -f '{{.State.Running}}' $CBE) · dòng ERROR=$(grep -c ' ERROR ' "$L" || true)"
rm -f "$L" "$T/be.loc" "$T/be.in"
docker rm -f $CBE > /dev/null
echo "T5 kiểm sau Flyway"
echo "  flyway (tổng|hỏng|bản cuối): $(q "select count(*), count(*) filter (where not success), (select version from flyway_schema_history order by installed_rank desc limit 1) from flyway_schema_history")"
echo "  V350-V357 đã chạy: $(q "select count(*) from flyway_schema_history where success and version in ('350','351','352','353','354','355','356','357')")/8"
echo "  trigger chặn TRUNCATE nhật ký: $(q "select string_agg(c.relname||':'||t.tgname, ' ' order by 1) from pg_trigger t join pg_class c on c.oid=t.tgrelid where not t.tgisinternal and (t.tgtype & 32) = 32")"
echo "T6 nạp rồi gỡ 4 đơn thử GF-TEST trên bản sao"
docker exec -i $CPG psql -U thu -d thu -X -q -A -t -F '|' -v ON_ERROR_STOP=1 < "$T/nap.sql" | sed 's/^/  nap: /' || dung "nap.sql hỏng"
docker exec -i $CPG psql -U thu -d thu -X -q -A -t -F '|' -v ON_ERROR_STOP=1 < "$T/go.sql" | sed 's/^/  go (phải 0|0): /' || dung "go.sql hỏng"
echo "T7 CSDL thật không đổi: flyway $(docker exec "$PGID" psql -U "$u" -d "$db" -X -A -t -F '|' -c "select count(*), count(*) filter (where not success) from flyway_schema_history")"
rm -rf "$T"
echo "THU_FLYWAY_XONG $ket"
