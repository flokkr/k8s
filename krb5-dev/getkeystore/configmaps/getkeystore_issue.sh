#!/usr/bin/env bash

$OUTPUT_DIR=${OUTPUT_DIR:-/tmp}
$KEYSTORE_PASS=${KEYSTORE_PASS:-changeit}

vault write pki/issue/$PKI_ROLE common_name=$(hostname -f) -format=json > cert

keytool -import -alias ca -file <(cat cert | jq -r '.data.issuing_ca' ) -keystore $OUTPUT_DIR/truststore -noprompt -storepass ${KEYSTORE_PASS} -trustcacerts

openssl pkcs12 -export -name cert -in <(cat cert | jq -r '.data.issuing_ca + "\n" + .data.certificate') -inkey <(cat cert | jq -r '.data.private_key' ) -nodes -CAfile <(cat cert | jq -r '.data.issuing_ca' ) -out keystore.p12 -passout pass:

keytool -importkeystore -destkeystore ${OUTPUT_DIR}/keystore -srckeystore keystore.p12 -srcstoretype pkcs12 -deststoretype pkcs12 -alias cert -srcstorepass '' -noprompt -storepass ${KEYSTORE_PASS} -destkeypass ${KEYSTORE_PASS}
