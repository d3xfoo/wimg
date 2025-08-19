#!/bin/bash

# wimg build script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${GREEN}Building wimg...${NC}"

# Change to project directory
cd "$PROJECT_DIR"

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo -e "${RED}Error: Go is not installed${NC}"
    exit 1
fi

# Get Go version
GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
echo -e "${YELLOW}Go version: $GO_VERSION${NC}"

# Clean previous builds
echo "Cleaning previous builds..."
rm -f wimg wimg-*

# Build the binary
echo "Building binary..."
go build -o wimg cmd/wimg/main.go

# Check if build was successful
if [ -f "wimg" ]; then
    echo -e "${GREEN}Build successful!${NC}"
    echo "Binary location: $(pwd)/wimg"
    
    # Show binary info
    echo -e "\n${YELLOW}Binary information:${NC}"
    ls -lh wimg
    file wimg
    
    # Test the binary
    echo -e "\n${YELLOW}Testing binary...${NC}"
    if ./wimg --help &> /dev/null || ./wimg &> /dev/null; then
        echo -e "${GREEN}Binary test passed!${NC}"
    else
        echo -e "${YELLOW}Binary test failed (this might be expected for wimg)${NC}"
    fi
else
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi

echo -e "\n${GREEN}Build complete!${NC}"
