# Maintaining sets of containers in Kubernetes with Deployment

S😎MESH~[Kubernetes]-$ cd simple_k8s/

S😎MESH~[simple_k8s]-$ code .

## Verify the `kubectl` is installed and working using `cluster-info` command
S😎MESH~[simple_k8s]-$ **kubectl cluster-info**
```
Kubernetes master is running at https://kubernetes.docker.internal:6443
KubeDNS is running at https://kubernetes.docker.internal:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

## Basic client pod file which uses the `multi-client` image from docker hub
S😎MESH~[simple_k8s]-$ **cat client-pod.yaml**
```
apiVersion: v1
kind: Pod
metadata:
    name: client-pod
    labels:
        component: web
spec:
    containers:
      - name: client
        image: someshprajapati/multi-client
        ports:
            - containerPort: 3000
```

## Apply the configuration to create pod
S😎MESH~[simple_k8s]-$ **kubectl apply -f client-pod.yaml**
```
pod/client-pod created
```

## Apply the configuration to create service
S😎MESH~[simple_k8s]-$ **kubectl apply -f client-node-port.yaml**
```
service/client-node-port created
```

## Get the running pod
S😎MESH~[simple_k8s]-$ **kubectl get pods**
```
NAME         READY   STATUS    RESTARTS   AGE
client-pod   1/1     Running   0          112s
```

## Get the running services
S😎MESH~[simple_k8s]-$ **kubectl get services**
```
NAME               TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
client-node-port   NodePort    10.103.45.64   <none>        3050:31515/TCP   2m32s
kubernetes         ClusterIP   10.96.0.1      <none>        443/TCP          27d
```

## Basic client pod file which uses the `multi-worker` image from docker hub
#### Updated the image from `multi-client` to `multi-worker`
S😎MESH~[simple_k8s]-$ **cat client-pod.yaml**
```
apiVersion: v1
kind: Pod
metadata:
    name: client-pod
    labels:
        component: web
spec:
    containers:
      - name: client
        image: someshprajapati/multi-worker
        ports:
            - containerPort: 3000
```

## Apply the new configuration to create pod
S😎MESH~[simple_k8s]-$ **kubectl apply -f client-pod.yaml**
```
pod/client-pod configured
```

## Get the running pod
S😎MESH~[simple_k8s]-$ **kubectl get pods**
```
NAME         READY   STATUS    RESTARTS   AGE
client-pod   1/1     Running   1          17h
```

## Describe the pod details
S😎MESH~[simple_k8s]-$ **kubectl describe pod client-pod**
```
Name:         client-pod
Namespace:    default
Priority:     0
Node:         docker-desktop/192.168.65.3
Start Time:   Sat, 11 Jul 2020 17:35:49 +0530
Labels:       component=web
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"labels":{"component":"web"},"name":"client-pod","namespace":"default"},"spec...
Status:       Running
IP:           10.1.0.41
IPs:
  IP:  10.1.0.41
