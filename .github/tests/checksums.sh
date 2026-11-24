#!/bin/bash
# Checks that every download in a cask has the checksum its release lists in SHA256SUMS.txt.
# A bump hashes whatever it downloads, so this ties the cask back to what the release published.
# Each SHA256SUMS.txt must also carry a build attestation from the release workflow on main, so it
# needs gh, signed in or with GH_TOKEN set.
#
# It reads the cask as Homebrew evaluates it on this machine, for every OS and architecture. That
# covers declarative casks, like the ones in this tap. A cask that branches on something else, such
# as an environment variable, can show this check a different download than a user gets.
#
# It runs on the bash 3.2 that macOS ships.
set -euo pipefail

fail() {
    echo "error: $*" >&2
    exit 1
}

# With no arguments, check every cask in the tap.
if [ "$#" -eq 0 ]; then
    casks=()
    while IFS= read -r token; do
        casks+=("$token")
    done < <(brew tap-info --json strands-agents/tap | jq -r '.[0].cask_tokens[]')
    [ "${#casks[@]}" -gt 0 ] || fail "strands-agents/tap has no casks"
    set -- "${casks[@]}"
fi

# Each part of the path must be one plain segment. A `.` or `..` segment, or a percent-escape,
# could point the download, and its SHA256SUMS.txt, at another owner's release.
release_url='^https://github\.com/strands-agents/([A-Za-z0-9_.-]+)/releases/download/([^/?#%]+)/([^/?#%]+)$'

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

for cask in "$@"; do
    # The base entry is this runner's platform; each variation adds another platform's download.
    brew info --cask --json=v2 --variations "$cask" | jq -r '
        .casks[0] as $cask
        # Homebrew lists the downloads of language blocks apart from the variations, so refuse them.
        | if [$cask | .. | objects | select((.language_variations // []) | length > 0)] | length > 0
          then error("\($cask.full_token): language blocks are not supported") else . end
        # A variation lists only the fields that differ, so the rest comes from the base entry.
        # Homebrew does not download on a platform that has no sha256, so those are left out.
        | [$cask, ($cask.variations // {})[]]
        | map({url: (.url // $cask.url), sha256: (if has("sha256") then .sha256 else $cask.sha256 end)})
        | map(select(.sha256 != null))
        | unique[]
        | "\(.url) \(.sha256)"
    ' > "$work/downloads"
    [ -s "$work/downloads" ] || fail "$cask has no downloads"

    while read -r url sha256; do
        [[ "$url" =~ $release_url ]] ||
            fail "$cask downloads from outside a strands-agents GitHub release: $url"
        for part in "${BASH_REMATCH[@]:1}"; do
            case "$part" in
                . | ..) fail "$cask downloads from outside a strands-agents GitHub release: $url" ;;
            esac
        done
        asset=${url##*/}
        sums="$work/$(printf '%s' "${url%/*}" | tr -c 'A-Za-z0-9' _)"
        if [ ! -f "$sums" ]; then
            curl -fsSL --retry 3 "${url%/*}/SHA256SUMS.txt" -o "$sums.download" ||
                fail "cannot download SHA256SUMS.txt for $url"
            # SHA256SUMS.txt must carry an attestation from the repository's release workflow on
            # main, so a checksum file that workflow didn't publish can't vouch for a download.
            repo=${BASH_REMATCH[1]}
            case "$repo" in
                box) workflow=deploy-box-artifact.yml ;;
                *) fail "no release workflow is known for strands-agents/$repo" ;;
            esac
            gh attestation verify "$sums.download" --repo "strands-agents/$repo" \
                --signer-workflow "strands-agents/$repo/.github/workflows/$workflow" \
                --source-ref refs/heads/main > /dev/null ||
                fail "SHA256SUMS.txt for $url has no attestation from strands-agents/$repo's $workflow on main"
            mv "$sums.download" "$sums"
            echo "SHA256SUMS.txt for ${url%/*} is attested"
        fi
        expected=$(awk -v asset="$asset" '$2 == asset || $2 == "*" asset { print $1 }' "$sums")
        [ -n "$expected" ] || fail "SHA256SUMS.txt lists no $asset"
        [ "$(wc -l <<< "$expected")" -eq 1 ] || fail "SHA256SUMS.txt lists $asset more than once"
        [ "$expected" = "$sha256" ] || fail "$asset: the cask has $sha256, the release lists $expected"
        echo "$asset $sha256 matches"
    done < "$work/downloads"
done
