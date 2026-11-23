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

| Package | Type | Description |
| --- | --- | --- |
| [`box`](Casks/box.rb) | Cask | [Strands Box](https://github.com/strands-agents/box): sandbox for running AI coding agents under a policy |

## Install Strands Box

```sh
brew install --cask strands-agents/tap/box
```

This adds the tap, trusts the `box` cask, and installs `box` into Homebrew's `bin` folder. Check
that it works:

```sh
box --version
```

Then [create a profile](https://github.com/strands-agents/box/blob/main/docs/cli/getting-started.md#2-create-a-claude-code-profile)
and run your first agent. Box is already installed, so skip that guide's install step.

`box` sends usage telemetry. To opt out, run `box telemetry off`.
[Usage telemetry](https://github.com/strands-agents/box/blob/main/CLI_TELEMETRY.md) says what it sends.

### Requirements

| Platform | Supported |
| --- | --- |
| macOS 15 or later on Apple silicon | Yes |
| Linux on ARM64 or x86-64, glibc 2.34 or later | Yes |
| Intel Macs | No |

On Linux, the box needs unprivileged user namespaces. Ubuntu 24.04 blocks them by default, so a box
won't start until AppArmor lets Box's `strands-box-contain-trampoline` create them. See
[Linux requirements](https://github.com/strands-agents/box/blob/main/docs/user/linux-requirements.md).

### Install by short name

Since Homebrew 6.0, Homebrew loads a third-party tap's code only after you trust it
([Tap Trust](https://docs.brew.sh/Tap-Trust)). The full name above trusts only the `box` cask. To use
the short name instead, trust the cask once:

```sh
brew tap strands-agents/tap
brew trust --cask strands-agents/tap/box
brew install --cask box
```

## Upgrade

```sh
brew update
brew upgrade --cask box
```

The cask follows Box's stable releases and skips pre-releases. A new release reaches the tap when its
bump pull request is merged.

## Uninstall

```sh
brew uninstall --cask box
```

This removes the `box` program and its release files. Your profiles, packs, storage and run records
stay in `~/.strands/box`. To remove them too, delete that folder.

To remove the tap:

```sh
brew untap strands-agents/tap
```

## Switch from the install script

Use one install method on a machine, so that `box` on your `PATH` is the one you upgrade. To switch
from the install script to Homebrew, install the cask first:

```sh
brew install --cask strands-agents/tap/box
```

Then remove what the install script added. The first command deletes the script's release files, and
the second deletes its link to them:

```sh
rm -rf ~/.strands/box/packages
rm ~/.local/bin/box
```

Your profiles in `~/.strands/box` keep working. If the script also added a `# >>> Box PATH >>>` block
to your shell's startup file, [Uninstall](https://github.com/strands-agents/box/blob/main/docs/cli/install.md#uninstall)
says how to remove it. Check that your shell finds Homebrew's `box`:

```sh
which -a box
```

## Verify the install

Homebrew checks each download against the SHA-256 checksum in the cask. Those checksums match the
release's `SHA256SUMS.txt`.

On macOS, the release is signed with the publisher's Developer ID and notarized by Apple. The cask
keeps both:

```sh
codesign --verify --strict --verbose=2 "$(brew --caskroom)/box/$(box --version | cut -d' ' -f2)/box"
spctl --assess --type install --verbose "$(brew --caskroom)/box/$(box --version | cut -d' ' -f2)/box"
```

`spctl` prints `source=Notarized Developer ID`. The Linux packages aren't signed.

## Troubleshooting

| Problem | What to do |
| --- | --- |
| `Refusing to load cask strands-agents/tap/box from untrusted tap` | Install by the full name, `strands-agents/tap/box`, or trust the cask as shown in [Install by short name](#install-by-short-name). |
| `box --version` shows an older release | Another `box` comes first on your `PATH`. Run `which -a box`, and see [Switch from the install script](#switch-from-the-install-script). |
| Homebrew refuses the cask on a Mac | Box needs Apple silicon and macOS 15 or later. |
| A box fails to start on Linux | See [Linux requirements](https://github.com/strands-agents/box/blob/main/docs/user/linux-requirements.md) and [Troubleshooting](https://github.com/strands-agents/box/blob/main/docs/cli/troubleshooting.md). |

Report problems with installing or upgrading in this repository's
[issues](https://github.com/strands-agents/homebrew-tap/issues). Report problems with Box itself in
[strands-agents/box](https://github.com/strands-agents/box/issues).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how the casks are tested and updated.

## Security

See [SECURITY.md](SECURITY.md) to report a security issue. Please don't open a public issue.

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE).
