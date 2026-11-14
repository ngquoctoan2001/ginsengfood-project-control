# r-e01-99.sh (.99): ca E01 nghiệm thu M3 ↔ M8 trên .99 (deploy/m8/nghiem-thu-m3/README.md Bước 1, repo ginsengfood-ivr), phần M3:
# bốn lệnh kiểm (deploy/m8/noi-m3/viec-m34.md §4) rồi ba yêu cầu intake bị từ chối. Mọi lời gọi M8 đi từ container be (nguồn đã
# allow ở nginx 8443; gọi từ host .99 sẽ bị nginx 403 trước khi tới M8). Không đặt đơn, không tạo task. Không in token rác, không in thân.
cd "$G"
CA=m8-that/bi-mat/ca-m8.pem
[ -n "$(docker compose ps -q --status running be)" ] || dung "be .99 không chạy"
echo "-- 4 lệnh kiểm (viec-m34.md §4; CA trên máy, gọi từ be)"
openssl x509 -in "$CA" -noout -subject -enddate | sed 's/^/  /'
echo "  sha256 DER: $(openssl x509 -in "$CA" -outform DER | sha256sum | cut -c1-64)"
for p in /.well-known/oauth-authorization-server /.well-known/jwks.json; do
  ma=$(docker compose exec -T be curl -sS --cacert /run/m8t/be/ca-m8.pem -o /dev/null -w '%{http_code}' "https://192.168.1.99:8443$p" < /dev/null 2>&1 || true)
  echo "  GET $p -> $ma"
done
echo "-- E01: 3 yêu cầu intake bị từ chối (từ container be)"
docker compose exec -T be sh -c '
TOKEN_RAC="rac-$(od -An -N12 -tx1 /dev/urandom | tr -d " \n")"
INTAKE=https://192.168.1.99:8443/v1/ivr/order-confirmation/tasks
goi() {
  if [ "$3" = co ]; then
    out=$(curl -sS --cacert /run/m8t/be/ca-m8.pem -w " HTTP=%{http_code}" -X POST -H "Content-Type: application/json" -H "X-Source-System: $2" -H "Authorization: Bearer $TOKEN_RAC" -H "X-Correlation-Id: $1" -H "Idempotency-Key: $1" --data "{}" "$INTAKE" 2>&1)
  else
    out=$(curl -sS --cacert /run/m8t/be/ca-m8.pem -w " HTTP=%{http_code}" -X POST -H "Content-Type: application/json" -H "X-Source-System: $2" -H "X-Correlation-Id: $1" -H "Idempotency-Key: $1" --data "{}" "$INTAKE" 2>&1)
  fi
  ma=$(printf "%s" "$out" | sed -n "s/.* HTTP=\([0-9][0-9]*\)\$/\1/p")
  code=$(printf "%s" "$out" | grep -o "\"code\":\"[A-Z_]*\"" | head -n 1)
  echo "  E01 $1 nguồn=$2 token=$3 -> http=${ma:-?} ${code:-(không có error.code)}"
}
goi uat-e01-khong-token-99 order-core khong
goi uat-e01-token-rac-99 order-core co
goi uat-e01-sai-nguon-99 khong-phai-order-core co
' < /dev/null
echo "  mong: 401 IVR_UNAUTHENTICATED · 403 IVR_FORBIDDEN_CALLER · 403 IVR_FORBIDDEN_CALLER (token rác ra 401 = M8 không đọc được nguồn khoá ký: dừng, báo)"
echo "  giờ xong: $(date '+%F %T %z')"
echo E01_XONG
