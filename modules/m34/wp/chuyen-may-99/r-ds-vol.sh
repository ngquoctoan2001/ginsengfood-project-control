# r-ds-vol.sh (.60 hoặc .99, CHỈ ĐỌC): mỗi tệp trong các volume đối số một dòng "volume sha256  ./đường-dẫn" (không in nội dung).
# phaB-cat.sh (B0b) giữ danh sách trong biến để so hai máy, không in ra. Volume chưa có thì bỏ qua.
for v in "$@"; do
  [[ $v =~ ^m34_[a-z0-9_-]+$ ]] || dung "tên volume lạ: $v"
  docker volume inspect "$v" > /dev/null 2>&1 || continue
  docker run --rm --network none -v "$v:/v:ro" --entrypoint sh postgres:17 -c 'cd /v && find . -type f -exec sha256sum {} +' < /dev/null \
    | sed "s#^#$v #"
done
