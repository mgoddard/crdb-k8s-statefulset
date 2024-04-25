#!/bin/bash

echo "Applying StorageClass SSD config ..."
kubectl apply -f storage-class-ssd.yaml

echo "Applying CockroachDB stateful set config ..."
kubectl apply -f cockroachdb-statefulset.yaml

while [[ $( kubectl get pods -l app=cockroachdb | sed 1d | awk '{print $3}' | sort -u ) != "Running" ]]
do
  echo "Waiting for all CockroachDB pods to start up ..."
  sleep 1
done

echo "Showing the PVs:"
kubectl get pv

# Note: this will fail if the cluster had already been initialized, due to the PVs
echo "Initializing the CockroachDB cluster ..."
kubectl exec -it cockroachdb-0 -- /cockroach/cockroach init --certs-dir=/cockroach/cockroach-certs
echo "Done"

echo "Expose the CockroachDB service via external IP ..."
kubectl expose service cockroachdb-public --type=LoadBalancer --name=crdb-lb

lb_ip=""
while [[ ! $( echo $lb_ip | egrep '^(\d+\.){3}\d+$' ) ]]
do
  echo "Waiting to get the load balancer IP address ..."
  lb_ip=$( kubectl get svc | sed 1d | awk '{print $4}' | egrep '^(\d+\.){3}\d+$' )
  sleep 1
done
echo "Load balancer IP: $lb_ip"

