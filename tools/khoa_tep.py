"""Bảng khoá tệp theo repo (D-lead-063): nhiều phiên, nhiều agent cùng sửa MỘT checkout mà không giẫm chân nhau.

  python tools/khoa_tep.py khai --repo ops-core --chu m12/WP30 --tep apps/admin-web/src/features/x apps/api/Foo.cs [--ghi-chu "..."]
  python tools/khoa_tep.py kiem --repo ops-core --tep apps/admin-web/src/lib        # chỉ kiểm, không khai
  python tools/khoa_tep.py giai --repo ops-core --chu m12/WP30 [--ep]               # --ep: gỡ khoá của người khác (phải nhắn họ trước)
  python tools/khoa_tep.py xem  [--repo ops-core]
  python tools/khoa_tep.py gio  [--tuoi 12]                                         # khoá cũ hơn N giờ (chỉ liệt kê)

--tep: đường dẫn tương đối so với gốc repo, tệp hoặc thư mục (thư mục khoá cả cây dưới nó). Hai khoá chồng nhau khi
trùng, hoặc cái này nằm trong thư mục của cái kia. Khai lại cùng --chu thì thay khoá cũ (mở rộng/thu hẹp phạm vi).

Khoá đặc biệt (một lúc chỉ một chủ giữ MỘT trong ba, mỗi repo; không chồng với khoá tệp thường):
  @bo-kiem-du  chạy bộ kiểm đủ/integration/e2e/DB (tránh cạn cổng, cây đổi giữa chừng)
  @dot-bien    verifier sửa tạm mã để thử đột biến (trong lúc giữ, không ai build/test repo đó)
  @dong-bo     merge/pull nhánh gốc vào cây (kèm --tep các tệp sẽ đổi: `git diff --name-only HEAD..origin/<nhánh>`)

Mã thoát: 0 ổn · 2 chồng khoá (in ai đang giữ, giữ gì, từ lúc nào) · 1 lỗi dùng. Kho khoá: khoa-tep/<repo>.json (không vào git).
"""
import argparse
import json
import os
import sys
import time
from pathlib import Path

sys.stdout.reconfigure(encoding="utf-8")
KHO = Path(r"C:\Projects\Project Control\khoa-tep")
DAC_BIET = {"@bo-kiem-du", "@dot-bien", "@dong-bo"}


def chuan(p: str) -> str:
    p = p.replace("\\", "/").strip().strip("/")
    while p.startswith("./"):
        p = p[2:]
    return p.lower()


def chong(a: str, b: str) -> bool:
    return a == b or a.startswith(b + "/") or b.startswith(a + "/")


