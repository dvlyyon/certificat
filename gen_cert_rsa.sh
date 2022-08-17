#!/bin/sh
crt_dir=.
pr_dir=./private
db_dir=./db
ncrt_dir=./certs

ca_name="ca"
leaf_name="myne1"

#rm -rf $pr_dir
rm -rf $db_dir
rm -rf $ncrt_dir
#rm -rf $crt_dir/*.crt
#rm -rf $crt_dir/*.csr

mkdir -p $pr_dir
mkdir -p $db_dir
mkdir -p $ncrt_dir

echo 10 > $db_dir/$ca_name.srl
touch $db_dir/$ca_name.index

openssl genrsa -out $pr_dir/$leaf_name.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name.key -out $pr_dir/$leaf_name.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$leaf_name.pkcs8.key -config $leaf_cnf_name.cnf -out $crt_dir/$leaf_name.csr

openssl ca -config $ca_name.cnf -in $crt_dir/$leaf_name.csr -out $crt_dir/$leaf_name.crt


openssl pkcs12 -export -name "My Certificates $leaf_name" -out $leaf_name.pfx -inkey private/$leaf_name.key -in $leaf_name.crt 


