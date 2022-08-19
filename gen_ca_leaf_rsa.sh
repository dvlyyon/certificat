#!/bin/sh
crt_dir=.
pr_dir=./private
db_dir=./db
ncrt_dir=./certs

ca_name="ca"
ca1_name="ca1"
ca11_name="ca11"
ca111_name="ca111"
leaf_name1="myne1"
leaf_name11="myne11"
leaf_name111="myne111"
leaf_name1111="myne1111"

rm -rf $pr_dir
rm -rf $db_dir
rm -rf $ncrt_dir
rm -rf $crt_dir/*.crt
rm -rf $crt_dir/*.csr

mkdir -p $pr_dir
mkdir -p $db_dir
mkdir -p $ncrt_dir

echo 00 > $db_dir/$ca_name.srl
echo 20 > $db_dir/$ca1_name.srl
echo 40 > $db_dir/$ca11_name.srl
echo 60 > $db_dir/$ca111_name.srl
touch $db_dir/$ca_name.index
touch $db_dir/$ca1_name.index
touch $db_dir/$ca11_name.index
touch $db_dir/$ca111_name.index

openssl genrsa -out $pr_dir/$ca_name.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca_name.key -out $pr_dir/$ca_name.pkcs8.key
openssl req -new -x509 -key $pr_dir/$ca_name.pkcs8.key -out $crt_dir/$ca_name.crt -days 3650 -config $ca_name.cnf -extensions v3_req


openssl genrsa -out $pr_dir/$ca1_name.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca1_name.key -out $pr_dir/$ca1_name.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$ca1_name.pkcs8.key -config $ca1_name.cnf -out $crt_dir/$ca1_name.csr

openssl genrsa -out $pr_dir/$ca11_name.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca11_name.key -out $pr_dir/$ca11_name.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$ca11_name.pkcs8.key -config $ca11_name.cnf -out $crt_dir/$ca11_name.csr

openssl genrsa -out $pr_dir/$ca111_name.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca111_name.key -out $pr_dir/$ca111_name.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$ca111_name.pkcs8.key -config $ca111_name.cnf -out $crt_dir/$ca111_name.csr

openssl genrsa -out $pr_dir/$leaf_name1.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name1.key -out $pr_dir/$leaf_name1.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$leaf_name1.pkcs8.key -config $leaf_name1.cnf -out $crt_dir/$leaf_name1.csr

openssl genrsa -out $pr_dir/$leaf_name11.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name11.key -out $pr_dir/$leaf_name11.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$leaf_name11.pkcs8.key -config $leaf_name11.cnf -out $crt_dir/$leaf_name11.csr

openssl genrsa -out $pr_dir/$leaf_name111.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name111.key -out $pr_dir/$leaf_name111.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$leaf_name111.pkcs8.key -config $leaf_name111.cnf -out $crt_dir/$leaf_name111.csr

openssl genrsa -out $pr_dir/$leaf_name1111.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name1111.key -out $pr_dir/$leaf_name1111.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$leaf_name1111.pkcs8.key -config $leaf_name1111.cnf -out $crt_dir/$leaf_name1111.csr

openssl ca -config $ca_name.cnf -in $crt_dir/$ca1_name.csr -out $crt_dir/$ca1_name.crt
openssl ca -config $ca_name.cnf -in $crt_dir/$leaf_name1.csr -out $crt_dir/$leaf_name1.crt
openssl ca -config $ca1_name.cnf -in $crt_dir/$ca11_name.csr -out $crt_dir/$ca11_name.crt
openssl ca -config $ca1_name.cnf -in $crt_dir/$leaf_name11.csr -out $crt_dir/$leaf_name11.crt
openssl ca -config $ca11_name.cnf -in $crt_dir/$ca111_name.csr -out $crt_dir/$ca111_name.crt
openssl ca -config $ca11_name.cnf -in $crt_dir/$leaf_name111.csr -out $crt_dir/$leaf_name111.crt
openssl ca -config $ca111_name.cnf -in $crt_dir/$leaf_name1111.csr -out $crt_dir/$leaf_name1111.crt

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
