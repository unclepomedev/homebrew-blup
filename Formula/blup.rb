class Blup < Formula
  desc "The Blender Version Manager"
  homepage "https://github.com/unclepomedev/blup"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.2.0/blup-aarch64-apple-darwin.tar.xz"
      sha256 "5ac642aefe3fac30b92694ec13390883ba65f74b057e9a50cb843d0a82b0a9ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.2.0/blup-x86_64-apple-darwin.tar.xz"
      sha256 "850717bbffde03e93979d6e549ed1cdb3cf24cc340b520e37dc0f84d163ef5a7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.2.0/blup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6e159fac2aa68ff939151d918b9948315852cf21f5c0ecec38c01576c49d932a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.2.0/blup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "377b224ac3a01df7299d8364ade5e93b5557e7b4d96b9af5b9f8c673a388047d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "blup"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "blup"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "blup"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "blup"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
