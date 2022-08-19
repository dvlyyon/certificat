#!/bin/sh
crt_dir=.
pr_dir=./private_ecdsa1
db_dir=./db_ecdsa1
ncrt_dir=./certs_ecdsa1

ca_name="ca_ecdsa"
leaf_name="myne1_ecdsa"

#rm -rf $pr_dir
rm -rf $db_dir
rm -rf $ncrt_dir
#rm -rf $crt_dir/*.crt
rm -rf $crt_dir/*.csr

mkdir -p $pr_dir
mkdir -p $db_dir
mkdir -p $ncrt_dir

echo 00 > $db_dir/$ca_name.srl
echo 20 > $db_dir/$leaf_name.srl
touch $db_dir/$ca_name.index
touch $db_dir/$leaf_name.index

#openssl genrsa -out $pr_dir/$ca_name.key 2048
#openssl genkey -out $pr_dir/$ca_name.key -algorithm EC -pkeyopt ec_paramgen_curve:secp256r1 -aes-128-cbc
openssl ecparam -name secp384r1 -genkey -out $pr_dir/$ca_name.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca_name.key -out $pr_dir/$ca_name.pkcs8.key
#openssl req -new -x509 -key $pr_dir/$ca_name.pkcs8.key -out $crt_dir/$ca_name.crt -days 365 -config $ca_name.cnf
openssl req -new -x509 -key $pr_dir/$ca_name.pkcs8.key -out $crt_dir/$ca_name.crt -days 365 -config $ca_name.cnf -extensions v3_req

#openssl genrsa -out $pr_dir/$leaf_name.key 2048
openssl ecparam -name secp384r1 -genkey -out $pr_dir/$leaf_name.key
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$leaf_name.key -out $pr_dir/$leaf_name.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$leaf_name.pkcs8.key -config $leaf_name.cnf -out $crt_dir/$leaf_name.csr


#openssl genrsa -out $leaf_name.key 2048
#openssl pkcs8 -topk8 -nocrypt -in $leaf_name.key -out $leaf_name.pkcs8.key
#openssl req -new -sha256 -key $leaf_name.pkcs8.key -config $leaf_name.cnf -out $leaf_name.csr
#
#
#openssl genrsa -out $qa_name.key 2048
#openssl pkcs8 -topk8 -nocrypt -in $qa_name.key -out $qa_name.pkcs8.key
#openssl req -new -sha256 -key $qa_name.pkcs8.key -config $qa_name.cnf -out qa.csr
#
#openssl genrsa -out ne127.key 2048
#openssl pkcs8 -topk8 -nocrypt -in ne127.key -out ne127.pkcs8.key
#openssl req -new -sha256 -key ne127.pkcs8.key -config infinera_sh_qa_ne127.cnf -out ne127.csr
#

openssl ca -config $ca_name.cnf -in $crt_dir/$leaf_name.csr -out $crt_dir/$leaf_name.crt
#openssl ca -config infinera_sh.cnf -in qa.csr -out qa.crt
#openssl ca -config infinera_sh_qa.cnf -in ne127.csr -out ne127.crt

openssl crl2pkcs7 -nocrl -certfile $ca_name.crt -out $ca_name.p7b
openssl crl2pkcs7 -nocrl -certfile $leaf_name.crt -out $leaf_name.p7b

#openssl pkcs12 -export -in $leaf_name.crt -inkey private/$leaf_name.key -out $leaf_name.pfx -certfile $ca_name.crt
openssl pkcs12 -export -in $leaf_name.crt -inkey private/$leaf_name.key -out $leaf_name.pfx 



