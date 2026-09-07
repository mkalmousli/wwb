# Reproducible build environment for `build.py`.
# Usage:
#   docker build -t wwb-build .
#   docker run --rm -v "$PWD":/tmp/app wwb-build /tmp/app/build.py
FROM debian:bookworm-20250908

RUN apt-get update && apt-get install -y --no-install-recommends \
        python3-minimal python3 \
        git curl ca-certificates \
        unzip zip xz-utils \
        openjdk-17-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/opt/android-sdk

WORKDIR /tmp/app
ENTRYPOINT ["python3"]
