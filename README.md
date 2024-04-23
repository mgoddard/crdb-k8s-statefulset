# Kubernetes StatefulSet CockroachDB Deployment (single region, GCP)

This repo just contains scripts to help deploy CockroachDB onto GKE, per
[this doc](https://www.cockroachlabs.com/docs/stable/deploy-cockroachdb-with-kubernetes?filters=manual).

## Scripts

`00_setup_gke.sh`: Set up the GKE cluster

`01_gen_certs.sh`: Generate certificates

`02_apply_stateful_set.sh`: Apply the CockroachDB stateful set configuration, yielding a running cluster
with a publicly accessible load balancer

`03_sql_client.sh`: Deploy a SQL client pod and add a database role

`04_psql_cli.sh`: Wrapper around `psql` to access the cluster using the role added in the previous step

`05_scale_out.sh`: Add a 4th node

`06_rolling_upgrade.sh`: Perform an online rolling upgrade