Containers:
  client:
    Container ID:   docker://1f6fd9a9394d65bb6666deaa5f69c9f5cbef80f4c852050b4b4bf20d7fb96564
    Image:          someshprajapati/multi-worker
    Image ID:       docker-pullable://someshprajapati/multi-worker@sha256:a7344dc03301351b48eb1c42d503a689b7e965b7efb9f36693febfb0a5313305
    Port:           3000/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Sun, 12 Jul 2020 11:29:25 +0530
    Last State:     Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Sat, 11 Jul 2020 20:15:08 +0530
      Finished:     Sun, 12 Jul 2020 11:29:12 +0530
    Ready:          True
    Restart Count:  1
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-qfhgv (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-qfhgv:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-qfhgv
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason   Age                  From                     Message
  ----    ------   ----                 ----                     -------
  Normal  Killing  2m40s                kubelet, docker-desktop  Container client definition changed, will be restarted
  Normal  Pulling  2m40s                kubelet, docker-desktop  Pulling image "someshprajapati/multi-worker"
  Normal  Pulled   2m28s                kubelet, docker-desktop  Successfully pulled image "someshprajapati/multi-worker"
  Normal  Created  2m27s (x2 over 15h)  kubelet, docker-desktop  Created container client
  Normal  Started  2m27s (x2 over 15h)  kubelet, docker-desktop  Started container client
```

## Updated the containerPort from `3000` to `9000`
S😎MESH~[simple_k8s]-$ **cat client-pod.yaml**
```
apiVersion: v1
kind: Pod
metadata:
    name: client-pod
    labels:
        component: web
spec:
    containers:
      - name: client
        image: someshprajapati/multi-worker
        ports:
            - containerPort: 9000
```

## Apply the new configuration to create pod
#### The Pod "client-pod" is invalid: spec: Forbidden: pod updates may not change fields other than `spec.containers[*].image`, `spec.initContainers[*].image`, `spec.activeDeadlineSeconds` or `spec.tolerations` (only additions to existing tolerations)

S😎MESH~[simple_k8s]-$ **kubectl apply -f client-pod.yaml**
```
The Pod "client-pod" is invalid: spec: Forbidden: pod updates may not change fields other than `spec.containers[*].image`, `spec.initContainers[*].image`, `spec.activeDeadlineSeconds` or `spec.tolerations` (only additions to existing tolerations)
  core.PodSpec{
  	Volumes:        []core.Volume{{Name: "default-token-qfhgv", VolumeSource: core.VolumeSource{Secret: &core.SecretVolumeSource{SecretName: "default-token-qfhgv", DefaultMode: &420}}}},
  	InitContainers: nil,
  	Containers: []core.Container{
  		{
  			... // 3 identical fields
  			Args:       nil,
  			WorkingDir: "",
  			Ports: []core.ContainerPort{
  				{
  					Name:          "",
  					HostPort:      0,
- 					ContainerPort: 9000,
+ 					ContainerPort: 3000,
  					Protocol:      "TCP",
  					HostIP:        "",
  				},
  			},
  			EnvFrom: nil,
  			Env:     nil,
  			... // 14 identical fields
  		},
  	},
  	EphemeralContainers: nil,
  	RestartPolicy:       "Always",
  	... // 24 identical fields
  }
```

## Basic deployment file which uses the `multi-client` image from docker hub
S😎MESH~[simple_k8s]-$ **cat client-deployment.yaml**
```
apiVersion: apps/v1
kind: Deployment
metadata:
    name: client-deployment
spec:
    replicas: 1
    selector:
        matchLabels:
            component: web
    template:
        metadata:
            labels:
                component: web
        spec:
            containers:
              - name: client
                image: someshprajapati/multi-client
                ports:
                    - containerPort: 3000
```

## Apply the deployment
S😎MESH~[simple_k8s]-$ **kubectl apply -f client-deployment.yaml**
```
deployment.apps/client-deployment created
```

## Get the deployment
S😎MESH~[simple_k8s]-$ **kubectl get deployments**
```
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
client-deployment   0/1     1            0           5s
```

## Get the pods (still creating)
S😎MESH~[simple_k8s]-$ **kubectl get pods**
```
NAME                                 READY   STATUS              RESTARTS   AGE
client-deployment-85c9c4447b-xgfkn   0/1     ContainerCreating   0          11s
```

## Get the pods again (running)
S😎MESH~[simple_k8s]-$ **kubectl get pods**
```
NAME                                 READY   STATUS    RESTARTS   AGE
client-deployment-85c9c4447b-xgfkn   1/1     Running   0          64s
```

## Get the deployment again
S😎MESH~[simple_k8s]-$ **kubectl get deployments**
```
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
client-deployment   1/1     1            1           96s
```

S😎MESH~[simple_k8s]-$ **kubectl get pods -o wide**
```
NAME                                 READY   STATUS    RESTARTS   AGE     IP          NODE             NOMINATED NODE   READINESS GATES
client-deployment-85c9c4447b-xgfkn   1/1     Running   0          4m12s   10.1.0.52   docker-desktop   <none>           <none>
```

S😎MESH~[simple_k8s]-$ **ls -l**
```
-rw-r--r--   1 someshprajapati  staff  15063 Jul 12 12:49 README.md
drwxr-xr-x  12 someshprajapati  staff    384 Jul 12 13:12 client
-rw-r--r--   1 someshprajapati  staff    424 Jul 12 12:24 client-deployment.yaml
-rw-r--r--   1 someshprajapati  staff    218 Jul 11 17:26 client-node-port.yaml
-rw-r--r--   1 someshprajapati  staff    226 Jul 12 12:21 client-pod.yaml
```

S😎MESH~[simple_k8s]-$ **cd client**
S😎MESH~[client]-$ **ls -l**
```
-rw-r--r--   1 someshprajapati  staff     330 Jul 12 13:12 Dockerfile
-rw-r--r--   1 someshprajapati  staff     195 Jul 12 13:12 Dockerfile.dev
-rw-r--r--   1 someshprajapati  staff  119451 Jul 12 13:12 README.md
drwxr-xr-x   3 someshprajapati  staff      96 Jul 12 13:12 nginx
drwxr-xr-x   2 someshprajapati  staff      64 Jul 12 13:12 node_modules
-rw-r--r--   1 someshprajapati  staff     399 Jul 12 13:12 package.json
drwxr-xr-x   5 someshprajapati  staff     160 Jul 12 13:12 public
drwxr-xr-x  11 someshprajapati  staff     352 Jul 12 13:12 src
```

## Create the new `multi-client-k8s` image 
S😎MESH~[client]-$ **docker build -t someshprajapati/multi-client-k8s .**
```
Sending build context to Docker daemon  163.8kB
Step 1/10 : FROM node:alpine as builder
alpine: Pulling from library/node
cbdbe7a5bc2a: Already exists
bdfc8e0b7a31: Already exists
b0f8983c8893: Already exists
057ed1351239: Already exists
Digest: sha256:ae13d1ab371853dc03590ddee6b0901f0c66c3e107e78dc26e4bd673a7334b41
Status: Downloaded newer image for node:alpine
 ---> 5d97b3d11dc1
Step 2/10 : WORKDIR '/app'
 ---> Running in 0285c2c36272
Removing intermediate container 0285c2c36272
 ---> 7c37c2b26309
Step 3/10 : COPY ./package.json ./
 ---> 2ee6519aa2b3
Step 4/10 : RUN npm install
 ---> Running in fbecefcdc8ca
Removing intermediate container fbecefcdc8ca
 ---> d9d329677461
Step 5/10 : COPY ./ ./
 ---> 4493902ce4d3
Step 6/10 : RUN npm run build
 ---> Running in 02fc899e633b
Removing intermediate container 02fc899e633b
 ---> 153db60b3fd9
Step 7/10 : FROM nginx
latest: Pulling from library/nginx
8559a31e96f4: Already exists
1cf27aa8120b: Pull complete
67d252a8c1e1: Pull complete
9c2b660fcff6: Pull complete
4584011f2cd1: Pull complete
Digest: sha256:a93c8a0b0974c967aebe868a186e5c205f4d3bcb5423a56559f2f9599074bbcd
Status: Downloaded newer image for nginx:latest
 ---> 0901fa9da894
Step 8/10 : EXPOSE 3000
 ---> Running in 0b6fac36ecb0
Removing intermediate container 0b6fac36ecb0
 ---> ee37ed4af6b9
Step 9/10 : COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
 ---> 6b36243f8dcb
Step 10/10 : COPY --from=builder /app/build /usr/share/nginx/html
 ---> 4611c4c29eb3
Successfully built 4611c4c29eb3
Successfully tagged someshprajapati/multi-client-k8s:latest
```

## Push the new `multi-client-k8s` image to docker hub
S😎MESH~[client]-$ **docker push someshprajapati/multi-client-k8s**
```
The push refers to repository [docker.io/someshprajapati/multi-client-k8s]
dabde873ef87: Pushed
39f44df2e096: Pushed
2808ec4a8ea7: Mounted from library/nginx
4856db5e4f59: Mounted from library/nginx
7ef35766ef7d: Mounted from library/nginx
0e32546a8af0: Mounted from library/nginx
13cb14c2acd3: Mounted from someshprajapati/multi-client
latest: digest: sha256:d5c306096334b836944a05e0a351bd0fa0bc195333fc7187119467c2ffc4d577 size: 1779
```

## client-deployment with new image `multi-client-k8s`
S😎MESH~[simple_k8s]-$ **cat client-deployment.yaml**
```
apiVersion: apps/v1
kind: Deployment
metadata:
    name: client-deployment
spec:
    replicas: 1
    selector:
        matchLabels:
            component: web
    template:
        metadata:
            labels:
                component: web
        spec:
            containers:
              - name: client
                image: someshprajapati/multi-client-k8s
                ports:
                    - containerPort: 3000
```

## Update the pod with the new image at runtime
S😎MESH~[simple_k8s]-$ **kubectl set image deployment/client-deployment client=someshprajapati/multi-client-k8s**
```
deployment.apps/client-deployment image updated
```

S😎MESH~[simple_k8s]-$ **kubectl get pods**
```
NAME                                 READY   STATUS    RESTARTS   AGE
client-deployment-7f48d474dd-rkrdr   1/1     Running   0          11s
```