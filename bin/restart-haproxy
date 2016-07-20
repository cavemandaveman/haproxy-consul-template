#!/bin/sh

HAPROXY_CURRENT=$(readlink /haproxy-current)
HAPROXY_ALT=$(readlink /haproxy-alt)

s6-svc -O $HAPROXY_CURRENT
s6-svc -u $HAPROXY_ALT

ln -sfn $HAPROXY_ALT /haproxy-current
ln -sfn $HAPROXY_CURRENT /haproxy-alt
