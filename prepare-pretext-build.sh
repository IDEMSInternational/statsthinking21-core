#!/bin/bash
# Pre-build script for PreTeXt
# Copies images from images/ directory to external/ directory for PreTeXt build

echo "Copying images from images/ to external/ for PreTeXt build..."

# Create external directory if it doesn't exist
mkdir -p external

# Copy all PNG images from images/ to external/
cp images/*.png external/ 2>/dev/null || true
cp images/*.jpg external/ 2>/dev/null || true
cp images/*.jpeg external/ 2>/dev/null || true

echo "Images copied successfully."
echo "You can now run: pretext build html"
