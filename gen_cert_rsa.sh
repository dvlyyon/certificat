#!/bin/sh
crt_dir=.
pr_dir=./private
db_dir=./db
ncrt_dir=./certs

ca_name="ca"
ca1_name="ca_c1"
ca11_name="ca_c1_c1"
leaf_name="myne1"

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
touch $db_dir/$ca_name.index
touch $db_dir/$ca1_name.index
touch $db_dir/$ca11_name.index

openssl genrsa -out $pr_dir/$ca_name.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca_name.key -out $pr_dir/$ca_name.pkcs8.key
openssl req -new -x509 -key $pr_dir/$ca_name.pkcs8.key -out $crt_dir/$ca_name.crt -days 365 -config $ca_name.cnf

openssl genrsa -out $pr_dir/$ca1_name.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca1_name.key -out $pr_dir/$ca1_name.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$ca1_name.pkcs8.key -config $ca1_name.cnf -out $crt_dir/$ca1_name.csr

openssl genrsa -out $pr_dir/$ca11_name.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca11_name.key -out $pr_dir/$ca11_name.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$ca11_name.pkcs8.key -config $ca11_name.cnf -out $crt_dir/$ca11_name.csr

openssl genrsa -out $pr_dir/$leaf_name.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name.key -out $pr_dir/$leaf_name.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$leaf_name.pkcs8.key -config $leaf_name.cnf -out $crt_dir/$leaf_name.csr

openssl ca -config $ca_name.cnf -in $crt_dir/$ca1_name.csr -out $crt_dir/$ca1_name.crt
openssl ca -config $ca1_name.cnf -in $crt_dir/$ca11_name.csr -out $crt_dir/$ca11_name.crt
openssl ca -config $ca11_name.cnf -in $crt_dir/$leaf_name.csr -out $crt_dir/$leaf_name.crt
#openssl ca -config infinera_sh.cnf -in qa.csr -out qa.crt
#openssl ca -config infinera_sh_qa.cnf -in ne127.csr -out ne127.crt

cat $crt_dir/$leaf_name.crt $crt_dir/$ca11_name.crt $crt_dir/$ca1_name.crt | sed -n '/-BEGIN CERT/,/-END CERT/p' > $crt_dir/$leaf_name.chain.crt


