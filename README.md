# Concourse CI on Kubernetes

This is a proof of concept to see whether it's possible to run [Concourse CI](http://concourse.ci) in a [Kubernetes](http://kubernetes.io) cluster.

## Status

The concourse-web pod seems to run with no issues. However, the concourse-worker pod currently logs the following error:

```
{"timestamp":"1458141620.837122202","source":"worker","message":"worker.baggageclaim.fs.run-command.failed","log_level":2,"data":{"args":["bash","-e","-x","-c","\n\t\tif [ ! -e $IMAGE_PATH ] || [ \"$(stat --printf=\"%s\" $IMAGE_PATH)\" != \"$SIZE_IN_BYTES\" ]; then\n\t\t\ttouch $IMAGE_PATH\n\t\t\ttruncate -s ${SIZE_IN_BYTES} $IMAGE_PATH\n\t\tfi\n\n\t\tlo=\"$(losetup -j $IMAGE_PATH | cut -d':' -f1)\"\n\t\tif [ -z \"$lo\" ]; then\n\t\t\tlo=\"$(losetup -f --show $IMAGE_PATH)\"\n\t\tfi\n\n\t\tif ! file $IMAGE_PATH | grep BTRFS; then\n\t\t\tmkfs.btrfs --nodiscard $IMAGE_PATH\n\t\tfi\n\n\t\tmkdir -p $MOUNT_PATH\n\n\t\tif ! mountpoint -q $MOUNT_PATH; then\n\t\t\tmount -t btrfs $lo $MOUNT_PATH\n\t\tfi\n\t"],"command":"/bin/bash","env":["PATH=/opt/concourse/worker/linux/btrfs:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin","MOUNT_PATH=/opt/concourse/worker/volumes","IMAGE_PATH=/opt/concourse/worker/volumes.img","SIZE_IN_BYTES=4674318336"],"error":"exit status 1","session":"2.1.1","stderr":"+ '[' '!' -e /opt/concourse/worker/volumes.img ']'\n++ stat --printf=%s /opt/concourse/worker/volumes.img\n+ '[' 4674318336 '!=' 4674318336 ']'\n++ cut -d: -f1\n++ losetup -j /opt/concourse/worker/volumes.img\n+ lo=\n+ '[' -z '' ']'\n++ losetup -f --show /opt/concourse/worker/volumes.img\nlosetup: cannot find an unused loop device\n+ lo=\n","stdout":""}}
failed to set up volumes filesystem: exit status 1
```

This is probably a problem with mounting volumes inside of the Docker container. I'm still investigating.

## Deployment

To deploy Concourse to Kubernetes, first clone this repository:

```
git clone https://github.com/vyshane/concourse-kubernetes.git
```

Then run the `up.sh` script:

```
cd concourse-kubernetes
./up.sh
```

The script will deploy Concourse to the Kubernetes cluster & namespace currently targeted by your kubectl context.

To undo the deployment, run:

```
./down.sh
```

## Secrets

This repository ships with some example secrets so that you can get a demo up and running quickly. You will want to generate your own credentials and keys before deploying Concourse CI to production. These reside in the following configuration files:

  * [manifests/concourse-secrets.yaml](manifests/concourse-secrets.yaml)
  * [manifests/concourse-postgresql-secrets.yaml](manifests/concourse-postgresql-secrets.yaml)

Refer to the [Concourse binary distribution documentation](https://github.com/concourse/bin) for more information on how to generate the web and worker keys.

## Docker Images

I've created the following Docker images for use in this project:

  * [vyshane/concourse-base](https://github.com/vyshane/concourse-base-docker) [[Docker Hub link](https://hub.docker.com/r/vyshane/concourse-base/)]
  * [vyshane/concourse-web](https://github.com/vyshane/concourse-web-docker) [[Docker Hub link](https://hub.docker.com/r/vyshane/concourse-web/)]
  * [vyshane/concourse-worker](https://github.com/vyshane/concourse-worker-docker) [[Docker Hub link](https://hub.docker.com/r/vyshane/concourse-worker/)]

The `vyshane/concourse-base` image packages the Concourse binary distribution.

The `vyshane/concourse-web` and `vyshane/concourse-worker` images implement the web and worker roles respectively.
