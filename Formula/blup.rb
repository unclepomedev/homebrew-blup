class Blup < Formula
  desc "The Blender Version Manager"
  homepage "https://github.com/unclepomedev/blup"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.1.3/blup-aarch64-apple-darwin.tar.xz"
      sha256 "21d71fbf22c194dac6d04b1bbada97b8cbeb765338c95264225dc3328dc9cedd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.1.3/blup-x86_64-apple-darwin.tar.xz"
      sha256 "0fe92a5d9040ef16cf64d5a4be98fcb018a8a56f611d342712365145d05a7a52"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.1.3/blup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ce64a129e2d8545df2c56fa567970026f41057f6de029b584d73978b9873c7de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.1.3/blup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bccbd1e7dbda416c4e71db5223aa55d508d604a6a02d1506b051369eb11eb44d"
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
