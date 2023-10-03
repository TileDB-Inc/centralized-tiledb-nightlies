#!/bin/bash
set -eu

# usage: source scripts/bootstrap-linux.sh YYYY-MM-DD
#
# defaults to current date
#
# Warning: modifies LD_LIBRARY_PATH

the_date=${1-$(date +%Y-%m-%d)}
echo "Bootstrapping nightlies from $the_date"

mkdir -p "/tmp/nightly-tiledb-$the_date/downloads"
mkdir -p "/tmp/nightly-tiledb-$the_date/install-libtiledb"
mkdir -p "/tmp/nightly-tiledb-$the_date/install-libtiledbvcf"
mkdir -p "/tmp/nightly-tiledb-$the_date/install-libtiledbsoma"

wget --quiet -O "/tmp/nightly-tiledb-$the_date/downloads/libtiledb-$the_date.tar.gz" \
  https://github.com/jdblischak/centralized-tiledb-nightlies/releases/download/$the_date/libtiledb-$the_date.tar.gz
wget --quiet -O "/tmp/nightly-tiledb-$the_date/downloads/libtiledbvcf-$the_date.tar.gz" \
  https://github.com/jdblischak/centralized-tiledb-nightlies/releases/download/$the_date/libtiledbvcf-$the_date.tar.gz
wget --quiet -O "/tmp/nightly-tiledb-$the_date/downloads/libtiledbsoma-$the_date.tar.gz" \
  https://github.com/jdblischak/centralized-tiledb-nightlies/releases/download/$the_date/libtiledbsoma-$the_date.tar.gz

tar -C "/tmp/nightly-tiledb-$the_date/install-libtiledb" \
  -xzf "/tmp/nightly-tiledb-$the_date/downloads/libtiledb-$the_date.tar.gz"
tar -C "/tmp/nightly-tiledb-$the_date/install-libtiledbvcf" \
  -xzf "/tmp/nightly-tiledb-$the_date/downloads/libtiledbvcf-$the_date.tar.gz"
tar -C "/tmp/nightly-tiledb-$the_date/install-libtiledbsoma" \
  -xzf "/tmp/nightly-tiledb-$the_date/downloads/libtiledbsoma-$the_date.tar.gz"

export LD_LIBRARY_PATH="/tmp/nightly-tiledb-$the_date/install-libtiledb/lib:${LD_LIBRARY_PATH-}"
export LD_LIBRARY_PATH="/tmp/nightly-tiledb-$the_date/install-libtiledbvcf/lib:${LD_LIBRARY_PATH-}"
export LD_LIBRARY_PATH="/tmp/nightly-tiledb-$the_date/install-libtiledbsoma/lib:${LD_LIBRARY_PATH-}"

ldd /tmp/nightly-tiledb-$the_date/install-libtiledb/lib/libtiledb.so
ldd /tmp/nightly-tiledb-$the_date/install-libtiledbvcf/lib/libtiledbvcf.so
ldd /tmp/nightly-tiledb-$the_date/install-libtiledbsoma/lib/libtiledbsoma.so

chmod +x /tmp/nightly-tiledb-$the_date/install-libtiledbvcf/bin/tiledbvcf

/tmp/nightly-tiledb-$the_date/install-libtiledbvcf/bin/tiledbvcf version
