#!/bin/bash

echo "Starting the Geo Tourist app ..."
kubectl apply -f ./crdb-geo-tourist.yaml

lb_ip=""
while [ -z "$lb_ip" ]
do
  echo "Waiting for the Geo Tourist app load balancer IP address ..."
  lb_ip=$( kubectl describe service crdb-geo-tourist-lb | perl -ne 'print "$1\n" if /^LoadBalancer Ingress:\s+((\d+\.){3}\d+)$/' )
  sleep 2
done
echo "Geo Tourist app load balancer IP: $lb_ip"

