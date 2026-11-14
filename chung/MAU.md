# Mẫu tệp

Chép đúng khung, điền nội dung. Tên tệp ASCII không dấu.

## 0. Sẵn sàng của luồng — `modules/<mã>/SAN_SANG.md`

`/ke-hoach` dựng theo khung này; bỏ chữ "BẢN NHÁP" khi mọi bậc đã có bằng chứng.

```markdown
# Sẵn sàng — <luồng>

Mốc: <dd/mm hh:mm> · % sẵn sàng: <X> (trung bình trọng số) · Kịp 15/11: XANH|VÀNG|ĐỎ — <một câu vì sao>

## Hạng mục lõi (tổng trọng số 100)
| Hạng mục (người ngoài hiểu được) | Trọng số | Bậc | Bằng chứng (tệp:dòng / lệnh / SHA) |

## Cổng G1–G8 (`chung/CONG_PRODUCTION.md` §3)
| Cổng | Đạt / chưa / không áp dụng | Thiếu gì |

## Gói việc
| WP | Mục tiêu | Rủi ro | Phụ thuộc | Mốc | Ước lượng | Trạng thái (theo phiếu `wp/`) |

## Đường găng tới mốc A–D
## Việc ngoài code (phiên `lead` gom về `modules/lead/VIEC_NGOAI.md`)
| Việc | Ai gỡ | Cần trước ngày | Trạng thái |

## Không kịp 15/11 + bản tối thiểu chạy được 15/11
```

## 1. Phiếu gói việc — `modules/<mã>/wp/<WP>.md`

Phiên chính tạo phiếu **trước khi giao** (`/song` bước 3) và cập nhật sau mỗi vòng. Phiếu vừa là brief cho subagent, vừa là
bằng chứng cho báo cáo tuần, vừa là chỗ phiên mới đọc để làm tiếp khi phiên cũ hỏng. Một WP một phiếu, ≤ 80 dòng, không tách theo lượt.

```markdown
# <WP> — <tên dễ hiểu>

Trạng thái: SẴN SÀNG | ĐANG LÀM | CHỜ KIỂM | ĐẠT | CẦN SỬA | CHẶN | HUỶ · Rủi ro: R1|R2|R3 · Chế độ: W|S|A · Mốc: A–D
Hạng mục nâng: <hạng mục trong SAN_SANG.md> từ <bậc> lên <bậc> · Sheet: <id> · Ước lượng: <giờ>
Chỗ làm: <worktree / bản sao / checkout chung> · Base SHA: <sha> · Chỗ kiểm: <worktree kiểm, nếu có>

## Brief
1. Repo · thư mục làm việc tuyệt đối · nhánh/base:
2. Mục tiêu ("khi xong thì …") + tiêu chí đạt (lệnh hoặc kịch bản kiểm được):
3. Phạm vi ghi · tệp cấm · tệp nóng được phép:
4. Đọc trước (đường dẫn + mục):
5. Lệnh kiểm nhanh (coder + verifier: build project bị đổi + test của WP, có lọc) · bộ kiểm đủ (chỉ phiên chính chạy cuối sóng;
   coder/verifier KHÔNG chạy, D-lead-030) · lệnh KHÔNG được chạy · không được làm gì thêm:
6. Bằng chứng phải nộp:
7. Tuân thủ `C:\Projects\Project Control\chung\LUAT_SUBAGENT.md`.
8. Đầu ra: tin nhắn cuối ≤ 25 dòng theo LUAT_SUBAGENT mục 10.

## Diễn biến (mỗi vòng một dòng, mới nhất ở cuối)
- <dd/mm hh:mm> coder v1: ĐẠT/CHƯA XONG/CHẶN · tệp đổi · lệnh kiểm + số
- <dd/mm hh:mm> verifier: ĐẠT/CẦN SỬA (lỗi chính) · đột biến bắt được n/m
- <dd/mm hh:mm> ghép: commit <SHA> / nhánh / PR · bộ đủ cuối sóng (SHA, số): xanh / đỏ (test hỏng → WP)

## Bước kế tiếp chính xác
<một câu: ai làm gì tiếp, ở đâu — để phiên mới làm tiếp không cần hỏi>

## Còn lại / CẦN QUYẾT
```

## 2. Bản rà soát — `modules/<mã>/ra-soat/<yyyy-mm-dd>-<đối tượng>.md`

```markdown
# Rà soát <đối tượng> · <từ> → <đến> · màu XANH|VÀNG|ĐỎ

Khoảng commit: <SHA đầu>..<SHA cuối> · số commit · người/agent
## Lời kể vs git (bảng: việc · người nói · git thấy · lệch?)
## Phát hiện (bảng: mức NẶNG/VỪA/NHẸ · tệp:dòng · vấn đề · đề xuất)
## Bậc hạng mục (bảng: hạng mục · bậc · bằng chứng)
## Câu hỏi cho Lead (đánh số <mã>.<n>)
```

## 3. Tin nhắn giao/nhắc việc — `modules/<mã>/ra-soat/<yyyy-mm-dd>-tin-<nguoi>.md`

Lead tự gửi. Mỗi tin gồm hai phần (Lead dặn 14/11, luật ở `CLAUDE.md` §7):

**(a) Tin Zalo** — 3–6 dòng, giọng miền Tây gần gũi, không đường dẫn, mã commit, tên biến, dòng code:

```text
<Tài|Phúc> ơi, anh giao em việc <một câu đời thường> nha. Hạn <ngày>.
<một hai câu: cần gì, xong là sao>. Chi tiết anh để trong file kèm theo, em coi rồi làm luôn nghen.
```

(Anh Tuấn: "Dạ anh Tuấn, em nhờ anh … được hông anh. Em cảm ơn anh nhiều nha." · chú Dũng: "Dạ chú, con …")

**(b) Tệp `.md` kèm** — phần kỹ thuật. Với Tài: cùng khung với hộp thư của Tài
(`M4-PLAN/Nhiệm Vụ Phát Sinh/<yyyy-mm-dd>_lead_<chu-de>.md`) để Lead có thể thả thẳng vào đó.

```markdown
Gửi <Phúc|Tài> · <ngày> · từ Lead
Việc: <một câu>
Vì sao: <một câu, có bằng chứng: commit/tệp>
Cần làm: 1… 2… 3…
Xong khi: <tiêu chí kiểm được>
Hạn: <ngày giờ> · báo lại bằng: <PR/commit/Sheet>
```

## 4. Nhật ký — `modules/<mã>/nhat-ky/<yyyy-mm-dd>.md`

`- hh:mm · <lệnh hoặc việc> · <kết quả một câu> · <tệp/SHA>` — mỗi dòng một việc, thêm cuối tệp; giờ lấy từ `date`.
