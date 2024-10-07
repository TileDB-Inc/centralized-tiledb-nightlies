#!/bin/bash
set -eu

# usage: source scripts/bootstrap-linux.sh YYYY-MM-DD
#
# defaults to current date
#
# Warning: modifies LD_LIBRARY_PATH and PKG_CONFIG_PATH

the_date=${1-$(date +%Y-%m-%d)}
echo "Bootstrapping nightlies from $the_date"

mkdir -p "/tmp/nightly-tiledb-$the_date/downloads"
mkdir -p "/tmp/nightly-tiledb-$the_date/install-libtiledb"
mkdir -p "/tmp/nightly-tiledb-$the_date/install-libtiledbvcf"
mkdir -p "/tmp/nightly-tiledb-$the_date/install-libtiledbsoma"

wget --quiet -O "/tmp/nightly-tiledb-$the_date/downloads/libtiledb-$the_date.tar.gz" \
  https://github.com/TileDB-Inc/centralized-tiledb-nightlies/releases/download/$the_date/libtiledb-$the_date.tar.gz
wget --quiet -O "/tmp/nightly-tiledb-$the_date/downloads/libtiledbvcf-$the_date.tar.gz" \
  https://github.com/TileDB-Inc/centralized-tiledb-nightlies/releases/download/$the_date/libtiledbvcf-$the_date.tar.gz
wget --quiet -O "/tmp/nightly-tiledb-$the_date/downloads/libtiledbsoma-$the_date.tar.gz" \
  https://github.com/TileDB-Inc/centralized-tiledb-nightlies/releases/download/$the_date/libtiledbsoma-$the_date.tar.gz

tar -C "/tmp/nightly-tiledb-$the_date/install-libtiledb" \
  -xzf "/tmp/nightly-tiledb-$the_date/downloads/libtiledb-$the_date.tar.gz"
tar -C "/tmp/nightly-tiledb-$the_date/install-libtiledbvcf" \
  -xzf "/tmp/nightly-tiledb-$the_date/downloads/libtiledbvcf-$the_date.tar.gz"
tar -C "/tmp/nightly-tiledb-$the_date/install-libtiledbsoma" \
  -xzf "/tmp/nightly-tiledb-$the_date/downloads/libtiledbsoma-$the_date.tar.gz"

export LD_LIBRARY_PATH="/tmp/nightly-tiledb-$the_date/install-libtiledb/lib:${LD_LIBRARY_PATH-}"
export LD_LIBRARY_PATH="/tmp/nightly-tiledb-$the_date/install-libtiledbvcf/lib:${LD_LIBRARY_PATH-}"
export LD_LIBRARY_PATH="/tmp/nightly-tiledb-$the_date/install-libtiledbsoma/lib:${LD_LIBRARY_PATH-}"
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

ldd /tmp/nightly-tiledb-$the_date/install-libtiledb/lib/libtiledb.so
ldd /tmp/nightly-tiledb-$the_date/install-libtiledbvcf/lib/libtiledbvcf.so
ldd /tmp/nightly-tiledb-$the_date/install-libtiledbsoma/lib/libtiledbsoma.so

export PKG_CONFIG_PATH="/tmp/nightly-tiledb-$the_date/install-libtiledb/lib/pkgconfig:${PKG_CONFIG_PATH-}"
export PKG_CONFIG_PATH="/tmp/nightly-tiledb-$the_date/install-libtiledbvcf/lib/pkgconfig:${PKG_CONFIG_PATH-}"
export PKG_CONFIG_PATH="/tmp/nightly-tiledb-$the_date/install-libtiledbsoma/lib/pkgconfig:${PKG_CONFIG_PATH-}"
echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH"

pkg-config --libs tiledb
# tiledbvcf doesn't export a tiledbvcf.pc file
#pkg-config --libs tiledbvcf
pkg-config --libs tiledbsoma

export PATH="/tmp/nightly-tiledb-$the_date/install-libtiledbvcf/bin:${PATH-}"
export PATH="/tmp/nightly-tiledb-$the_date/install-libtiledbsoma/bin:${PATH-}"
echo "PATH=$PATH"

chmod +x /tmp/nightly-tiledb-$the_date/install-libtiledbvcf/bin/tiledbvcf
chmod +x /tmp/nightly-tiledb-$the_date/install-libtiledbsoma/bin/tdbsoma

tiledbvcf version
tdbsoma
