#!/bin/sh
#
# libbitcoin version 2 Ubuntu packaging script
# Tested on Ubuntu 16.04
#

export SIGN_KEYID="" # Empty will leave packages unsigned
export RELEASE_NAME="ubuntu_xenial"
export OUTPUT_DIR=$PWD/packages/$RELEASE_NAME
export PACKAGES_DIR=$PWD/src/$RELEASE_NAME
cd $PACKAGES_DIR

apt-get install -y libtool autoconf make pkg-config libtool-bin devscripts dh-autoreconf git quilt libsodium18 libgmp-dev libboost1.58-all-dev libsodium-dev libczmq-dev libczmq3

git submodule init
git submodule update

sudo dpkg -i $PACKAGES_DIR/libczmq*deb
cd $PACKAGES_DIR/czmqpp
dpkg-buildpackage -rfakeroot

cd $PACKAGES_DIR/secp256k1
dpkg-buildpackage -rfakeroot -j4

sudo dpkg -i $PACKAGES_DIR/libsecp256k1*deb
cd $PACKAGES_DIR/libbitcoin-consensus
dpkg-buildpackage -rfakeroot -j4

cd $PACKAGES_DIR/libbitcoin
dpkg-buildpackage -rfakeroot -j4

sudo dpkg -i $PACKAGES_DIR/libbitcoin*deb
sudo dpkg -i $PACKAGES_DIR/libbitcoin-consensus*deb
cd $PACKAGES_DIR/libbitcoin-blockchain
dpkg-buildpackage -rfakeroot -j4

sudo dpkg -i $PACKAGES_DIR/libczmqpp*deb 
cd $PACKAGES_DIR/libbitcoin-client
dpkg-buildpackage -rfakeroot -j4

sudo dpkg -i $PACKAGES_DIR/libbitcoin-client*deb
cd $PACKAGES_DIR/libbitcoin-explorer
dpkg-buildpackage -rfakeroot -j4

sudo dpkg -i $PACKAGES_DIR/libbitcoin-blockchain*deb
cd $PACKAGES_DIR/libbitcoin-node
dpkg-buildpackage -rfakeroot -j4

sudo dpkg -i $PACKAGES_DIR/libbitcoin-node*deb
cd $PACKAGES_DIR/libbitcoin-server
dpkg-buildpackage -rfakeroot -j4

sudo dpkg -i $PACKAGES_DIR/libbitcoin-server*deb

cd $PACKAGES_DIR
mkdir -p $OUTPUT_DIR
mv *.deb *.xz *.dsc *.changes $OUTPUT_DIR

if ! [ "x$SIGN_KEYID" = "x" ]; then
    debsign *.changes -k$SIGN_KEYID
fi
