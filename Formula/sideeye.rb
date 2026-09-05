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
      url "https://github.com/yottayoshida/sideeye/releases/download/v1.2.0/sideeye-v1.2.0-aarch64-macos.tar.gz"
      sha256 "355ff62fa7316f3aae8ec22d857fbf3f4c216b485b4934214e65bcab775087a5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/yottayoshida/sideeye/releases/download/v1.2.0/sideeye-v1.2.0-x86_64-linux.tar.gz"
      sha256 "418816b98e0312f1fb3fa7f850761a55c1283acab41af5b5aa3f29d0e2801823"
    end
    on_arm do
      url "https://github.com/yottayoshida/sideeye/releases/download/v1.2.0/sideeye-v1.2.0-aarch64-linux.tar.gz"
      sha256 "ee7b21a8ac89db912e6802af53ade9a259baf114137c460ffc5b85b013f108e5"
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

      demo compiles a small planted-bug tool (it needs a C compiler) and
      explores it, so it exits 1 on success: finding the planted bug is the
      expected result.
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
