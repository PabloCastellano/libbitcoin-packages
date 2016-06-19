#!/bin/sh
#
# libbitcoin version 2 Debian packaging script
# Tested on Debian 8.5 (Jessie)
#

export SIGN_KEYID="" # Empty will leave packages unsigned
export RELEASE_NAME="debian_jessie"
export OUTPUT_DIR=$PWD/packages/$RELEASE_NAME
export PACKAGES_DIR=$PWD/src/$RELEASE_NAME
cd $PACKAGES_DIR

apt-get install sudo
sudo apt-get install -y libtool autoconf make pkg-config libtool-bin devscripts dh-autoreconf git quilt

sudo apt-get install -y libzmq3 libzmq3-dev  # czmq
sudo apt-get install -y libgmp-dev # secp256k1
sudo apt-get install -y libboost1.55-all-dev  # libbitcoin-consensus
sudo apt-get install -y libsodium-dev libsodium13 # libbitcoin-client, libbitcoin-server

git submodule init
git submodule update

cd $PACKAGES_DIR/czmq
dpkg-buildpackage -rfakeroot

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
