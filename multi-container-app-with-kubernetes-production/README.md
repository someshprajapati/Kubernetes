# Multi Container App Deployment on Google Kubernetes Engine (GKE) for Production Environment

### Preparing the app for the GKE 
S😎MESH~[multi-container-app-with-kubernetes-production (master)]-$ **ls -l**
```
-rw-r--r--   1 someshprajapati  staff  13562 Jul 13 20:52 README.md
drwxr-xr-x@ 11 someshprajapati  staff    352 Jul 13 20:52 client
drwxr-xr-x  14 someshprajapati  staff    448 Jul 13 20:52 k8s
drwxr-xr-x@  9 someshprajapati  staff    288 Jul 13 20:52 server
drwxr-xr-x@  8 someshprajapati  staff    256 Jul 13 20:52 worker
```

### Running the ruby container on Mac for Travis configuration
##### Note: Using container to avoid the ruby install on Mac
S😎MESH~[multi-container-app-with-kubernetes-production (master)]-$ **docker run -it -v $(pwd):/app ruby:2.4 sh**
```
Unable to find image 'ruby:2.4' locally
2.4: Pulling from library/ruby
e867cf779be3: Pull complete
62af18474b7a: Pull complete
Digest: sha256:c15e108473724fd2fde6045657f905b411eea638be1ca97713a462e90db78da7
Status: Downloaded newer image for ruby:2.4
```

## Next few commands we need to run inside the ruby container
**# gem install travis**
```
Successfully installed multipart-post-2.1.1
Successfully installed faraday-1.0.1
Successfully installed faraday_middleware-1.0.0
Successfully installed highline-2.0.3
Successfully installed concurrent-ruby-1.1.6
Successfully installed travis-1.9.1
23 gems installed
```

**# travis**
```
Shell completion not installed. Would you like to install it now? |y| n
Usage: travis COMMAND ...
```

**# travis login**
```
We need your GitHub login to identify you.
This information will not be sent to Travis CI, only to api.github.com.
The password will not be displayed.

Try running with --github-token or --auto if you don't want to enter your password anyway.

Username: someshprajapati
Password for someshprajapati: ************
Successfully logged in as someshprajapati!
```

**# pwd**
```
/
```

**# ls**
```
app  bin  boot	dev  etc  home	lib  lib64  media  mnt	opt  proc  root  run  sbin  srv  sys  tmp  usr	var
```

**# cd /app**

**# ls**
```
README.md  client  k8s	server	service-account.json  worker
```

**# travis encrypt-file service-account.json -r someshprajapati/multi-container-app-with-kubernetes-production**
```
encrypting service-account.json for someshprajapati/multi-container-app-with-kubernetes-production
storing result as service-account.json.enc
storing secure env variables for decryption

Please add the following to your build script (before_install stage in your .travis.yml, for instance):

    openssl aes-256-cbc -K $encrypted_9f3b5599b056_key -iv $encrypted_9f3b5599b056_iv -in service-account.json.enc -out service-account.json -d

Pro Tip: You can add it automatically by running with --add.

Make sure to add service-account.json.enc to the git repository.
Make sure not to add service-account.json to the git repository.
Commit all changes to your .travis.yml.
```

**# ls**
```
README.md  client  k8s	server	service-account.json  service-account.json.enc	worker
```

**# exit**


### On Google Cloud Terminal we are installing the `helm` to follow the below steps:

soprajap@cloudshell:~ (multi-kubernetes-production)$ **kubectl create secret generic pgpassword --from-literal PGPASSWORD=test123**
```                                                          
secret/pgpassword created
```

## Steps to install `helm` on Google Cloud Project

This note is if you wish to use the latest version of Helm, which is now v3. This is a major update, as it removes the use of Tiller.

1. **Install Helm v3:**
In your Google Cloud Console run the following:
```
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
```  

Link to the docs: https://helm.sh/docs/intro/install/#from-script

2. **Install Ingress-Nginx:**
In your Google Cloud Console run the following:
```
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm install my-release ingress-nginx/ingress-nginx
```   

Link to the docs: https://kubernetes.github.io/ingress-nginx/deploy/#using-helm


### Now we are installing the `helm` on Google Cloud Terminal
soprajap@cloudshell:~ (multi-kubernetes-production)$ **curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3**
soprajap@cloudshell:~ (multi-kubernetes-production)$ **chmod 700 get_helm.sh**
soprajap@cloudshell:~ (multi-kubernetes-production)$ **./get_helm.sh**
```
Helm v3.2.4 is available. Changing from version v3.2.1.
Downloading https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz
Preparing to install helm into /usr/local/bin
helm installed into /usr/local/bin/helm
```

### Get the namespaces on Google Cloud Terminal
soprajap@cloudshell:~ (multi-kubernetes-production)$ **kubectl get namespaces**
NAME              STATUS   AGE
default           Active   166m
kube-node-lease   Active   166m
kube-public       Active   166m
kube-system       Active   166m

### Create the service account for `tiller` under namespace `kube-system` on Google Cloud Terminal
soprajap@cloudshell:~ (multi-kubernetes-production)$ **kubectl create serviceaccount --namespace kube-system tiller**
```
serviceaccount/tiller created
```

### Create the cluster-admin role for `tiller`
soprajap@cloudshell:~ (multi-kubernetes-production)$ **kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller**
```
clusterrolebinding.rbac.authorization.k8s.io/tiller-cluster-rule created
```


soprajap@cloudshell:~ (multi-kubernetes-production)$ **helm install my-nginx stable/nginx-ingress --set rbac.create=true**
```
NAME: my-nginx
LAST DEPLOYED: Tue Jul 14 10:00:08 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The nginx-ingress controller has been installed.
It may take a few minutes for the LoadBalancer IP to be available.
You can watch the status by running 'kubectl --namespace default get services -o wide -w my-nginx-nginx-ingress-controller'
An example Ingress that makes use of the controller:
  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    annotations:
      kubernetes.io/ingress.class: nginx
    name: example
    namespace: foo
  spec:
    rules:
      - host: www.example.com
        http:
          paths:
            - backend:
                serviceName: exampleService
                servicePort: 80
              path: /
    # This section is only required if TLS is to be enabled for the Ingress
    tls:
        - hosts:
            - www.example.com
          secretName: example-tls
If TLS is enabled for the Ingress, a Secret containing the certificate and key must also be provided:
  apiVersion: v1
  kind: Secret
  metadata:
    name: example-tls
    namespace: foo
  data:
    tls.crt: <base64 encoded cert>
    tls.key: <base64 encoded key>
  type: kubernetes.io/tls
```
