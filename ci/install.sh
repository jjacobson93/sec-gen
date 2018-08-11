#!/usr/bin/env sh

set -ex

main() {
  local current_os=
  if [ $TRAVIS_OS_NAME = linux ]; then
    current_os=x86_64-unknown-linux-musl
  else
    current_os=x86_64-apple-darwin
  fi

  # Builds for iOS are done on OSX, but require the specific target to be
  # installed.
  case $TARGET in
    aarch64-apple-ios)
      rustup target install aarch64-apple-ios
      ;;
    armv7-apple-ios)
      rustup target install armv7-apple-ios
      ;;
    armv7s-apple-ios)
      rustup target install armv7s-apple-ios
      ;;
    i386-apple-ios)
      rustup target install i386-apple-ios
      ;;
    x86_64-apple-ios)
      rustup target install x86_64-apple-ios
      ;;
  esac

  # Install cross
  url="https://github.com/rust-embedded/cross/releases/download/v0.1.14/cross-v0.1.14-${current_os}.tar.gz"
  td=$(mktemp -d || mktemp -d -t tmp)
  curl -sL $url | tar -C $td -xz
  mv "$td/cross" "$HOME/.cargo/bin/cross"
}

main
