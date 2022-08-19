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

rm -rf $pr_dir
rm -rf $db_dir
rm -rf $ncrt_dir

mkdir -p $pr_dir
mkdir -p $db_dir
mkdir -p $ncrt_dir

echo 10 > $db_dir/$ca_name.srl
echo 30 > $db_dir/$ca1_name.srl
echo 50 > $db_dir/$ca11_name.srl
echo 70 > $db_dir/$ca111_name.srl
touch $db_dir/$ca_name.index
touch $db_dir/$ca1_name.index
touch $db_dir/$ca11_name.index
touch $db_dir/$ca111_name.index

echo "create $ca_name"
openssl ecparam -name secp521r1 -genkey -out $pr_dir/$ca_name.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca_name.key -out $pr_dir/$ca_name.pkcs8.key
openssl req -new -x509 -key $pr_dir/$ca_name.pkcs8.key -out $crt_dir/$ca_name.crt -days 3650 -config $ca_name.cnf -extensions v3_req


echo "create $ca1_name"
openssl ecparam -name secp384r1 -genkey -out $pr_dir/$ca1_name.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca1_name.key -out $pr_dir/$ca1_name.pkcs8.key
openssl req -new -sha384 -key $pr_dir/$ca1_name.pkcs8.key -config $ca1_name.cnf -out $crt_dir/$ca1_name.csr

echo "create $ca11_name"
openssl ecparam -name prime256v1 -genkey -out $pr_dir/$ca11_name.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca11_name.key -out $pr_dir/$ca11_name.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$ca11_name.pkcs8.key -config $ca11_name.cnf -out $crt_dir/$ca11_name.csr

echo "create $ca111_name"
openssl ecparam -name prime256v1 -genkey -out $pr_dir/$ca111_name.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca111_name.key -out $pr_dir/$ca111_name.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$ca111_name.pkcs8.key -config $ca111_name.cnf -out $crt_dir/$ca111_name.csr

echo "create $leaf_name1"
openssl ecparam -name secp384r1 -genkey -out $pr_dir/$leaf_name1.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name1.key -out $pr_dir/$leaf_name1.pkcs8.key
openssl req -new -sha384 -key $pr_dir/$leaf_name1.pkcs8.key -config $leaf_name1.cnf -out $crt_dir/$leaf_name1.csr

echo "create $leaf_name11"
openssl ecparam -name prime256v1 -genkey -out $pr_dir/$leaf_name11.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name11.key -out $pr_dir/$leaf_name11.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$leaf_name11.pkcs8.key -config $leaf_name11.cnf -out $crt_dir/$leaf_name11.csr

echo "create $leaf_name111"
openssl ecparam -name secp128r1 -genkey -out $pr_dir/$leaf_name111.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name111.key -out $pr_dir/$leaf_name111.pkcs8.key
openssl req -new -sha384 -key $pr_dir/$leaf_name111.pkcs8.key -config $leaf_name111.cnf -out $crt_dir/$leaf_name111.csr

echo "create $leaf_name1111"
openssl ecparam -name secp128r1 -genkey -out $pr_dir/$leaf_name1111.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name1111.key -out $pr_dir/$leaf_name1111.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$leaf_name1111.pkcs8.key -config $leaf_name1111.cnf -out $crt_dir/$leaf_name1111.csr

echo "create public certificate"
openssl ca -config $ca_name.cnf -in $crt_dir/$ca1_name.csr -out $crt_dir/$ca1_name.crt
openssl ca -config $ca_name.cnf -in $crt_dir/$leaf_name1.csr -out $crt_dir/$leaf_name1.crt
openssl ca -config $ca1_name.cnf -in $crt_dir/$ca11_name.csr -out $crt_dir/$ca11_name.crt
openssl ca -config $ca1_name.cnf -in $crt_dir/$leaf_name11.csr -out $crt_dir/$leaf_name11.crt
openssl ca -config $ca11_name.cnf -in $crt_dir/$ca111_name.csr -out $crt_dir/$ca111_name.crt
openssl ca -config $ca11_name.cnf -in $crt_dir/$leaf_name111.csr -out $crt_dir/$leaf_name111.crt
openssl ca -config $ca111_name.cnf -in $crt_dir/$leaf_name1111.csr -out $crt_dir/$leaf_name1111.crt

echo "convert to p7b format"
openssl crl2pkcs7 -nocrl -out $crt_dir/$ca_name.p7b -certfile $crt_dir/$ca_name.crt
openssl crl2pkcs7 -nocrl -out $crt_dir/$ca1_name.p7b -certfile $crt_dir/$ca1_name.crt 
openssl crl2pkcs7 -nocrl -out $crt_dir/$ca11_name.p7b -certfile $crt_dir/$ca11_name.crt 
openssl crl2pkcs7 -nocrl -out $crt_dir/$ca111_name.p7b -certfile $crt_dir/$ca111_name.crt 

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
echo "complete for $leaf_name1"
