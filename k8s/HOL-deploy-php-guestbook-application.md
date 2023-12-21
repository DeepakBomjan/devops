## Example: Deploying PHP Guestbook application with Redis


```yaml
# SOURCE: https://cloud.google.com/kubernetes-engine/docs/tutorials/guestbook
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-leader
  labels:
    app: redis
    role: leader
    tier: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
        role: leader
        tier: backend
    spec:
      containers:
      - name: leader
        image: "docker.io/redis:6.0.5"
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
        - containerPort: 6379
```

### Apply the Redis Deployment from the redis-leader-deployment.yaml
```bash
kubectl create namespace guestbook
```

```bash
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-leader-deployment.yaml -n guestbook
```
### Get pods
```bash
kubectl get pods
```

### view the logs from the Redis leader Pod
```bash
kubectl logs -f deployment/redis-leader -n guestbook
```

## Creating the Redis leader Service

```bash
# SOURCE: https://cloud.google.com/kubernetes-engine/docs/tutorials/guestbook
apiVersion: v1
kind: Service
metadata:
  name: redis-leader
  labels:
    app: redis
    role: leader
    tier: backend
spec:
  ports:
  - port: 6379
    targetPort: 6379
  selector:
    app: redis
    role: leader
    tier: backend
```
```bash
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-leader-service.yaml -n guestbook
```

### Ref link
https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller

