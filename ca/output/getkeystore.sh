#!/usr/bin/env bash
set -ex
STATEDIR=".state/keystore"
mkdir -p "$STATEDIR"
CADIR=".state/ca"
DESCRIPTOR="$1"
NAME=$(basename $1)
STATEFILE="$STATEDIR/$NAME"
if [ ! -f "$STATEFILE" ]; then
   source "$DESCRIPTOR"
   if [ ! -f "$CADIR/$PRIMARY_DOMAIN.key" ]; then
     certstrap --depot-path "$CADIR" request-cert --passphrase "" --domain $PRIMARY_DOMAIN,$OTHER_DOMAINS 1>&2
     certstrap --depot-path "$CADIR" sign --CA ca $PRIMARY_DOMAIN 1>&2
   fi
   openssl pkcs12 -export \
       -in $CADIR/$PRIMARY_DOMAIN.crt \
       -inkey $CADIR/$PRIMARY_DOMAIN.key \
       -out "$STATEFILE" \
       -name jetty \
       -CAfile "$CADIR/ca.crt" \
       -caname ca \
       -passout pass:Welcome1
   keytool -import \
       -keystore "$STATEFILE" \
       -alias trust \
       -storepass  Welcome1 \
       -file $CADIR/ca.crt \
       -trustcacerts  -noprompt
fi
echo "keystore $(cat "$STATEDIR/$NAME" | base64 -w 0)"
