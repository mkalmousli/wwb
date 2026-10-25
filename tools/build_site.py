#!/usr/bin/env python3
"""Generate the GitHub Pages site into site/ (index, one page per feature, sitemap, robots).

    python3 tools/build_site.py

Media lives in site/assets/{img,video}; edit FEATURES below to change copy.
"""
from __future__ import annotations

import html
import json
from datetime import date
from pathlib import Path

SITE = Path(__file__).resolve().parent.parent / "site"
ORIGIN = "https://mkalmousli.github.io"
BASE = "/wwb"
URL = ORIGIN + BASE + "/"
REPO = "https://github.com/mkalmousli/wwb"
RELEASES = REPO + "/releases/latest"
NAME = "WayWayBack"
TAGLINE = "Wayback Machine browser for Android"
DESC = (
    "WayWayBack is a free, open-source Wayback Machine client for Android, Linux, "
    "Windows and macOS. Browse any website's Internet Archive history on a heat-map "
    "calendar by year, month and day. No account, no ads, no tracking."
)
KEYWORDS = (
    "Wayback Machine, Wayback Machine app, Wayback Machine Android, Internet Archive, "
    "web archive, archived websites, website history, old website viewer, "
    "Wayback Machine client, F-Droid, open source, Flutter, WayWayBack"
)
TODAY = date.today().isoformat()

FEATURES = [
    dict(slug="calendar", title="Year, month and day calendar", img="calendar", video="calendar",
         short="See every capture of a site on a heat-map calendar.",
         desc="Pick a year, a month and a day and see how many times the Wayback Machine captured a website, on a heat scale. Empty periods are marked and never re-fetched.",
         body=["WayWayBack talks to the Wayback Machine's own sparkline and calendar-captures endpoints, so it fetches only the year you are looking at instead of crawling the whole index.",
               "Every day cell shows its capture count on a heat scale. Years, months and days with no captures are crossed out and are never requested, which keeps the app fast and gentle on the Internet Archive.",
               "Results are cached on the device, so revisiting a site is instant."]),
    dict(slug="search", title="Smart search", img="search", video="search",
         short="Type a name or a URL and jump straight to its archive.",
         desc="Search merges instant URL guesses with optional Wikipedia and npm lookups, and remembers your recent searches. No API keys, no accounts.",
         body=["Type example.com and WayWayBack immediately offers https://example.com and the www variant. Type a well-known name and the optional Wikipedia engine maps the article to its official homepage.",
               "The optional npm engine maps a package name to its repository or website. Both engines are keyless and can be switched off in Settings.",
               "Recent searches are saved locally and offered next time."]),
    dict(slug="snapshots", title="Per-day snapshot list with filters", img="day", video="day",
         short="Open any capture, filter by hour, minute and second.",
         desc="Every capture of a day with its time and HTTP status. Smart hour, minute and second filters only offer the times that actually exist.",
         body=["Tap a day to see every snapshot taken on it, with time and HTTP status. Tap a snapshot to open the archived page in your browser.",
               "Busy sites can have hundreds of captures per day. The hour, minute and second filters only list values that exist, so you never pick an empty combination.",
               "Share a single snapshot or the whole day as a web.archive.org link."]),
    dict(slug="stars-and-history", title="Stars and history", img="home", video="library",
         short="Keep the sites and captures you care about.",
         desc="Star websites and individual snapshots, and keep a local history of every link and capture you opened. Everything stays on your device.",
         body=["The home screen has three tabs: starred Websites, starred Snapshots and History. Tabs can be reordered in Settings.",
               "History records every link and capture you opened, with the time, and can be cleared at any time.",
               "All of it is stored locally in an on-device database. Nothing is uploaded."]),
    dict(slug="share-to-open", title="Share a link to open its archive", img="calendar-light", video="share",
         short="Share any URL into WayWayBack and land on its calendar.",
         desc="Share a link from any Android app, or use a wwb://open?url=… deep link, to open the site's Wayback Machine calendar straight away.",
         body=["Found a dead link? Use the Android share sheet and pick WayWayBack. The app opens on that site's archive calendar with no copy-paste.",
               "Deep links are supported too: wwb://open?url=https://example.com opens the calendar for example.com."]),
    dict(slug="themes", title="Themes and layout", img="settings", video="theme",
         short="Light, dark or system theme and reorderable tabs.",
         desc="Light, dark or system theme, drag-to-reorder home tabs and optional search engines, all in a simple settings screen.",
         body=["Pick Light, Dark or follow the system. Drag the home tabs into the order you prefer.",
               "Toggle the optional Wikipedia and npm search engines on or off."]),
    dict(slug="privacy", title="Private by design", img="about", video="about",
         short="No account, no backend, no tracking, no ads.",
         desc="WayWayBack is fully client-side and GPL-3.0 licensed: no account, no backend, no analytics, no ads. Everything is stored on your device.",
         body=["The app talks only to web.archive.org, and to Wikipedia or npm if you leave those optional search engines on.",
               "There is no analytics, no advertising and no account. The source code is public under the GNU GPL v3 or later.",
               "WayWayBack is an independent, unofficial client. It is not affiliated with or endorsed by the Internet Archive."]),
]

