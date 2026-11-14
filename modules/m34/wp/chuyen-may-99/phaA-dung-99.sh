#!/usr/bin/env bash
# Pha A: dựng gói trên .99 ở /data/ginsengfood-business-platform (D-lead-037), chạy thử trên CSDL rỗng, rồi tắt đường vào.
# .60 KHÔNG đổi gì (chỉ đọc, chép ra từ ~/m34).
# Điều kiện: nền .99 sẵn (Docker + Compose, /data/docker, /data/sao-luu/ginsengfood-business-platform, ssv nhóm docker, gf-tuong-lua);
# Toàn đã chạy lệnh `sudo mv` của nền để có /data/ginsengfood-business-platform rỗng của ssv; toandeptrai (nhánh cục bộ) có bản vá
# đường .99 (CHUYEN_MAY_99.md mục 1). Chạy lại sau khi hỏng: A1 dừng nếu thư mục .99 đã có dữ liệu.
# Chạy: bash "C:/Projects/Project Control/modules/m34/wp/chuyen-may-99/phaA-dung-99.sh"
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
REPO=${M34_REPO:-C:/Projects/ginsengfood-business-platform}
LOG="$NHAT_KY_LOCAL/phaA-$(moc).log"
# Mục của ~/m34 KHÔNG chép (dump, sao lưu, nhật ký, dấu chuyển máy: sinh lại trên .99). Giữ đồng bộ với LOC_FIND bên dưới.
LOAI_TAR="'--exclude=./sao-luu/*.dump' '--exclude=./sao-luu/*.sha256' '--exclude=./sao-luu/*.dang-ghi' --exclude=./sao-luu/hang-ngay --exclude=./nhat-ky --exclude=./_chuyen-may --exclude=./.env.tu-60 --exclude=./DA_CHUYEN_SANG_99.txt"
# Danh sách để so hai máy: tên, loại, cỡ (chỉ tệp thường; cỡ thư mục tuỳ hệ tệp), quyền.
LOC_FIND="-mindepth 1 \\( -path ./nhat-ky -o -path ./sao-luu/hang-ngay -o -path ./_chuyen-may -o -path ./.env.tu-60 -o -path ./DA_CHUYEN_SANG_99.txt -o -path './sao-luu/*.dump' -o -path './sao-luu/*.sha256' -o -path './sao-luu/*.dang-ghi' \\) -prune -o \\( -type f -printf '%p f %s %m\\n' \\) -o -printf '%p %y - %m\\n'"
# Script phải là bản đường .99 của toandeptrai (bản trên .60 còn ~/m34 cứng): 3 guard + cd-entry chọn thư mục theo IP;
# trien-khai.sh, sao-luu.sh dùng .docker của thư mục chứa script.
SCRIPT_GUARD="canh-bao.sh cong-tac-khan.sh m8-gia-lap/lam-moi-ton-thu.sh cd-entry.sh"
SCRIPT_DOCKER="trien-khai.sh sao-luu/sao-luu.sh"
{
  tieu_de "A0 bản vá đường .99 có trên toandeptrai (nhánh cục bộ)"
  for f in $SCRIPT_GUARD; do
    grep -qF "$D99" <<< "$(git -C "$REPO" show "toandeptrai:deploy/m34/$f")" || dung "toandeptrai chưa có đường $D99 trong $f"
  done
  for f in $SCRIPT_DOCKER; do
    grep -qF 'export DOCKER_CONFIG="$PWD/.docker"' <<< "$(git -C "$REPO" show "toandeptrai:deploy/m34/$f")" || dung "toandeptrai chưa có DOCKER_CONFIG theo thư mục trong $f"
  done
  grep -qF DA_CHUYEN_SANG_99.txt <<< "$(git -C "$REPO" show "toandeptrai:deploy/m34/trien-khai.sh")" || dung "toandeptrai chưa có chặn DA_CHUYEN_SANG_99 trong trien-khai.sh"
  grep -qx 'set_real_ip_from 192.168.0.0/23;' <<< "$(git -C "$REPO" show "toandeptrai:deploy/m34/nginx/m34.conf")" || dung "toandeptrai chưa có realip LAN /23 trong nginx/m34.conf"
  echo "có (toandeptrai $(git -C "$REPO" rev-parse --short toandeptrai))"

  tieu_de "A1 .99: $D99 thư mục thật rỗng của ssv, $SL99, Docker /data/docker, cổng 80/8445 trống"
  chay 99 r-a1-chuan-bi-99.sh

  tieu_de "A2 .60 ~/m34 -> .99 $D99: chép tệp máy (gồm .env, secrets/, m8-that/bi-mat/, .docker/: đi trong ống ssh, không ghi đĩa máy Toàn, không in)"
  lenh 60 "cd ~/m34 && tar --numeric-owner -cpf - $LOAI_TAR ." \
    | lenh 99 "cd $D99 && [ -z \"\$(ls -A)\" ] && tar --numeric-owner -xpf - && echo A2_XONG" || dung "A2 chép hỏng"
  b60=$(lenh 60 "cd ~/m34 && find . $LOC_FIND | LC_ALL=C sort | sha256sum | cut -c1-64")
  b99=$(lenh 99 "cd $D99 && find . $LOC_FIND | LC_ALL=C sort | sha256sum | cut -c1-64")
  echo "danh sách tệp (tên, loại, cỡ tệp, quyền) .60 $b60 · .99 $b99"
  [ "$b60" = "$b99" ] || dung "danh sách tệp ~/m34 (.60) và $D99 (.99) lệch"

  tieu_de "A3 .99: .env đổi M34_BIND_IP, M3_CB_BIND_IP, CORS sang .99 (bí mật giữ nguyên, không in)"
  chay 99 r-a3-env-99.sh

  tieu_de "A4 .99: sao-luu/hang-ngay -> $SL99/hang-ngay, nhat-ky, _chuyen-may"
  lenh 99 "cd $D99 && mkdir -p -m 700 nhat-ky sao-luu _chuyen-may && { [ -e sao-luu/hang-ngay ] || ln -s $SL99/hang-ngay sao-luu/hang-ngay; } && [ \"\$(readlink -f sao-luu/hang-ngay)\" = $SL99/hang-ngay ] && echo A4_XONG" \
    || dung "A4 hỏng"

  tieu_de "A5 .99: script bản đường .99 từ toandeptrai ($SCRIPT_GUARD $SCRIPT_DOCKER)"
  for f in $SCRIPT_GUARD $SCRIPT_DOCKER; do
    git -C "$REPO" show "toandeptrai:deploy/m34/$f" \
      | lenh 99 "cd $D99 && if [ -e $f ]; then cat > $f.moi && chmod --reference=$f $f.moi && mv -f $f.moi $f && echo 'thay $f'; else cat > /dev/null; echo 'bỏ qua $f (không có trên .60)'; fi"
  done

  tieu_de "A5b .99: nginx/m34.conf bản toandeptrai (realip LAN 192.168.0.0/23, Toàn chốt 13/11; khối by-code M3-181); bản .60 giữ ở nginx/m34.conf.tu-60"
  git -C "$REPO" show "toandeptrai:deploy/m34/nginx/m34.conf" \
    | lenh 99 "cd $D99 && [ -f nginx/m34.conf ] && cp -p nginx/m34.conf nginx/m34.conf.tu-60 && cat > nginx/m34.conf.moi && chmod --reference=nginx/m34.conf nginx/m34.conf.moi && mv -f nginx/m34.conf.moi nginx/m34.conf && grep -qx 'set_real_ip_from 192.168.0.0/23;' nginx/m34.conf && echo A5B_XONG" \
    || dung "A5b đặt nginx/m34.conf hỏng"

  tieu_de "A6 .99: chứng thư cầu .99, kéo image đúng SHA .60, compose create"
  chay 99 r-a6-anh-99.sh

  tieu_de "A7 .60 -> .99: chép chữ ký ClamAV (m34_clamav) để clamav .99 khoẻ ngay"
  lenh 60 'docker run --rm --network none -v m34_clamav:/v:ro --entrypoint tar postgres:17 -C /v --numeric-owner -cpf - .' \
    | lenh 99 'docker run --rm -i --network none -v m34_clamav:/v --entrypoint tar postgres:17 -C /v --numeric-owner -xpf - && echo A7_XONG' \
    || dung "A7 chép chữ ký ClamAV hỏng"

  tieu_de "A8 .99: chạy thử trên CSDL rỗng, health, rồi tắt nginx/cầu/fe/be"
  chay 99 r-a8-thu-99.sh

  tieu_de "A9 .60 (chỉ đọc): cron gói m34 sẽ cài lên .99 ở B7 (giờ UTC, đường mới)"
  chay 60 r-cron-thu.sh

  tieu_de "PHA A XONG: .99 sẵn, tối đường vào; .60 vẫn phục vụ"
} 2>&1 | tee "$LOG"
