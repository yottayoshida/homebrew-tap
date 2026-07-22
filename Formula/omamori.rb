class Omamori < Formula
  desc "AI Agent's Omamori — protect your system from dangerous AI CLI commands"
  homepage "https://github.com/yottayoshida/omamori"
  url "https://github.com/yottayoshida/omamori/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b1b6372640e4fde4bcae7dd6cd19f855dfe3d16a5378ddec151ce9233329ce1d"
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
        omamori config list                          # show current rules
        omamori config add my-rule --command rm --action block --match-any -rf  # scaffold a custom rule
        omamori config disable my-rule                 # disable it
        omamori override disable git-push-force-block  # disable a built-in (core rules use override)
    EOS
  end

  test do
    assert_match "AI tool safety guard", shell_output("#{bin}/omamori help")
  end
end
