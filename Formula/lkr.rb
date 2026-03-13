class Lkr < Formula
  desc "LLM Key Ring — manage LLM API keys via macOS Keychain"
  homepage "https://github.com/yottayoshida/llm-key-ring"
  url "https://github.com/yottayoshida/llm-key-ring/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "a3a0045fd303de4a7d80c268229f1e8f5c51d0c57a447313d8bf930066e9121f"
  license "MIT"

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/lkr-cli")
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
