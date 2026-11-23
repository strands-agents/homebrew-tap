cask "box" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "apple-darwin", linux: "unknown-linux-gnu"

  version "0.3.0"
  sha256 arm:          "bc077119fe6b9c4ff84dffea4f895bd23531d7eda36c965aa5503131c69aaa70",
         arm64_linux:  "9c7c01b22374b0041823429ba068745829ac3800db7c43b762f1836b54b40658",
         x86_64_linux: "55770ed51b589f321b53502efd60aed0aaf03fa3671606389baf6d861e4df8e9"

  on_macos do
    depends_on arch: :arm64
    depends_on macos: ">= :sequoia"
  end

  url "https://github.com/strands-agents/box/releases/download/v#{version}/box-cli-v#{version}-#{arch}-#{os}.tar.gz"
  name "Strands Box"
  desc "Run AI agents in a sandbox that limits what they can run, read, write and reach"
  homepage "https://github.com/strands-agents/box"

  livecheck do
    url :url
    strategy :github_latest
  end

  # box finds its helpers and resources next to its real path in the Caskroom.
  binary "box"

  # ~/.strands/box holds the user's profiles and run history.
  zap :not_required
end
