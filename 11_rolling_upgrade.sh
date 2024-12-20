#!/bin/bash

echo "Starting rolling upgrade of CockroachDB ..."
kubectl patch statefulsets cockroachdb --type='json' -p='[ { "op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "cockroachdb/cockroach:v24.3.1" } ]'
echo "Started.  Follow progress in DB Console"

