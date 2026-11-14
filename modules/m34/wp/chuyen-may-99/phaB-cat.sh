#!/usr/bin/env bash
# Pha B: CỬA SỔ CẮT (D-lead-038: không khung giờ cố định; chạy khi m12 đã ở .99 và Toàn duyệt liền, không giữa buổi chạy mốc D 14/11;
# Toàn nhắn nhóm Phúc/Tài một câu trước khi chạy). .60 ngừng phục vụ từ B1 tới khi cổng vào trỏ .99 (pha C).
# Điều kiện: pha A xong (.99 tối đường vào, pg/redis/clamav chạy). Đo thử 10/11: nạp dump ~10 s; cả pha ước 10–20 phút.
# Hỏng ở bất kỳ bước nào: dừng ngay, in DỪNG. Trước B6 thì .60 còn nguyên dữ liệu: chạy lui-60.sh là về như cũ.
# .60 ở ~/m34; .99 ở /data/ginsengfood-business-platform, dump cửa sổ ở /data/sao-luu/ginsengfood-business-platform/chuyen-may.
# Chạy: bash "C:/Projects/Project Control/modules/m34/wp/chuyen-may-99/phaB-cat.sh"
# B0 dừng nếu compose.override.yml .99 còn dòng 192.168.1.60 không phải chú thích; đã xem và giữ được thì: M34_OVERRIDE_DA_XEM=co bash .../phaB-cat.sh
# B0b dừng nếu m34_uploads/m34_mail .99 có tệp .60 không có y hệt; đã xem (chỉ là tệp be sinh lúc chạy thử A8, .99 chưa phục vụ) thì M34_XOA_VOL_99=co.
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
LOG="$NHAT_KY_LOCAL/phaB-$(moc).log"
OUT_B2=$(mktemp)
trap 'rm -f -- "$OUT_B2"' EXIT
{
  tieu_de "B0 .99 đủ điều kiện nhận (chỉ đọc; hỏng thì .60 chưa đổi gì)"
  chay 99 r-b0-kiem-99.sh "${M34_OVERRIDE_DA_XEM:-khong}"
  ban60=$(lenh 60 "sed -n 's/^M34_BAN=//p' ~/m34/.env | tail -n 1")
  ban99=$(lenh 99 "sed -n 's/^M34_BAN=//p' $D99/.env | tail -n 1")
  echo "hai máy cùng bản: .60 $ban60 · .99 $ban99"
  [ "$ban60" = "$ban99" ] && [[ $ban60 =~ ^[0-9a-f]{40}$ ]] || dung "M34_BAN hai máy khác nhau (đổi bản giữa pha A và B?): chạy lại A6 trên .99"
  oc60=$(lenh 60 "sed -n 's/^OPS_CORE_BASE_URL=//p' ~/m34/.env | tail -n 1")
  echo "OPS_CORE_BASE_URL trên .60: ${oc60:-(chưa đặt)}"
  case $oc60 in
    ''|http://192.168.1.99:5000|http://192.168.1.99:5000/*) ;;
    *) echo "CHÚ Ý: M3 trên .60 còn gọi M12 ở $oc60: m12 đã cắt sang .99 chưa (D-lead-038: m12 trước m34)? Sau B6, be .99 gọi đúng địa chỉ này." ;;
  esac

  # B0b TRƯỚC B1: A8 (be chạy thử trên CSDL rỗng) tự sinh tệp trong m34_uploads .99 (14/11: 60 content + 34 seed). .99 chỉ được có tệp
  # trùng hệt .60 (đường dẫn + sha256): khi đó B4 làm rỗng rồi chép lại; có tệp .60 không có y hệt thì dừng ở đây, .60 chưa đổi gì,
  # trừ khi M34_XOA_VOL_99=co (Toàn/phiên đã xem: tệp sinh lúc A8, nhật ký nginx .99 không có khách).
  tieu_de "B0b volume m34_uploads/m34_mail .99 so với .60 (chỉ đọc; danh sách giữ trong biến, không in)"
  ds60=$(chay 60 r-ds-vol.sh m34_uploads m34_mail | sort)
  ds99=$(chay 99 r-ds-vol.sh m34_uploads m34_mail | sort)
  XOA_VOL=khong
  if [ -n "$ds99" ]; then
    rieng99=$(comm -13 <(printf '%s\n' "$ds60") <(printf '%s\n' "$ds99") | grep -c . || true)
    if [ "$rieng99" = 0 ]; then
      echo "  .99 có $(printf '%s\n' "$ds99" | grep -c .) tệp, đều trùng hệt .60 (be tự sinh lúc chạy thử): B4 làm rỗng rồi chép lại"
    elif [ "${M34_XOA_VOL_99:-khong}" = co ]; then
      echo "  .99 có $(printf '%s\n' "$ds99" | grep -c .) tệp, $rieng99 tệp .60 không có y hệt: làm rỗng theo cờ M34_XOA_VOL_99=co (tệp chạy thử A8) rồi chép lại"
    else
      dung "B0b: .99 có $rieng99 tệp trong m34_uploads/m34_mail mà .60 không có y hệt (dữ liệu ghi trên .99 ở lượt trước?): không xoá; .60 chưa đổi gì. Chỉ là tệp chạy thử A8 thì chạy lại với M34_XOA_VOL_99=co"
    fi
    XOA_VOL=co
  else
    echo "  .99 chưa có tệp nào"
  fi

  tieu_de "B1 .60: BẢO TRÌ: lưu + gỡ cron gói m34, dừng nginx, cầu M8, fe, be (từ giờ khách/admin/M8 không vào được)"
  chay 60 r-b1-bao-tri-60.sh

  tieu_de "B2 .60: pg_dump, kiểm, sha256, đếm bảng; dừng redis"
  chay 60 r-b2-dump-60.sh | tee "$OUT_B2"
  TEP=$(sed -n 's/^TEP=//p' "$OUT_B2"); SHA=$(sed -n 's/^SHA=//p' "$OUT_B2")
  [[ $TEP =~ ^chuyen-may-99-[0-9TZ]+-[0-9a-f]{8}\.dump$ ]] && [[ $SHA =~ ^[0-9a-f]{64}$ ]] && grep -qx B2_XONG "$OUT_B2" \
    || dung "B2 chưa xong hoặc không đọc được TEP/SHA (lui-60.sh để bật lại .60)"

  tieu_de "B3 .60 -> .99: dump, số đếm, crontab đã lưu"
  sha99=$(lenh 60 "cat ~/m34/sao-luu/$TEP" | lenh 99 "cat > $SL99/chuyen-may/$TEP && sha256sum $SL99/chuyen-may/$TEP | cut -c1-64")
  echo "sha256 .60 $SHA · .99 $sha99"
  [ "$sha99" = "$SHA" ] || dung "dump chép sang .99 lệch sha256 (lui-60.sh để bật lại .60)"
  lenh 60 'cat ~/m34/_chuyen-may/dem-60.tsv' | lenh 99 "cat > $D99/_chuyen-may/dem-60.tsv" || dung "B3 chép số đếm hỏng"
  lenh 60 'cat ~/m34/_chuyen-may/crontab.60.truoc' | lenh 99 "cat > $D99/_chuyen-may/crontab.60.truoc" || dung "B3 chép crontab hỏng"

  tieu_de "B3b .60 -> .99: chép lại .env + secrets/ (m12 cắt trước có thể đã đổi OPS_CORE_BASE_URL, bí mật client ops-core), áp lại A3"
  lenh 60 'cd ~/m34 && tar --numeric-owner -cpf - .env $(test -d secrets && echo secrets)' \
    | lenh 99 "cd $D99 && tar --numeric-owner -xpf - && echo 'đã chép .env + secrets/ (không in)'" || dung "B3b chép .env hỏng"
  chay 99 r-a3-env-99.sh

  tieu_de "B4 .60 -> .99: volume m34_uploads (tệp khách tải lên), m34_mail, m34_redis"
  chay 99 r-b4-don-99.sh "$XOA_VOL"
  for v in m34_uploads m34_mail m34_redis; do
    lenh 60 "docker run --rm --network none -v $v:/v:ro --entrypoint tar postgres:17 -C /v --numeric-owner -cpf - ." \
      | lenh 99 "docker run --rm -i --network none -v $v:/v --entrypoint tar postgres:17 -C /v --numeric-owner -xpf - && echo 'đã chép $v'" \
      || dung "B4 chép $v hỏng"
  done
  k60=$(chay 60 r-ke-vol.sh m34_uploads m34_mail m34_redis)
  k99=$(chay 99 r-ke-vol.sh m34_uploads m34_mail m34_redis)
  printf '.60:\n%s\n.99:\n%s\n' "$k60" "$k99"
  [ "$k60" = "$k99" ] || dung "số tệp/băm volume hai máy lệch (lui-60.sh để bật lại .60)"

  tieu_de "B5 .99: nạp dump, so số dòng từng bảng với .60"
  chay 99 r-b5-nap-99.sh "$TEP" "$SHA"

  tieu_de "B6 .99: bật cả gói, health, Flyway, log"
  lenh 60 'date -u +%FT%TZ > ~/m34/_chuyen-may/b6-bat-dau' || dung "không ghi được dấu B6 trên .60 (chưa bật .99; lui-60.sh để bật lại .60)"
  chay 99 r-b6-len-99.sh

  tieu_de "B7 .99: cron gói m34 (giờ UTC, đường $D99) + sao lưu hằng ngày chạy thử"
  chay 99 r-b7-cron-99.sh

  tieu_de "B8 kiểm khói từ máy Toàn (LAN)"
  for d in /nginx-health /api/health/ready /vi /admin; do
    printf '  http://192.168.1.99%s %s\n' "$d" "$(curl -s -m 8 -o /dev/null -w '%{http_code}' "http://192.168.1.99$d" || echo 000)"
  done

  lenh 60 'date -u +%FT%TZ > ~/m34/_chuyen-may/c-cong-vao-99' || echo "CẢNH BÁO: không ghi được dấu cổng vào trên .60"
  echo "dấu cổng vào ghi trên .60: từ giờ lui-60.sh đòi M34_LUI_SAU_GHI=co (Anh Tuấn có thể trỏ cổng vào bất cứ lúc nào)"
  tieu_de "PHA B XONG: .99 phục vụ trên 192.168.1.99:80; .60 dừng be/fe/nginx (dữ liệu nguyên). Kế: Anh Tuấn trỏ cổng vào (pha C)"
} 2>&1 | tee "$LOG"
