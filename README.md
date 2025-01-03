# Kubernetes StatefulSet CockroachDB Deployment (single region, GCP)

This repo just contains scripts to help deploy CockroachDB onto GKE, per
[this doc](https://www.cockroachlabs.com/docs/stable/deploy-cockroachdb-with-kubernetes?filters=manual),
with the addition of:

* The [locality-checker](https://github.com/cockroachdb/k8s/blob/master/locality-checker/README.md),
which injects the `--locality` flag so you get `region` and `zones`
* The [PGWeb](https://github.com/sosedoff/pgweb) Web UI SQL client
* The [_cockroach workload_](https://www.cockroachlabs.com/docs/stable/cockroach-workload) demo
* The _Geo Tourist_ demo app which is available in [this GitHub repo](https://github.com/cockroachlabs-field/crdb-geo-tourist-iam)

## Script for a demo (you can vary to suit your goals)

**Note:** over time, parts of this may change and need to be updated; for example:
* CockroachDB versions
* _Geo Tourist_ app version
* Documentation links

### Overall set up of GKE and CockroachDB clusters
1. `00_setup_gke.sh`: Set up your GKE cluster.  Note the prerequisites listed in
[this document](https://www.cockroachlabs.com/docs/stable/deploy-cockroachdb-with-kubernetes#hosted-gke)
1. `01_gen_certs.sh`: Generate the required SSL certificates and create the required K8s _secrets_
1. `02_apply_stateful_set.sh`: Applying CockroachDB stateful set configuration; when ready, it will print the public IP address which can be used to connect via SQL client of web browser, for DB Console (port 8080)
1. `03_sql_client.sh`: Start a SQL client pod and use it to create a _demouser_ account in CockroachDB
1. `04_pgweb_start.sh`: Use the [PGWeb SQL UI](https://github.com/sosedoff/pgweb) to access the CockroachDB cluster as _demouser_

### Option A: Run _cockroach workload_ against that CockroachDB cluster
1. Specify the time in minutes to run the workload: `export WORKLOAD_RUN_MINUTES=15`
1. `06_run_workload.sh`: Runs _cockroach workload bank_ for the specified duration (the script runs it all for you)
1. Other _cockroach workload_ options are described [here](https://www.cockroachlabs.com/docs/stable/cockroach-workload#workloads)

### Option B: Deploy the _Geo Tourist_ demo against that CockroachDB cluster
1. `08_geo_load_data.sh`: Deploy the data loader app which creates tables and loads data
1. Wait for the data loader to complete before launching the app
1. `09_geo_app_start.sh`: Deploy the app itself; when finished, it will print the public IP address of the app

### Day two operations
1. `10_scale_out.sh`: Add a 4th node to the CockroachDB cluster (zero down time)
1. `11_rolling_upgrade.sh`: Perform a zero downtime rolling upgrade of the CockroachDB cluster
1. `12_kill_a_node.sh`: Kill one of the CockroachDB nodes and observe effects via DB Console and/or the app
1. `13_psql_cli.sh`: Use the `psql` CLI to connect to the CockroachDB cluster
1. `14_create_backup_schedule.sh`: Create a backup schedule for _defaultdb_. When this script is run, it outputs a list of requirements (Enterprise license, Cloud Storage bucket, service account with key).

### Clean it all up
1. `20_clean_up.sh`: Clean up the app and the CockroachDB components
1. `21_gke_delete_cluster.sh`: Delete the GKE cluster itself

