"""Chuyển báo cáo tuần gửi Chú (Markdown) sang Word, khổ A4 (mặc định nằm ngang; `--doc` = khổ dọc).

Dùng: python tools/md_sang_docx.py <báo cáo>.md [<ra>.docx] [--doc]
Không ghi <ra> thì lưu cạnh tệp .md, cùng tên, đuôi .docx. Dòng `<!-- trang mới -->` = ngắt trang.

Hiểu đúng phần Markdown mà khuôn báo cáo dùng (prompt 3): dòng tiêu đề in đậm, `#`/`##`/`###`, gạch đầu dòng `- `,
danh sách số `1. `, bảng `| … |`, chữ đậm `**…**`. Mỗi dòng thường là một đoạn. Cần python-docx.
"""
import re
import sys
from pathlib import Path

from docx import Document
from docx.enum.section import WD_ORIENT
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Cm, Pt, RGBColor

FONT = "Times New Roman"
CO_CHU = Pt(13)  # chữ tối thiểu 13 (D-lead-007)
CO_CHU_BANG = Pt(13)
CO_TIEU_DE = Pt(18)
LE_O_TREN_DUOI = 110  # lề trên/dưới trong ô bảng, đơn vị 1/20 pt (~2 mm)
LE_O_TRAI_PHAI = 100
LE = Cm(1.5)
MAU_DAU_BANG = "D9E2F3"
MAU_DO, MAU_VANG, MAU_XANH = "F4CCCC", "FFF2CC", "D9EAD3"


def dat_font(run, co=None, dam=None):
    run.font.name = FONT
    run._element.get_or_add_rPr().get_or_add_rFonts().set(qn("w:eastAsia"), FONT)
    if co:
        run.font.size = co
    if dam is not None:
        run.bold = dam


def them_chu(doan, chu, co=None, dam_ca=False):
    """Thêm chữ có `**đậm**`; bỏ dấu `code`."""
    chu = chu.replace("`", "")
    for i, phan in enumerate(re.split(r"\*\*(.+?)\*\*", chu)):
        if phan:
            # Không đậm thì để None: chữ theo kiểu đoạn (tiêu đề vẫn đậm).
            dat_font(doan.add_run(phan), co, True if (dam_ca or i % 2 == 1) else None)


def to_nen(o, mau):
    tcPr = o._tc.get_or_add_tcPr()
    shd = OxmlElement("w:shd")
    shd.set(qn("w:val"), "clear")
    shd.set(qn("w:color"), "auto")
    shd.set(qn("w:fill"), mau)
    tcPr.append(shd)


def mau_theo_chu(chu):
    c = chu.strip().lower()
    if c.startswith("đỏ"):
        return MAU_DO
    if c.startswith("vàng"):
        return MAU_VANG
    if c.startswith("xanh"):
        return MAU_XANH
    return None


def tach_dong_bang(dong):
    dong = dong.strip()
    if dong.startswith("|"):
        dong = dong[1:]
    if dong.endswith("|"):
        dong = dong[:-1]
    return [o.strip() for o in dong.split("|")]


def la_dong_ke(dong):
    return re.fullmatch(r"\|?\s*:?-{2,}:?\s*(\|\s*:?-{2,}:?\s*)*\|?", dong.strip()) is not None


CM_MOI_KY_TU = 0.25  # Times New Roman 13 pt, ước rộng một ký tự
DEM_O = 0.55  # lề trong ô, hai bên


