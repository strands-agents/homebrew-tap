<div align="center">
  <div>
    <a href="https://strandsagents.com">
      <picture>
        <source media="(prefers-color-scheme: dark)" srcset="https://strandsagents.com/latest/assets/wordmark-github-dark.svg">
        <img src="https://strandsagents.com/latest/assets/wordmark-github-light.svg" alt="Strands" width="320">
      </picture>
    </a>
  </div>

  <h1>Strands Homebrew Tap</h1>

  <h2>Install Strands command-line tools with Homebrew on macOS and Linux.</h2>

  <div align="center">
    <a href="https://github.com/strands-agents/homebrew-tap/actions/workflows/tests.yml"><img src="https://github.com/strands-agents/homebrew-tap/actions/workflows/tests.yml/badge.svg" alt="Tests"></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-Apache--2.0-blue" alt="License"></a>
  </div>

</div>

<hr>

## Overview

This is the official [Homebrew tap](https://docs.brew.sh/Taps) for [Strands Agents](https://strandsagents.com).
It installs the release packages that Strands publishes on GitHub, unchanged. Homebrew doesn't
rebuild them.

## Packages

| Package | Type | Description | Install, upgrade and uninstall |
| --- | --- | --- | --- |
| [`box`](Casks/box.rb) | Cask | [Strands Box](https://github.com/strands-agents/box): sandbox for running AI coding agents under a policy | [Install Box with Homebrew](https://github.com/strands-agents/box/blob/main/docs/cli/install.md#install-with-homebrew) |

Each package's guide gives its requirements, its exact commands, what it keeps on your machine and
what to do next.

## Install a package

Install a cask by its full name:

```sh
brew install --cask strands-agents/tap/<package>
```

This adds the tap and trusts that one package.

### Install by short name

Since Homebrew 6.0, Homebrew loads a third-party tap's code only after you trust it
([Tap Trust](https://docs.brew.sh/Tap-Trust)). The full name above trusts only the package you
install. To use the short name instead, trust the package once:

```sh
brew tap strands-agents/tap
brew trust --cask strands-agents/tap/<package>
brew install --cask <package>
```

## Upgrade

```sh
brew update
brew upgrade --cask <package>
```

Each cask follows its tool's stable releases and skips pre-releases. A new release reaches the tap
when its bump pull request is merged.

## Remove the tap

Uninstall each package as its guide says, then remove the tap:

```sh
brew untap strands-agents/tap
```

## How downloads are checked

Homebrew checks each download against the SHA-256 checksum in the cask. The tap's tests check that
each checksum matches the release's `SHA256SUMS.txt`, and that this file has a build attestation from
the tool's release workflow on `main`. To check a `box` download yourself, use the
`gh attestation verify` command in its [release notes](https://github.com/strands-agents/box/releases).

## Troubleshooting

| Problem | What to do |
| --- | --- |
| `Refusing to load cask strands-agents/tap/<package> from untrusted tap` | Install by the full name, or trust the package as shown in [Install by short name](#install-by-short-name). |
| Anything else about a package | See its guide in [Packages](#packages). |

Report problems with installing or upgrading in this repository's
[issues](https://github.com/strands-agents/homebrew-tap/issues). Report problems with a tool itself in
that tool's own repository.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how the casks are tested and updated.

## Security

See [SECURITY.md](SECURITY.md) to report a security issue. Please don't open a public issue.

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE).
