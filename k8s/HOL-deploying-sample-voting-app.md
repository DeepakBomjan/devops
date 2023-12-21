## Deploy voting app

### Clone repo
```bash
git clone https://github.com/dockersamples/example-voting-app
```

### Create new namespace vote
```bash
kubectl create  namespace vote
```

### Deploy voting app
```bash
kubectl create -f k8s-specifications/
```

### Check pods
```bash
kubectl get pods --namespace=vote
```
### Check deployments
```bash
kubectl get deployment --namespace=vote
```

### Get service
```bash
kubectl get service --namespace=vote
```
