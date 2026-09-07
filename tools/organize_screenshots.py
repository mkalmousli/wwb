#!/usr/bin/env python3
"""
Organize hand-made screenshots into the places the repo expects them.

You take the screenshots yourself and drop them here:

    screenshots/mobile/*.png     phone screenshots, in display order
    screenshots/desktop/*.png    desktop screenshots, in display order

Ordering is by filename, so name them with a leading number:

    screenshots/mobile/1-home.png
    screenshots/mobile/2-search.png
    ...

Then run:

    python3 tools/organize_screenshots.py

which copies them (metadata stripped) to:

    docs/screenshots/1.png, 2.png, ...              (README / project page)
    docs/screenshots/desktop-1.png, desktop-2.png   (README)
    fastlane/metadata/android/en-US/images/phoneScreenshots/1.png, ...   (F-Droid)

Nothing else is touched. Re-run it whenever you replace a screenshot.
"""
from __future__ import annotations

import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC_MOBILE = ROOT / "screenshots" / "mobile"
SRC_DESKTOP = ROOT / "screenshots" / "desktop"
DOCS = ROOT / "docs" / "screenshots"
FASTLANE = ROOT / "fastlane" / "metadata" / "android" / "en-US" / "images" / "phoneScreenshots"

HAVE_CONVERT = shutil.which("convert") is not None


def pngs(d: Path) -> list[Path]:
    return sorted(p for p in d.glob("*.png") if p.is_file())


def place(src: Path, dst: Path):
    dst.parent.mkdir(parents=True, exist_ok=True)
    if HAVE_CONVERT:
        subprocess.run(["convert", str(src), "-strip", str(dst)], check=True)
    else:
        shutil.copyfile(src, dst)
    print(f"  {src.relative_to(ROOT)}  ->  {dst.relative_to(ROOT)}")


def clear(d: Path, pattern: str):
    if d.exists():
        for old in d.glob(pattern):
            old.unlink()


def main() -> int:
    mobile = pngs(SRC_MOBILE) if SRC_MOBILE.exists() else []
    desktop = pngs(SRC_DESKTOP) if SRC_DESKTOP.exists() else []

    if not mobile and not desktop:
        print(
            "Nothing to do. Put PNGs in screenshots/mobile/ and screenshots/desktop/\n"
            "(name them 1-*.png, 2-*.png, ... to set the order)."
        )
        return 1

    if mobile:
        print(f"mobile: {len(mobile)} screenshot(s)")
        clear(DOCS, "[0-9]*.png")
        clear(FASTLANE, "*.png")
        for i, src in enumerate(mobile, 1):
            place(src, DOCS / f"{i}.png")
            place(src, FASTLANE / f"{i}.png")

    if desktop:
        print(f"desktop: {len(desktop)} screenshot(s)")
        clear(DOCS, "desktop-*.png")
        for i, src in enumerate(desktop, 1):
            place(src, DOCS / f"desktop-{i}.png")

    print("\nDone. Review with `git status` / `git diff --stat`.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
