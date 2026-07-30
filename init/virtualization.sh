#!/usr/bin/env bash
set -euo pipefail

if [[ ! -r /etc/os-release ]]; then
  exit 0
fi

. /etc/os-release

if [[ "$ID" != "arch" ]]; then
  exit 0
fi

if ! command -v virsh >/dev/null 2>&1; then
  printf '%s\n' "virsh is required. Run saya install first." >&2
  exit 1
fi

network=/etc/libvirt/qemu/networks/default.xml

sudo systemctl enable --now libvirtd.socket

if ! sudo virsh net-info default >/dev/null 2>&1; then
  sudo virsh net-define "$network"
fi

sudo virsh net-autostart default

if ! sudo virsh net-list --name | grep -qx default; then
  sudo virsh net-start default
fi
