## Managing Container Resources
Relevant Documentation
[Resource Requests and Limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-requests-and-limits-of-pod-and-container)
Create a pod with resource requests that exceed aviable node resources.
```bash
vi big-request-pod.yml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: big-request-pod
spec:
  containers:
  - name: busybox
    image: busybox
    command: ['sh', '-c', 'while true; do sleep 3600; done']
    resources:
      requests:
        cpu: "10000m"
        memory: "128Mi"
```

```bash
kubectl create -f big-request-pod.yml
```
Check the pod status. It should never leave the Pending state since no worker nodes have enough resources to meet the
request.
```bash
kubectl get pod big-request-pod
```
Create a pod with resource requests and limits.
```bash
vi resource-pod.yml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: resource-pod
spec:
  containers:
  - name: busybox
    image: busybox
    command: ['sh', '-c', 'while true; do sleep 3600; done']
    resources:
    requests:
      cpu: "250m"
      memory: "128Mi"
    limits:
      cpu: "500m"
      memory: "256Mi"
```
```bash
kubectl create -f resource-pod.yml
```
Check the pod status.
```bash
kubectl get pods
```