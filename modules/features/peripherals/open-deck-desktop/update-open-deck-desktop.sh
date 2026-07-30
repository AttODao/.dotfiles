set -euo pipefail

app_dir="$HOME/.local/share/appimages"
latest_link="$app_dir/Open-Deck.AppImage"
api_url="https://api.github.com/repos/kawa-nobu/Open-Deck-Desktop/releases/latest"

mkdir -p "$app_dir"

curl_args=(
  --fail
  --silent
  --show-error
  --location
  --header "Accept: application/vnd.github+json"
  --header "User-Agent: open-deck-desktop-updater"
)
github_token="${GITHUB_TOKEN:-${GH_TOKEN:-}}"
if [[ -n "$github_token" ]]; then
  curl_args+=(--header "Authorization: Bearer $github_token")
fi

if ! release_json="$(curl "${curl_args[@]}" "$api_url")"; then
  echo "warning: could not check Open-Deck Desktop latest release" >&2
  exit 0
fi

version="$(jq -r '(.tag_name // "") | sub("^v"; "")' <<<"$release_json")"
asset="$(
  jq -c 'first(.assets[] | select(.name | test("linux-x86_64\\.AppImage$"))) // empty' \
    <<<"$release_json"
)"
asset_url="$(jq -r '.browser_download_url // empty' <<<"$asset")"
digest="$(jq -r '.digest // empty' <<<"$asset")"

if [[ -z "$version" || -z "$asset_url" ]]; then
  echo "warning: Open-Deck Desktop x86_64 AppImage was not found in latest release" >&2
  exit 0
fi

target="$app_dir/Open-Deck-$version.AppImage"

if [[ ! -f "$target" ]]; then
  tmp="$(mktemp "$app_dir/.Open-Deck-$version.XXXXXX.AppImage")"
  trap 'rm -f "$tmp"' EXIT
  curl "${curl_args[@]}" "$asset_url" --output "$tmp"

  if [[ "$digest" == sha256:* ]]; then
    expected="${digest#sha256:}"
    actual="$(sha256sum "$tmp" | cut -d' ' -f1)"
    if [[ "$actual" != "$expected" ]]; then
      echo "Open-Deck Desktop checksum mismatch for v$version" >&2
      exit 1
    fi
  fi

  chmod +x "$tmp"
  mv "$tmp" "$target"
  trap - EXIT
fi

ln -sfn "$target" "$latest_link"

echo "Open-Deck Desktop is ready: v$version"
