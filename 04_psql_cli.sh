#!/bin/bash

lb_ip=$( kubectl describe service crdb-lb | perl -ne 'chomp; print "$1\n" if /^LoadBalancer Ingress:\s+((\d+\.){3}\d+)/;' )

cert="./certs/ca.crt"

export PAGER=cat # Disable paging
psql "postgresql://demouser:demopasswd@${lb_ip}:26257/defaultdb?sslmode=require&sslrootcert=$cert"

