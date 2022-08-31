#!/bin/sh
crt_dir=.
pr_dir=./private
db_dir=./db
ncrt_dir=./certs

ca_name="ca"
leaf_name3072="myne1_3072"
leaf_name4096="myne1_4096"
leaf_name3="myne1_nohost"

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

openssl genrsa -out $pr_dir/$leaf_name3072.key 3072
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name3072.key -out $pr_dir/$leaf_name3072.pkcs8.key
openssl req -new -sha384 -key $pr_dir/$leaf_name3072.pkcs8.key -config $leaf_name3072.cnf -out $crt_dir/$leaf_name3072.csr

openssl genrsa -out $pr_dir/$leaf_name4096.key 4096
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name4096.key -out $pr_dir/$leaf_name4096.pkcs8.key
openssl req -new -sha512 -key $pr_dir/$leaf_name4096.pkcs8.key -config $leaf_name4096.cnf -out $crt_dir/$leaf_name4096.csr

openssl genrsa -out $pr_dir/$leaf_name3.key 4096
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name3.key -out $pr_dir/$leaf_name3.pkcs8.key
openssl req -new -sha512 -key $pr_dir/$leaf_name3.pkcs8.key -config $leaf_name3.cnf -out $crt_dir/$leaf_name3.csr

openssl ca -config $ca_name.cnf -in $crt_dir/$leaf_name3072.csr -out $crt_dir/$leaf_name3072.crt
openssl ca -config $ca_name.cnf -in $crt_dir/$leaf_name4096.csr -out $crt_dir/$leaf_name4096.crt
openssl ca -config $ca_name.cnf -in $crt_dir/$leaf_name3.csr -out $crt_dir/$leaf_name3.crt


openssl pkcs12 -export -name "My Certificates $leaf_name4096" -out $leaf_name4096.pfx -inkey $pr_dir/$leaf_name4096.key -in $leaf_name4096.crt 
openssl pkcs12 -export -name "My Certificates $leaf_name3072" -out $leaf_name3072.pfx -inkey $pr_dir/$leaf_name3072.key -in $leaf_name3072.crt 
openssl pkcs12 -export -name "My Certificates $leaf_name3" -out $leaf_name3.pfx -inkey $pr_dir/$leaf_name3.key -in $leaf_name3.crt 


