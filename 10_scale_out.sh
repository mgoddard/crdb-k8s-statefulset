#!/bin/bash

echo "Scaling CockroachDB cluster by adding additional node(s) ..."
kubectl scale statefulsets cockroachdb --replicas=6
echo "Ok"

