#!/bin/bash
# Aira Lite — 自包含构建（iOS Simulator，无需 Xcode 工程）
set -e
cd "$(dirname "$0")"
APP=AiraLite.app
rm -rf "$APP" && mkdir -p "$APP"
xcrun -sdk iphonesimulator swiftc \
  -target arm64-apple-ios17.0-simulator \
  -parse-as-library -O -whole-module-optimization \
  -D LITE \
  Sources/*.swift -o "$APP/AiraLite"
cp Info.plist "$APP/"
cp -R Assets/* "$APP/" 2>/dev/null || true
xcrun simctl install booted "$APP"
if [ -n "$1" ]; then xcrun simctl launch booted com.aira.t0.lite -start "$1"
else xcrun simctl launch booted com.aira.t0.lite; fi
