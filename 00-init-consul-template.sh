#!/bin/sh

/usr/local/bin/consul-template -config /consul-template/config.d -once || exit 1
