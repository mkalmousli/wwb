#!/usr/bin/env python3
"""
Reproducible APK build for WayWayBack.

Goal: the F-Droid build server, a Docker container and a local machine all
produce a byte-for-byte identical ``app-release.apk``. F-Droid then strips the
signature, compares it against the APK attached to the matching GitHub release,
and — if they match — publishes the *developer-signed* APK.

Reproducibility relies on:
  * building at one fixed absolute path (Dart/Flutter embed paths in artifacts);
  * an exact, pinned Flutter version (``.fvmrc``);
  * a fixed pub cache;
  * no R8 / resource shrinking and no dependency-info block
    (see ``android/app/build.gradle.kts``).

Adapted from https://github.com/mkalmousli/FloatingVolume/blob/main/build.py
"""
import os
import shutil
import subprocess
import sys
from json import load
from os.path import abspath, basename, dirname, exists, getsize, join

THIS_DIR = dirname(abspath(__file__))

# One fixed path for every environment. When this script already runs from here
# (e.g. a Docker bind-mount to /tmp/app) we build in place; otherwise (F-Droid,
# a local checkout) we copy the source here first.
REPRODUCIBLE_ROOT = "/tmp/app"
CACHE_DIR = join(REPRODUCIBLE_ROOT, ".build-cache")
TOOLS_DIR = join(CACHE_DIR, "tools")
PUB_CACHE = join(CACHE_DIR, "pub-cache")
FLUTTER_DIR = join(TOOLS_DIR, "flutter")
ANDROID_HOME = os.environ.get("ANDROID_HOME") or "/opt/android-sdk"

with open(join(THIS_DIR, ".fvmrc")) as f:
    FLUTTER_VERSION = load(f)["flutter"]

print(f"Flutter version : {FLUTTER_VERSION}")
print(f"Source dir      : {THIS_DIR}")
print(f"Build dir       : {REPRODUCIBLE_ROOT}")
print(f"Android SDK      : {ANDROID_HOME}")


def run(cmd, cwd=REPRODUCIBLE_ROOT, env=None):
    print("+", " ".join(cmd), flush=True)
    subprocess.check_call(cmd, cwd=cwd, env=env or os.environ)


def download(url, dest):
    if exists(dest):
        return dest
    os.makedirs(dirname(dest), exist_ok=True)
    print(f"Downloading {url}", flush=True)
    from urllib.request import urlopen

    with urlopen(url) as r, open(dest + ".part", "wb") as out:
        shutil.copyfileobj(r, out)
    os.replace(dest + ".part", dest)
    return dest


# 1. Get the source to the fixed build path.
if THIS_DIR != REPRODUCIBLE_ROOT:
    if exists(REPRODUCIBLE_ROOT):
        shutil.rmtree(REPRODUCIBLE_ROOT)
    shutil.copytree(
        THIS_DIR,
        REPRODUCIBLE_ROOT,
        ignore=shutil.ignore_patterns(
            ".git", "build", ".dart_tool", ".gradle", ".kotlin", "dist",
            ".build-cache",
        ),
    )
os.makedirs(TOOLS_DIR, exist_ok=True)

# 2. Android SDK.
if not exists(join(ANDROID_HOME, "platform-tools")) and not exists(
    join(ANDROID_HOME, "cmdline-tools")
):
    zip_path = join(CACHE_DIR, "cmdline-tools.zip")
    download(
        "https://dl.google.com/android/repository/"
        "commandlinetools-linux-11076708_latest.zip",
        zip_path,
    )
    cmt = join(TOOLS_DIR, "cmdline-tools")
    if not exists(cmt):
        os.makedirs(cmt, exist_ok=True)
        run(["unzip", "-q", zip_path, "-d", cmt], cwd=TOOLS_DIR)
    sdkmanager = join(cmt, "cmdline-tools", "bin", "sdkmanager")
    os.makedirs(ANDROID_HOME, exist_ok=True)
    p = subprocess.Popen(
        [sdkmanager, f"--sdk_root={ANDROID_HOME}", "--licenses"],
        stdin=subprocess.PIPE,
    )
    p.communicate(b"y\n" * 50)
    run(
        [
            sdkmanager, f"--sdk_root={ANDROID_HOME}",
            "platform-tools", "build-tools;34.0.0", "platforms;android-35",
        ],
        cwd=TOOLS_DIR,
    )
os.environ["ANDROID_HOME"] = ANDROID_HOME
os.environ["ANDROID_SDK_ROOT"] = ANDROID_HOME

# 3. Flutter SDK — exact pinned version.
if not exists(FLUTTER_DIR):
    run(
        [
            "git", "clone", "--depth", "1", "--branch", FLUTTER_VERSION,
            "https://github.com/flutter/flutter.git", FLUTTER_DIR,
        ],
        cwd=TOOLS_DIR,
    )
os.environ["PATH"] = join(FLUTTER_DIR, "bin") + os.pathsep + os.environ["PATH"]
os.environ["PUB_CACHE"] = PUB_CACHE

# 4. Build.
run(["flutter", "--version"])
run(["flutter", "config", "--no-analytics", "--no-cli-animations"])
run(["flutter", "pub", "get"])
run(["dart", "run", "build_runner", "build", "--delete-conflicting-outputs"])
run(["flutter", "build", "apk", "--release"])

# 5. Copy the artifact next to this script.
src = join(
    REPRODUCIBLE_ROOT, "build", "app", "outputs", "flutter-apk", "app-release.apk"
)
out = join(THIS_DIR, "app.apk")
if exists(out):
    os.remove(out)
shutil.copy(src, out)
print(f"\nBuilt {out}  ({getsize(out) / 1024 / 1024:.1f} MB)", flush=True)
sys.exit(0)
