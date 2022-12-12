#!/bin/sh
crt_dir=.
pr_dir=./ecdsa_std_private
db_dir=./ecdsa_std_db
ncrt_dir=./ecdsa_std_certs

ca1_name="ecdsa_ca_256"
ca2_name="ecdsa_ca_384"
ca3_name="ecdsa_ca_521"
leaf_name1="ecdsa_leaf_256"
leaf_name2="ecdsa_leaf_384"
leaf_name3="ecdsa_leaf_521"


rm -rf $pr_dir
rm -rf $db_dir
rm -rf $ncrt_dir

mkdir -p $pr_dir
mkdir -p $db_dir
mkdir -p $ncrt_dir

echo 30 > $db_dir/$ca1_name.srl
echo 50 > $db_dir/$ca2_name.srl
echo 70 > $db_dir/$ca3_name.srl
touch $db_dir/$ca1_name.index
touch $db_dir/$ca2_name.index
touch $db_dir/$ca3_name.index



echo "create $ca1_name"
openssl ecparam -name prime256v1 -genkey -out $pr_dir/$ca1_name.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca1_name.key -out $pr_dir/$ca1_name.pkcs8.key
openssl req -new -x509 -key $pr_dir/$ca1_name.pkcs8.key -out $crt_dir/$ca1_name.crt -days 3650 -sha256 -config $ca1_name.cnf -extensions v3_req

echo "create $ca2_name"
openssl ecparam -name secp384r1 -genkey -out $pr_dir/$ca2_name.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca2_name.key -out $pr_dir/$ca2_name.pkcs8.key
openssl req -new -x509 -key $pr_dir/$ca2_name.pkcs8.key -out $crt_dir/$ca2_name.crt -days 3650 -sha384 -config $ca2_name.cnf -extensions v3_req

echo "create $ca3_name"
openssl ecparam -name secp521r1 -genkey -out $pr_dir/$ca3_name.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca3_name.key -out $pr_dir/$ca3_name.pkcs8.key
openssl req -new -x509 -key $pr_dir/$ca3_name.pkcs8.key -out $crt_dir/$ca3_name.crt -days 3650 -sha512 -config $ca3_name.cnf -extensions v3_req
openssl req -new -sha256 -key $pr_dir/$ca3_name.pkcs8.key -config $ca3_name.cnf -out $crt_dir/$ca3_name.csr

echo "create $leaf_name1"
openssl ecparam -name prime256v1 -genkey -out $pr_dir/$leaf_name1.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name1.key -out $pr_dir/$leaf_name1.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$leaf_name1.pkcs8.key -config $leaf_name1.cnf -out $crt_dir/$leaf_name1.csr

echo "create $leaf_name2"
openssl ecparam -name secp384r1 -genkey -out $pr_dir/$leaf_name2.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name2.key -out $pr_dir/$leaf_name2.pkcs8.key
openssl req -new -sha384 -key $pr_dir/$leaf_name2.pkcs8.key -config $leaf_name2.cnf -out $crt_dir/$leaf_name2.csr

echo "create $leaf_name3"
openssl ecparam -name secp521r1 -genkey -out $pr_dir/$leaf_name3.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name3.key -out $pr_dir/$leaf_name3.pkcs8.key
openssl req -new -sha512 -key $pr_dir/$leaf_name3.pkcs8.key -config $leaf_name3.cnf -out $crt_dir/$leaf_name3.csr


echo "create public certificate"
openssl ca -config $ca1_name.cnf -md sha256 -in $crt_dir/$leaf_name1.csr -out $crt_dir/$leaf_name1.crt
openssl ca -config $ca2_name.cnf -md sha384 -in $crt_dir/$leaf_name2.csr -out $crt_dir/$leaf_name2.crt
openssl ca -config $ca3_name.cnf -md sha512 -in $crt_dir/$leaf_name3.csr -out $crt_dir/$leaf_name3.crt

echo "convert to p7b format"
openssl crl2pkcs7 -nocrl -out $crt_dir/$ca1_name.p7b -certfile $crt_dir/$ca1_name.crt 
openssl crl2pkcs7 -nocrl -out $crt_dir/$ca2_name.p7b -certfile $crt_dir/$ca2_name.crt 
openssl crl2pkcs7 -nocrl -out $crt_dir/$ca3_name.p7b -certfile $crt_dir/$ca3_name.crt 

echo "convert to p12 for $leaf_name1"
openssl pkcs12 -export -name "My Certificates $leaf_name1" -out $leaf_name1.pfx -inkey $pr_dir/$leaf_name1.key -in $leaf_name1.crt 
echo "complete for $leaf_name1"

echo "convert to p12 for $leaf_name2"
openssl pkcs12 -export -name "My Certificates $leaf_name2" -out $leaf_name2.pfx -inkey $pr_dir/$leaf_name2.key -in $leaf_name2.crt 
echo "complete for $leaf_name2"

echo "convert to p12 for $leaf_name3"
openssl pkcs12 -export -name "My Certificates $leaf_name3" -out $leaf_name3.pfx -inkey $pr_dir/$leaf_name3.key -in $leaf_name3.crt 
echo "complete for $leaf_name3"

