#!/bin/bash

# Spot prices change over time, but the relevant discounts are always in the 60-91% range.
# See "--spot", below.

MACHINETYPE="e2-standard-8" # 8 vCPU, 32 GB RAM, $0.301848/hour (<= $0.1207392 for spot instance)
#MACHINETYPE="e2-standard-4" # 4 vCPU, 16 GB RAM, $0.134012/hour
#MACHINETYPE="e2-standard-16" # 16 vCPU, 64 GB RAM, $0.701207/hour
#MACHINETYPE="t2a-standard-4" # ARM

#REGION="us-east1" # South Carolina
REGION="us-east4" # NoVA
#REGION="us-central1" # Iowa(?)
N_NODES=2 # This will create N_NODES *per AZ* within REGION

DATE=$( date '+%Y%m%d' )
NAME="${USER}-${DATE}"

# Save some of these for reuse when this cluster is deleted
# gcloud container clusters delete $NAME --region=$REGION --quiet
cat > gke_env.sh <<EoM
export NAME=$NAME
export REGION=$REGION
EoM

# Create the GKE K8s cluster
# See https://www.cockroachlabs.com/docs/stable/orchestrate-cockroachdb-with-kubernetes.html#hosted-gke"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
echo "Creating GKE cluster in $REGION with $N_NODES per AZ ..."
gcloud container clusters create $NAME --region=$REGION --machine-type=$MACHINETYPE --num-nodes=$N_NODES --spot
echo "Done"

# Set role binding
ACCOUNT=$( gcloud info | perl -ne 'print "$1\n" if /^Account: \[([^@]+@[^\]]+)\]$/' )
echo "Creating cluster role binding for user $ACCOUNT to cluster-admin ..."
kubectl create clusterrolebinding $USER-cluster-admin-binding --clusterrole=cluster-admin --user=$ACCOUNT
echo "Done"