FAQ = [
    ("Is WayWayBack the official Wayback Machine app?",
     "No. It is an independent, unofficial, open-source client for the Internet Archive's public Wayback Machine."),
    ("Is WayWayBack free?", "Yes. It is free software under the GNU GPL v3 or later, with no ads and no in-app purchases."),
    ("Does it collect my data?", "No. There is no account, backend or analytics. Stars and history stay on your device."),
    ("Which platforms are supported?", "Android (APK and F-Droid build), plus native Linux, Windows and macOS builds."),
    ("How do I install it?", "Download an APK from the latest GitHub release. arm64-v8a suits most phones; universal works everywhere."),
]

e = html.escape
CSS = """:root{--bg:#f7f9fc;--fg:#10151f;--mut:#566074;--card:#fff;--line:#dfe5ee;--acc:#1565c0;--acc2:#0d3b8c}
@media(prefers-color-scheme:dark){:root{--bg:#0e1118;--fg:#e8ecf4;--mut:#9aa6bd;--card:#161b26;--line:#252c3b;--acc:#8ab4ff;--acc2:#4f83e0}}
*{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;font:17px/1.6 system-ui,-apple-system,Segoe UI,Roboto,sans-serif;background:var(--bg);color:var(--fg)}
a{color:var(--acc)}.w{max-width:1040px;margin:0 auto;padding:0 20px}
header.top{display:flex;gap:16px;align-items:center;justify-content:space-between;padding:14px 0;flex-wrap:wrap}
.brand{display:flex;gap:10px;align-items:center;font-weight:700;color:var(--fg);text-decoration:none;font-size:20px}.brand img{border-radius:8px}
nav a{margin-left:16px;text-decoration:none;color:var(--mut)}nav a:hover{color:var(--acc)}
.hero{display:grid;grid-template-columns:1.1fr .9fr;gap:32px;align-items:center;padding:40px 0 56px}
h1{font-size:clamp(34px,6vw,54px);line-height:1.1;margin:0 0 14px}h2{font-size:30px;margin:48px 0 12px}h3{margin:0 0 6px}
.lead{font-size:20px;color:var(--mut)}.btn{display:inline-block;padding:12px 22px;border-radius:12px;background:var(--acc2);color:#fff;text-decoration:none;font-weight:600;margin:6px 8px 6px 0}
.btn.alt{background:transparent;color:var(--acc);border:1px solid var(--line)}
.phone{width:100%;max-width:300px;border-radius:26px;border:6px solid #222;box-shadow:0 18px 50px #0004;display:block;margin:auto;background:#000}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:18px}
.card{background:var(--card);border:1px solid var(--line);border-radius:16px;padding:20px}.card p{margin:0;color:var(--mut)}.card a.h{text-decoration:none;color:inherit}
.feat{display:grid;grid-template-columns:300px 1fr;gap:36px;align-items:start;padding:30px 0}.feat p{color:var(--mut)}
.crumbs{font-size:14px;color:var(--mut);margin-top:8px}details{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:12px 16px;margin:10px 0}summary{cursor:pointer;font-weight:600}
.shots{display:flex;gap:14px;overflow-x:auto;padding:6px 0 16px;scroll-snap-type:x mandatory}.shots img{height:440px;width:auto;border-radius:16px;border:1px solid var(--line);scroll-snap-align:start}
footer{border-top:1px solid var(--line);margin-top:64px;padding:28px 0;color:var(--mut);font-size:15px}
@media(max-width:760px){.hero,.feat{grid-template-columns:1fr}.hero img.phone,.feat video{margin:auto}}
"""

def ld(obj):
    return '<script type="application/ld+json">' + json.dumps(obj, ensure_ascii=False) + "</script>"

