# M1–M2 · Phiếu thực thi Development và Production trên .99

**Hồ sơ 26/11/2026.** Toàn đã đồng ý các phương án trong phiên điều phối và ra lệnh riêng m12.243b (D-m12-142). Lượt đọc P0 sau mẻ thật và lượt P1–P7 có phạm vi riêng. Phiên UAT giữ quyền chạy test sau khi m12.243b xong.

## Kết quả m12.243b ngày 26/11

- `.99` chạy **`d4163331ce9804f625c81bc448a23a2298f757b4` Development từ 09:16:10 giờ Việt Nam**. Đối chiếu 5 image ID và nhãn revision trước/sau khi nạp. 4 dịch vụ ứng dụng đang dùng đúng ảnh. Đường lui `7c7d07234f6fdb2292c711dee5c1d319503137f9`.
- Sao lưu tiền kiểm PASS, bản ngay trước đổi container lúc 09:15:48 **PASS**, 3.681.867 byte. Migrator báo không có migration mới cần áp. PostgreSQL cùng ID, Compose giữ đúng nội dung Development ban đầu.
- Sáu dịch vụ chạy. Health live/ready, API cấu hình đăng nhập, trang đăng nhập Admin/PWA và trang truy xuất trả 200. Phần đăng nhập kiểm ở mức tuyến HTTP. M3 thực hiện **19/19** lời gọi availability trả 200 trong lượt đối chiếu sau nâng, không thấy 401/403/429/500 ở các lời gọi này.
- Máy Windows khởi động lại giữa lượt dựng. Ba ảnh hoàn tất được giữ lại, sau khi mở lại Docker chỉ dựng tiếp Public Trace và Shopfloor PWA. Lượt kiểm duy nhất đã bàn giao lại cho UAT.

## Bản ứng viên và đường lui

| Mục | Giá trị hoặc việc cần xác minh |
|---|---|
| Candidate | `d4163331ce9804f625c81bc448a23a2298f757b4`. HEAD và hai nhánh theo dõi remote cục bộ cùng SHA lúc rà. Hai commit đã lên remote theo nhật ký 26/11. Diff từ `7c7d07234` không đổi deploy hay migration. |
| Compose SHA-256 | `1df348da708da6831537a02b59e1de860c37fde70f3eebf8a3ff522481b1a550` |
| Caddyfile SHA-256 | `3639671f7118bfbb7a4624751a1a8c32912196794d3c333b06ce170c719f7a3c` |
| Bản chạy được ghi nhận | `d4163331c` Development từ 26/11 09:16:10. Đường lui xác minh của m12.243b là `7c7d07234`. |
| Phạm vi hash | Hai băm lấy từ byte blob Git, trùng ở `7c7d07234` và candidate. Dùng gói giải nén từ `git archive` để giữ LF. |

## 1. Development · m12.243b

| Bước | Thực hiện khi được Toàn giao | Dừng khi |
|---|---|---|
| 1. Chốt cửa sổ | Chốt giờ trước khi Toàn nhập dữ liệu nền tối 26/11. Toàn báo Phúc gián đoạn dự kiến 1–2 phút. Xác nhận có người đối chiếu M3 sau nâng. Ghi phạm vi dựng đúng 5 ảnh, nạp ảnh qua SSH, chạy `trien-khai.sh`, sao lưu và kiểm sau nâng. Script tự cập nhật `M12_BAN` trong `.env` và lịch sử `PHIEN_BAN` khi đạt. | Chưa có lệnh rõ phạm vi và khung giờ hoặc xưởng đang ghi phiếu. |
| 2. Tiền kiểm máy | Đối chiếu commit đang chạy theo `PHIEN_BAN`, tag và dịch vụ. Kiểm fingerprint cấu hình Compose theo phương thức đã duyệt, ID PostgreSQL, dung lượng, hồ sơ khôi phục 25/11, tình trạng sao lưu và đủ tag bản lui. Đối chiếu SEC-19 như dưới. | Bản, Compose, backup, đường lui hoặc ảnh đang phục vụ chưa xác minh được. |
| 3. Dựng 5 ảnh | Dùng Git Bash và `build_m12_images_sha.sh` với SHA 40 ký tự và `--can-head`. Soát thư mục tạm trước vì script dùng đường dẫn scratch của phiên cũ. Dựng từ tar mới lấy bằng `git archive`. Đối chiếu năm tag, image ID, OCI revision và `SOURCE_REVISION` của API theo cơ chế của ảnh. Nhường máy cho phiên kiểm thử nếu đang chạy. | HEAD khác SHA đã duyệt, context lấy từ cây dở, scratch hỏng hoặc thiếu một ảnh. |
| 4. Nạp và nâng | Truyền 5 tag bằng pipeline nhị phân Git Bash có `pipefail`. Đối chiếu manifest 5 ảnh tại đích trước khi gọi script để tránh nhánh kéo ảnh thiếu từ registry. Script khóa lượt, sao lưu, chạy bước migrate và nâng. Diff candidate không có migration mới, đối chiếu log cho bước migrate. | Nạp thiếu ảnh, sao lưu lỗi, kết quả migrate khác dự kiến hoặc chỉ báo script nói bản đã chạy trong khi các nguồn còn lệch. |
| 5. Xác minh | Bản/ảnh/dịch vụ khớp SHA, sáu dịch vụ khỏe, `/health/live` 200, Toàn kiểm đăng nhập và đường web. Ghi ít nhất một lần M3 gọi availability thật trả 200, đối chiếu log lỗi và ID PostgreSQL. | Script tự lùi khi kiểm health trong bước nâng thất bại. Nếu kiểm nghiệp vụ sau nâng không đạt, dừng bàn giao, đối chiếu bản đang chạy và dùng đường lui đã xác nhận khi Toàn đã duyệt cách lùi. |

