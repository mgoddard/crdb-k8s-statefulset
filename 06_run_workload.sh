#!/bin/bash

# In parent shell: export WORKLOAD_RUN_MINUTES=15
runtime="${WORKLOAD_RUN_MINUTES:-10}"

echo "Initializing the workload ..."
kubectl exec --stdin --tty cockroachdb-client-secure -- /bin/bash -c "./cockroach workload init bank 'postgres://demouser:demopasswd@cockroachdb-public:26257/bank?sslrootcert=/cockroach-certs/ca.crt'"

echo "Running the workload for $runtime minutes ..."
kubectl exec --stdin --tty cockroachdb-client-secure -- /bin/bash -c "./cockroach workload run bank --duration=${runtime}m 'postgres://demouser:demopasswd@cockroachdb-public:26257/bank?sslrootcert=/cockroach-certs/ca.crt'"

echo "Cleaning up ..."
echo "DROP DATABASE BANK;" | kubectl exec --stdin cockroachdb-client-secure -- /bin/bash -c "./cockroach sql --url 'postgres://demouser:demopasswd@cockroachdb-public:26257/bank?sslrootcert=/cockroach-certs/ca.crt'"