class Kho:
    def __init__(self, repo: str):
        KHO.mkdir(parents=True, exist_ok=True)
        self.f = KHO / f"{repo}.json"
        self.lock = KHO / f"{repo}.lock"

    def __enter__(self):
        t0 = time.time()
        while True:
            try:
                fd = os.open(self.lock, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
                os.close(fd)
                return self
            except FileExistsError:
                try:
                    if time.time() - self.lock.stat().st_mtime > 30:
                        self.lock.unlink()
                        continue
                except OSError:
                    pass
                if time.time() - t0 > 15:
                    print("Không lấy được ổ khoá của bảng sau 15 giây, thử lại.")
                    sys.exit(1)
                time.sleep(0.2)

    def __exit__(self, *_):
        try:
            self.lock.unlink()
        except OSError:
            pass

    def doc(self) -> list:
        if not self.f.exists():
            return []
        try:
            return json.loads(self.f.read_text(encoding="utf-8"))
        except (OSError, ValueError):
            return []

    def ghi(self, ds: list) -> None:
        tmp = self.f.with_suffix(".tmp")
        tmp.write_text(json.dumps(ds, ensure_ascii=False, indent=1), encoding="utf-8")
        os.replace(tmp, self.f)


def xung_dot(ds: list, chu: str, tep: list) -> list:
    out = []
    mine = [chuan(t) for t in tep]
    for k in ds:
        if k["chu"] == chu:
            continue
        for a in mine:
            for b in k["tep"]:
                if a.startswith("@") or b.startswith("@"):
                    if a.startswith("@") and b.startswith("@") and a in DAC_BIET and b in DAC_BIET:
                        out.append((k, a, b))
                elif chong(a, b):
                    out.append((k, a, b))
    return out


def tuoi(k: dict) -> str:
    gio = (time.time() - k["luc_ts"]) / 3600
    return f"{gio:.1f} giờ trước"


def in_xung_dot(xs: list) -> None:
    seen = set()
    for k, a, b in xs:
        key = (k["chu"], a, b)
        if key in seen:
            continue
        seen.add(key)
        print(f"CHỒNG: {a} với {b} — {k['chu']} giữ từ {tuoi(k)}" + (f" ({k['ghi_chu']})" if k.get("ghi_chu") else ""))
    print("Làm tuần tự: nhắn chủ khoá (SendMessage) hoặc chờ họ giải khoá; không sửa tệp đang bị khoá.")


def main() -> int:
    ap = argparse.ArgumentParser()
    sp = ap.add_subparsers(dest="lenh", required=True)
    for ten in ("khai", "kiem", "giai", "xem", "gio"):
        p = sp.add_parser(ten)
        p.add_argument("--repo", default="" if ten in ("xem", "gio") else None, required=ten not in ("xem", "gio"))
        if ten in ("khai", "giai"):
            p.add_argument("--chu", required=True)
        if ten in ("khai", "kiem"):
            p.add_argument("--tep", nargs="+", required=True)
        if ten == "khai":
            p.add_argument("--ghi-chu", default="")
        if ten == "giai":
            p.add_argument("--ep", action="store_true")
        if ten == "gio":
            p.add_argument("--tuoi", type=float, default=12.0)
    a = ap.parse_args()

    if a.lenh in ("xem", "gio"):
        repos = [a.repo] if a.repo else sorted(p.stem for p in KHO.glob("*.json")) if KHO.exists() else []
        n = 0
        for r in repos:
            for k in Kho(r).doc():
                if a.lenh == "gio" and (time.time() - k["luc_ts"]) / 3600 < a.tuoi:
                    continue
                n += 1
                print(f"{r} · {k['chu']} · {tuoi(k)} · {', '.join(k['tep'])}" + (f" · {k['ghi_chu']}" if k.get("ghi_chu") else ""))
        if n == 0:
            print("Không có khoá nào.")
        return 0

    with Kho(a.repo) as kho:
        ds = kho.doc()
        if a.lenh == "kiem":
            xs = xung_dot(ds, "", a.tep)
            if xs:
                in_xung_dot(xs)
                return 2
            print("Không chồng khoá nào.")
            return 0
        if a.lenh == "khai":
            xs = xung_dot(ds, a.chu, a.tep)
            if xs:
                in_xung_dot(xs)
                return 2
            ds = [k for k in ds if k["chu"] != a.chu]
            ds.append({"chu": a.chu, "tep": [chuan(t) for t in a.tep], "ghi_chu": a.ghi_chu, "luc": time.strftime("%d/%m %H:%M"), "luc_ts": time.time()})
            kho.ghi(ds)
            print(f"Đã khai khoá cho {a.chu}: {len(a.tep)} đường dẫn.")
            return 0
        if a.lenh == "giai":
            truoc = len(ds)
            ds = [k for k in ds if k["chu"] != a.chu]
            if len(ds) == truoc:
                print(f"Không có khoá nào của {a.chu}.")
                return 0
            kho.ghi(ds)
            print(f"Đã giải khoá của {a.chu}." + (" (ép)" if a.ep else ""))
            return 0
    return 1


if __name__ == "__main__":
    sys.exit(main())
