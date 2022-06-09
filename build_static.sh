#!/bin/bash
# based on the solution by Florian Dejonckheere <florian@floriandejonckheere.be>
# at https://github.com/JBBgameich/rsync-static

mkdir toolchain
echo "I: Downloading prebuilt toolchain"
wget --continue https://skarnet.org/toolchains/native/x86_64-linux-musl_pc-11.3.0.tar.xz -O /tmp/x86_64-linux-musl_pc.tar.xz|| echo "Failed to find x86_64-linux-musl_pc-11.3.0.tar.xz. Please open your browser at https://skarnet.org/toolchains/native and find the correct file to fix this"
tar -xf /tmp/x86_64-linux-musl_pc.tar.xz -C toolchain

echo "Native compiler is called gcc"
TOOLCHAIN_PATH="$(readlink -f $(dirname $(find . -name "gcc"))/..)"
echo "Use local gcc instead of the OS installed one"
export PATH=$TOOLCHAIN_PATH/bin:$PATH

echo "Get rsync source"
git clone https://github.com/WayneD/rsync.git

echo "Build rsync"
cd rsync/
make clean
export CC="gcc"
echo "Disable openssl xxhash zstd and lz4 as they did not configure even after consulting the INSTALL"
./configure CFLAGS="-static" --host="x86" --disable-openssl --disable-xxhash --disable-zstd --disable-lz4
make
strip rsync