**SEC-19 trước m12.243b.** Đầu runbook WP17b có cảnh báo chung cho `trien-khai.sh`. Mục 8 giải thích sự cố khi lệnh toàn stack tạo lại PostgreSQL theo Compose Production có `read_only` và `tmpfs /tmp`, trong khi script sao lưu có thể dùng `docker cp` từ `/tmp`. Đợt 25/11 chạy trên Compose Development và có sao lưu PASS. Trước lượt mới phải xác minh máy vẫn dùng đúng Compose Development, cơ chế sao lưu hiện hành đã được xác nhận và Toàn chốt phạm vi theo cảnh báo. Nếu Compose đã đổi hoặc còn nghi ngờ tương thích, dùng cổng bước 0 của WP17 trước khi gọi lệnh toàn stack.

**Đường lui Development.** Lấy bản đang phục vụ ngay trước lượt, chỉ dùng `7c7d07234` nếu đã xác minh. Script có thể lùi dịch vụ về tag cũ, phần migrate đã chạy đứng riêng. Khi có tác động DB ngoài dự kiến, lưu bằng chứng và trình Toàn quyết phục hồi DB theo hồ sơ sao lưu.

## 2. Production · m12.244

1. **Chuẩn bị sau buổi 27/11.** Chốt cửa sổ sáng 28/11 sau khi xưởng ngừng ghi. Toàn báo Phúc gián đoạn 1–2 phút tại P6 và chuẩn bị cho người dùng đăng nhập lại sau xoay JWT. Theo nhật ký 25/11, ba phiếu nhập đã có đủ Trưởng ngày, QC và Kế toán kho. Đối chiếu lại trên giao diện vì P0 chỉ cảnh báo và bộ đọc SQL có trường hợp lệch với cách ứng dụng diễn giải.
2. **Đặt gói và P0 chỉ đọc.** Chờ lệnh ghi rõ phạm vi chép gói từ Git lên .99 nếu gói chưa có, rồi chạy `p0-kiem-truoc.sh --dry-run --ban d4163331c` trên máy sau khi Toàn duyệt lượt đọc. P0 đọc chỉ báo qua script và có thể dùng container quét tạm với kho gắn chỉ đọc. `--ban` kiểm bản đang phục vụ. Trước khi qua P1 cần bản khớp, dữ liệu đúng, đĩa ≥ 2 GB, backup gần nhất ≤ 2 giờ theo mặc định, kiểm kho và mode khoá đạt. Soát cả cảnh báo, kể cả liên kết mềm trong kho nếu có, và ghi số đếm an toàn.
3. **Ảnh bản rõ 20/11 và khoá bằng chứng.** Từ nhật ký có một ảnh thử bản rõ. Chỉ đề nghị cách ly đúng đối tượng thử đã xác nhận thông tin tham chiếu và đã có lệnh Toàn, lưu ở nơi hạn chế truy cập ngoài thư mục API quét. Giữ nguyên hồ sơ bằng chứng thật và chạy lại P0 để xác nhận không còn tệp bản rõ, hỏng, không đọc được hoặc dữ liệu tải dở chưa xử lý. Nếu tệp lỗi thuộc hồ sơ thật hoặc P0 báo không chuyển được khoá, dừng. P2 phải chuyển nguyên khoá mã hoá hiện dùng theo D-m12-139. Xác minh khả năng đọc hồ sơ thật đã mã hoá trước khi nghiệm thu.
4. **Khóa JWT và TLS.** Toàn xác nhận khoá JWT mới khác khoá lịch sử. P2 sinh tại .99, P7 đối chiếu attestation. Hồ sơ đóng ngoại lệ dùng dấu vết được phép công bố, không dùng giá trị khoá, hạn **30/11 23:59 giờ Việt Nam**. Với Anh Tuấn, giữ đường TLS đã chọn qua proxy .98 đến đệm Caddy của .99, kiểm chứng chỉ hợp lệ và đệm trả 204 từ API mới. Phúc xác nhận riêng bên nhận thật và cách bàn giao khoá ký. Đệm 204 chỉ xác nhận chặng TLS/đệm. Sau mẻ thật rà lại outbox và dead-letter vì P6 chỉ cảnh báo nếu đệm lỗi.
5. **Lệnh thực thi tách riêng.** Toàn duyệt candidate, hai băm, cửa sổ và P1–P7 trong `tmux`. Wrapper tự chạy lại P0 và gọi P7 với `--tu-sua-nguon`. Nếu nhận 403 và xác định đúng nguồn M3, nhánh này ghi ô 2 của allowlist và tạo lại API thêm một lần. Lệnh chạy wrapper phải bao gồm quyền cho nhánh đó. Nếu phạm vi chỉ cho kiểm nguồn, chạy từng pha theo runbook trong cùng lượt và gọi P7 không kèm cờ tự sửa. Lượt khởi động lại để kiểm OPS-01 là thao tác riêng, có thêm gián đoạn.

