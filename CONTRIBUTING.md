# Contributing to the Strands Homebrew Tap

Thank you for your interest in contributing. Please read this document before you open an issue or a
pull request.

## What belongs here

This tap holds the Homebrew casks for Strands command-line tools. A cask installs the release
package that the tool's own repository publishes, unchanged. It doesn't build or change it.

- Problems with installing, upgrading or uninstalling through Homebrew belong in this repository.
- Problems with a tool itself belong in that tool's repository, such as
  [strands-agents/box](https://github.com/strands-agents/box/issues).

## How releases reach the tap

The [Bump casks](.github/workflows/autobump.yml) workflow runs every few hours. It uses
[`brew livecheck`](https://docs.brew.sh/Brew-Livecheck) to find each tool's newest stable GitHub
release, and opens a pull request that updates the cask's version and checksums. The
[Tests](.github/workflows/tests.yml) workflow then checks the checksums against the release's
`SHA256SUMS.txt` and installs the release on every supported platform. A maintainer merges the pull
request once the `CI Gate` check passes.

You don't need to open a pull request for a new release yourself.

## Make a change

Homebrew works on a tap in its own checkout. Tap this repository, trust it, then work in that
checkout:

```sh
brew tap strands-agents/tap
brew trust strands-agents/tap
cd "$(brew --repository strands-agents/tap)"
git checkout -b my-change
```

Check your change with Homebrew's own linters, and check the checksums against the release:

```sh
brew style --fix strands-agents/tap
brew audit --strict --online --os=all --arch=all --tap=strands-agents/tap
.github/tests/checksums.sh strands-agents/tap/box
```

`--os=all --arch=all` matters: without it, `brew audit` on Linux skips any cask that has
`depends_on macos`.

Then install your version and run its test. Use `reinstall`, so that a `box` you already have is
replaced by your version:

```sh
brew reinstall --cask strands-agents/tap/box
.github/tests/box.sh
```

The test script checks the installed cask's signatures on macOS, then its files. Then it starts a
box that may write in its project and checks that a write outside the project fails. It works in a
temporary folder in your home folder and deletes it at the end, so it leaves your `~/.strands/box`
alone. On Linux, it needs unprivileged user namespaces.

Follow Homebrew's [Cask Cookbook](https://docs.brew.sh/Cask-Cookbook) for the cask format. Keep a
cask's `url` on the tool's own GitHub releases, and take its checksums from the release's
`SHA256SUMS.txt`.

## Add a package

A new package needs:

1. A cask in `Casks/` for prebuilt release packages, or a formula in `Formula/` that Homebrew
   builds.
2. A test script in `.github/tests/` that checks the installed package and that it runs.
3. A job in [`tests.yml`](.github/workflows/tests.yml) that runs that script on every platform the
   package supports, listed in the `CI Gate` job's `needs`.
4. Its name in [`autobump.yml`](.github/workflows/autobump.yml) and in the checksum step.
5. A row in the package table in the [README](README.md).

Please [request the package](https://github.com/strands-agents/homebrew-tap/issues/new?template=package_request.yml)
before you start.

## Pull requests

1. Work from the latest `main` branch, and check that no open pull request already makes the change.
2. Make a focused change. Please don't reformat unrelated files.
3. Run the linters, the checksum check and the test script.
4. Open a pull request, and respond to review feedback.

## Using AI tools

We accept contributions written with AI tools. Please read the
[Strands AI usage policy](https://github.com/strands-agents/harness-sdk/blob/main/team/AI_USAGE_POLICY.md)
first. You own every line you submit, and you should be able to explain why it works.

## Code of Conduct

This project has adopted the [Amazon Open Source Code of Conduct](CODE_OF_CONDUCT.md).

## Security

See [SECURITY.md](SECURITY.md). Please don't open a public issue for a security problem.

## Licensing

See the [LICENSE](LICENSE) file for this project's licensing. We will ask you to confirm the
licensing of your contribution.
