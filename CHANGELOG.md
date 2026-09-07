# Changelog

All notable changes to WayWayBack are documented here.
This project follows [Semantic Versioning](https://semver.org).

## [1.0.0] — 2026-09-07

First public release.

### Added
- Year → month → day heat calendar of a site's Wayback Machine captures,
  powered by the archive's own `__wb/sparkline` and `__wb/calendarcaptures`
  endpoints, with local TTL caching.
- Empty years and months are detected from the sparkline, marked with a ✕, and
  never re-fetched.
- Per-day snapshot list with cascading hour / minute / second filters.
- Search: instant URL guesses plus two optional keyless engines — Wikipedia
  (article → homepage) and npm (package → repository). Recent searches are
  saved and offered next time.
- Star favourite sites and snapshots; local History of opened links and captures.
- Android share-target and `wwb://open?url=…` deep links open the Link screen
  directly; a dismissable tip points this out.
- Light / dark / system theme; drag-to-reorder home tabs.
- About screen detects phone vs desktop and links the other build, plus a
  Ko-fi donation link.
- Runs on Android, Linux, Windows and macOS.

[1.0.0]: https://github.com/mkalmousli/wwb/releases/tag/v1.0.0
