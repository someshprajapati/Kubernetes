# Multi Container App with Kubernetes for dev environment

### Apply the deployment `client-deployment` and service `client-cluster-ip-service`
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl apply -f k8s**
```
service/client-cluster-ip-service created
deployment.apps/client-deployment created
```

### Get the deployments details
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get deployments**
```
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
client-deployment   3/3     3            3           13s
```

### Get the pods
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get pods**
```
NAME                                 READY   STATUS    RESTARTS   AGE
client-deployment-6fc4f8df6f-djm8d   1/1     Running   0          23s
client-deployment-6fc4f8df6f-mbbz2   1/1     Running   0          23s
client-deployment-6fc4f8df6f-vsrlw   1/1     Running   0          23s
```

### Get the services
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get services**
```
NAME                        TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
client-cluster-ip-service   ClusterIP   10.97.99.237   <none>        3050/TCP   35m
kubernetes                  ClusterIP   10.96.0.1      <none>        443/TCP    28d
```

### Apply the deployment `server-deployment`, `worker-deployment` and service `server-cluster-ip-service`
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl apply -f k8s**
```
service/client-cluster-ip-service unchanged
deployment.apps/client-deployment unchanged
service/server-cluster-ip-service created
deployment.apps/server-deployment created
deployment.apps/worker-deployment created
```

### Get the pods
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get pods**
```
NAME                                 READY   STATUS    RESTARTS   AGE
client-deployment-6fc4f8df6f-djm8d   1/1     Running   0          33m
client-deployment-6fc4f8df6f-mbbz2   1/1     Running   0          33m
client-deployment-6fc4f8df6f-vsrlw   1/1     Running   0          33m
server-deployment-5dd68746d-89vft    1/1     Running   0          5m57s
server-deployment-5dd68746d-tzb96    1/1     Running   0          5m57s
server-deployment-5dd68746d-vqrw2    1/1     Running   0          5m57s
worker-deployment-bd595c6b7-mlrg2    1/1     Running   0          19s
```

### Get the deployments details
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get deployments**
```
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
client-deployment   3/3     3            3           33m
server-deployment   3/3     3            3           6m9s
worker-deployment   1/1     1            1           31s
```

### Get the services
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get services**
```
NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
client-cluster-ip-service   ClusterIP   10.97.99.237    <none>        3000/TCP   68m
kubernetes                  ClusterIP   10.96.0.1       <none>        443/TCP    28d
server-cluster-ip-service   ClusterIP   10.97.239.165   <none>        5000/TCP   3m24s
```

### Get the logs of `server-deployment`
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl logs server-deployment-5dd68746d-89vft**
```
> @ start /app
> node index.js

Listening
```

### Get the logs of `worker-deployment`
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl logs worker-deployment-bd595c6b7-mlrg2**
```
> @ start /app
> node index.js
```

### Apply the deployment `redis-deployment` and service `redis-cluster-ip-service`
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl apply -f k8s**
```
service/client-cluster-ip-service unchanged
deployment.apps/client-deployment unchanged
service/redis-cluster-ip-service created
deployment.apps/redis-deployment created
service/server-cluster-ip-service unchanged
deployment.apps/server-deployment unchanged
deployment.apps/worker-deployment unchanged
```

### Get the services
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get services**
```
NAME                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
client-cluster-ip-service   ClusterIP   10.97.99.237     <none>        3000/TCP   75m
kubernetes                  ClusterIP   10.96.0.1        <none>        443/TCP    28d
redis-cluster-ip-service    ClusterIP   10.106.171.185   <none>        6379/TCP   18s
server-cluster-ip-service   ClusterIP   10.97.239.165    <none>        5000/TCP   9m41s
```

### Apply the deployment `postgres-deployment` and service `postgres-cluster-ip-service`
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl apply -f k8s**
```
service/client-cluster-ip-service unchanged
deployment.apps/client-deployment unchanged
service/postgres-cluster-ip-service created
deployment.apps/postgres-deployment created
service/redis-cluster-ip-service unchanged
deployment.apps/redis-deployment unchanged
service/server-cluster-ip-service unchanged
deployment.apps/server-deployment unchanged
deployment.apps/worker-deployment unchanged
```

### Get the storageclass
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get storageclass**
```
NAME                 PROVISIONER          AGE
hostpath (default)   docker.io/hostpath   28d
```

### Describe the storageclass
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl describe storageclass**
```
Name:            hostpath
IsDefaultClass:  Yes
Annotations:     kubectl.kubernetes.io/last-applied-configuration={"apiVersion":"storage.k8s.io/v1","kind":"StorageClass","metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"},"name":"hostpath"},"provisioner":"docker.io/hostpath","reclaimPolicy":"Delete","volumeBindingMode":"Immediate"}
,storageclass.kubernetes.io/is-default-class=true
Provisioner:           docker.io/hostpath
Parameters:            <none>
AllowVolumeExpansion:  <unset>
MountOptions:          <none>
ReclaimPolicy:         Delete
VolumeBindingMode:     Immediate
Events:                <none>
```

### Apply the PVC `database-persistent-volume-claim`
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl apply -f k8s**
```
service/client-cluster-ip-service unchanged
deployment.apps/client-deployment unchanged
persistentvolumeclaim/database-persistent-volume-claim created
service/postgres-cluster-ip-service unchanged
deployment.apps/postgres-deployment unchanged
service/redis-cluster-ip-service unchanged
deployment.apps/redis-deployment unchanged
service/server-cluster-ip-service unchanged
deployment.apps/server-deployment unchanged
deployment.apps/worker-deployment unchanged
```

