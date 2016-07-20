# haproxy-consul-template
Alpine docker container hosting HAProxy with dynamic config updating through consul-template with process supervision using s6

## About this image

This creates a small container with [s6] supervisor running and monitoring HAProxy and consul-template. The container runs two instances of HAProxy in order to let us keep HAProxy's graceful restart while still having supervision of the process.

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

You must include the following `destination=` and `command=` in the `template{}` block of your config file in order to propery reload the HAProxy configuration:

```javascript
template {
  destination = "/etc/haproxy/haproxy.cfg"
  command = "restart-haproxy"
}
```
#### What does the the restart script do?

First, we tell the current HAProxy to not restart itself when killed, because by default s6 will keep restarting the process (like a good supervisor should). Next, we start the alternate instance of HAProxy (which in turn softly kills `haproxy -db -f /etc/haproxy/haproxy.cfg -sf $(pidof haproxy)` the old HAProxy instance). Then we change the links of the alternate instance to the current instance and vice versa in order for the next restart to work properly. You can read more about the idea [directly from the creator of s6].


[s6]: http://skarnet.org/software/s6/
[read]: https://github.com/just-containers/s6-overlay
[about]: https://blog.tutum.co/2014/12/02/docker-and-s6-my-new-favorite-process-supervisor/
[here]: https://blog.tutum.co/2015/05/20/s6-made-easy-with-the-s6-overlay/
[directly from the creator of s6]: https://www.mail-archive.com/supervision@list.skarnet.org/msg01213.html
