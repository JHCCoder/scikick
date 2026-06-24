#!/usr/bin/env bash
# PhiDkick — Chrome extension loading helper
#
# Usage:
#   ./install-extension.sh
#
# Detects your browser, opens the extensions page, copies the extension
# folder path to your clipboard, and prints clear instructions.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSION_DIR="$SCRIPT_DIR/extension"

GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
BLUE=$'\033[0;34m'
NC=$'\033[0m'

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Load the PhiDkick Chrome Extension${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ── Detect browser ──
BROWSER=""
BROWSER_NAME=""
EXTENSIONS_URL=""

if command -v open &>/dev/null; then
    # macOS: check for common browsers
    if [ -d "/Applications/Google Chrome.app" ]; then
        BROWSER="Google Chrome"
        BROWSER_NAME="Chrome"
        EXTENSIONS_URL="chrome://extensions/"
    elif [ -d "/Applications/Chromium.app" ]; then
        BROWSER="Chromium"
        BROWSER_NAME="Chromium"
        EXTENSIONS_URL="chrome://extensions/"
    elif [ -d "/Applications/Microsoft Edge.app" ]; then
        BROWSER="Microsoft Edge"
        BROWSER_NAME="Edge"
        EXTENSIONS_URL="edge://extensions/"
    elif [ -d "/Applications/Brave Browser.app" ]; then
        BROWSER="Brave Browser"
        BROWSER_NAME="Brave"
        EXTENSIONS_URL="brave://extensions/"
    elif [ -d "/Applications/Arc.app" ]; then
        BROWSER="Arc"
        BROWSER_NAME="Arc"
        EXTENSIONS_URL="chrome://extensions/"
    fi
fi

if [ -z "$BROWSER" ]; then
    echo "Could not auto-detect your browser."
    echo "Supported browsers: Chrome, Chromium, Edge, Brave, Arc"
    echo ""
    echo "Manual steps:"
    echo "  1. Open your browser's extensions page"
    echo "  2. Enable Developer mode"
    echo "  3. Click 'Load unpacked'"
    echo "  4. Select: $EXTENSION_DIR"
    echo ""
    exit 0
fi

echo "Detected browser: ${GREEN}$BROWSER${NC}"
echo "Extension folder:  ${GREEN}$EXTENSION_DIR${NC}"
echo ""

# ── Copy path to clipboard ──
if command -v pbcopy &>/dev/null; then
    echo -n "$EXTENSION_DIR" | pbcopy
    echo "📋 Extension folder path copied to clipboard!"
elif command -v xclip &>/dev/null; then
    echo -n "$EXTENSION_DIR" | xclip -selection clipboard
    echo "📋 Extension folder path copied to clipboard!"
elif command -v clip.exe &>/dev/null; then
    echo -n "$EXTENSION_DIR" | clip.exe
    echo "📋 Extension folder path copied to clipboard!"
fi

echo ""
echo -e "${YELLOW}Follow these steps:${NC}"
echo ""
echo "  1. Open the Extensions page:"
echo -e "     → ${BLUE}$EXTENSIONS_URL${NC}"
echo ""
echo "  2. Toggle ${YELLOW}Developer mode${NC} ON (switch in top-right corner)"
echo ""
echo "  3. Click ${YELLOW}Load unpacked${NC} (button that appears after step 2)"
echo ""
echo "  4. Select this folder (path is in your clipboard — paste it):"
echo -e "     ${GREEN}$EXTENSION_DIR${NC}"
echo ""
echo "  5. The PhiDkick icon 📄 appears in your toolbar — pin it!"
echo ""

# ── Open extensions page ──
if command -v open &>/dev/null; then
    read -r -p "Open $EXTENSIONS_URL in $BROWSER_NAME now? [Y/n]: " resp
    if [ "$resp" != "n" ] && [ "$resp" != "N" ]; then
        open -a "$BROWSER" "$EXTENSIONS_URL" 2>/dev/null || \
        open "$EXTENSIONS_URL" 2>/dev/null || true
    fi
fi

echo ""
echo -e "${GREEN}Done! Click the PhiDkick icon in your toolbar to open the side panel.${NC}"
echo ""