### Get the persistent-volume details
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get pv**
```
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                      STORAGECLASS   REASON   AGE
pvc-8860e4c2-90f3-4aee-9f8c-da85829a14cc   2Gi        RWO            Delete           Bound    default/database-persistent-volume-claim   hostpath                45s
```

### Get the persistent-volume-claim details
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get pvc**
```
NAME                               STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
database-persistent-volume-claim   Bound    pvc-8860e4c2-90f3-4aee-9f8c-da85829a14cc   2Gi        RWO            hostpath       16m
```

### Get the pods
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get pods**
```
NAME                                   READY   STATUS             RESTARTS   AGE
client-deployment-6fc4f8df6f-dx6jb     1/1     Running            0          2m9s
client-deployment-6fc4f8df6f-j8nzb     1/1     Running            0          2m9s
client-deployment-6fc4f8df6f-xp2x7     1/1     Running            0          2m9s
postgres-deployment-6767f87b54-p6b2m   0/1     CrashLoopBackOff   3          2m9s
redis-deployment-5f458546b8-wzggz      1/1     Running            0          2m9s
server-deployment-5dd68746d-7xz7l      1/1     Running            0          2m9s
server-deployment-5dd68746d-vdvww      1/1     Running            0          2m9s
server-deployment-5dd68746d-vztn2      1/1     Running            0          2m9s
worker-deployment-bd595c6b7-bpzxs      1/1     Running            0          2m9s
```

### Create the secret which we are going to use in postgres DB
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl create secret generic pgpassword --from-literal PGPASSWORD=test123**
```
secret/pgpassword created
```

### Get the secrets details
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get secrets**
```
NAME                  TYPE                                  DATA   AGE
default-token-qfhgv   kubernetes.io/service-account-token   3      29d
pgpassword            Opaque                                1      16s
```

### Apply the changes after putting the secrets in `postgres-deployment` and `server-deployment`
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl apply -f k8s**
```
service/client-cluster-ip-service unchanged
deployment.apps/client-deployment unchanged
persistentvolumeclaim/database-persistent-volume-claim unchanged
service/postgres-cluster-ip-service unchanged
deployment.apps/postgres-deployment unchanged
service/redis-cluster-ip-service unchanged
deployment.apps/redis-deployment unchanged
service/server-cluster-ip-service unchanged
deployment.apps/server-deployment configured
deployment.apps/worker-deployment configured
```

### Get the pods for `ingress-nginx`
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get pods -n ingress-nginx**
```
No resources found in ingress-nginx namespace.
```

### Use the `ingress-nginx` repo and apply the `ingress-nginx` controller
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.0/deploy/static/provider/cloud/deploy.yaml**
```
namespace/ingress-nginx created
serviceaccount/ingress-nginx created
configmap/ingress-nginx-controller created
clusterrole.rbac.authorization.k8s.io/ingress-nginx created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx created
role.rbac.authorization.k8s.io/ingress-nginx created
rolebinding.rbac.authorization.k8s.io/ingress-nginx created
service/ingress-nginx-controller-admission created
service/ingress-nginx-controller created
deployment.apps/ingress-nginx-controller created
validatingwebhookconfiguration.admissionregistration.k8s.io/ingress-nginx-admission created
clusterrole.rbac.authorization.k8s.io/ingress-nginx-admission created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
job.batch/ingress-nginx-admission-create created
job.batch/ingress-nginx-admission-patch created
role.rbac.authorization.k8s.io/ingress-nginx-admission created
rolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
serviceaccount/ingress-nginx-admission created
```

### Get the pods for `ingress-nginx`
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl get pods -n ingress-nginx**
```
NAME                                        READY   STATUS      RESTARTS   AGE
ingress-nginx-admission-create-94zx5        0/1     Completed   0          106s
ingress-nginx-admission-patch-l9jzf         0/1     Completed   0          106s
ingress-nginx-controller-68679c6884-9w4s4   1/1     Running     0          116s
```

### Apply the service `ingress-service`
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl apply -f k8s**
```
service/client-cluster-ip-service unchanged
deployment.apps/client-deployment unchanged
persistentvolumeclaim/database-persistent-volume-claim unchanged
ingress.extensions/ingress-service created
service/postgres-cluster-ip-service unchanged
deployment.apps/postgres-deployment unchanged
service/redis-cluster-ip-service unchanged
deployment.apps/redis-deployment unchanged
service/server-cluster-ip-service unchanged
deployment.apps/server-deployment unchanged
deployment.apps/worker-deployment unchanged
```

### Get the kubernetes-dashboard used by Docker Desktop based Kubernetes
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **curl -O https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml**
```
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  4577  100  4577    0     0   9398      0 --:--:-- --:--:-- --:--:--  9398
```

### Apply the `kubernetes-dashboard` configuration
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl apply -f k8s/kubernetes-dashboard.yaml**
```
secret/kubernetes-dashboard-certs created
serviceaccount/kubernetes-dashboard created
role.rbac.authorization.k8s.io/kubernetes-dashboard-minimal created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard-minimal created
deployment.apps/kubernetes-dashboard created
service/kubernetes-dashboard created
```

### Start the kubernetes proxy to check the dev app on `kubernetes-dashboard`
S😎MESH~[multi-container-app-with-kubernetes (master)]-$ **kubectl proxy**
```
Starting to serve on 127.0.0.1:8001
```

