cask "box" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "apple-darwin", linux: "unknown-linux-gnu"

  version "0.3.1"
  sha256 arm:          "64e8668f0867f268127192cad1f5524575c24d9d6bb130ebe0b54dedda145a73",
         arm64_linux:  "741d7f33db01e77974dd8c93c724de737e57b39b82fa03344933527e7e2b06d5",
         x86_64_linux: "bb7dbc4d628b08838331ce63670fafb3b3f4fa8df6693309c47b1bea6095bdd9"

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
