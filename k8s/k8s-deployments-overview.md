## K8s Deployments Overview
Relevant Documentation
[Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

Log in to your Control Plane server.
Create a deployment specification file.
```bash
vi my-deployment.yml
```
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
    app: my-deployment
  template:
    metadata:
      labels:
        app: my-deployment
    spec:
      containers:
      - name: nginx
        image: nginx:1.19.1
        ports:
          - containerPort: 80
```
Create the deployment.
```bash
kubectl create -f my-deployment.yml
```
Check the deployment status.
```bash
kubectl get deployments
```
Examine pods created by the deployment.
```bash
kubectl get pods
```
