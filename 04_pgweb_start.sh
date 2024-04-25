#!/bin/bash

echo "Starting the PGWeb DB client UI ..."
kubectl apply -f ./pgweb.yaml

lb_ip=""
while [ -z "$lb_ip" ]
do
  echo "Waiting for the PGWeb app load balancer IP address ..."
  lb_ip=$( kubectl describe service pgweb-lb | perl -ne 'print "$1\n" if /^LoadBalancer Ingress:\s+((\d+\.){3}\d+)$/' )
  sleep 2
done
echo "PGWeb app load balancer IP: $lb_ip"

