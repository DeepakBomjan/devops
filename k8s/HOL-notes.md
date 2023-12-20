
## Simple pod deployment
```bash
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80

```

## To create the Pod
```bash
kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml
```


## Batch job
```bash
apiVersion: batch/v1
kind: Job
metadata:
  name: hello
spec:
  template:
    # This is the pod template
    spec:
      containers:
      - name: hello
        image: busybox:1.28
        command: ['sh', '-c', 'echo "Hello, Kubernetes!" && sleep 3600']
      restartPolicy: OnFailure
    # The pod template ends here
```

## Creating a Deployment
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80

```
## Run deployment
```bash
kubectl apply -f https://k8s.io/examples/controllers/nginx-deployment.yaml
```
## To check the deployment
```bash
kubectl get deployments
## To see the Deployment rollout status
kubectl rollout status deployment/nginx-deployment
```
## To see the labels automatically generated for each Pod
```bash
kubectl get pods --show-labels
```

## Get details of your Deployment
```bash
kubectl describe deployments
```
## manually scale a Deployment
```bash
kubectl scale deployment nginx-deployment --replicas=5
```
## When to use a ReplicaSet
```bash
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: frontend
  labels:
    app: guestbook
    tier: frontend
spec:
  # modify replicas according to your case
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: gcr.io/google_samples/gb-frontend:v3

```

## To apply
```bash
kubectl apply -f https://kubernetes.io/examples/controllers/frontend.yaml
kubectl get rs
```

## Get yaml of one of the pod
```bash
kubectl get pods frontend-b2zdv -o yaml
```

## Rolling update
```bash
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2
```
