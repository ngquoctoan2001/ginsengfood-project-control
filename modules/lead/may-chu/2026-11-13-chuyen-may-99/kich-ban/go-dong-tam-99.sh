#!/usr/bin/env bash
# Gỡ 2 dòng TAM trong /etc/ginsengfood/cong-noi-bo.conf trên .99 (lead.h1; Toàn duyệt 14/11, hẹn làm 16/11).
# Thứ tự 16/11 (không làm sớm hơn: 15/11 nghiệm thu M1-2 trên .99, M8 diễn tập 03B):
#   (1) máy Lead:  bash kiem-go-tam-99.sh truoc   → phải in "DU DIEU KIEN"
#   (2) scp tệp này lên .99 ~/ ; Toàn chạy trên .99:  sudo bash ~/go-dong-tam-99.sh
#   (3) máy Lead:  bash kiem-go-tam-99.sh sau     → phải in "DAT"
# Làm gì:
#   - bỏ:  192.168.1.60 8443 (M3 ở .60 gọi M8) · 192.168.1.61 8445 (M8 ở .61 gọi cầu callback M3) · dòng tiêu đề "# TAM ..."
#   - sửa ghi chú dòng 192.168.1.60 5000 (M3 đã cắt, chỉ còn M7 tạm ở .60)
#   - KHÔNG đụng dòng nào khác (vd dòng 8446 M5 gọi M3 TLS do phiên m34 thêm): nếu khác biệt vượt 4 dòng trên
#     → trả bản cũ, dừng, không khởi động lại tường lửa
#   - lưu bản cũ cạnh tệp, khởi động lại gf-tuong-lua (hỏng → tự trả bản cũ), in bảng mới
# Đường lui: sudo cp <bản .bak in ra> /etc/ginsengfood/cong-noi-bo.conf && sudo systemctl restart gf-tuong-lua
set -euo pipefail
F=/etc/ginsengfood/cong-noi-bo.conf
[ "$(id -u)" = 0 ] || { echo "Chay bang sudo."; exit 1; }
[ -f "$F" ] || { echo "Khong thay $F"; exit 1; }

RTD='^# TAM trong luc chuyen'
R60='^192\.168\.1\.60[[:space:]]+8443[[:space:]]'
R61='^192\.168\.1\.61[[:space:]]+8445[[:space:]]'
R5000='^192\.168\.1\.60[[:space:]]+5000[[:space:]]'

for r in "$R60" "$R61"; do
  n=$(grep -cE "$r" "$F" || true)
  [ "$n" = 1 ] || { echo "DUNG: dong '$r' co $n lan (mong 1). Bang da doi, xem lai truoc khi go."; exit 1; }
done

B="$F.bak-$(date +%Y%m%d-%H%M%S)"
cp -p "$F" "$B"
sed -i -E \
  -e "/$RTD/d" \
  -e "/$R60/d" \
  -e "/$R61/d" \
  -e 's/^(192\.168\.1\.60[[:space:]]+5000[[:space:]]+).*/\1M7 tam o .60 (M3 da sang .99 14\/11)/' \
  "$F"

# Chốt chặn: chỉ được bỏ dòng tiêu đề TAM, 2 dòng TAM, dòng 5000 cũ; chỉ được thêm dòng 5000 mới.
BO=$(diff --unchanged-line-format= --old-line-format='%L' --new-line-format= "$B" "$F" || true)
THEM=$(diff --unchanged-line-format= --old-line-format= --new-line-format='%L' "$B" "$F" || true)
LA_BO=$(printf '%s\n' "$BO" | grep -vE "$RTD|$R60|$R61|$R5000" | grep -v '^$' || true)
LA_THEM=$(printf '%s\n' "$THEM" | grep -vE "$R5000" | grep -v '^$' || true)
SO_BO=$(printf '%s\n' "$BO" | grep -cE "$R60|$R61" || true)
if [ -n "$LA_BO" ] || [ -n "$LA_THEM" ] || [ "$SO_BO" != 2 ]; then
  cp -p "$B" "$F"
  echo "DUNG: khac biet ngoai du kien → da tra ban cu, KHONG khoi dong lai tuong lua."
  echo "bo la:   ${LA_BO:-(khong)}"; echo "them la: ${LA_THEM:-(khong)}"; echo "so dong TAM bo: $SO_BO (mong 2)"
  exit 1
fi

echo "Ban cu: $B"
echo "--- khac biet:"; diff "$B" "$F" || true
echo "--- dong 8446 (phai giu nguyen neu co):"; grep -nE '[[:space:]]8446[[:space:]]' "$F" || echo "(chua co dong 8446)"

if ! systemctl restart gf-tuong-lua || ! systemctl is-active --quiet gf-tuong-lua; then
  echo "LOI: gf-tuong-lua khong len → tra ban cu"
  cp -p "$B" "$F"; systemctl restart gf-tuong-lua || true
  systemctl is-active gf-tuong-lua || true
  exit 1
fi
echo "gf-tuong-lua: $(systemctl is-active gf-tuong-lua)"
echo "--- bang moi (bo chu thich):"; grep -vE '^\s*(#|$)' "$F"
