# r-a1-chuan-bi-99.sh (.99): thư mục triển khai $G = /data/ginsengfood-business-platform (D-lead-037) là THƯ MỤC THẬT, rỗng, của ssv.
# Thư mục do Toàn tạo bằng lệnh `sudo mv` của nền .99; pha A KHÔNG tạo (không sudo) và không tạo ~/m34.
# Guard của canh-bao.sh, cong-tac-khan.sh, lam-moi-ton-thu.sh trên .99 đòi readlink -f đúng đường này và nhãn compose working_dir
# đúng đường này. Sao lưu: $SL99 (hang-ngay qua symlink sao-luu/hang-ngay, chuyen-may cho dump của cửa sổ cắt).
[ -e "$G" ] || dung "$G chưa có: chờ Toàn chạy lệnh sudo mv của nền .99 (D-lead-037), rồi chạy lại pha A"
[ -d "$G" ] && [ ! -L "$G" ] || dung "$G không phải thư mục thật"
[ -O "$G" ] || dung "$G không thuộc ssv"
[ "$(readlink -f "$G")" = "$G" ] || dung "readlink -f $G khác chính nó"
[ -z "$(ls -A "$G")" ] || dung "$G đã có $(ls -A "$G" | wc -l) mục: pha A đã chạy rồi? Không ghi đè."
chmod 700 "$G"
if [ -e "$HOME/m34" ] || [ -L "$HOME/m34" ]; then
  echo "CHÚ Ý: ~/m34 vẫn có trên .99 ($(ls -ld "$HOME/m34" | cut -c1-10)); D-lead-037 bỏ đường này, kịch bản không dùng và không xoá nó"
fi
[ -d "$SL99" ] && [ -w "$SL99" ] || dung "$SL99 chưa có hoặc ssv không ghi được (nền .99)"
mkdir -p -m 700 "$SL99/hang-ngay" "$SL99/chuyen-may"
goc=$(docker info --format '{{.DockerRootDir}}') || dung "ssv chưa gọi được docker (nhóm docker?)"
[ "$goc" = /data/docker ] || dung "Docker đang dùng $goc, không phải /data/docker"
echo "compose $(docker compose version --short) (cần >= 2.23.1)"
for p in 80 8445; do
  if grep -q ":$p\$" <<< "$(ss -ltnH | awk '{print $4}')"; then dung "cổng $p trên .99 đang bận"; fi
done
echo "đĩa /data còn $(df -P /data | awk 'NR == 2 {printf "%d GiB", $4 / 1048576}')"
echo A1_XONG
