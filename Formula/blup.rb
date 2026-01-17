class Blup < Formula
  desc "The Blender Version Manager"
  homepage "https://github.com/unclepomedev/blup"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.0.3/blup-aarch64-apple-darwin.tar.xz"
      sha256 "a5a89804945f3af64104145ee0e85074365b1186681969bd7fdbcf8fbb1ca416"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.0.3/blup-x86_64-apple-darwin.tar.xz"
      sha256 "d3e1d9603bcb13cfa9467cfdb5f85387dab8066e1723aa6c8a5027c0a75c793e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.0.3/blup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ac18aa47261822b0a740dc77d9776cf1100e0a57afaca3da2a4007ccf47c20bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.0.3/blup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "082b20bd00a3186a7d49d44a5a0495d02f8842394cab9adca23f0ebd1617905a"
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
