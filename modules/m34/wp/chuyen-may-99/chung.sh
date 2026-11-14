# Dùng chung cho các pha chuyển gói M3 + M4 + M9 từ .60 (~/m34) sang .99 (/data/ginsengfood-business-platform, D-lead-035/037).
# Chạy trên MÁY TOÀN (Git Bash), không chạy trên máy chủ. Mỗi pha = một lệnh `bash <pha>.sh`, Toàn duyệt một lần.
# Máy đích nhận đoạn r-dau.sh + r-*.sh qua stdin của ssh (bash -s), không cần chép script lên máy trước. Cả khối được bọc trong
# một hàm và hàm chạy với stdin = /dev/null: bash đọc hết script trước khi chạy dòng đầu, nên lệnh con (docker compose exec,
# ssh, ...) không nuốt được phần script còn lại.
# Dữ liệu (dump, volume, tệp ~/m34 có .env/bí mật) đi thẳng .60 -> ống ssh -> .99: không ghi xuống đĩa máy này, không in ra.
# Chạy thử: M34_SSH=<thư mục này>/gia/ssh (host giả) — thu-gia.sh làm sẵn.
set -Eeuo pipefail
export LC_ALL=C
THU=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
H60=${M34_H60:-ssv@192.168.1.60}
H99=${M34_H99:-ssv@192.168.1.99}
SSH=${M34_SSH:-ssh}
SSH_OPT=(-o BatchMode=yes -o ConnectTimeout=10 -o ServerAliveInterval=30 -o ServerAliveCountMax=6)
NHAT_KY_LOCAL=${M34_NHAT_KY:-$THU/nhat-ky-chay}
# Thư mục trên .99 (D-lead-037); .60 dùng ~/m34 (lệnh gửi sang .60 viết ~/m34).
D99=/data/ginsengfood-business-platform
SL99=/data/sao-luu/ginsengfood-business-platform
mkdir -p "$NHAT_KY_LOCAL"

host_cua() { case $1 in 60) echo "$H60" ;; 99) echo "$H99" ;; *) echo "sai máy: $1" >&2; return 2 ;; esac; }
# chay <60|99> <r-*.sh> [đối số...]: chạy r-dau.sh + tệp trên máy đích (bọc hàm, stdin /dev/null như trên).
chay() {
  local may=$1 tep=$2 h; shift 2
  h=$(host_cua "$may")
  { echo 'm34_chinh() {'; cat "$THU/r-dau.sh" "$THU/$tep"; printf '\n}\nm34_chinh "$@" < /dev/null\n'; } \
    | "$SSH" "${SSH_OPT[@]}" "$h" bash -s -- "$may" "$@"
}
# lenh <60|99> '<lệnh một dòng>': cho ống truyền dữ liệu (tar, cat). Lệnh viết sẵn trong pha, không ghép đầu vào lạ.
lenh() { local h; h=$(host_cua "$1"); "$SSH" "${SSH_OPT[@]}" "$h" "$2"; }
moc() { date -u +%Y%m%dT%H%M%SZ; }
tieu_de() { printf '\n===== %s · %s =====\n' "$(date '+%H:%M:%S')" "$*"; }
dung() { printf 'DỪNG: %s\n' "$*" >&2; exit 1; }
# Hai đích phải đúng hai máy, khác nhau (đặt nhầm M34_H99 thành .60 thì lệnh "của .99" sẽ ghi lên .60).
case $H60 in *@192.168.1.60) ;; *) dung "M34_H60=$H60 không phải ...@192.168.1.60" ;; esac
case $H99 in *@192.168.1.99) ;; *) dung "M34_H99=$H99 không phải ...@192.168.1.99" ;; esac
# Chạy thật mà ssh không phải ssh thật (hoặc chạy thử mà ssh là ssh thật) thì dừng: chặn nhầm máy thật khi thử.
if [ "${M34_THU_GIA:-0}" = 1 ]; then
  case "$SSH" in */gia/ssh) ;; *) dung "chạy thử nhưng M34_SSH=$SSH không phải host giả" ;; esac
else
  [ "$SSH" = ssh ] || dung "chạy thật phải dùng ssh của máy (M34_SSH=$SSH)"
fi
