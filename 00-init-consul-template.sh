#!/bin/sh

ln -s /var/run/s6/services/haproxy1 /haproxy-current
ln -s /var/run/s6/services/haproxy2 /haproxy-alt
consul-template -config /consul-template/config.d -once
