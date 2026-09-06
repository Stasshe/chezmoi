#!/usr/bin/env bash
set -euo pipefail

# pwndbg ships in the distro repo, but its `di` (decompiler integration) command
# needs decomp2dbg, which no repository packages: the python client for gdb and a
# matching Ghidra extension. Both are installed here.
#
# The client lives in its own venv instead of the system site-packages; ~/.gdbinit
# puts it on the python path that gdb embeds.

d2d_version="3.14.0"
venv="$HOME/.local/share/pwndbg-d2d"
ghidra_root="/opt/ghidra"

# The venv must use the interpreter gdb embeds, since ~/.gdbinit adds it there.
python_version="$(gdb --nx --batch -ex 'python import sys; print("%d.%d" % sys.version_info[:2])')"

printf '[pwndbg] install decomp2dbg %s for python %s\n' "$d2d_version" "$python_version"
uv venv --clear --python "$python_version" "$venv"
uv pip install --python "$venv/bin/python" "decomp2dbg==$d2d_version"

if [[ ! -d $ghidra_root ]]; then
  printf '[pwndbg] ghidra not installed, skipping its extension\n'
  exit 0
fi

read_property() {
  sed -n "s/^$1=//p" "$ghidra_root/Ghidra/application.properties"
}

ghidra_version="$(read_property application.version)"
ghidra_release="$(read_property application.release.name)"
extensions="${XDG_CONFIG_HOME:-$HOME/.config}/ghidra/ghidra_${ghidra_version}_${ghidra_release}/Extensions"
archive="$(mktemp --suffix=-d2d-ghidra.zip)"
trap 'rm -f "$archive"' EXIT

printf '[pwndbg] install the decomp2dbg extension into ghidra %s\n' "$ghidra_version"
curl -fsSL -o "$archive" \
  "https://github.com/mahaloz/decomp2dbg/releases/download/v${d2d_version}/d2d-ghidra-plugin.zip"

rm -rf "${extensions:?}/d2d_ghidra"
mkdir -p "$extensions"
unzip -q "$archive" -d "$extensions"

# The release is built against an older Ghidra; without this the extension is
# reported as incompatible and never loaded.
sed -i "s/^version=.*/version=$ghidra_version/" "$extensions/d2d_ghidra/extension.properties"
