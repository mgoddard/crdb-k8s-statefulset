#!/bin/bash

echo "Starting rolling upgrade of CockroachDB ..."
kubectl patch statefulsets cockroachdb --type='json' -p='[ { "op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "cockroachdb/cockroach-unstable:v24.1.0-beta.1" } ]'
echo "Started.  Follow progress in DB Console"

