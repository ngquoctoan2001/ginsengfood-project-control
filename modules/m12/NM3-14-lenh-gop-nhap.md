# NM3-14 — chạy bộ nghiệm thu WP06a từ `.60` tới `.61` (NHÁP 13/11, CHƯA CHẠY, chưa đưa Toàn duyệt)

Yêu cầu từ M3-4 (13/11): có phản hồi `/check` thật để NM3-15b làm tươi 13 fixture và chốt SKU-M3-04 (`sku_id` có luôn trong phản hồi không).
Bộ chạy: `tools/integration/m3-acceptance/run-m3-acceptance.mjs` (Node 24, 18 dòng: 13 ca §6 + ca 14 + C37-1..4).

## Vì sao KHÔNG chạy nguyên văn `--profile 61` trên Production
- `profiles/61.json` cứng dữ liệu SANDBOX của `.61` cũ: kho `b0300000-…1002`, SKU `b0400000-…0003/…0002/…0019`, tồn 1000, ≥19 dòng tồn. CSDL Production sạch (P1) không có các id này ⇒ ca FAIL vì dữ liệu, không phải vì lỗi API.
- Ca 10 cần principal THỨ HAI chỉ có `SELLABLE_CHECK` (cấp riêng). Production P1 chỉ có hai principal (M3, M6).
- Ca 4/12/14 cần QR hộp `PRINTED` (lô `GENERATED` ⇒ `TRACE_NOT_READY`). Ca 9 giữ 10 hộp `A2/CS/BASA` 30 phút (cờ tự nhả tắt).
- Chưa kiểm: có Node ≥ 24 trên `.60` không (cần một lệnh chỉ đọc `node --version`).

## Hai đường (đề xuất: A ngay để M3 có fixture; B sau khi Lan nhập kho)
- **A — trước cutover, trên `.61` hiện tại (CSDL sandbox, hồ sơ `61.json` nguyên văn).** Đáp ứng đúng nhu cầu fixture (hình dạng phản hồi, không phụ thuộc dữ liệu). Cần: secret `SVC-M3-SELLABLE` hiện hành trên `.61` (Phúc giữ; token cũ từng 401 ⇒ có thể phải xoay trước) và principal thiếu quyền (chưa kiểm có trên `.61` không). Nếu thiếu principal thiếu quyền: chạy `--cases` bỏ ca 10 và ghi `KHÔNG CHẠY`, không suy thành đạt.
- **B — sau cutover, trên Production:** cần hồ sơ mới (`61-production.json`) lập từ bảng ánh xạ C-M3-3 + tồn Lan nhập + QR `PRINTED`. Chưa lập.

## Cụm lệnh gộp (đường A) để Toàn duyệt MỘT LƯỢT
1. Máy Toàn → `.60`, chỉ đọc: `ssh <.60> 'node --version'` (cần ≥ 24).
2. Máy Toàn → `.60`: `scp -r tools/integration/m3-acceptance <.60>:~/m3acc/` (không có bí mật, không có dữ liệu khách).
3. Trên `.60` (ssh có terminal), nhập bí mật ẩn, không in, không vào lịch sử:
   ```bash
   cd ~/m3acc && read -rs -p 'secret M3: ' M3ACC_CLIENT_SECRET; echo; export M3ACC_CLIENT_SECRET M3ACC_CLIENT_ID=SVC-M3-SELLABLE
   read -rs -p 'secret thieu quyen (bo qua neu khong co): ' M3ACC_LOWPERM_CLIENT_SECRET; echo; export M3ACC_LOWPERM_CLIENT_SECRET M3ACC_LOWPERM_CLIENT_ID=<principal thieu quyen>
   node run-m3-acceptance.mjs --profile profiles/61.json --out ~/m3acc/out-$(date +%d%H%M)
   unset M3ACC_CLIENT_SECRET M3ACC_LOWPERM_CLIENT_SECRET
   ```
4. Máy Toàn: `scp <.60>:~/m3acc/out-*/summary.md` và `raw-log.jsonl` (đã che bí mật) về, gửi M3-4/Phúc kèm `correlationId`. Ca FAIL gửi nguyên, không sửa rồi báo PASS.
- **Tác động:** ghi vào `.61` đúng một lượt giữ hàng 10 hộp `A2/CS/BASA`, tự hết hạn sau 30 phút (cờ tự nhả tắt); trần xin token 10 lần/60 giây/IP dùng chung với M3 trên `.60` (bộ chạy xin tối đa 6/lượt). Không đổi cấu hình, không đổi principal.
- **Điểm lùi:** không cần; nếu chạy lặp trong 30 phút thì giữ cộng dồn (đừng lặp).
- **Trước khi chạy:** đồng bộ với M3-4 (đang chạy cutover Cụm 2 hay chưa: token cũ 401 ⇒ kết quả vô nghĩa) và đặt `--cases` nếu thiếu principal thiếu quyền.

## Trả lời SKU-M3-04 (không cần chạy)
Theo `PL-D` (rà mã 11/11, `Contracts…cs:105-161`): `data.sku_id` LUÔN có trong phản hồi `/check` (cả `SELLABLE` lẫn `NOT_SELLABLE`). Bằng chứng thật sẽ nằm trong `raw-log.jsonl` của lượt trên.
