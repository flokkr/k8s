#!/usr/bin/env bash
vault write pki/issue/ozone common_name=$(hostname -f) -format=json > cert

keytool -import -alias ca -file <(cat cert | jq -r '.data.issuing_ca' ) -keystore /data/truststore -noprompt -storepass changeit -trustcacerts

openssl pkcs12 -export -name cert -in <(cat cert | jq -r '.data.issuing_ca + "\n" + .data.certificate') -inkey <(cat cert | jq -r '.data.private_key' ) -nodes -CAfile <(cat cert | jq -r '.data.issuing_ca' ) -out keystore.p12 -passout pass:

keytool -importkeystore -destkeystore /data/keystore -srckeystore keystore.p12 -srcstoretype pkcs12 -deststoretype pkcs12 -alias cert -srcstorepass '' -noprompt -storepass changeit -destkeypass changeit
