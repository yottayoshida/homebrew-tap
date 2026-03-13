class Lkr < Formula
  desc "LLM Key Ring — manage LLM API keys via macOS Keychain"
  homepage "https://github.com/yottayoshida/llm-key-ring"
  url "https://github.com/yottayoshida/llm-key-ring/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "40a590060b8cd0f277f806d5b085d9599a138d1e50ca40c9422f9c240e8feb76"
  license "MIT"

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", "--locked", *std_cargo_args(path: "crates/lkr-cli")
  end

  def caveats
    <<~EOS
      After upgrading lkr (e.g. `brew upgrade lkr`), run:
        lkr harden
      to refresh Keychain ACL for the new binary.

      Uninstalling lkr does NOT delete your Keychain or stored keys.
      To remove keys: `lkr rm <name>` for each key, then delete the keychain file.
    EOS
  end

  test do
    assert_match "LLM Key Ring", shell_output("#{bin}/lkr --help")
    assert_match version.to_s, shell_output("#{bin}/lkr --version")
  end
end
