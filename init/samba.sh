#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$root/smb.conf"

if [[ ! -d "$HOME/Documents" ]]; then
  printf 'Documents directory does not exist: %s\n' "$HOME/Documents" >&2
  exit 1
fi

if ! command -v saya >/dev/null 2>&1; then
  printf 'Saya is not installed.\n' >&2
  exit 1
fi

saya install

if [[ -e /etc/arch-release ]]; then
  service=smb.service
else
  service=smbd.service
fi

rendered="$(mktemp "$root/.smb.conf.XXXXXX")"
trap 'rm -f "$rendered"' EXIT
sed \
  -e "s|__HOME__|$HOME|g" \
  -e "s|__USER__|$USER|g" \
  "$config" >"$rendered"

testparm -s "$rendered" >/dev/null
sudo install -m 0644 "$rendered" /etc/samba/smb.conf
sudo systemctl enable "$service"
sudo systemctl restart "$service"

if command -v ufw >/dev/null 2>&1; then
  ufw_status="$(sudo ufw status)"
  if [[ "$ufw_status" == *"Status: active"* ]]; then
    sudo ufw allow Samba
  fi
fi

account_exists=false
while IFS=: read -r account _; do
  if [[ "$account" == "$USER" ]]; then
    account_exists=true
    break
  fi
done < <(sudo pdbedit -L)

if [[ "$account_exists" == false ]]; then
  sudo smbpasswd -a "$USER"
fi

read -r address _ < <(hostname -I)
printf 'Connect to smb://%s and select Documents.\n' "$address"
