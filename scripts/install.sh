#!/bin/bash

# wimg install script
# Downloads and installs the wimg binary

set -e

# --- Configuration ---
REPO_OWNER="d3xfoo"
REPO_NAME="wimg"
# Base URL for releases - replace with your actual domain if not using GitHub Releases
BASE_DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download"

# --- Colors for output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Functions ---

get_latest_version() {
    # Fetches the latest release version from GitHub API
    # Replace with your own API endpoint if using a custom domain for releases
    curl -sSL "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest" |
    grep "tag_name" | head -n 1 | awk -F ': \"' '{print $2}' | sed 's/\"$//'
}

check_dependencies() {
    echo -e "${YELLOW}Checking dependencies...${NC}"
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}Error: curl is not installed. Please install it to proceed.${NC}"
        exit 1
    fi
    if ! command -v tar &> /dev/null; then
        echo -e "${RED}Error: tar is not installed. Please install it to proceed.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Dependencies met.${NC}"
}

get_platform() {
    local os="$(uname -s)"
    local arch="$(uname -m)"

    case "$os" in
        Linux*)
            OS="linux"
            ;;
        Darwin*)
            OS="darwin"
            ;;
        CYGWIN*|MINGW32*|MSYS*|MINGW*)
            OS="windows"
            ;;
        *)
            echo -e "${RED}Unsupported OS: $os${NC}"
            exit 1
            ;;
    esac

    case "$arch" in
        x86_64)
            ARCH="amd64"
            ;;
        aarch64)
            ARCH="arm64"
            ;;
        arm64)
            ARCH="arm64"
            ;;
        *)
            echo -e "${RED}Unsupported architecture: $arch${NC}"
            exit 1
            ;;
    esac
}

# --- Main installation logic ---

echo -e "${GREEN}Starting wimg installation...${NC}"

check_dependencies
get_platform

INSTALL_DIR="/usr/local/bin"
if [ "$OS" == "windows" ]; then
    # For Windows, we might need a different install path or guide user
    # For simplicity, let's just place it in current dir for now for cross-platform consistency
    # A robust installer for Windows would use Chocolatey or Scoop
    INSTALL_DIR="."
    echo -e "${YELLOW}Detected Windows. Binary will be placed in current directory: $INSTALL_DIR${NC}"
fi

# Determine latest version, or use a default if API call fails
VERSION=$(get_latest_version)
if [ -z "$VERSION" ]; then
    echo -e "${YELLOW}Warning: Could not fetch latest version. Using default v1.0.0${NC}"
    VERSION="v1.0.0"
fi

BINARY_NAME="wimg"
ARCHIVE_EXT=".tar.gz"
if [ "$OS" == "windows" ]; then
    ARCHIVE_EXT=".zip"
    BINARY_NAME="wimg.exe"
fi

DOWNLOAD_URL="${BASE_DOWNLOAD_URL}/${VERSION}/${REPO_NAME}-${VERSION}-${OS}-${ARCH}${ARCHIVE_EXT}"
LOCAL_ARCHIVE="${REPO_NAME}-${VERSION}-${OS}-${ARCH}${ARCHIVE_EXT}"

echo -e "${YELLOW}Platform: ${OS}/${ARCH}${NC}"
echo -e "${YELLOW}Downloading from: ${DOWNLOAD_URL}${NC}"

# Download the archive
curl -L -o "$LOCAL_ARCHIVE" "$DOWNLOAD_URL"

# Extract the binary
echo "Extracting binary..."
if [ "$OS" == "windows" ]; then
    unzip -o "$LOCAL_ARCHIVE"
else
    tar -xzf "$LOCAL_ARCHIVE"
fi

# Move binary to install directory
echo "Moving binary to $INSTALL_DIR..."
sudo mv "${REPO_NAME}-${OS}-${ARCH}" "$INSTALL_DIR/${BINARY_NAME}" || echo -e "${RED}Failed to move binary (might need sudo/permissions). Attempting to move without sudo.${NC}"

# Fallback without sudo (if sudo failed or not available)
if [ ! -f "$INSTALL_DIR/${BINARY_NAME}" ]; then
    mv "${REPO_NAME}-${OS}-${ARCH}" "$INSTALL_DIR/${BINARY_NAME}"
fi

# Make executable
echo "Making binary executable..."
sudo chmod +x "$INSTALL_DIR/${BINARY_NAME}" || echo -e "${RED}Failed to set executable permissions (might need sudo/permissions). Attempting without sudo.${NC}"

# Fallback without sudo
if [ ! -x "$INSTALL_DIR/${BINARY_NAME}" ]; then
    chmod +x "$INSTALL_DIR/${BINARY_NAME}"
fi

# Clean up
echo "Cleaning up..."
rm -f "$LOCAL_ARCHIVE"
rm -f "${REPO_NAME}-${OS}-${ARCH}"


if command -v "$INSTALL_DIR/${BINARY_NAME}" &> /dev/null; then
    echo -e "\n${GREEN}wimg installed successfully to $(command -v ${BINARY_NAME})!${NC}"
    "$INSTALL_DIR/${BINARY_NAME}" --help
else
    echo -e "\n${RED}Installation failed. Please check the output above for errors.${NC}"
    echo -e "Ensure that ${INSTALL_DIR} is in your system's PATH."
    exit 1
fi
