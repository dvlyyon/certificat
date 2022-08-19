#!/bin/sh
crt_dir=.
pr_dir=./ecdsa_private
db_dir=./ecdsa_db
ncrt_dir=./ecdsa_certs

ca_name="ecdsa_ca"
leaf_name1="ecdsa_myne1_128"
leaf_name2="ecdsa_myne1_256"
leaf_name3="ecdsa_myne1_521"


openssl ecparam -name secp128r1 -genkey -out $pr_dir/$leaf_name1.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name1.key -out $pr_dir/$leaf_name1.pkcs8.key
openssl req -new -sha384 -key $pr_dir/$leaf_name1.pkcs8.key -config $leaf_name1.cnf -out $crt_dir/$leaf_name1.csr

openssl ecparam -name prime256v1 -genkey -out $pr_dir/$leaf_name2.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name2.key -out $pr_dir/$leaf_name2.pkcs8.key
openssl req -new -sha512 -key $pr_dir/$leaf_name2.pkcs8.key -config $leaf_name2.cnf -out $crt_dir/$leaf_name2.csr

openssl ecparam -name secp521r1 -genkey -out $pr_dir/$leaf_name3.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name3.key -out $pr_dir/$leaf_name3.pkcs8.key
openssl req -new -sha384 -key $pr_dir/$leaf_name3.pkcs8.key -config $leaf_name3.cnf -out $crt_dir/$leaf_name3.csr

openssl ca -config $ca_name.cnf -in $crt_dir/$leaf_name1.csr -out $crt_dir/$leaf_name1.crt
openssl ca -config $ca_name.cnf -in $crt_dir/$leaf_name2.csr -out $crt_dir/$leaf_name2.crt
openssl ca -config $ca_name.cnf -in $crt_dir/$leaf_name3.csr -out $crt_dir/$leaf_name3.crt

openssl pkcs12 -export -name "My Certificates $leaf_name1" -out $leaf_name1.pfx -inkey $pr_dir/$leaf_name1.key -in $leaf_name1.crt 
openssl pkcs12 -export -name "My Certificates $leaf_name2" -out $leaf_name2.pfx -inkey $pr_dir/$leaf_name2.key -in $leaf_name2.crt 
openssl pkcs12 -export -name "My Certificates $leaf_name3" -out $leaf_name3.pfx -inkey $pr_dir/$leaf_name3.key -in $leaf_name3.crt 


