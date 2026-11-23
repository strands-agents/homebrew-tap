# Security Policy

## Scope

This repository holds Homebrew casks and the workflows that test and update them. A security issue
here includes:

- A cask that downloads from a source other than the tool's official GitHub releases
- A checksum that doesn't match the release's published `SHA256SUMS.txt`
- A cask or workflow that changes, re-signs or replaces a release package
- A workflow that exposes a token or lets an untrusted pull request write to the repository

Security issues in a tool itself, such as a way out of a Strands Box sandbox, belong to that tool. See
the [Strands Box security policy](https://github.com/strands-agents/box/blob/main/SECURITY.md).

## Reporting Security Issues

Amazon Web Services (AWS) is dedicated to the responsible disclosure of security vulnerabilities.

We kindly ask that you **do not** open a public GitHub issue to report security concerns.

Instead, please submit the issue to the AWS Vulnerability Disclosure Program via [HackerOne](https://hackerone.com/aws_vdp) or send your report via [email](mailto:aws-security@amazon.com).

For more details, visit the [AWS Vulnerability Reporting Page](http://aws.amazon.com/security/vulnerability-reporting/).

Thank you in advance for collaborating with us to help protect our customers.
