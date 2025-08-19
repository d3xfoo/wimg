#!/bin/bash
# Optional installation hook for wimg AUR package

echo "wimg has been installed successfully!"
echo ""
echo "Usage examples:"
echo "  wimg image.jpg .webp        # Convert to WebP"
echo "  wimg image.jpg              # Compress (creates image.compressed.jpg)"
echo "  wimg -r image.jpg           # Compress & replace original"
echo ""
echo "Compression behavior:"
echo "  - Without -r: Creates .compressed file, preserves original"
echo "  - With -r: Replaces original with compressed version"
echo ""
echo "For more information, see: man wimg"
echo "Or visit: https://github.com/d3xfoo/wimg"
