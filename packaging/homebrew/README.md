# Homebrew Formula for wimg

This directory contains the Homebrew formula for installing `wimg` on macOS.

## Installation

### From this tap (if you have it added)
```bash
brew install d3xfoo/tap/wimg
```

### From source
```bash
# Clone this repository
git clone https://github.com/d3xfoo/wimg.git
cd wimg

# Install using the local formula
brew install packaging/homebrew/wimg.rb
```

## Updating the Formula

When releasing a new version:

1. Update the version number in `wimg.rb`
2. Update the URL to point to the new release
3. Update the SHA256 hash (run `shasum -a 256` on the downloaded tarball)
4. Test the formula locally: `brew install --build-from-source packaging/homebrew/wimg.rb`

## Formula Details

- **Class**: `Wimg`
- **Description**: A fast and efficient command-line image processing tool
- **Homepage**: https://github.com/d3xfoo/wimg
- **License**: MIT
- **Dependencies**: Go (build-time only)
- **Architecture**: macOS (Intel and Apple Silicon)

## Testing

The formula includes a basic test that verifies the binary can be executed:
```ruby
test do
  system "#{bin}/wimg", "--help"
end
```

## Contributing

To contribute to the Homebrew formula:
1. Fork the repository
2. Make your changes
3. Test locally with `brew install --build-from-source`
4. Submit a pull request
