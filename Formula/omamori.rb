class Omamori < Formula
  desc "AI Agent's Omamori — protect your system from dangerous AI CLI commands"
  homepage "https://github.com/yottayoshida/omamori"
  url "https://github.com/yottayoshida/omamori/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "b94a962ec3ec1434eaffe386d6215f2ab4626747b2e54e31e1f292c954a04da0"
  license any_of: ["MIT", "Apache-2.0"]

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

      That's it! install auto-creates config and verifies rules.

      After `brew upgrade`, Claude Code hooks auto-update on next command.
      Cursor users: re-merge ~/.omamori/hooks/cursor-hooks.snippet.json

      To customize rules:
        omamori config list                        # show current rules
        omamori config disable git-push-force-block # disable a rule
        omamori config enable git-push-force-block  # re-enable
    EOS
  end

  test do
    assert_match "omamori usage", shell_output("#{bin}/omamori help")
  end
end
