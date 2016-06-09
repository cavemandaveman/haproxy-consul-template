FROM alpine:3.4

MAINTAINER cavemandaveman <cavemandaveman@openmailbox.org>

ENV S6_VERSION="v1.17.2.0" \
    CONSUL_TEMPLATE_VERSION="0.14.0"

RUN apk --no-cache add openssl \
    haproxy \
    && wget -qO - https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz \
    | tar -zxC / \
    && wget -qO "/consul-template.zip" "https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" \
    && unzip -qd "/usr/local/bin/" "/consul-template.zip" \
    && rm "/consul-template.zip"

COPY haproxy/ /etc/services.d/haproxy/
COPY consul-template/ /etc/services.d/consul-template/
COPY 00-init-consul-template.sh /etc/cont-init.d/

ENTRYPOINT ["/init"]
