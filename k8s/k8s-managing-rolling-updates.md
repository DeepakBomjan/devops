## Managing Rolling Updates With Deployments
Relevant Documentation
[Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment)
[Rolling Back a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-back-a-deployment)

Log in to your Control Plane server.
Edit the deployment spec, changing the image version to 1.19.2 .
```bash
kubectl edit deployment my-deployment
```
```yaml
...
spec:
containers:
- name: nginx
  image: nginx:1.19.2
...
```

Check the rollout status, deployment status, and pods.
```bash
kubectl rollout status deployment.v1.apps/my-deployment
kubectl get deployment my-deployment
kubectl get pods
```
Perform another rollout, this time using the kubectl set image method. Intentionally use a bad image version.
```bash
kubectl set image deployment/my-deployment nginx=nginx:broken --record
```
Check the rollout status again. You will see the rollout unable to succeed due to a failed image pull.
```bash
kubectl rollout status deployment.v1.apps/my-deployment
kubectl get pods
```
Check the rollout history.
```bash
kubectl rollout history deployment.v1.apps/my-deployment
```
Roll back to an earlier working version with one of the following methods.
```bash
kubectl rollout undo deployment.v1.apps/my-deployment
```
Or:
```bash
kubectl rollout undo deployment.v1.apps/my-deployment --to-revision=<last working revision>
```
