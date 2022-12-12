#!/bin/sh
crt_dir=.
pr_dir=./private
db_dir=./db
ncrt_dir=./certs

ca_name="ca"
leaf_name1="myne1_2048_256"
leaf_name2="myne1_3072_384"
leaf_name3="myne1_4096_512"

#rm -rf $pr_dir
#rm -rf $db_dir
#rm -rf $ncrt_dir
#rm -rf $crt_dir/*.crt
#rm -rf $crt_dir/*.csr

#mkdir -p $pr_dir
#mkdir -p $db_dir
#mkdir -p $ncrt_dir

#echo 10 > $db_dir/$ca_name.srl
#touch $db_dir/$ca_name.index

openssl genrsa -out $pr_dir/$leaf_name1.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name1.key -out $pr_dir/$leaf_name1.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$leaf_name1.pkcs8.key -config $leaf_name1.cnf -out $crt_dir/$leaf_name1.csr

openssl genrsa -out $pr_dir/$leaf_name2.key 3072
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name2.key -out $pr_dir/$leaf_name2.pkcs8.key
openssl req -new -sha384 -key $pr_dir/$leaf_name2.pkcs8.key -config $leaf_name2.cnf -out $crt_dir/$leaf_name2.csr

openssl genrsa -out $pr_dir/$leaf_name3.key 4096
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name3.key -out $pr_dir/$leaf_name3.pkcs8.key
openssl req -new -sha512 -key $pr_dir/$leaf_name3.pkcs8.key -config $leaf_name3.cnf -out $crt_dir/$leaf_name3.csr

openssl ca -config $ca_name.cnf -md sha256 -in $crt_dir/$leaf_name1.csr -out $crt_dir/$leaf_name1.crt
openssl ca -config $ca_name.cnf -md sha384 -in $crt_dir/$leaf_name2.csr -out $crt_dir/$leaf_name2.crt
openssl ca -config $ca_name.cnf -md sha512 -in $crt_dir/$leaf_name3.csr -out $crt_dir/$leaf_name3.crt


openssl pkcs12 -export -name "My Certificates $leaf_name1" -out $leaf_name1.pfx -inkey $pr_dir/$leaf_name1.key -in $leaf_name1.crt 
openssl pkcs12 -export -name "My Certificates $leaf_name2" -out $leaf_name2.pfx -inkey $pr_dir/$leaf_name2.key -in $leaf_name2.crt 
openssl pkcs12 -export -name "My Certificates $leaf_name3" -out $leaf_name3.pfx -inkey $pr_dir/$leaf_name3.key -in $leaf_name3.crt 


