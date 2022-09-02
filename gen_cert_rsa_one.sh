#!/bin/sh
crt_dir=.
pr_dir=./private
db_dir=./db
ncrt_dir=./certs

ca_name="ca"
leaf_name="myne1_ipv6"



openssl genrsa -out $pr_dir/$leaf_name.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name.key -out $pr_dir/$leaf_name.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$leaf_name.pkcs8.key -config $leaf_name.cnf -out $crt_dir/$leaf_name.csr

openssl ca -config $ca_name.cnf -in $crt_dir/$leaf_name.csr -out $crt_dir/$leaf_name.crt


openssl pkcs12 -export -name "My Certificates $leaf_name" -out $leaf_name.pfx -inkey $pr_dir/$leaf_name.key -in $leaf_name.crt 


