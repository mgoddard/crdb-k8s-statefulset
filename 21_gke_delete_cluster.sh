#!/bin/bash

. ./gke_env.sh

echo "Deleting the entire GKE cluster ..."
gcloud container clusters delete $NAME --region=$REGION --quiet

rm -f ./gke_env.sh

