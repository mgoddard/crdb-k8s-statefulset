#!/bin/bash

echo "Scaling CockroachDB cluster out by adding a 4th node ..."
kubectl scale statefulsets cockroachdb --replicas=4
echo "Ok"

