## Creating a service for an application running in five pods

Run a Hello World application in your cluster:

### Create namespace
```bash
kubectl create ns lb
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/name: load-balancer-example
  name: hello-world
spec:
  replicas: 5
  selector:
    matchLabels:
      app.kubernetes.io/name: load-balancer-example
  template:
    metadata:
      labels:
        app.kubernetes.io/name: load-balancer-example
    spec:
      containers:
      - image: gcr.io/google-samples/node-hello:1.0
        name: hello-world
        ports:
        - containerPort: 8080

```

```bash
kubectl apply -f https://k8s.io/examples/service/load-balancer-example.yaml -n lb
```

### Display information about the Deployment:
```bash
kubectl get deployments hello-world -n lb
kubectl describe deployments hello-world -n lb
```

### Display information about your ReplicaSet objects
```bash
kubectl get replicasets -n lb
kubectl describe replicasets -n lb
```

### Create a Service object that exposes the deployment
```bash
kubectl expose deployment hello-world --type=LoadBalancer --name=my-service
```

### Display information about the Service
```bash
kubectl get services my-service
```

### Display detailed information about the Service
```bash
kubectl describe services my-service
```


### Install aws load balancer
```bash
# get cluster name
# kubectl config view --minify -o jsonpath='{.clusters[].name}'
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=kubernetes \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller 

```bash
kubectl get deployment -n kube-system aws-load-balancer-controller
```
```bash
kubectl patch svc <svc-name> -n <namespace> -p '{"spec": {"type": "LoadBalancer", "externalIPs":["172.31.71.218"]}}'
```