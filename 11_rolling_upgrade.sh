#!/bin/bash

echo "Starting rolling upgrade of CockroachDB ..."
kubectl patch statefulsets cockroachdb --type='json' -p='[ { "op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "cockroachdb/cockroach:v23.2.5" } ]'
echo "Started.  Follow progress in DB Console"