Mẫu lệnh **chờ Toàn duyệt đúng phạm vi wrapper**, chạy trong `tmux` trên .99 sau P0 đạt:

```bash
umask 077
G=/data/ginsengfood-ops-core/goi-production/deploy/m12/chuyen-production-99
bash "$G/chay-tat-ca.sh" --ban d4163331c \
  --sha-compose 1df348da708da6831537a02b59e1de860c37fde70f3eebf8a3ff522481b1a550 \
  --sha-caddyfile 3639671f7118bfbb7a4624751a1a8c32912196794d3c333b06ce170c719f7a3c
```

| Pha | Bằng chứng cần ghi | Khi có lỗi |
|---|---|---|
| P1 | Backup mới có PASS, ID PostgreSQL/Caddy, bản trước | Dừng trước P2 |
| P2–P5 | Khoá bằng chứng đã chuyển nguyên giá trị, fingerprint JWT theo phạm vi, bản sao gốc của cấu hình, hai băm đúng, cấu hình kiểm đạt | Dừng. Nếu đã ghi cấu hình, dùng `lui.sh` của đúng lượt khi được Toàn giao. |
| P6 | Caddy hợp lệ, API và ba web chạy. PostgreSQL giữ ID, API health 200. Đệm webhook trả 204 hoặc có sự cố chờ xử lý trước dùng outbox thật. | P6 tự gọi `lui.sh` khi lỗi hoặc nhận tín hiệu ngắt. Kiểm log kết quả lùi và trạng thái dịch vụ. |
| P7 và kiểm tay | Production và đúng CSDL, sáu dịch vụ khỏe, ID PostgreSQL như P1, quên mật khẩu tắt, đăng nhập thường và mail do Toàn kiểm. Đối chiếu JWT attestation, M3 thật có ít nhất một lần availability 200. Một 401 rồi 200 sau đổi JWT là dự kiến, 403/429 hoặc 401 cuối là lỗi. | Nếu script báo hoàn tất nhưng chưa thấy M3 gọi, giữ trạng thái chờ, phối hợp Phúc và xác minh trước nghiệm thu. Nếu API không khỏe, chọn lùi theo runbook của đúng lượt. |

**Đường lui Production.** Gói dùng bản sao cấu hình gốc của lượt và tag hiện có. Chỉ ghi lùi thành công khi `LUI_XONG`, dịch vụ khỏe và đường M3 tiếp tục hoạt động. Xem trạng thái lượt trong `tmux` nếu SSH rớt. Nếu mất tiến trình hoặc chưa rõ hệ đang ở pha nào, dùng runbook lùi thay vì gọi lệnh toàn stack. Khi đã có bằng chứng thật sau chuyển, xác minh đọc được sau lùi trước khi bàn giao.

**SEC-19 sau Production.** P6 chỉ đổi dịch vụ cần thiết, giữ ID PostgreSQL. Trước CD kế tiếp có thể tạo lại PostgreSQL, làm cổng bước 0 WP17: xác minh script backup không phụ thuộc `docker cp` từ tmpfs, dùng dump ra stdout/host hoặc bind, và có backup PASS trước/sau thay đổi PostgreSQL. Theo dõi backup cron đầu tiên, 401/403/429, dead-letter và đối soát M3 trong hypercare.

## Nguồn và ranh giới

- [Lịch sử triển khai và P0 ngày 25/11](../nhat-ky/2026-11-25.md)
- [Chốt 26–28/11](2026-11-26-chot-27-28-11.md)
- [Script dựng ảnh từ Git](build_m12_images_sha.sh)
- Trong ops-core, runbook `25-11-chuyen-production-99-runbook.md` mục 2–9, WP17 mục 2.3 bước 0, `deploy/m12/trien-khai.sh` và `deploy/m12/chuyen-production-99/chay-tat-ca.sh`.

Trạng thái M1–M2 đã hoàn tất m12.243b trên .99 Development, lượt P0 sau mẻ thật và P1–P7 chờ lệnh riêng.
