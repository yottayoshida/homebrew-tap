class Sideeye < Formula
  desc "Deterministic crash-consistency checker for command-line tools"
  homepage "https://github.com/yottayoshida/sideeye"
  license any_of: ["MIT", "Apache-2.0"]

  # Ships the released build rather than compiling from source. The project
  # pins Zig 0.16.0 and has been broken by Zig releases before, so a
  # `depends_on "zig" => :build` formula would break whenever Homebrew's zig
  # moves ahead of the pin. The release already publishes the three targets
  # below, so this costs no new build work and installs in seconds.
  on_macos do
    # The release matrix builds aarch64-macos only; there is no Intel asset
    # to point at, and this gives a clear error instead of a missing URL.
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/yottayoshida/sideeye/releases/download/v1.13.0/sideeye-v1.13.0-aarch64-macos.tar.gz"
      sha256 "bec94bf6d1b5beb49cb72ded4efcaa99f4f6e418514f33f9806544ae0f40fcb1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/yottayoshida/sideeye/releases/download/v1.13.0/sideeye-v1.13.0-x86_64-linux.tar.gz"
      sha256 "e2aaf8b5fcba752edca019a8a9503095bcea6bfeb582b4e7a1a702324e4e798f"
    end
    on_arm do
      url "https://github.com/yottayoshida/sideeye/releases/download/v1.13.0/sideeye-v1.13.0-aarch64-linux.tar.gz"
      sha256 "93046775f9f5e28f6f6716730aaa3cbab8fa1916c1f41ff0afc73b7cc1ed2e06"
    end
  end

  def install
    # The shim is half the product. sideeye looks for it beside the binary
    # first and then at ../lib, resolving its own path with realpath, so a
    # Homebrew install finds <cellar>/<version>/lib from the bin symlink
    # with no --shim and no wrapper. Measured against this layout before
    # the formula was written.
    bin.install "sideeye"
    lib.install Dir["libsideeye_shim.*"]
    prefix.install "LICENSE-MIT", "LICENSE-APACHE"
  end

  def caveats
    <<~EOS
      The shim is installed alongside the binary and is found automatically.
      Pass --shim only to override it.

      Check the install with:
        sideeye demo

      demo explores a small planted-bug tool carried inside sideeye, so it
      exits 1 on success: finding the planted bug is the expected result.
    EOS
  end

  test do
    assert_match "sideeye #{version}", shell_output("#{bin}/sideeye version")

    # Prove the shim is found without --shim, which is the whole reason this
    # formula can exist without a wrapper. demo exits 1 when it finds the
    # planted bug, which is the passing case.
    output = shell_output("#{bin}/sideeye demo 2>&1", 1)
    assert_match "FAIL", output
  end
end
