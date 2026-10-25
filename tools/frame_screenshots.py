#!/usr/bin/env python3
"""Frame screenshots/mobile/*.png as captioned store/README images (needs ImageMagick).

    python3 tools/frame_screenshots.py

writes docs/screenshots/framed-N.png and site/assets/img/framed-<name>.webp
"""
from __future__ import annotations

import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "screenshots" / "mobile"
DOCS = ROOT / "docs" / "screenshots"
SITE = ROOT / "site" / "assets" / "img"

CAPTIONS = {
    "home": ("Your archive, organised", "Starred sites, snapshots and history in one place"),
    "search": ("Search or paste a URL", "Instant URL guesses plus optional Wikipedia and npm lookups"),
    "calendar": ("A calendar of the whole web", "Capture counts on a heat scale. Empty periods are never re-fetched"),
    "day": ("Every capture of the day", "Filter by hour, minute and second"),
    "history": ("Remember what you opened", "A local history of every link and capture"),
    "settings": ("Make it yours", "Light, dark or system theme and reorderable tabs"),
    "about": ("Private by design", "No account, no backend, no tracking, no ads"),
    "calendar-light": ("Light or dark", "Follows your system theme"),
}
W, H, PW, R, B = 1000, 2000, 700, 56, 14


def run(*a: str) -> None:
    subprocess.run(a, check=True)


def main() -> None:
    DOCS.mkdir(parents=True, exist_ok=True)
    SITE.mkdir(parents=True, exist_ok=True)
    tmp = ROOT / "build" / "frame"
    tmp.mkdir(parents=True, exist_ok=True)
    for i, src in enumerate(sorted(SRC.glob("*.png")), 1):
        name = src.stem.split("-", 1)[1]
        title, sub = CAPTIONS[name]
        inner = PW - 2 * B
        shot = tmp / "shot.png"
        run("convert", str(src), "-resize", f"{inner}x", "-alpha", "set",
            "(", "+clone", "-alpha", "transparent", "-fill", "white", "-draw",
            f"roundrectangle 0,0,{inner - 1},{int(inner * 1512 / 720) - 1},{R - B},{R - B}", ")",
            "-compose", "DstIn", "-composite", str(shot))
        ph = int(inner * 1512 / 720) + 2 * B
        phone = tmp / "phone.png"
        run("convert", "-size", f"{PW}x{ph}", "xc:none", "-fill", "#0b0d12", "-draw",
            f"roundrectangle 0,0,{PW - 1},{ph - 1},{R},{R}", str(shot), "-gravity", "center",
            "-composite", "(", "+clone", "-background", "black", "-shadow", "55x28+0+22", ")",
            "+swap", "-background", "none", "-layers", "merge", "+repage", str(phone))
        out = DOCS / f"framed-{i}.png"
        run("convert", "-size", f"{W}x{H}", "gradient:#2196f3-#0b3a91",
            "(", "-size", "880x", "-background", "none", "-fill", "white", "-font", "DejaVu-Sans-Bold",
            "-pointsize", "70", "-gravity", "center", f"caption:{title}", ")",
            "-gravity", "north", "-geometry", "+0+90", "-composite",
            "(", "-size", "820x", "-background", "none", "-fill", "#d6e8ff", "-font", "DejaVu-Sans",
            "-pointsize", "36", "-gravity", "center", f"caption:{sub}", ")",
            "-gravity", "north", "-geometry", "+0+270", "-composite",
            str(phone), "-gravity", "south", "-geometry", "+0+20", "-composite", "-strip", str(out))
        run("convert", str(out), "-resize", "600x", "-strip", "-quality", "84", str(SITE / f"framed-{name}.webp"))
        print(out.name)


if __name__ == "__main__":
    main()
