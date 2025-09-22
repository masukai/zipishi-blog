#!/usr/bin/env bash
set -euo pipefail

require_root() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    echo "このスクリプトは root 権限で実行してください。" >&2
    exit 1
  fi
}

ensure_debian_like() {
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "apt-get が利用できる Debian/Ubuntu 系ディストリビューションでの実行を想定しています。" >&2
    exit 1
  fi
}

install_apt_dependencies() {
  local packages=()

  command -v curl >/dev/null 2>&1 || packages+=("curl")
  command -v unzip >/dev/null 2>&1 || packages+=("unzip")

  if ((${#packages[@]} > 0)); then
    echo "必要な APT パッケージをインストールします: ${packages[*]}"
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y "${packages[@]}"
  fi
}

TMP_DIRS=()
cleanup() {
  local dir
  for dir in "${TMP_DIRS[@]}"; do
    rm -rf "$dir"
  done
}
trap cleanup EXIT

install_hugo() {
  local version="0.124.1"
  local archive="hugo_extended_${version}_Linux-64bit.tar.gz"
  local url="https://github.com/gohugoio/hugo/releases/download/v${version}/${archive}"
  local current=""

  if command -v hugo >/dev/null 2>&1; then
    current=$(hugo version 2>/dev/null | sed -nE 's/^hugo v([0-9.]+).*/\1/p')
  fi

  if [[ "$current" == "$version" ]]; then
    echo "Hugo ${version} は既にインストール済みです。"
    return
  fi

  if [[ -n "$current" ]]; then
    echo "Hugo ${current} を ${version} に更新します。"
  else
    echo "Hugo ${version} をインストールします。"
  fi

  local tmpdir
  tmpdir=$(mktemp -d)
  TMP_DIRS+=("$tmpdir")

  (
    cd "$tmpdir"
    curl -fsSLO "$url"
    tar -xzf "$archive" hugo
    install -m 0755 hugo /usr/local/bin/hugo
  )
}

install_terraform() {
  local version="1.6.6"
  local archive="terraform_${version}_linux_amd64.zip"
  local url="https://releases.hashicorp.com/terraform/${version}/${archive}"
  local current=""

  if command -v terraform >/dev/null 2>&1; then
    current=$(terraform version 2>/dev/null | sed -nE 's/^Terraform v([0-9.]+).*/\1/p')
  fi

  if [[ "$current" == "$version" ]]; then
    echo "Terraform ${version} は既にインストール済みです。"
    return
  fi

  if [[ -n "$current" ]]; then
    echo "Terraform ${current} を ${version} に更新します。"
  else
    echo "Terraform ${version} をインストールします。"
  fi

  local tmpdir
  tmpdir=$(mktemp -d)
  TMP_DIRS+=("$tmpdir")

  (
    cd "$tmpdir"
    curl -fsSLO "$url"
    unzip -o "$archive"
    install -m 0755 terraform /usr/local/bin/terraform
  )
}

main() {
  require_root
  ensure_debian_like
  install_apt_dependencies
  install_hugo
  install_terraform
  echo "セットアップが完了しました。"
}

main "$@"
