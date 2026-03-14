class Omamori < Formula
  desc "AI Agent's Omamori — protect your system from dangerous AI CLI commands"
  homepage "https://github.com/yottayoshida/omamori"
  url "https://github.com/yottayoshida/omamori/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "c425ed9756488d87b576ca946db43196e3aaf5fd47346d9372e76f4174c0e9a1"
  license "MIT"

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      To activate omamori, run:
        omamori install --hooks

      Then add the shim to your PATH (add to ~/.zshrc):
        export PATH="$HOME/.omamori/shim:$PATH"

      And add the Claude Code hook to ~/.claude/settings.json:
        cat ~/.omamori/hooks/claude-settings.snippet.json

      Verify with:
        omamori test

      To customize rules:
        omamori init > ~/.config/omamori/config.toml
        chmod 600 ~/.config/omamori/config.toml
    EOS
  end

  test do
    assert_match "omamori usage", shell_output("#{bin}/omamori help")
  end
end
