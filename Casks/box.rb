cask "box" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "apple-darwin", linux: "unknown-linux-gnu"

  version "0.3.2"
  sha256 arm:          "3f65565737411fa17f743e7beb1b39e1bc35e43f8e2755fc62595d41326f6262",
         arm64_linux:  "5db4623989377c2990c639fbfa8d533546c70c67319e016ad113769dc807c985",
         x86_64_linux: "d91e7344a23ce89b83d9212543bb22e68b7b67afef4623185e86f83edf79e521"

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :sequoia
  end

  url "https://github.com/strands-agents/box/releases/download/v#{version}/box-cli-v#{version}-#{arch}-#{os}.tar.gz"
  name "Strands Box"
  desc "Sandbox for running AI coding agents under a policy"
  homepage "https://github.com/strands-agents/box"

  livecheck do
    url :url
    strategy :github_latest
  end

  # box finds its helpers and resources next to its real path in the Caskroom.
  binary "box"

  # ~/.strands/box holds the user's profiles and run history.
  zap :not_required

  caveats <<~EOS
    box sends usage telemetry to telemetry.strandsagents.com unless you opt out. To opt out, run:
      box telemetry off
    To learn more:
      https://github.com/strands-agents/box/blob/main/CLI_TELEMETRY.md
  EOS
end