def page(path, title, desc, body, extra_ld=(), og_img="assets/og.png", depth=0, ptype="website"):
    canon = URL + path
    root = BASE + "/"
    head = f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{e(title)}</title>
<meta name="description" content="{e(desc)}">
<meta name="keywords" content="{e(KEYWORDS)}">
<meta name="author" content="mkalmousli">
<meta name="robots" content="index,follow,max-image-preview:large,max-snippet:-1,max-video-preview:-1">
<meta name="theme-color" content="#1565c0">
<link rel="canonical" href="{canon}">
<link rel="icon" href="{root}favicon.ico" sizes="48x48"><link rel="icon" href="{root}assets/logo.svg" type="image/svg+xml">
<link rel="apple-touch-icon" href="{root}apple-touch-icon.png">
<meta property="og:type" content="{ptype}"><meta property="og:site_name" content="{NAME}">
<meta property="og:title" content="{e(title)}"><meta property="og:description" content="{e(desc)}">
<meta property="og:url" content="{canon}"><meta property="og:image" content="{ORIGIN}{root}{og_img}">
<meta property="og:image:width" content="1200"><meta property="og:image:height" content="630"><meta property="og:locale" content="en_US">
<meta name="twitter:card" content="summary_large_image"><meta name="twitter:title" content="{e(title)}">
<meta name="twitter:description" content="{e(desc)}"><meta name="twitter:image" content="{ORIGIN}{root}{og_img}">
<link rel="stylesheet" href="{root}assets/style.css">
{''.join(ld(x) for x in extra_ld)}
</head><body>
<div class="w"><header class="top"><a class="brand" href="{root}"><img src="{root}assets/icon.png" width="36" height="36" alt="{NAME} logo">{NAME}</a>
<nav aria-label="Main"><a href="{root}#features">Features</a><a href="{root}#install">Install</a><a href="{root}#faq">FAQ</a><a href="{REPO}">GitHub</a></nav></header>
<main>
"""
    foot = f"""</main>
