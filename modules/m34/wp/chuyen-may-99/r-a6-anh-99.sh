# r-a6-anh-99.sh (.99): chứng thư cầu callback cho .99 (CA cầu giữ nguyên nên M8 không phải ghim lại), kéo đúng image
# đang chạy trên .60, tạo volume/mạng/container theo nhãn compose (chưa chạy).
cd "$G"
mkdir -p -m 700 nhat-ky
cf=$(doc_env COMPOSE_FILE)
echo "COMPOSE_FILE=${cf:-compose.yml}"
case ":$cf:" in
  *:compose.m8-that.yml:*)
    echo "-- chứng thư cầu M3 cho 192.168.1.99 (m8-that/tao-chung-thu-cau.sh, chỉ in vân tay/ngày hết hạn)"
    bash m8-that/tao-chung-thu-cau.sh ;;
esac
ban=$(doc_env M34_BAN); kho=$(doc_env M34_KHO)
[[ $ban =~ ^[0-9a-f]{40}$ ]] || dung "M34_BAN sai dạng"
[[ $kho == ghcr.io/* ]] || dung "M34_KHO lạ: $kho"
echo "-- kéo be/fe $ban"
docker pull -q "$kho/bp-backend:$ban"
docker pull -q "$kho/bp-frontend:$ban"
echo "-- kéo dịch vụ còn lại (be/fe pull_policy: never nên compose bỏ qua)"
docker compose pull -q
docker compose config --images | sort -u | sed 's/^/  /'
docker compose create
for a in bp-backend bp-frontend; do printf '  %s Id %s\n' "$a" "$(docker image inspect --format '{{.Id}}' "$kho/$a:$ban")"; done
echo A6_XONG
