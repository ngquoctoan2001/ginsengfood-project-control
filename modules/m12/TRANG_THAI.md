# Trạng thái: m12

Mở phiên 27/11/2026, giờ Bangkok. Phiên M1–M2 Operational Core. Quyết định tới D-m12-146. Lịch sử ở [nhật ký 26/11](nhat-ky/2026-11-26.md) và [nhật ký 27/11](nhat-ky/2026-11-27.md).

- **Git · 15:02:** ops-core `main` = `origin/main` = `gitlab/main` = `4bb29f8dff4ca576c756667bb9d1e003870af476`. Thêm 15 commit từ `d4163331c`: kho, dashboard, audit, PWA, đồng bộ sổ tay/catalog/Excel. `c355f22cd` sửa nghiệp vụ PWA, `8d85cd1da` sửa chuyển trang khi gặp 403 (Vitest lọc 2 Đạt), `4bb29f8df` đồng bộ 2.326 ca/626 chức năng theo sổ theo dõi. Diff commit không đổi `deploy/` và đường dẫn EF migrations. Chưa xác minh pipeline GitLab đúng SHA mới.
- **Checkout chung:** 4 worktree phụ, index trống. 5 tệp tracked đang dở: ba tệp màn nhà cung cấp admin-web, `apps/public-trace/app/manifest.ts` và sổ theo dõi Toàn. Hai mục chưa theo dõi gồm cấu hình công cụ local và đường dẫn icon PWA. Khoá `@bo-kiem-du` vẫn thuộc `m12/uat-codex`. Dọn máy đã dừng sáu tiến trình mồ côi, gồm API lab :5200 và web lab :3204. Container PostgreSQL lab và local còn chạy.
- **.99 · 27/11 20:08 (D-m12-146):** `4bb29f8df` **Development** (5 ảnh `git archive`, ID khớp; sao lưu trước PASS 4.217.864 byte; không migration; PG giữ ID). Live/ready 200 (chỉ MISA_SYNC UNKNOWN), ops/pwa/trace 200/307, M3 availability 13/13 lượt 200, 0 lỗi. Chưa kiểm đăng nhập người thật. Đường lui `d4163331c` (5 ảnh còn trên máy). Sheet M12-124.
- **Mốc:** 28/11 chuyển Production và go/no-go, 30/11 chạy thật. **VÀNG nghiêng ĐỎ** cho 30/11 (`/ke-hoach` 27/11 19:3x: mã đủ, nhưng 0 mẻ/0 tồn/0 thao tác người thật trên `.99`, biên bản trống). **48%** theo thang trọng số (17/11: 47). Mốc 15/11 đã qua, ĐỎ theo sổ. Ngoại lệ JWT hết 30/11 lúc 16:59 UTC (23:59 giờ Bangkok). [Thang sẵn sàng](SAN_SANG.md)
- **Sheet 27/11 · 15:02:** đọc lại 123 việc. Có 61 Hoàn thành, 5 Hủy, 29 Đang làm, 11 Chờ review, 15 Chưa bắt đầu, 2 Bị chặn. Trong 57 còn mở, 28 thuộc nối M3 và 29 thuộc M12 khác theo đối chiếu ngày 27/11. Kết luận 10 hồ sơ W/X đã lưu tại phiếu rà. [Đối chiếu Sheet](ra-soat/2026-11-27-review-sheet-codex.md)

## Đang làm và việc chặn

