# wimg

A fast and efficient command-line image processing tool written in Go. Convert images between formats and compress them with ease.

## Features

- **Format Conversion**: Convert between JPEG, PNG, WebP, TIFF, and AVIF formats
- **Image Compression**: Compress images to create `.compressed` files with configurable quality
- **Fast Processing**: Built with high-performance image processing libraries
- **Simple CLI**: Easy-to-use command-line interface
- **Cross-platform**: Works on Linux, macOS, and Windows

## Installation

### From Source

```bash
git clone https://github.com/d3xfoo/wimg.git
cd wimg
go build -o wimg cmd/wimg/main.go
sudo mv wimg /usr/local/bin/
```

## Usage

### Basic Commands

```bash
# Convert image to WebP format
wimg image.jpg .webp

# Compress image (creates image.compressed.jpg)
wimg image.jpg

# Compress and replace original with compressed version
wimg -r image.jpg
```

### Examples

```bash
# Convert JPEG to PNG
wimg photo.jpg .png

# Convert to WebP (great for web)
wimg photo.jpg .webp

# Convert to AVIF (modern format)
wimg photo.jpg .avif

# Compress a large image (creates large-photo.compressed.jpg)
wimg large-photo.jpg

# Compress and replace original (keeps only compressed version)
wimg -r photo.jpg
```

## Supported Formats

- **Input**: JPEG, PNG, WebP, TIFF, AVIF
- **Output**: JPEG, PNG, WebP, TIFF, AVIF

## Compression Behavior

When compressing an image without the `-r` flag:
- Creates a new file with `.compressed` extension
- Original file is preserved
- Example: `wimg photo.jpg` → creates `photo.compressed.jpg`

When using the `-r` flag:
- Creates compressed version
- Removes the original file
- Renames compressed file to original name
- Example: `wimg -r photo.jpg` → replaces `photo.jpg` with compressed version

## Dependencies

- Go 1.24.5 or later
- [bimg](https://github.com/h2non/bimg) - Image processing library

## Development

### Building

```bash
make build
```

### Testing

```bash
make test
```

### Release

```bash
make release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [bimg](https://github.com/h2non/bimg) for the excellent image processing capabilities
- The Go community for the robust ecosystem
