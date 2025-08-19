package imgtool

import (
	"path/filepath"
	"strings"
)

func IsImageFile(filename string) bool {
	ext := strings.ToLower(filepath.Ext(filename))
	supportedExts := []string{".jpg", ".jpeg", ".png", ".webp", ".tiff", ".avif"}
	
	for _, supported := range supportedExts {
		if ext == supported {
			return true
		}
	}
	return false
}

func GetOutputFilename(inputPath, targetExt string) string {
	base := strings.TrimSuffix(inputPath, filepath.Ext(inputPath))
	return base + targetExt
}

func ValidateExtension(ext string) bool {
	if !strings.HasPrefix(ext, ".") {
		return false
	}
	return IsImageFile("dummy" + ext)
}