- **WP-UAT / M12-009/105:** Toàn dừng sau L21 lúc 10:28. Sổ lab 2.326 ca gồm 2.253 Đạt, 0 Không đạt, 68 Không áp dụng, 5 Bị chặn, 0 Chưa chạy. L21 đủ 25 Đạt, gồm hai ca mật khẩu Toàn trực tiếp kiểm. Sang/Toàn chuẩn bị thiết bị cho bốn ca camera và một ca cài trang truy xuất bằng Chrome khi Toàn mở lại. Giữ volume và bản sao lưu lab đã kiểm. [Biên bản L21](ra-soat/2026-11-27-luot-uat-codex.md#l21--n01-f03-t04) · [Checklist thiết bị](ra-soat/2026-11-27-chot-ca-uat-bi-chan.md#chuẩn-bị-5-ca-thiết-bị)
- **WP-NT / M12-010, WP22 / M12-054:** dòng 7 (FRM-22, tồn bán được), dòng 9 (M3), tập huấn và chữ ký còn thiếu xác nhận trong biên bản. Toàn/Lan xác nhận mẻ, SKU, kho, đơn vị và tồn. Phúc báo M3 `586a3e7b8` quan sát mỗi bốn phút, cả 19 SKU tồn 0 tại thời điểm báo. CSV đủ 19 mã theo kiểm cục bộ, còn đối chiếu API môi trường phục vụ. Phúc báo bộ nhận webhook đang tắt. S02/S03 chờ tồn mẻ thật, S16 chờ đầu nhận, NK-b giữ NO-GO tạm cho giữ/nhả thật và ENFORCE. [Biên bản mẻ](wp/M12-010-bien-ban-27-11.md) · [Hồ sơ nối M3](ra-soat/2026-11-27-noi-m3-thuc-hien.md)
- **WP17b / m12.244:** phương án đã duyệt ghim `d4163331c` và hai băm compose/Caddyfile. HEAD mới cần bằng chứng và quyết định riêng nếu chọn đổi. Toàn chốt cửa sổ sau khi xưởng ngừng ghi, xác nhận JWT mới khác khóa lịch sử, báo Phúc gián đoạn 1–2 phút, phối hợp Anh Tuấn về TLS. Toàn đã duyệt P0 chỉ đọc sau khi có xác nhận mẻ. Chưa chạy P0. P1–P7 chờ lệnh riêng. P0 ngày 25/11 có một ảnh thử bản rõ, cần xác định lại phạm vi và quyết định riêng nếu còn phải cách ly. Phạm vi P7 tự sửa cũng cần chốt. [Phiếu chuyển 28/11](ra-soat/2026-11-26-chot-27-28-11.md#2811--m12244-chuyển-99-sang-production)
- **Các phiếu còn dở:** WP12g giữ bằng chứng kiểm lọc và phần HDSD còn phải đối chiếu khi rà lại. WP24/WP28 còn cổng thiết bị và bố cục. WP25/WP27/WP29 và WP30–33 còn trạng thái mở ở phiếu lịch sử, cần so SHA/bằng chứng trước khi chốt. WP32 giữ cờ tắt qua mốc chạy thật theo D-m12-140. WP33 còn việc cấu hình. WP chuyển máy .99 còn phần vận hành/CD. Không mở thêm đợt code trong lượt đầu phiên.
- **Nợ và phụ thuộc:** WP18b khôi phục, cảnh báo và thử tải; CI đêm chờ quyền; m12.242 lịch giám sát chờ lệnh `go`; m12.204 lô cũ chờ danh sách; DIET-2 chờ chú Dũng; SEC-11 đã dời sau 30/11, còn đối chiếu thứ tự với ký NM3-99. MISA và in tem đã hoãn.

## Cần Toàn quyết / làm tay

- **D-m12-145/146 (27/11):** bản chạy thật `4bb29f8df` — ĐÃ lên `.99` Development 20:08; webhook M12→M3 + 3 nợ S3 dời sau 30/11; hồ sơ đóng JWT có bản nháp + script tự kiểm ĐẠT ở `_wt/_luu/m12-jwt-dong` (điền sau P2; cùng commit phải sửa `.gitlab-ci.yml` 2 dòng ghim). **Cần Toàn:** giờ P0–P7 sáng 28/11 (Phúc lên BP chiều 28/11); chạy job JWT pipeline tay trên `4bb29f8df` trước P2 để chắc gitleaks vẫn 3 phát hiện (đề xuất có). [SAN_SANG](SAN_SANG.md)

- **m12.244:** Toàn duyệt kế hoạch sáng 28/11, candidate `d4163331c` và P0 chỉ đọc sau xác nhận mẻ. Chưa có giờ bắt đầu cụ thể. Hai băm compose/Caddyfile đã đối chiếu lại từ blob Git. P1–P7 chờ P0 đạt, đủ điều kiện tay và lệnh riêng.
- **m12.247:** Toàn giao Codex kiểm FRM-22, nhập kho và đối chiếu S02/S03 ở chế độ quan sát bằng ChatGPT Extension trên Chrome. Đã vào được `ops.ginsengfood.vn` sau khi Toàn cấp quyền và đăng nhập. Kiểm 15:21: danh sách nhập kho không có phiếu và 19/19 SKU hiển thị Chưa có tồn, 0 mẻ. Dòng 7 chờ chứng từ FRM-22, dòng 9 chờ tồn bán được. S02/S03 và P0 chưa chạy.
- **m12.248:** Toàn giao Codex làm tiếp năm ca thiết bị trên Chrome. Windows hiện không nhận diện camera vật lý, bốn ca quét còn cần thiết bị. Ca cài trang truy xuất chờ bàn giao lượt lab do `m12/uat-codex` còn giữ khóa. Chưa đổi kết quả UAT.

## Kế tiếp

1. WP-NT: ghi nhận mẻ, tập huấn và chữ ký theo chứng cứ nội bộ.
2. WP17b: đối chiếu SHA đang phục vụ và chạy P0 theo lệnh riêng. Chuẩn bị cửa sổ rollback và hồ sơ xác nhận theo pha.
3. WP22: sau khi có tồn bán được, đối chiếu S02/S03 ở chế độ quan sát. WP-UAT chỉ mở lại theo quyết định m12.248.
