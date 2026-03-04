#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> Building Rorlux..."
swift build -c release

echo "==> Creating app bundle..."
APP_DIR="build/Rorlux.app/Contents"
rm -rf build/Rorlux.app
mkdir -p "$APP_DIR/MacOS"
mkdir -p "$APP_DIR/Resources"

cp .build/release/Rorlux "$APP_DIR/MacOS/Rorlux"
cp Resources/Info.plist "$APP_DIR/Info.plist"
cp Resources/AppIcon.icns "$APP_DIR/Resources/AppIcon.icns"

echo "==> Signing (ad-hoc)..."
codesign --force --sign - "build/Rorlux.app"

echo ""
echo "Done! App bundle created at: build/Rorlux.app"
echo ""
echo "To install:  rm -rf /Applications/Rorlux.app && cp -r build/Rorlux.app /Applications/"
echo "To run:      open build/Rorlux.app"
