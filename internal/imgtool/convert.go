package imgtool

import (
	"strings"

	"github.com/h2non/bimg"
)

func ConvertImage(inputPath, outputPath, ext string) error {
	buffer, err := bimg.Read(inputPath)
	if err != nil {
		return err
	}

	options := bimg.Options{
		Type: bimgImageType(ext),
	}

	newImage, err := bimg.NewImage(buffer).Process(options)
	if err != nil {
		return err
	}

	return bimg.Write(outputPath, newImage)
}

func bimgImageType(ext string) bimg.ImageType {
	switch strings.ToLower(ext) {
	case ".jpeg", ".jpg":
		return bimg.JPEG
	case ".png":
		return bimg.PNG
	case ".webp":
		return bimg.WEBP
	case ".tiff":
		return bimg.TIFF
	case ".avif":
		return bimg.AVIF
	default:
		return bimg.JPEG
	}
}
