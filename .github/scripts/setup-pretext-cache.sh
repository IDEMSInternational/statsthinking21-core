#!/bin/bash
# Setup PreTeXt cache to work around bug in versions 2.32.0-2.36.0
# where rs_services.xml is not found when the download fails.

set -e

# Get PreTeXt version
PTX_VERSION=$(pretext --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
echo "PreTeXt version: $PTX_VERSION"

# Create cache directory
CACHE_DIR="$HOME/.ptx/$PTX_VERSION/rs_cache"
mkdir -p "$CACHE_DIR"

# Check if rs_services.xml already exists
if [ -f "$CACHE_DIR/rs_services.xml" ]; then
    echo "Cache file rs_services.xml already exists"
    exit 0
fi

# Check if runestone_services.xml exists and copy it
if [ -f "$CACHE_DIR/runestone_services.xml" ]; then
    echo "Copying runestone_services.xml to rs_services.xml"
    cp "$CACHE_DIR/runestone_services.xml" "$CACHE_DIR/rs_services.xml"
    exit 0
fi

# Create a minimal fallback cache file if neither exists
# Note: These values are from Runestone 7.10.0 (as of 2024) and were
# extracted from a working PreTeXt installation. They provide basic
# Runestone functionality and reference a specific versioned CDN release.
# PreTeXt will attempt to fetch updated values on each build, so this
# fallback is only used when the network fetch fails. If builds succeed,
# these values remain valid indefinitely due to versioned CDN URLs.
echo "Creating minimal fallback cache file"
cat > "$CACHE_DIR/rs_services.xml" << 'EOF'
<?xml version="1.0" ?>
<all>
	<js type="list">
		<item type="str">prefix-runtime.f91c1a4dc12163f2.bundle.js</item>
		<item type="str">prefix-723.3e6434f80549315a.bundle.js</item>
		<item type="str">prefix-runestone.fe35e59c546f8d19.bundle.js</item>
	</js>
	<css type="list">
		<item type="str">prefix-723.3bccd435914aa0ff.css</item>
		<item type="str">prefix-runestone.557d81b04b3ec0e4.css</item>
	</css>
	<cdn-url type="str">https://runestone.academy/cdn/runestone/</cdn-url>
	<version type="str">7.10.0</version>
</all>
EOF

echo "Cache file created successfully"
