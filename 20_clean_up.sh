#!/bin/bash

echo "Starting to tear it all down ..."
echo ""
read -p "Type 'Y', ENTER continue: " y_n
y_n=${y_n:-N}
case $y_n in
  ([yY])
    ;;
  (*)
    echo "Aborting"
    exit 0
    ;;
esac

echo "Deleting the PGWeb app ..."
kubectl delete -f ./pgweb.yaml

echo "Deleting the Geo Tourist app ..."
kubectl delete -f ./crdb-geo-tourist.yaml
kubectl delete -f ./data-loader.yaml

echo "Deleting the SQL client pod ..."
kubectl delete pod cockroachdb-client-secure

echo "Deleting the CockroachDB deployment ..."
kubectl delete -f ./cockroachdb-statefulset.yaml
kubectl delete pods,statefulsets,services,poddisruptionbudget,jobs,rolebinding,clusterrolebinding,role,clusterrole,serviceaccount,prometheus,prometheusrule,serviceMonitor -l app=cockroachdb

echo "Deleting the persistent volumes and persistent volume claims ..."
kubectl delete pv,pvc --all

echo "Removing local certs directories ..."
rm -rf ./certs ./my-safe-directory
echo "Done"

