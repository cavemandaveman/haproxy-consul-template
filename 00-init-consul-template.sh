#!/bin/sh

/bin/ln -s /var/run/s6/services/haproxy1 /haproxy-current
/bin/ln -s /var/run/s6/services/haproxy2 /haproxy-alt
/usr/local/bin/consul-template -config /consul-template/config.d -once
