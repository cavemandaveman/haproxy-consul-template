# haproxy-consul-template
Alpine docker container hosting HAProxy with dynamic config updating through consul-template

## About this image

This creates a small container with [s6] supervisor running and monitoring HAProxy and consul-template.

#### Why s6?

1. We need to run more than one process inside the container
2. Small, minimal footprint
3. Secure and stable

You can [read] more [about] s6 [here].

## How to use this image

Run the container with a bind mount on the directory that has your consul-template configuration:
```
docker run -d -v /path/to/consul-template/config/:/consul-template/config.d/ clearent/haproxy-consul-template:latest
```

You must include the following `destination` and `command` in the `template` block of your config file in order to propery reload the HAProxy configuration:

```javascript
template {
  destination = "/etc/haproxy/haproxy.cfg"
  command = "s6-svc -wR -t /var/run/s6/services/haproxy/"
}
```
#### What does the command you are telling consul-template to do mean?

This [s6-svc] command sends `SIGTERM` to our s6 haproxy service, waits for s6 to restart it, and blocks until it has notified that it is ready to serve again. This provides us with high stability and near zero downtime.

#### Why not just have consul-template restart the haproxy service conventionally?

Restarting conventionally, with (`haproxy -f /etc/haproxy/haproxy.cfg -sf $(pidof haproxy)`), will kill the s6 haproxy service and create a new HAProxy process. However, this process will no longer be supervised by s6, which means we have a rogue, unmonitored HAProxy process.


[s6]: http://skarnet.org/software/s6/
[read]: https://github.com/just-containers/s6-overlay
[about]: https://blog.tutum.co/2014/12/02/docker-and-s6-my-new-favorite-process-supervisor/
[here]: https://blog.tutum.co/2015/05/20/s6-made-easy-with-the-s6-overlay/
[s6-svc]: http://www.skarnet.org/software/s6/s6-svc.html
