#!/usr/bin/env bash
set -euo pipefail

if [[ ! -r /etc/os-release ]]; then
  exit 0
fi

. /etc/os-release

if [[ "$ID" != "arch" ]]; then
  exit 0
fi

for command in bsdtar sha256sum virsh wget; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf '%s\n' "$command is required. Run saya install first." >&2
    exit 1
  fi
done

network=/etc/libvirt/qemu/networks/default.xml
kali_version=2026.2
kali_name="kali-linux-$kali_version-qemu-amd64"
kali_archive="$HOME/Downloads/$kali_name.7z"
kali_image_dir="/var/lib/libvirt/images/$kali_name"
kali_sha256=c7c35588d05277c482c908bf7a136d348f76ffa68700b04ff53c0b217e6bd071
kali_url="https://kali.download/base-images/kali-$kali_version/$kali_name.7z"
kali_marker="$kali_image_dir/.source-sha256"

sudo systemctl enable --now libvirtd.socket

if ! sudo virsh net-info default >/dev/null 2>&1; then
  sudo virsh net-define "$network"
fi

sudo virsh net-autostart default

if ! sudo virsh net-list --name | grep -qx default; then
  sudo virsh net-start default
fi

mkdir -p "$HOME/Downloads"

if ! printf '%s  %s\n' "$kali_sha256" "$kali_archive" | sha256sum --check --status; then
  download="$kali_archive.part"
  wget --progress=bar:force:noscroll --output-document="$download" "$kali_url"
  printf '%s  %s\n' "$kali_sha256" "$download" | sha256sum --check
  mv -- "$download" "$kali_archive"
fi

if [[ "$(sudo cat "$kali_marker" 2>/dev/null || true)" != "$kali_sha256" ]]; then
  sudo install -d -m 0750 -o libvirt-qemu -g libvirt-qemu "$kali_image_dir"

  if sudo find "$kali_image_dir" -mindepth 1 -print -quit | grep -q .; then
    printf 'Refusing to overwrite unverified image files in %s\n' "$kali_image_dir" >&2
    exit 1
  fi

  sudo bsdtar --extract --file "$kali_archive" --directory "$kali_image_dir"
  printf '%s\n' "$kali_sha256" | sudo tee "$kali_marker" >/dev/null
  sudo chown -R -- libvirt-qemu:libvirt-qemu "$kali_image_dir"
fi

printf 'Kali QEMU image is ready in %s\n' "$kali_image_dir"
