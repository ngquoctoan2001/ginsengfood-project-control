# r-ke-vol.sh (.60 hoặc .99): số tệp + băm (tên tệp + nội dung) của từng volume nêu ở đối số. Không in tên tệp.
# Volume không có thì dừng (không để docker tự tạo volume rỗng rồi hai máy "khớp" ở 0 tệp).
for v in "$@"; do
  [[ $v =~ ^m34_[a-z0-9_-]+$ ]] || dung "tên volume lạ: $v"
  kq=$(ke_volume "$v") || dung "không có volume $v"
  printf '%s %s\n' "$v" "$kq"
done