def do_rong_cot(cac_dong, tong_cm):
    """Mỗi cột đủ rộng cho từ dài nhất (không ngắt giữa chữ) và tiêu đề ngắn; phần dư chia theo độ dài nội dung."""
    so_cot = max(len(d) for d in cac_dong)
    dai = [0] * so_cot
    toi_thieu = [0.0] * so_cot
    for r, d in enumerate(cac_dong):
        for i, o in enumerate(d):
            chu = o.replace("**", "").replace("`", "")
            dai[i] = max(dai[i], min(len(chu), 120))
            tu_dai = max((len(t) for t in re.split(r"\s+|<br>", chu) if t), default=0)
            can = tu_dai
            if r == 0 and len(chu) <= 12:
                can = len(chu)  # tiêu đề ngắn nằm trên một dòng
            toi_thieu[i] = max(toi_thieu[i], can * CM_MOI_KY_TU + DEM_O)
    if sum(toi_thieu) >= tong_cm:
        return [tong_cm * t / sum(toi_thieu) for t in toi_thieu]
    trong_so = [max(6, x) ** 0.8 for x in dai]
    rong = [tong_cm * t / sum(trong_so) for t in trong_so]
    # Nâng cột dưới mức tối thiểu, lấy bớt từ các cột còn dư theo tỉ lệ.
    for _ in range(5):
        thieu = sum(max(0.0, toi_thieu[i] - rong[i]) for i in range(so_cot))
        if thieu < 0.01:
            break
        du = [max(0.0, rong[i] - toi_thieu[i]) for i in range(so_cot)]
        tong_du = sum(du)
        rong = [max(rong[i], toi_thieu[i]) - (thieu * du[i] / tong_du if tong_du else 0) for i in range(so_cot)]
    return rong


def dat_le_o(bang):
    """Lề trong mọi ô: trên/dưới rộng hơn mặc định để bảng thoáng."""
    tblPr = bang._tbl.tblPr
    mar = OxmlElement("w:tblCellMar")
    for canh, gia_tri in (("top", LE_O_TREN_DUOI), ("left", LE_O_TRAI_PHAI),
                          ("bottom", LE_O_TREN_DUOI), ("right", LE_O_TRAI_PHAI)):
        el = OxmlElement(f"w:{canh}")
        el.set(qn("w:w"), str(gia_tri))
        el.set(qn("w:type"), "dxa")
        mar.append(el)
    # Đúng thứ tự lược đồ: tblCellMar đứng trước tblLook (nếu có).
    look = tblPr.find(qn("w:tblLook"))
    if look is not None:
        look.addprevious(mar)
    else:
        tblPr.append(mar)


def lap_lai_dau_bang(hang):
    trPr = hang._tr.get_or_add_trPr()
    el = OxmlElement("w:tblHeader")
    el.set(qn("w:val"), "true")
    trPr.append(el)


def khong_cat_hang(hang):
    """Một hàng không bị cắt đôi sang trang sau."""
    trPr = hang._tr.get_or_add_trPr()
    el = OxmlElement("w:cantSplit")
    el.set(qn("w:val"), "true")
    trPr.insert(0, el)


def ve_bang(doc, cac_dong, rong_cm):
    so_cot = max(len(d) for d in cac_dong)
    cac_dong = [d + [""] * (so_cot - len(d)) for d in cac_dong]
    rong = do_rong_cot(cac_dong, rong_cm)
    bang = doc.add_table(rows=len(cac_dong), cols=so_cot)
    bang.style = "Table Grid"
    bang.alignment = WD_TABLE_ALIGNMENT.CENTER
    bang.autofit = False
    dat_le_o(bang)
    # Độ rộng hai nơi: lưới cột và từng ô (Word, Google Docs đều giữ đúng).
    luoi = bang._tbl.tblGrid
    for i, gc in enumerate(luoi.findall(qn("w:gridCol"))):
        gc.set(qn("w:w"), str(int(Cm(rong[i]).twips)))
    cot_mau = [i for i, o in enumerate(cac_dong[0]) if "kịp" in o.lower()]
    for r, dong in enumerate(cac_dong):
        hang = bang.rows[r]
        khong_cat_hang(hang)
        if r == 0:
            lap_lai_dau_bang(hang)
        for c, chu in enumerate(dong):
            o = hang.cells[c]
            o.width = Cm(rong[c])
            doan = o.paragraphs[0]
            doan.paragraph_format.space_after = Pt(0)
            for k, manh in enumerate(chu.split("<br>")):
                if k:
                    doan = o.add_paragraph()
                    doan.paragraph_format.space_after = Pt(0)
                them_chu(doan, manh.strip(), CO_CHU_BANG, dam_ca=(r == 0))
            if r == 0:
                to_nen(o, MAU_DAU_BANG)
                for dd in o.paragraphs:
                    dd.paragraph_format.keep_with_next = True  # đầu bảng không nằm lẻ cuối trang
            elif c in cot_mau and mau_theo_chu(chu):
                to_nen(o, mau_theo_chu(chu))
    doc.add_paragraph().paragraph_format.space_after = Pt(0)


NGAT_TRANG = "<!-- trang mới -->"


def chuyen(nguon: Path, dich: Path, doc_doc: bool = False):
    doc = Document()
    sec = doc.sections[0]
    if doc_doc:
        sec.orientation = WD_ORIENT.PORTRAIT
        sec.page_width, sec.page_height = Cm(21.0), Cm(29.7)
    else:
        sec.orientation = WD_ORIENT.LANDSCAPE
        sec.page_width, sec.page_height = Cm(29.7), Cm(21.0)
    for canh in ("left_margin", "right_margin", "top_margin", "bottom_margin"):
        setattr(sec, canh, LE)
    rong_cm = (21.0 if doc_doc else 29.7) - 2 * 1.5

    kieu = doc.styles["Normal"]
    kieu.font.name = FONT
    kieu.font.size = CO_CHU
    kieu.element.get_or_add_rPr().get_or_add_rFonts().set(qn("w:eastAsia"), FONT)
    kieu.paragraph_format.space_after = Pt(3)
    for ten, co in (("Heading 1", 16), ("Heading 2", 14), ("Heading 3", 13)):
        k = doc.styles[ten]
        k.font.name = FONT
        k.font.size = Pt(co)
        k.font.bold = True
        k.font.color.rgb = RGBColor(0x1F, 0x3A, 0x5F)
        k.element.get_or_add_rPr().get_or_add_rFonts().set(qn("w:eastAsia"), FONT)

    dong = nguon.read_text(encoding="utf-8").splitlines()
    i, dau_tien, ngat = 0, True, False
    while i < len(dong):
        d = dong[i].rstrip()
        if d.strip() == NGAT_TRANG:
            # Ngắt trang gắn vào đoạn kế tiếp (đoạn rỗng chứa dấu ngắt có thể tràn thành trang trắng).
            ngat = True
            i += 1
            continue
        if ngat and d.lstrip().startswith("|"):
            doc.add_paragraph().paragraph_format.page_break_before = True
            ngat = False
        if not d.strip() or d.strip() in ("---", "```", "```markdown"):
            i += 1
            continue
        if d.lstrip().startswith("|"):
            khoi = []
            while i < len(dong) and dong[i].lstrip().startswith("|"):
                if not la_dong_ke(dong[i]):
                    khoi.append(tach_dong_bang(dong[i]))
                i += 1
            ve_bang(doc, khoi, rong_cm)
            continue
        m = re.match(r"^(#{1,3})\s+(.*)", d)
        if m:
            p = doc.add_heading(level=len(m.group(1)))
            them_chu(p, m.group(2))
        elif re.match(r"^\s*[-*]\s+", d):
            p = doc.add_paragraph(style="List Bullet")
            them_chu(p, re.sub(r"^\s*[-*]\s+", "", d))
        elif re.match(r"^\s*\d+\.\s+", d):
            p = doc.add_paragraph(style="List Number")
            them_chu(p, re.sub(r"^\s*\d+\.\s+", "", d))
        else:
            p = doc.add_paragraph()
            them_chu(p, d)
            if dau_tien:
                p.alignment = WD_ALIGN_PARAGRAPH.CENTER
                for r in p.runs:
                    r.font.size = CO_TIEU_DE
                    r.bold = True
        if ngat:
            p.paragraph_format.page_break_before = True
            ngat = False
        dau_tien = False
        i += 1
    doc.save(dich)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    doc_doc = "--doc" in sys.argv
    thamso = [a for a in sys.argv[1:] if a != "--doc"]
    if not thamso:
        sys.exit(__doc__)
    nguon = Path(thamso[0])
    dich = Path(thamso[1]) if len(thamso) > 1 else nguon.with_suffix(".docx")
    chuyen(nguon, dich, doc_doc)
    print(f"Đã lưu {dich}")
