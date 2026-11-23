#!/bin/bash
# Checks that every download in a cask has the checksum its release lists in SHA256SUMS.txt.
# A bump hashes whatever it downloads, so this ties the cask back to what the release published.
set -euo pipefail

[ "$#" -gt 0 ] || set -- strands-agents/tap/box

fail() {
    echo "error: $*" >&2
    exit 1
}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

for cask in "$@"; do
    # The base entry is this runner's platform; each variation adds another platform's download.
    brew info --cask --json=v2 --variations "$cask" | jq -r '
        .casks[0] as $cask
        | ([{url: $cask.url, sha256: $cask.sha256}]
           + [($cask.variations // {})[] | select(.url and .sha256) | {url, sha256}])
        | unique[]
        | "\(.url) \(.sha256)"
    ' > "$work/downloads"
    [ -s "$work/downloads" ] || fail "$cask has no downloads"

    while read -r url sha256; do
        case "$url" in
            https://github.com/strands-agents/*/releases/download/*) ;;
            *) fail "$cask downloads from outside a strands-agents GitHub release: $url" ;;
        esac
        asset=${url##*/}
        sums="$work/$(printf '%s' "${url%/*}" | tr -c 'A-Za-z0-9' _)"
        [ -f "$sums" ] || curl -fsSL --retry 3 "${url%/*}/SHA256SUMS.txt" -o "$sums" ||
            fail "cannot download SHA256SUMS.txt for $url"
        expected=$(awk -v asset="$asset" '$2 == asset || $2 == "*" asset { print $1 }' "$sums")
        [ -n "$expected" ] || fail "SHA256SUMS.txt lists no $asset"
        [ "$(wc -l <<< "$expected")" -eq 1 ] || fail "SHA256SUMS.txt lists $asset more than once"
        [ "$expected" = "$sha256" ] || fail "$asset: the cask has $sha256, the release lists $expected"
        echo "$asset $sha256 matches"
    done < "$work/downloads"
done
