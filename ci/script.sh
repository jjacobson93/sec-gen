#!/usr/bin/env bash

set -ex

main() {
  install_standard_crates
  configure_cargo
  build_cargo_project
}

install_standard_crates() {
  INSTALLED=$(rustup target list | grep -e "$TARGET\s*(\(installed\|default\))" || true)
  if [ -z "$INSTALLED" ]; then
    rustup target add $TARGET
  else
    echo "$TARGET already installed."
  fi
}

configure_cargo() {
  local prefix

  case "$TARGET" in
    aarch64-unknown-linux-gnu)
      prefix=aarch64-linux-gnu
      ;;
    arm*-unknown-linux-gnueabihf)
      prefix=arm-linux-gnueabihf
      ;;
    arm-unknown-linux-gnueabi)
      prefix=arm-linux-gnueabi
      ;;
    mipsel-unknown-linux-musl)
      prefix=mipsel-openwrt-linux
      ;;
    x86_64-pc-windows-gnu)
      prefix=x86_64-w64-mingw32
      ;;
    x86_64-apple-darwin)
      prefix=x86_64-apple-darwin15
      ;;
    *)
      return
      ;;
  esac

  mkdir -p ~/.cargo

  cat >>~/.cargo/config <<EOF
[target.$TARGET]
linker = "$prefix-gcc"
ar = "$prefix-ar"
EOF
}

build_cargo_project() {
  cargo build --release --target $TARGET
  mv target/$TARGET/release/sec-gen binaries/sec-gen-$TARGET
  md5sum binaries/sec-gen-$TARGET > binaries/sec-gen-$TARGET.md5
  sha256sum binaries/sec-gen-$TARGET > binaries/sec-gen-$TARGET.sha256
}

main
