#!/usr/bin/env bash
# Based on https://github.com/codota/TabNine/blob/master/dl_binaries.sh
# Download latest TabNine binaries and install in /usr/local/bin/ 

set -o errexit
set -o pipefail
set -x

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
if [ -f binaries/$path ]; then
    exit
fi
echo Downloading version $version
curl https://update.tabnine.com/$path --create-dirs -o binaries/$path
chmod +x binaries/$path

ln -sf binaries/$path TabNine
