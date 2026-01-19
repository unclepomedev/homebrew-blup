class Blup < Formula
  desc "The Blender Version Manager"
  homepage "https://github.com/unclepomedev/blup"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.1.1/blup-aarch64-apple-darwin.tar.xz"
      sha256 "4f1ad2d0da1ba47f01e49ed06ea2617e9c1a6eb59cc270aee4d0f0a691a7b93d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.1.1/blup-x86_64-apple-darwin.tar.xz"
      sha256 "96a2f48791aea3b89f332fba9e4309d92e5d9071626c3b21d9e319114d4d4aaa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.1.1/blup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61f18034ee78ac465474bc04f6a1d2ea69bb0311668cfe8a1b8267e182397043"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.1.1/blup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "85525840bd740c0c1e752c93d981de019ab6c535c1218746927e6b7fbbd86e85"
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
