class Blup < Formula
  desc "The Blender Version Manager"
  homepage "https://github.com/unclepomedev/blup"
  version "0.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.0.5/blup-aarch64-apple-darwin.tar.xz"
      sha256 "25da6e7e515eef4f2fb3e51df9a176e0d844409bd41b1c021b1134bca7e40fcd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.0.5/blup-x86_64-apple-darwin.tar.xz"
      sha256 "831ed9a27dabae54c20e59de21c4e0feb20bdc7d1cb8add3172457448a3445ea"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.0.5/blup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "76ad8734d1d6a5bf3317e4952c5c51fb4b7ca2698d1cc2045c99fe5e506f3d6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.0.5/blup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a78bc8524b085b18cfeb14c7d9331a3188af2478c493de8afa4516bd6ca342b9"
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
