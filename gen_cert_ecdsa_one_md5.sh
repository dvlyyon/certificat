#!/bin/sh
crt_dir=.
pr_dir=./ecdsa_private
db_dir=./ecdsa_db
ncrt_dir=./ecdsa_certs

ca_name="ecdsa_ca"
#leaf_name="ecdsa_myne1_ipv6"
leaf_name="ecdsa_myne1_md5"



openssl ecparam -name prime256v1 -genkey -out $pr_dir/$leaf_name.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name.key -out $pr_dir/$leaf_name.pkcs8.key
openssl req -new -md5 -key $pr_dir/$leaf_name.pkcs8.key -config $leaf_name.cnf -out $crt_dir/$leaf_name.csr

openssl ca -config $ca_name.cnf -in $crt_dir/$leaf_name.csr -out $crt_dir/$leaf_name.crt

openssl pkcs12 -export -name "My Certificates $leaf_name" -out $leaf_name.pfx -inkey $pr_dir/$leaf_name.key -in $leaf_name.crt 


