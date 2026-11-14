#!/bin/sh
# Ginsengfood · máy .99 · chặn cổng Docker từ LAN, chỉ mở cho đúng IP trong /etc/ginsengfood/cong-noi-bo.conf.
# Cổng Docker công bố đi vòng qua ufw, nên lọc ở chuỗi DOCKER-USER (Docker không xoá chuỗi này).
# So theo cổng GỐC trên máy (--ctorigdstport, trước khi Docker đổi đích), nên bảng ghi đúng cổng máy.
# Đổi bảng: sửa cong-noi-bo.conf rồi `sudo systemctl restart gf-tuong-lua`.
set -eu
CONF=/etc/ginsengfood/cong-noi-bo.conf
LAN_IF=eth0

iptables -N DOCKER-USER 2>/dev/null || true
iptables -F DOCKER-USER
# gói trả lời của kết nối đã có: cho qua
iptables -A DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j RETURN
# chỉ lọc kết nối MỚI từ LAN vào container; container gọi ra, container gọi nhau: cho qua
iptables -A DOCKER-USER ! -i "$LAN_IF" -j RETURN
grep -vE '^[[:space:]]*(#|$)' "$CONF" | while read -r NGUON CONG _GHI; do
  iptables -A DOCKER-USER -i "$LAN_IF" -s "$NGUON" -p tcp -m conntrack --ctorigdstport "$CONG" -j RETURN
done
iptables -A DOCKER-USER -i "$LAN_IF" -m conntrack --ctstate NEW -j DROP
iptables -A DOCKER-USER -j RETURN
