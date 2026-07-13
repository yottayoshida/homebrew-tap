class Omamori < Formula
  desc "AI Agent's Omamori — protect your system from dangerous AI CLI commands"
  homepage "https://github.com/yottayoshida/omamori"
  url "https://github.com/yottayoshida/omamori/archive/refs/tags/v0.12.5.tar.gz"
  sha256 "307418930a942876f5566085081afd58ed45a440079bf9b490e3c3595ce8b144"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      One-command setup (installs shims, hooks, and shell PATH):
        omamori setup

      After `brew upgrade`, re-run `omamori setup` to update shims.
      Claude Code hooks auto-update on next command.

      To customize rules:
        omamori config list                        # show current rules
        omamori config disable git-push-force-block # disable a rule
        omamori config enable git-push-force-block  # re-enable
    EOS
  end

  test do
    assert_match "AI tool safety guard", shell_output("#{bin}/omamori help")
  end
end
