#!/bin/bash
# Checks an installed box cask: its files, its signatures on macOS, and a real box run.
# It uses a temporary home folder, so it doesn't touch ~/.strands/box.
set -euo pipefail

cask=strands-agents/tap/box
here=$(cd "$(dirname "$0")" && pwd)

fail() {
    echo "error: $*" >&2
    exit 1
}

version=$(brew info --cask --json=v2 "$cask" | jq -r '.casks[0].installed // empty')
[ -n "$version" ] || fail "$cask is not installed"
room="$(brew --caskroom)/box/$version"
box="$(brew --prefix)/bin/box"

echo "==> Installed files"
ls -la "$box" "$room"
[ "$(readlink "$box")" = "$room/box" ] || fail "$box does not link to $room/box"
[ "$("$box" --version)" = "box $version" ] || fail "box --version does not print box $version"
for file in strands-box-sock-alias strands-box-contain-trampoline release.json resources/packs/base/pack.toml; do
    [ -e "$room/$file" ] || fail "missing $room/$file"
done
"$box" help agent | grep -F "$room/resources/packs" > /dev/null ||
    fail "box help agent does not name the packs in $room/resources"

if [ "$(uname -s)" = Darwin ]; then
    echo "==> Signatures"
    team=94KV3E626L
    for program in box strands-box-sock-alias strands-box-contain-trampoline; do
        codesign --verify --strict --verbose=2 "$room/$program"
        details=$(codesign --display --verbose=4 "$room/$program" 2>&1)
        grep -Fx "TeamIdentifier=$team" <<< "$details" > /dev/null ||
            fail "$program is not signed by team $team"
        grep -E '^Authority=Developer ID Application: ' <<< "$details" ||
            fail "$program has no Developer ID signature"
    done
    spctl --assess --type install --verbose "$room/box" 2>&1 | tee /dev/stderr |
        grep -Fx 'source=Notarized Developer ID' > /dev/null || fail "box is not notarized"
fi

echo "==> Box run"
home=$(mktemp -d)
trap 'rm -rf "$home"' EXIT
mkdir -p "$home/.strands/box/profiles" "$home/project"
cp -R "$here/box" "$home/.strands/box/profiles/probe"
cd "$home/project"
run() {
    env -i HOME="$home" PATH=/usr/bin:/bin DO_NOT_TRACK=1 "$box" "$@" < /dev/null
}

# A profile from a shipped starter reads the cask's packs and policies.
run profile create claude --with bedrock --policy open
[ -f "$home/.strands/box/profiles/claude/profile.toml" ] || fail "box profile create wrote no profile"

# The probe profile runs a shell, so the run needs no agent and no model key.
run run probe --no-banner -- -c 'echo inside > proof.txt'
[ "$(cat proof.txt)" = inside ] || fail "the box could not write in the project"

if run run probe --no-banner -- -c "echo outside > '$home/outside.txt'"; then
    fail "the box wrote outside the project"
fi
[ ! -e "$home/outside.txt" ] || fail "the box wrote outside the project"

echo "==> box $version passed"
