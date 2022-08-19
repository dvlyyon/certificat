#!/bin/sh

crt_dir=.
pr_dir=./ecdsa_private
db_dir=./ecdsa_db
ncrt_dir=./ecdsa_certs

ca_name="ecdsa_ca"
ca1_name="ecdsa_ca1"
ca11_name="ecdsa_ca11"
ca111_name="ecdsa_ca111"
leaf_name1="ecdsa_myne1"
leaf_name11="ecdsa_myne11"
leaf_name111="ecdsa_myne111"
leaf_name1111="ecdsa_myne1111"


echo "convert to p12 for $leaf_name1"
openssl pkcs12 -export -name "My Certificates $leaf_name1" -out $leaf_name1.pfx -inkey $pr_dir/$leaf_name1.key -in $leaf_name1.crt 
echo "complete for $leaf_name1"

echo "convert to p12 for $leaf_name11"
openssl pkcs12 -export -name "My Certificates $leaf_name11" -out $leaf_name11.pfx -inkey $pr_dir/$leaf_name11.key -in $leaf_name11.crt 
openssl pkcs12 -export -name "My Certificates $leaf_name11" -out $leaf_name11.c0.pfx -inkey $pr_dir/$leaf_name11.key -in $leaf_name11.crt -certfile $ca1_name.crt
cat $crt_dir/$leaf_name11.crt $crt_dir/$ca1_name.crt | sed -n '/-BEGIN CERT/,/-END CERT/p' > $crt_dir/$leaf_name11.chain.crt
openssl pkcs12 -export -name "My Certificates $leaf_name11" -out $leaf_name11.c1.pfx -inkey $pr_dir/$leaf_name11.key -in $leaf_name11.chain.crt 
echo "complete for $leaf_name1"

echo "convert to p12 for $leaf_name111"
openssl pkcs12 -export -name "My Certificates $leaf_name111" -out $leaf_name111.pfx -inkey $pr_dir/$leaf_name111.key -in $leaf_name111.crt 
openssl pkcs12 -export -name "My Certificates $leaf_name111" -out $leaf_name111.c0.pfx -inkey $pr_dir/$leaf_name111.key -in $leaf_name111.crt -certfile $ca11_name.crt -certfile $ca1_name.crt
cat $crt_dir/$leaf_name111.crt $crt_dir/$ca11_name.crt $crt_dir/$ca1_name.crt | sed -n '/-BEGIN CERT/,/-END CERT/p' > $crt_dir/$leaf_name111.chain.crt
openssl pkcs12 -export -name "My Certificates $leaf_name111" -out $leaf_name111.c1.pfx -inkey $pr_dir/$leaf_name111.key -in $leaf_name111.chain.crt 
echo "complete for $leaf_name1"

echo "convert to p12 for $leaf_name1111"
openssl pkcs12 -export -name "My Certificates $leaf_name1111" -out $leaf_name1111.pfx -inkey $pr_dir/$leaf_name1111.key -in $leaf_name1111.crt 
openssl pkcs12 -export -name "My Certificates $leaf_name1111" -out $leaf_name1111.c0.pfx -inkey $pr_dir/$leaf_name1111.key -in $leaf_name1111.crt -certfile $ca111_name.crt -certfile $ca11_name.crt -certfile $ca1_name.crt
cat $crt_dir/$leaf_name1111.crt $crt_dir/$ca111_name.crt $crt_dir/$ca11_name.crt $crt_dir/$ca1_name.crt | sed -n '/-BEGIN CERT/,/-END CERT/p' > $crt_dir/$leaf_name1111.chain.crt
openssl pkcs12 -export -name "My Certificates $leaf_name1111" -out $leaf_name1111.c1.pfx -inkey $pr_dir/$leaf_name1111.key -in $leaf_name1111.chain.crt 
echo "complete for $leaf_name1111"
