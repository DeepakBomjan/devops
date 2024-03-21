## Scaling Applications With Deployments
Relevant Documentation
[Scaling a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#scaling-a-deployment)
Log in to your Control Plane server.
Edit a deployment spec, changing the number of replicas to scale the deployment up.
```bash
vi my-deployment.yml
```
```yaml
...
spec:
replicas: 5
...
```

Update the deployment.
```bash
kubectl apply -f my-deployment.yml
```
Examine the deployment and it's pods to see it scale up.
```bash
kubectl get deployments
kubectl get pods
```
Scale the deployment back down to 3 replicas. This time, use the 
kubectl scale method.
```bash
kubectl scale deployment.v1.apps/my-deployment --replicas=3
```
Check the status of the deployment and its pods again.
```bash
kubectl get deployment
kubectl get pods
```
