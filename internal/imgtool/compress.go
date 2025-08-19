package imgtool

import (
	"path/filepath"
	"strings"

	"github.com/h2non/bimg"
)

func CompressImage(inputPath string) (string, error) {
	return CompressImageWithQuality(inputPath, 75)
}

func CompressImageWithQuality(inputPath string, quality int) (string, error) {
	buffer, err := bimg.Read(inputPath)
	if err != nil {
		return "", err
	}

	options := bimg.Options{
		Quality: quality,
	}

	newImage, err := bimg.NewImage(buffer).Process(options)
	if err != nil {
		return "", err
	}

	outputPath := generateCompressedFilename(inputPath)
	
	err = bimg.Write(outputPath, newImage)
	if err != nil {
		return "", err
	}

	return outputPath, nil
}

func generateCompressedFilename(inputPath string) string {
	ext := filepath.Ext(inputPath)
	base := strings.TrimSuffix(inputPath, ext)
	return base + ".compressed" + ext
}
