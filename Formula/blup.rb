class Blup < Formula
  desc "The Blender Version Manager"
  homepage "https://github.com/unclepomedev/blup"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.2.1/blup-aarch64-apple-darwin.tar.xz"
      sha256 "6d7b71c566abee1ef394c36efc8e718f1b78c12434328b9c405557fd8f744ea5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.2.1/blup-x86_64-apple-darwin.tar.xz"
      sha256 "3990f736998c4bc141990724245c9f361a42d94634cbd7299ccbbfefed2ad452"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/unclepomedev/blup/releases/download/v0.2.1/blup-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61bc9db3445da258a93411ce25d0869e6605406c269ee613618d1a408e49ceb8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unclepomedev/blup/releases/download/v0.2.1/blup-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5f2a7cbe03e3fbe27567b1f99e2bc96b6d97c9544ce8537fb258985a09557019"
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
