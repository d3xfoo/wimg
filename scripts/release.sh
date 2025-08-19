#!/bin/bash
# wimg release script

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${GREEN}wimg Release Script${NC}"

cd "$PROJECT_DIR"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

# Check if working directory is clean
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}Error: Working directory is not clean${NC}"
    echo "Please commit or stash your changes before releasing"
    exit 1
fi

# Get current version
CURRENT_VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo "v0.0.0")
echo -e "${YELLOW}Current version: $CURRENT_VERSION${NC}"

# Prompt for new version
read -p "Enter new version (e.g., v1.0.0): " NEW_VERSION

if [ -z "$NEW_VERSION" ]; then
    echo -e "${RED}Error: Version cannot be empty${NC}"
    exit 1
fi

# Validate version format
if ! [[ $NEW_VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error: Invalid version format. Use format: vX.Y.Z${NC}"
    exit 1
fi

echo -e "${YELLOW}Creating release: $NEW_VERSION${NC}"

# Create and push tag
echo "Creating git tag..."
git tag -a "$NEW_VERSION" -m "Release $NEW_VERSION"

echo "Pushing tag to remote..."
git push origin "$NEW_VERSION"

# Build for all platforms
echo "Building for all platforms..."
make build-all

# Create release directory
RELEASE_DIR="release"
mkdir -p "$RELEASE_DIR"

# Create release artifacts
echo "Creating release artifacts..."

# Linux builds
tar -czf "$RELEASE_DIR/wimg-$NEW_VERSION-linux-amd64.tar.gz" wimg-linux-amd64
tar -czf "$RELEASE_DIR/wimg-$NEW_VERSION-linux-arm64.tar.gz" wimg-linux-arm64

# macOS builds
tar -czf "$RELEASE_DIR/wimg-$NEW_VERSION-darwin-amd64.tar.gz" wimg-darwin-amd64
tar -czf "$RELEASE_DIR/wimg-$NEW_VERSION-darwin-arm64.tar.gz" wimg-darwin-arm64

# Windows build
zip "$RELEASE_DIR/wimg-$NEW_VERSION-windows-amd64.zip" wimg-windows-amd64.exe

# Create checksums
echo "Creating checksums..."
cd "$RELEASE_DIR"
for file in wimg-$NEW_VERSION-*; do
    if [ -f "$file" ]; then
        sha256sum "$file" > "$file.sha256"
    fi
done
cd ..

# Show release artifacts
echo -e "\n${GREEN}Release artifacts created:${NC}"
ls -lh "$RELEASE_DIR"/wimg-$NEW_VERSION-*

echo -e "\n${GREEN}Release $NEW_VERSION created successfully!${NC}"
echo "Next steps:"
echo "1. Create a GitHub release with these artifacts"
echo "2. Update package managers (AUR, Homebrew)"
echo "3. Announce the release"
