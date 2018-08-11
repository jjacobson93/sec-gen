#!/usr/bin/env sh

set -ex

if [ ! "$(command -v md5sum)" ]; then
  MD5=md5
else
  MD5=md5sum
fi

if [ ! "$(command -v sha256sum)" ]; then
  SHA256="shasum -a 256"
else
  SHA256=sha256sum
fi

main() {
  cross build --target $TARGET --release
  OUTPUT_FILE=target/$TARGET/release/sec-gen
  if [ "$TARGET" = 'x86_64-pc-windows-gnu' ]; then
    OUTPUT_FILE="$OUTPUT_FILE.exe"
  fi
  mv "$OUTPUT_FILE" binaries/sec-gen-$TARGET
  $MD5 binaries/sec-gen-$TARGET > binaries/sec-gen-$TARGET.md5
  $SHA256 binaries/sec-gen-$TARGET > binaries/sec-gen-$TARGET.sha256
}

main
