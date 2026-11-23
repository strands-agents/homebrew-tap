# Contributing to the Strands Homebrew Tap

Thank you for your interest in contributing. Whether it's a bug report, a fix or a new package, we
value feedback and contributions from the community.

Please read this document before you open an issue or a pull request.

## What belongs here

This tap holds the Homebrew recipes for Strands tools. A recipe installs the release package that
the tool's own repository publishes. It doesn't build or change it.

- Problems with installing, upgrading or uninstalling through Homebrew belong in this repository.
- Problems with a tool itself belong in that tool's repository, such as
  [strands-agents/box](https://github.com/strands-agents/box/issues).

## How releases reach the tap

The [Bump casks](.github/workflows/autobump.yml) workflow runs every few hours. It uses
[`brew livecheck`](https://docs.brew.sh/Brew-Livecheck) to find each tool's newest stable GitHub
release, and opens a pull request that updates the cask's version and checksums. The
[Tests](.github/workflows/tests.yml) workflow then installs that release on every supported platform.
A maintainer merges the pull request when the tests pass.

You don't need to open a pull request for a new release yourself.

## Make a change

Homebrew works on a tap in its own checkout. Tap this repository, then work in that checkout:

```sh
brew tap strands-agents/tap
cd "$(brew --repository strands-agents/tap)"
git checkout -b my-change
```

Check your change with Homebrew's own linters:

```sh
brew style --fix strands-agents/tap
brew audit --strict --online --tap=strands-agents/tap
```

Then install your version and run its test:

```sh
brew install --cask strands-agents/tap/box
.github/tests/box.sh
```

The test script checks the installed cask's files and, on macOS, its signatures. Then it starts a
box that may write in its project and checks that a write outside the project fails. It works in a
temporary home folder, so it leaves your `~/.strands/box` alone. On Linux, it needs unprivileged
user namespaces.

Follow Homebrew's [Cask Cookbook](https://docs.brew.sh/Cask-Cookbook) for the recipe format. Keep a
cask's `url` on the tool's own GitHub releases, and take its checksums from the release's
`SHA256SUMS.txt`.

## Add a package

A new package needs:

1. A recipe in `Casks/` (prebuilt, signed release packages) or `Formula/` (Homebrew builds it).
2. A test script in `.github/tests/` that installs it and checks that it runs.
3. A job in [`tests.yml`](.github/workflows/tests.yml) that runs that script on every platform the
   recipe supports.
4. Its name in [`autobump.yml`](.github/workflows/autobump.yml).
5. A row in the package table in the [README](README.md).

Please open an issue first to discuss a new package.

## Pull requests

Before you send a pull request, please make sure that:

1. You are working against the latest `main` branch.
2. You checked open and recently merged pull requests to make sure someone else hasn't addressed
   the problem already.
3. You opened an issue to discuss any significant work.

To send a pull request:

1. Fork the repository.
2. Make a focused change. Please don't reformat unrelated files.
3. Run the linters and the test script.
4. Commit with a clear message, and open a pull request.
5. Watch the checks on your pull request, and respond to review feedback.

GitHub provides more documentation on [forking a repository](https://help.github.com/articles/fork-a-repo/)
and [creating a pull request](https://help.github.com/articles/creating-a-pull-request/).

## Using AI tools

We accept contributions written with AI tools. Please read the
[Strands AI usage policy](https://github.com/strands-agents/harness-sdk/blob/main/team/AI_USAGE_POLICY.md)
first. You own every line you submit, and you should be able to explain why it works.

## Code of Conduct

This project has adopted the [Amazon Open Source Code of Conduct](https://aws.github.io/code-of-conduct).
For more information see the [Code of Conduct FAQ](https://aws.github.io/code-of-conduct-faq) or contact
opensource-codeofconduct@amazon.com with any additional questions or comments.

## Security issue notifications

If you discover a potential security issue in this project, we ask that you notify AWS/Amazon Security
via our [vulnerability reporting page](http://aws.amazon.com/security/vulnerability-reporting/). Please
do **not** create a public GitHub issue.

## Licensing

See the [LICENSE](LICENSE) file for our project's licensing. We will ask you to confirm the licensing of
your contribution.
