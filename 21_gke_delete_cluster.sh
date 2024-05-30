#!/bin/bash

. ./gke_env.sh

gcloud container clusters delete $NAME --region=$REGION --quiet && rm -f ./gke_env.sh

