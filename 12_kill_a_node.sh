#!/bin/bash

kubectl delete pod cockroachdb-1 --grace-period 0 --force

