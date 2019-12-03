# Kubernetes The Hard Way (Vagrant)
Vagrant configuration and scripts for a Kubernetes setup, the hard way, add persistet volume support.
(This repository is forked and modified based on https://github.com/kinvolk/kubernetes-the-hard-way-vagrant) 

## Requirements Host
* Vagrant (with VirtualBox)
* 5GB free RAM

## Setup

### Single script

```
$ vagrant destroy -f   # remove previous setup
$ ./scripts/setup      # takes about 5 minutes or more
[...]
```

### Multiple scripts

Execute command line from `./scripts/distclean` in `./scripts/setup` step by step.

## Using the cluster

### Check cluster status

```
$ kubectl get nodes -o wide
NAME       STATUS   ROLES    AGE     VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
worker-0   Ready    <none>   3h20m   v1.13.0   192.168.199.20   <none>        Ubuntu 18.04.3 LTS   4.15.0-70-generic   cri-o://1.11.2
worker-1   Ready    <none>   3h19m   v1.13.0   192.168.199.21   <none>        Ubuntu 18.04.3 LTS   4.15.0-70-generic   cri-o://1.11.2
worker-2   Ready    <none>   3h18m   v1.13.0   192.168.199.22   <none>        Ubuntu 18.04.3 LTS   4.15.0-70-generic   cri-o://1.11.2

$ kubectl get all
NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
service/kubernetes   ClusterIP   10.32.0.1     <none>        443/TCP          3h24m
```

### Setup DNS add-on

Deploy the DNS add-on and verify it's working:

```
kubectl create -f ./manifests/kube-dns.yaml
[...]
kubectl get pods -l k8s-app=kube-dns -n kube-system
[...]
kubectl run busybox --image=busybox:1.28 --command -- sleep 3600
[...]
POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")
kubectl exec -ti $POD_NAME -- nslookup kubernetes
```

### Deploy service with Ingress Controller

```
$ kubectl apply -f ./manifests/nginx-ingress.yaml
ingress.extensions/nginx created
deployment.apps/nginx created
service/nginx created

# Access the service via Ingress Controller IP
$ curl -H "Host: nginx.virtualbox" 192.168.199.30
<!DOCTYPE html>
...
</html>
```

### Deploy Service with persistent volume

```
$ kubectl apply -f ./manifests/postgresql.yaml 
configmap/cm-psql created
persistentvolume/pv-psql created
persistentvolumeclaim/pvc-psql created
deployment.apps/deployment-psql created
service/svc-psql created

# logon at NodeIP 192.168.199.20/21/22
$ psql db -h 192.168.199.20 -p 30100 -U user
Password for user user:    # type "password"
psql (12.1)
Type "help" for help.
db=# 
```

### Connect to services from host

`10.32.0.0/24` is the IP range for services. In order to connect to a service
from the host, one of the worker nodes (with `kube-proxy`) must be used as a
gateway. Example:

```
# On Linux
sudo route add -net 10.32.0.0/24 gw 192.168.199.22

# On macOS
sudo route -n add -net 10.32.0.0/24 192.168.199.22
```