## Using DaemonSets
Relevant Documentation
[DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
Log in to the Control Plane node.
Create a DaemonSet descriptor.
```bash
vi my-daemonset.yml
```
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: my-daemonset
spec:
  selector:
    matchLabels:
      app: my-daemonset
  template:
    metadata:
      labels:
        app: my-daemonset
    spec:
      containers:
      - name: nginx
        image: nginx:1.19.1
```

Create the DaemonSet in the cluster.
```bash
kubectl create -f my-daemonset.yml
```
Get a list of pods, and verify that a DaemonSet pod is running on each worker node.
```bash
kubectl get pods -o wide
```
