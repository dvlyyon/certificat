#!/bin/sh
crt_dir=.
pr_dir=./private
db_dir=./db
ncrt_dir=./certs

ca_name="infr-ca"
sh_name="infr-sh-local"

rm -rf $pr_dir
rm -rf $db_dir
rm -rf $ncrt_dir
rm -rf $crt_dir/*.crt
rm -rf $crt_dir/*.csr

mkdir -p $pr_dir
mkdir -p $db_dir
mkdir -p $ncrt_dir

echo 00 > $db_dir/$ca_name.srl
echo 20 > $db_dir/$sh_name.srl
touch $db_dir/$ca_name.index
touch $db_dir/$sh_name.index

openssl genrsa -out $pr_dir/$ca_name.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$ca_name.key -out $pr_dir/$ca_name.pkcs8.key
#openssl req -new -x509 -key $pr_dir/$ca_name.pkcs8.key -out $crt_dir/$ca_name.crt -days 365 -config $ca_name.cnf
openssl req -new -x509 -key $pr_dir/$ca_name.pkcs8.key -out $crt_dir/$ca_name.crt -days 365 -config $ca_name.cnf -extensions v3_req

openssl genrsa -out $pr_dir/$sh_name.key 2048
openssl pkcs8 -topk8 -nocrypt -in $pr_dir/$sh_name.key -out $pr_dir/$sh_name.pkcs8.key
openssl req -new -sha256 -key $pr_dir/$sh_name.pkcs8.key -config $sh_name.cnf -out $crt_dir/$sh_name.csr


#openssl genrsa -out $sh_name.key 2048
#openssl pkcs8 -topk8 -nocrypt -in $sh_name.key -out $sh_name.pkcs8.key
#openssl req -new -sha256 -key $sh_name.pkcs8.key -config $sh_name.cnf -out $sh_name.csr
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

openssl ca -config $ca_name.cnf -in $crt_dir/$sh_name.csr -out $crt_dir/$sh_name.crt
#openssl ca -config infinera_sh.cnf -in qa.csr -out qa.crt
#openssl ca -config infinera_sh_qa.cnf -in ne127.csr -out ne127.crt

openssl crl2pkcs7 -nocrl -certfile $ca_name.crt -out $ca_name.p7b
openssl crl2pkcs7 -nocrl -certfile $sh_name.crt -out $sh_name.p7b

#openssl pkcs12 -export -in $sh_name.crt -inkey private/$sh_name.key -out $sh_name.pfx -certfile $ca_name.crt
openssl pkcs12 -export -in $sh_name.crt -inkey private/$sh_name.key -out $sh_name.pfx 



