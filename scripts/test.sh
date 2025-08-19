#!/bin/bash

# wimg test script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${GREEN}Running wimg tests...${NC}"

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

# Update dependencies
echo "Updating dependencies..."
go mod tidy
go mod download

# Run tests
echo -e "\n${YELLOW}Running tests...${NC}"
go test -v ./...

# Run tests with coverage
echo -e "\n${YELLOW}Running tests with coverage...${NC}"
go test -v -coverprofile=coverage.out ./...

# Generate HTML coverage report
echo "Generating coverage report..."
go tool cover -html=coverage.out -o coverage.html

# Show coverage summary
echo -e "\n${YELLOW}Coverage Summary:${NC}"
go tool cover -func=coverage.out

# Show coverage report location
echo -e "\n${GREEN}Coverage report generated: coverage.html${NC}"
echo "Open coverage.html in your browser to view detailed coverage"

# Check if tests passed
if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}All tests passed!${NC}"
else
    echo -e "\n${RED}Some tests failed!${NC}"
    exit 1
fi

echo -e "\n${GREEN}Testing complete!${NC}"
