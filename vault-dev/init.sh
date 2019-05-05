   0 vault secrets enable pki
   1 vault login
   2 vault login --help
   3 vault login
   4 export VAULT_ADDR=http://127.0.0.1:8200
   5 vault login
   6 vault login devtoken
   7 export VAULT_ADDR=http://127.0.0.1:8200
   8 vault login devtoken
   9 vault secrets enable pki
  10 vault secrets tune -max-lease-ttl=87600h pki
  11 vault write pki/root/generate/internal common_name=myvault.com ttl=87600h
  12 hostname -f
  13 vault write pki/roles/ozone allowed_domains=default.svc.cluster.local allow_subdomains=true
  ault write auth/kubernetes/role/default bound_service_account_namespaces=default 'bound_s
ervice_account_names=*' policies=default ttl=768h
