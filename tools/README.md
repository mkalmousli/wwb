# tools/

## `organize_screenshots.py`

Copies hand-made screenshots into the locations the repo expects.

```
screenshots/mobile/*.png     phone screenshots, ordered by filename (1-*.png, 2-*.png, …)
screenshots/desktop/*.png    desktop screenshots, ordered by filename
```

```sh
python3 tools/organize_screenshots.py
```

writes:

| destination | from |
|---|---|
| `docs/screenshots/1.png`, `2.png`, …            | `screenshots/mobile/` |
| `docs/screenshots/desktop-1.png`, `desktop-2.png`, … | `screenshots/desktop/` |
| `fastlane/metadata/android/en-US/images/phoneScreenshots/1.png`, … | `screenshots/mobile/` |

Metadata is stripped with ImageMagick `convert` when available, otherwise the
files are copied as-is. Re-run it whenever you swap a screenshot, then commit.
