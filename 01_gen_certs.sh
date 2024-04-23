#!/bin/bash

# In case you want to assign a DNS hostname to the LB public IP
dns_hostname="crdb.la-cucaracha.net"

certs_dir="certs"
safe_dir="my-safe-directory"

echo "Creating certificates and K8s secrets ..."

# Backup any existing
[ -d $certs_dir ] && mv $certs_dir ${certs_dir}_BAK
[ -d $safe_dir ] && mv $safe_dir ${safe_dir}_BAK

mkdir $certs_dir $safe_dir

cockroach cert create-ca --certs-dir=$certs_dir --ca-key=$safe_dir/ca.key
cockroach cert create-client root --certs-dir=$certs_dir --ca-key=$safe_dir/ca.key

kubectl create secret generic cockroachdb.client.root --from-file=$certs_dir

cockroach cert create-node \
  $dns_hostname \
  localhost 127.0.0.1 \
  cockroachdb-public cockroachdb-public.default \
  cockroachdb-public.default.svc.cluster.local \
  *.cockroachdb *.cockroachdb.default *.cockroachdb.default.svc.cluster.local \
  --certs-dir=$certs_dir --ca-key=$safe_dir/ca.key

kubectl create secret generic cockroachdb.node --from-file=$certs_dir

echo "Two secrets should be shown below:"
kubectl get secrets


