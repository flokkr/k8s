#!/usr/bin/env bash
set -e
CADIR=".state/ca"
mkdir -p $CADIR
if [ ! -f "$CADIR/ca.key" ]; then
  certstrap --depot-path $CADIR init --cn ca --passphrase "" 1>&2
fi
