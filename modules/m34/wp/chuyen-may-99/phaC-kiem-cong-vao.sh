#!/usr/bin/env bash
# Pha C (CHỈ ĐỌC): sau khi Anh Tuấn trỏ ginsengfood.vn (và /admin) về 192.168.1.99:80 ở máy nginx cổng vào.
# Kiểm từ máy Toàn qua tên miền (DNS ginsengfood.vn, www -> 14.224.139.101; bản ghi admin đã xoá, quản trị là ginsengfood.vn/admin),
# thử giả X-Forwarded-For qua tên miền (nginx của Anh Tuấn phải ĐẶT header đó bằng $remote_addr, nginx m34 tin LAN /23), và trên .99 đếm IP khách
# (sau realip) 15 phút qua + kết nối TCP đang mở vào nginx (IP máy cổng vào). Dấu cổng vào trên .60 đã ghi từ cuối pha B (C0 ghi nếu chưa có).
# C1b chạy từ LAN: chỉ khi nginx của Anh Tuấn ĐẶT X-Forwarded-For ($remote_addr) mới ra 403; NỐI hay chuyển nguyên đều lọt (nginx/m34.conf).
# Muốn chắc cho khách Internet: chạy lại riêng lệnh C1b từ máy ngoài LAN (4G).
# Chạy: bash "C:/Projects/Project Control/modules/m34/wp/chuyen-may-99/phaC-kiem-cong-vao.sh"
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
LOG="$NHAT_KY_LOCAL/phaC-$(moc).log"
{
  tieu_de "C0 .60: dấu cổng vào trỏ .99 (lui-60.sh đòi M34_LUI_SAU_GHI=co)"
  lenh 60 'f=~/m34/_chuyen-may/c-cong-vao-99; { [ -e "$f" ] || date -u +%FT%TZ > "$f"; } && echo "C0_XONG dấu từ $(head -n 1 "$f")"' || dung "không ghi được dấu pha C trên .60"
  tieu_de "C1 qua tên miền (từ máy Toàn)"
  for u in https://ginsengfood.vn/ https://ginsengfood.vn/vi https://ginsengfood.vn/admin https://ginsengfood.vn/api/health/ready https://www.ginsengfood.vn/; do
    printf '  %s %s\n' "$u" "$(curl -s -m 10 -o /dev/null -w '%{http_code} %{remote_ip}' "$u" || echo 000)"
  done
  tieu_de "C1b thử giả nguồn qua tên miền: GET by-code với X-Forwarded-For: 192.168.1.98 phải 403"
  ma=$(curl -s -m 10 -o /dev/null -w '%{http_code}' -H 'X-Forwarded-For: 192.168.1.98' https://ginsengfood.vn/api/v1/internal/orders/by-code/KIEM-GIA-NGUON) || true
  case ${ma:-000} in
    403) echo "  403: nginx của Anh Tuấn ĐẶT X-Forwarded-For, khách không giả được nguồn" ;;
    000*) echo "  không gọi được qua tên miền (${ma:-000}): chưa kết luận, thử lại sau" ;;
    *) echo "  CHÚ Ý ($ma): nginx của Anh Tuấn NỐI hoặc chuyển nguyên X-Forwarded-For: khách giả được IP (qua giới hạn tần suất, lớp allow). Nhờ Anh Tuấn đặt proxy_set_header X-Forwarded-For \$remote_addr; (không nối) rồi chạy lại pha C" ;;
  esac
  tieu_de "C2 .99: IP khách (sau realip) 15 phút qua + IP kết nối TCP đang mở vào nginx m34 (chỉ IP + số lượt)"
  chay 99 r-c2-ip-99.sh
  tieu_de "C3 .60: nginx m34 phải đang dừng (không còn ai vào nhầm máy cũ)"
  lenh 60 'cd ~/m34 && export DOCKER_CONFIG=$HOME/m34/.docker && docker compose ps --format "  {{.Service}} {{.State}}"'
} 2>&1 | tee "$LOG"
