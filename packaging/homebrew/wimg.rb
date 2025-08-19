class Wimg < Formula
  desc "A fast and efficient command-line image processing tool"
  homepage "https://github.com/d3xfoo/wimg"
  url "https://github.com/d3xfoo/wimg/archive/v1.0.0.tar.gz"
  sha256 "SKIP"
  license "MIT"
  head "https://github.com/d3xfoo/wimg.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "wimg", "cmd/wimg/main.go"
    bin.install "wimg"
  end

  test do
    # Test that the binary works
    system "#{bin}/wimg", "--help"
  end
end
