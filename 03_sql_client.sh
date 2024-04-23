#!/bin/bash

echo "Starting a SQL client pod ..."
kubectl apply -f https://raw.githubusercontent.com/cockroachdb/cockroach/master/cloud/kubernetes/bring-your-own-certs/client.yaml

while [[ $( kubectl get pods -l app=cockroachdb-client | sed 1d | awk '{print $3}' ) != "Running" ]]
do
  echo "Waiting for SQL client pod to start up ..."
  sleep 1
done

echo "Using the SQL client to create role 'demouser' with password 'demopasswd' ..."
cat create_user.sql | kubectl exec -it cockroachdb-client-secure -- ./cockroach sql --certs-dir=/cockroach-certs --host=cockroachdb-public
echo "Ok"

