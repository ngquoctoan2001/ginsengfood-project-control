# r-b4-don-99.sh (.99): trước khi nhận volume từ .60. be/fe/nginx/cầu phải đang dừng (A8). Dừng redis .99, xoá NỘI DUNG
# volume m34_redis của .99 (chỉ có dữ liệu lượt chạy thử A8 trên CSDL rỗng). m34_uploads, m34_mail .99: rỗng, hoặc đối số 1 = co
# (B0b đã so: mọi tệp .99 trùng hệt .60) thì làm rỗng để chép lại; có tệp mà không có co thì dừng.
XOA=${1:-khong}
cd "$G"
for s in be fe nginx m8that-cb; do
  [ -z "$(docker compose ps -q --status running "$s" 2>/dev/null)" ] || dung "$s đang chạy trên .99"
done
docker compose stop redis
for v in m34_uploads m34_mail; do
  so=$(docker run --rm --network none -v "$v:/v:ro" --entrypoint sh postgres:17 -c 'find /v -type f | wc -l')
  if [ "$so" != 0 ]; then
    [ "$XOA" = co ] || dung "$v trên .99 đã có $so tệp (không ghi đè, hỏi Toàn)"
    docker run --rm --network none -v "$v:/v" --entrypoint sh postgres:17 -c 'find /v -mindepth 1 -delete'
    echo "$v .99: đã làm rỗng $so tệp (B0b cho phép)"
  fi
done
docker run --rm --network none -v m34_redis:/v --entrypoint sh postgres:17 -c 'find /v -mindepth 1 -delete && echo "m34_redis .99: đã làm rỗng"'
echo B4_XONG
