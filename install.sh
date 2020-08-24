#!/usr/bin/env bash
#
# Based on https://github.com/codota/TabNine/blob/master/dl_binaries.sh
# Download latest TabNine binaries

set -o errexit
set -o pipefail
set -x

rm TabNine || true # remove old link

version=$(curl -sS https://update.tabnine.com/version)
case $(uname -s) in
"Darwin")
    platform="apple-darwin"
    ;;
"Linux")
    platform="unknown-linux-gnu"
    ;;
esac
triple="$(uname -m)-$platform"

cd $(dirname $0)
path=$version/$triple/TabNine
if [[ -f "binaries/$path" ]] && [[ -e "binaries/TabNine_$(uname -s)" ]]; then
    exit
fi
echo Downloading version $version
curl https://update.tabnine.com/$path --create-dirs -o binaries/$path
chmod +x binaries/$path

ln -sf $path "binaries/TabNine_$(uname -s)"
