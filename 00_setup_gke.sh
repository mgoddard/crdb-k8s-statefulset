#!/bin/bash

MACHINETYPE="e2-standard-4" # 4	vCPU, 16 GB RAM, $0.134012/hour
N_NODES=2 # This will create N_NODES *per AZ* within REGION
REGION="us-east4"

DATE=$( date '+%Y%m%d' )
NAME="${USER}-${DATE}"

# Create the GKE K8s cluster
# See https://www.cockroachlabs.com/docs/stable/orchestrate-cockroachdb-with-kubernetes.html#hosted-gke"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
echo "Creating GKE cluster in $REGION with $N_NODES per AZ ..."
gcloud container clusters create $NAME --region=$REGION --machine-type=$MACHINETYPE --num-nodes=$N_NODES
echo "Done"

# Set role binding
ACCOUNT=$( gcloud info | perl -ne 'print "$1\n" if /^Account: \[([^@]+@[^\]]+)\]$/' )
echo "Creating cluster role binding for user $ACCOUNT to cluster-admin ..."
kubectl create clusterrolebinding $USER-cluster-admin-binding --clusterrole=cluster-admin --user=$ACCOUNT
echo "Done"

