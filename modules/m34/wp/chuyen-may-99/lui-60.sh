#!/usr/bin/env bash
# ĐƯỜNG LUI: .99 tắt đường vào (nginx, cầu, fe, be) và gỡ cron gói m34; .60 khôi phục crontab đã lưu ở B1 và bật lại cả gói.
# Chỉ dùng khi .99 CHƯA nhận ghi thật. Kiểm trước khi đổi gì (L0): .60 đã qua pha D (DA_CHUYEN_SANG_99.txt) hoặc số dòng CSDL .99
# khác số đếm .60 lúc cắt (be .99 đã chạy trên dữ liệu thật từ B6) thì DỪNG: phải dump .99 nạp ngược về .60 trước
# (deploy/m34/CHUYEN_MAY_99.md mục 7, KHOI_PHUC.md). Toàn đã xem và quyết lui dù mất phần ghi trên .99:
#   M34_LUI_SAU_GHI=co bash ".../lui-60.sh"
# Dấu trên .60 (phaB ghi b6-bat-dau trước B6 và c-cong-vao-99 khi xong, vì Anh Tuấn có thể trỏ cổng vào bất cứ lúc nào sau đó): đã qua B6
# mà không kiểm được .99 (ssh lỗi, pg .99 dừng), hoặc cổng vào có thể đã trỏ .99 (số dòng không thấy UPDATE) thì cũng dừng, đòi M34_LUI_SAU_GHI=co. Chưa tới B6 mà .99 không vào được: vẫn bật lại .60, in CẢNH BÁO.
# Chạy: bash "C:/Projects/Project Control/modules/m34/wp/chuyen-may-99/lui-60.sh"
. "$(dirname "${BASH_SOURCE[0]}")/chung.sh"
LOG="$NHAT_KY_LOCAL/lui-60-$(moc).log"
SAU_GHI=${M34_LUI_SAU_GHI:-khong}
case $SAU_GHI in co|khong) ;; *) dung "M34_LUI_SAU_GHI chỉ nhận co hoặc khong" ;; esac
{
  tieu_de "L0a .60 (chỉ đọc): đã qua pha D chưa, dấu B6/pha C"
  rc=0; out60=$(chay 60 r-lui-kiem-60.sh) || rc=$?
  printf '%s\n' "$out60"
  dau_b6=$(sed -n 's/^DAU_b6-bat-dau=//p' <<< "$out60"); dau_c=$(sed -n 's/^DAU_c-cong-vao-99=//p' <<< "$out60")
  case $rc in
    0) ;;
    3) [ "$SAU_GHI" = co ] || dung ".60 đã qua pha D: .99 là máy phục vụ. Theo CHUYEN_MAY_99.md mục 7, hoặc Toàn quyết: M34_LUI_SAU_GHI=co"
       echo "M34_LUI_SAU_GHI=co: Toàn đã quyết lui sau pha D" ;;
    *) dung "không kiểm được .60 (mã $rc): không lui" ;;
  esac

  tieu_de "L0b .99 (chỉ đọc): đã nhận ghi sau cắt chưa (số dòng từng bảng so với .60 lúc cắt)"
  rc=0; chay 99 r-lui-kiem-99.sh || rc=$?
  case $rc in
    0) if [ -n "$dau_c" ]; then
         [ "$SAU_GHI" = co ] || dung "cổng vào có thể đã trỏ .99 từ $dau_c (pha B xong): số dòng khớp chưa chắc .99 không có UPDATE. Theo CHUYEN_MAY_99.md mục 7, hoặc Toàn quyết: M34_LUI_SAU_GHI=co"
         echo "M34_LUI_SAU_GHI=co: Toàn đã quyết lui sau pha B/C"
       fi ;;
    3) [ "$SAU_GHI" = co ] || dung ".99 đã ghi sau cắt (bảng lệch ở trên): lui thẳng sẽ mất phần đó. Theo CHUYEN_MAY_99.md mục 7, hoặc Toàn quyết: M34_LUI_SAU_GHI=co"
       echo "M34_LUI_SAU_GHI=co: Toàn đã quyết lui dù .99 lệch" ;;
    *) if [ -n "$dau_b6" ]; then
         [ "$SAU_GHI" = co ] || dung "không kiểm được .99 (mã $rc; 255 = ssh không vào được) mà be .99 đã bật từ $dau_b6 (B6): có thể đã nhận ghi. Kiểm tay .99, hoặc Toàn quyết: M34_LUI_SAU_GHI=co"
         echo "M34_LUI_SAU_GHI=co: Toàn đã quyết lui dù không kiểm được .99"
       fi
       echo "CẢNH BÁO: không kiểm được .99 (mã $rc; 255 = ssh không vào được). Lui tiếp; khi vào được .99 phải tắt đường vào .99 tay." ;;
  esac

  tieu_de "L1 .99: tắt đường vào, gỡ cron gói m34"
  rc=0; chay 99 r-lui-99.sh || rc=$?
  [ "$rc" = 0 ] || echo "CẢNH BÁO: L1 hỏng (mã $rc): .99 có thể còn phục vụ trên 192.168.1.99:80 và còn cron; tắt tay khi vào được (cd $D99 && docker compose stop nginx m8that-cb fe be; gỡ dòng $D99 trong crontab)"

  tieu_de "L2 .60: khôi phục crontab, bật lại ~/m34"
  chay 60 r-lui-60.sh "$SAU_GHI"
  tieu_de "ĐÃ LUI VỀ .60"
} 2>&1 | tee "$LOG"
