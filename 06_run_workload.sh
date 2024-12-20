#!/bin/bash

WORKLOAD_RUN_MINUTES=90

echo "Initializing the workload ..."
kubectl exec --stdin --tty cockroachdb-client-secure -- /bin/bash -c "./cockroach workload init bank 'postgres://demouser:demopasswd@cockroachdb-public:26257/bank?sslrootcert=/cockroach-certs/ca.crt'"

echo "Running the workload for $WORKLOAD_RUN_MINUTES minutes ..."
kubectl exec --stdin --tty cockroachdb-client-secure -- /bin/bash -c "./cockroach workload run bank --duration=${WORKLOAD_RUN_MINUTES}m 'postgres://demouser:demopasswd@cockroachdb-public:26257/bank?sslrootcert=/cockroach-certs/ca.crt'"

echo "Cleaning up ..."
echo "DROP DATABASE BANK;" | kubectl exec --stdin cockroachdb-client-secure -- /bin/bash -c "./cockroach sql --url 'postgres://demouser:demopasswd@cockroachdb-public:26257/bank?sslrootcert=/cockroach-certs/ca.crt'"

