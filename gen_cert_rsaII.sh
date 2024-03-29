#!/bin/sh
crt_dir=.
pr_dir=./private
db_dir=./db
ncrt_dir=./certs

ca1_name="ca1"
ca11_name="ca11"
leaf_name="myne111"
leaf_cnf_name="myne1"

#rm -rf $pr_dir
rm -rf $db_dir
rm -rf $ncrt_dir
#rm -rf $crt_dir/*.crt
rm -rf $crt_dir/*.csr

mkdir -p $pr_dir
mkdir -p $db_dir
mkdir -p $ncrt_dir

echo 00 > $db_dir/$ca_name.srl
echo 20 > $db_dir/$ca1_name.srl
echo 40 > $db_dir/$ca11_name.srl
touch $db_dir/$ca_name.index
touch $db_dir/$ca1_name.index
touch $db_dir/$ca11_name.index


openssl genrsa -out $pr_dir/$leaf_name.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name.key -out $pr_dir/$leaf_name.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$leaf_name.pkcs8.key -config $leaf_cnf_name.cnf -out $crt_dir/$leaf_name.csr

openssl ca -config $ca11_name.cnf -in $crt_dir/$leaf_name.csr -out $crt_dir/$leaf_name.crt


openssl pkcs12 -export -name "My Certificates $leaf_name" -out $leaf_name.pfx -inkey private/$leaf_name.key -in $leaf_name.crt 
openssl pkcs12 -export -name "My Certificates $leaf_name" -out $leaf_name.c0.pfx -inkey private/$leaf_name.key -in $leaf_name.crt -certfile $ca11_name.crt -certfile $ca1_name.crt
cat $crt_dir/$leaf_name.crt $crt_dir/$ca11_name.crt $crt_dir/$ca1_name.crt | sed -n '/-BEGIN CERT/,/-END CERT/p' > $crt_dir/$leaf_name.chain.crt
openssl pkcs12 -export -name "My Certificates" -out $leaf_name.c1.pfx -inkey private/$leaf_name.key -in $leaf_name.chain.crt 


