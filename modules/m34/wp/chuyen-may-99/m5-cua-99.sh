#!/usr/bin/env bash
# m34.100 (D-m34-076): cửa TLS 8446 trên .99 cho M5 (.98). Chạy trên máy Toàn, sau cap-nhat-99.sh:
#   bash m5-cua-99.sh bat      bật cửa trên .99 (r-m5-cua-99.sh); sau đó Toàn sudo thêm dòng tường lửa (in ở cuối)
#   bash m5-cua-99.sh kiem98   từ máy .98 (chỉ đọc: hai lời gọi không token) gọi thử qua cửa: by-code phải 503 (công tắc be tắt),
#                              advise phải 403 (M4 tắt); 000 = tường lửa .99 chưa mở cho .98 hoặc .98 không tới được
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
VIEC=${1:?bat|kiem98}
LOG="$NHAT_KY_LOCAL/m5-cua-99-$VIEC-$(moc).log"
{
  case $VIEC in
    bat)
      tieu_de "bật cửa 8446 (.99)"
      chay 99 r-m5-cua-99.sh
      tieu_de "Toàn làm (sudo, trên .99): thêm cổng 8446 cho nguồn 192.168.1.98 vào bảng cổng nội bộ rồi khởi động lại bộ lọc"
      echo "  ssh -t ssv@192.168.1.99"
      echo "  sudo cp -p /etc/ginsengfood/cong-noi-bo.conf /etc/ginsengfood/cong-noi-bo.conf.truoc-8446"
      echo "  echo '192.168.1.98     8446   M5 may mkt goi cua TLS m5cua (M3 by-code, M4 advise; m34.100)' | sudo tee -a /etc/ginsengfood/cong-noi-bo.conf"
      echo "  sudo systemctl restart gf-tuong-lua && sudo iptables -S DOCKER-USER | grep -- '--ctorigdstport 8446'"
      echo "  sudo iptables -S DOCKER-USER | grep -c -- '--ctstate NEW -j DROP'    # phải ra 1; ra 0 = bảng hỏng, chép lại bản .truoc-8446 rồi restart"
      echo "  rồi chạy: bash m5-cua-99.sh kiem98"
      ;;
    kiem98)
      tieu_de "gọi thử từ .98 qua cửa (không token)"
      ssh "${SSH_OPT[@]}" ssv@192.168.1.98 '
        printf "  GET by-code (mong 503): %s\n" "$(curl -sk -m 8 -o /dev/null -w "%{http_code}" https://192.168.1.99:8446/api/v1/internal/orders/by-code/GF-TEST-9999/channel-state || echo 000)"
        printf "  POST advise (mong 403): %s\n" "$(curl -sk -m 8 -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -d "{}" https://192.168.1.99:8446/api/v1/m4/channel/advise || echo 000)"
        printf "  GET đường khác (mong 404): %s\n" "$(curl -sk -m 8 -o /dev/null -w "%{http_code}" https://192.168.1.99:8446/api/v1/internal/ai/x || echo 000)"'
      tieu_de "nhật ký cửa trên .99: IP nguồn + mã (5 phút qua)"
      lenh 99 "cd $D99 && DOCKER_CONFIG=$D99/.docker docker compose logs --no-log-prefix --since 5m m5cua-nginx 2>/dev/null | awk '{print \$1, \$9}' | sort | uniq -c | head -10"
      ;;
    *) dung "lệnh lạ: $VIEC" ;;
  esac
} 2>&1 | tee "$LOG"
