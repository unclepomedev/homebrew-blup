class Blup < Formula
  desc "The Blender Version Manager"
  homepage "https://github.com/unclepomedev/blup"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.1.5/blup-aarch64-apple-darwin.tar.xz"
      sha256 "ffeaa00898fe30403a45c9a77b4786887fc8461a4a86e30e6787856fae3fe92d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.1.5/blup-x86_64-apple-darwin.tar.xz"
      sha256 "dcf3f88ae7a5c2e8badc53b536a11f9639b8dc2f4ebdaf649fdeafd0d461c312"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.1.5/blup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e04c8a004c94ed83782c0ff5928b09b78ea5b00cb3c4ca120ff274040ee3bd21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.1.5/blup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e6a5b6c3375fc7df4f084d7c143a27c4902a003c0d923db1a93b44658facf6b"
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
    bin.install "blup" if OS.mac? && Hardware::CPU.arm?
    bin.install "blup" if OS.mac? && Hardware::CPU.intel?
    bin.install "blup" if OS.linux? && Hardware::CPU.arm?
    bin.install "blup" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