<footer><p>{NAME} is an independent, unofficial client for the Internet Archive's Wayback Machine and is not affiliated with or endorsed by the Internet Archive.
Free software under <a href="{REPO}/blob/main/LICENSE">GPL-3.0-or-later</a> · <a href="{REPO}">Source</a> · <a href="{REPO}/issues">Report an issue</a> · <a href="https://al-mo.de/apps/waywayback/">Project page</a></p></footer></div></body></html>"""
    out = SITE / path / "index.html"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(head + body + foot)

def video(f, cls=""):
    r = BASE + "/assets/video/"
    return (f'<video class="phone {cls}" width="270" height="560" controls muted playsinline loop preload="none" '
            f'poster="{r}{f["video"]}.jpg" aria-label="{e(f["title"])} demo video"><source src="{r}{f["video"]}.mp4" type="video/mp4"></video>')

def build():
    (SITE / "assets").mkdir(parents=True, exist_ok=True)
    (SITE / "assets" / "style.css").write_text(CSS)
    img = lambda n, alt, **k: f'<img src="{BASE}/assets/img/{n}.webp" alt="{e(alt)}" width="540" height="1134" loading="lazy" {" ".join(f"{a}={chr(34)}{b}{chr(34)}" for a,b in k.items())}>'
    app = {"@context": "https://schema.org", "@type": "SoftwareApplication", "name": NAME,
           "alternateName": ["WWB", "Wayback Machine client"], "applicationCategory": "UtilitiesApplication",
           "operatingSystem": "Android, Linux, Windows, macOS", "description": DESC, "url": URL,
           "image": URL + "assets/og.png", "downloadUrl": RELEASES, "codeRepository": REPO,
           "license": "https://www.gnu.org/licenses/gpl-3.0.html", "isAccessibleForFree": True,
           "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
           "author": {"@type": "Person", "name": "mkalmousli", "url": "https://github.com/mkalmousli"},
           "screenshot": [URL + f"assets/img/{f['img']}.webp" for f in FEATURES],
           "featureList": [f["title"] for f in FEATURES]}
    faq = {"@context": "https://schema.org", "@type": "FAQPage",
           "mainEntity": [{"@type": "Question", "name": q, "acceptedAnswer": {"@type": "Answer", "text": a}} for q, a in FAQ]}
    cards = "".join(f'<article class="card"><h3><a class="h" href="{BASE}/features/{f["slug"]}/">{e(f["title"])}</a></h3><p>{e(f["short"])}</p></article>' for f in FEATURES)
    sections = "".join(f'''<section class="feat" id="{f["slug"]}"><div>{video(f)}</div><div><h3><a href="{BASE}/features/{f["slug"]}/">{e(f["title"])}</a></h3><p>{e(f["desc"])}</p><p><a href="{BASE}/features/{f["slug"]}/">Learn more →</a></p></div></section>''' for f in FEATURES)
    shots = "".join(img(f["img"], f"{NAME} screenshot: {f['title']}") for f in FEATURES)
    faqh = "".join(f"<details><summary>{e(q)}</summary><p>{e(a)}</p></details>" for q, a in FAQ)
    body = f'''<section class="hero"><div><h1>Browse the Wayback Machine by year, month and day</h1>
<p class="lead">{NAME} is a free, open-source Wayback Machine app for Android, Linux, Windows and macOS. Search a website, then walk its Internet Archive history on a heat-map calendar. No account, no ads, no tracking.</p>
<a class="btn" href="{RELEASES}">Download APK</a><a class="btn alt" href="{REPO}">View on GitHub</a></div>
<div><img class="phone" src="{BASE}/assets/img/calendar.webp" width="540" height="1134" alt="{NAME} calendar showing capture counts for example.com"></div></section>
<h2 id="features">Features</h2><div class="grid">{cards}</div>
<h2>See every feature in action</h2>{sections}
<h2>Screenshots</h2><div class="shots">{shots}</div>
<h2 id="install">Install</h2><div class="grid">
<div class="card"><h3>Android</h3><p>Grab an APK from the <a href="{RELEASES}">latest release</a>. <code>arm64-v8a</code> suits most phones; <code>universal</code> works anywhere.</p></div>
<div class="card"><h3>F-Droid</h3><p>A reproducible build recipe is included in the repository, ready for F-Droid.</p></div>
<div class="card"><h3>Desktop</h3><p>Linux, Windows and macOS archives are on the <a href="{RELEASES}">release page</a>.</p></div></div>
<h2 id="faq">FAQ</h2>{faqh}'''
    page("", f"{NAME} – {TAGLINE} | Browse Internet Archive history", DESC, body, [app, faq])
    for f in FEATURES:
        paras = "".join(f"<p>{e(p)}</p>" for p in f["body"])
        b = f'''<p class="crumbs"><a href="{BASE}/">Home</a> › <a href="{BASE}/#features">Features</a> › {e(f["title"])}</p>
<section class="feat"><div>{video(f)}</div><div><h1>{e(f["title"])}</h1><p class="lead">{e(f["desc"])}</p>{paras}
<a class="btn" href="{RELEASES}">Download {NAME}</a></div></section>
<h2>Screenshot</h2>{img(f["img"], f"{NAME} screenshot: {f['title']}", style="max-width:300px;border-radius:16px")}
<h2>More features</h2><div class="grid">{"".join(f'<article class="card"><h3><a class="h" href="{BASE}/features/{g["slug"]}/">{e(g["title"])}</a></h3><p>{e(g["short"])}</p></article>' for g in FEATURES if g is not f)}</div>'''
        crumbs = {"@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [
            {"@type": "ListItem", "position": 1, "name": NAME, "item": URL},
            {"@type": "ListItem", "position": 2, "name": f["title"], "item": f'{URL}features/{f["slug"]}/'}]}
        vid = {"@context": "https://schema.org", "@type": "VideoObject", "name": f"{f['title']} – {NAME} demo",
               "description": f["desc"], "thumbnailUrl": f'{URL}assets/video/{f["video"]}.jpg',
               "contentUrl": f'{URL}assets/video/{f["video"]}.mp4', "uploadDate": TODAY}
        page(f'features/{f["slug"]}/', f'{f["title"]} – {NAME} {TAGLINE}', f["desc"], b, [crumbs, vid], ptype="article")
    urls = [URL] + [f'{URL}features/{f["slug"]}/' for f in FEATURES]
    (SITE / "sitemap.xml").write_text('<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n' +
        "".join(f"<url><loc>{u}</loc><lastmod>{TODAY}</lastmod></url>\n" for u in urls) + "</urlset>\n")
    (SITE / "robots.txt").write_text(f"User-agent: *\nAllow: /\n\nSitemap: {URL}sitemap.xml\n")
    (SITE / "404.html").write_text(f'<!doctype html><meta charset="utf-8"><meta name="robots" content="noindex"><title>Not found – {NAME}</title><p>Page not found. <a href="{BASE}/">Go to {NAME}</a></p>')
    (SITE / ".nojekyll").write_text("")

if __name__ == "__main__":
    build()
