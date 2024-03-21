## Working with Kubectl
Relevant Documentation
[kubectl](https://kubernetes.io/docs/reference/kubectl/)

Create a pod.
```bash
vi pod.yml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: busybox
    image: radial/busyboxplus:curl
    command: ['sh', '-c', 'while true; do sleep 3600; done']
```
```bash
kubectl apply -f pod.yml
```
Get a list of pods.
```bash
kubectl get pods
```
Experiment with various output formats.
```bash
kubectl get pods -o wide
kubectl get pods -o json
kubectl get pods -o yaml

```
Sort results.
```bash
kubectl get pods -o wide --sort-by .spec.nodeName
```
Filter results by a label.
```bash
kubectl get pods -n kube-system --selector k8s-app=calico-node
```
Describe a pod.
```bash
kubectl describe pod my-pod
```
Test create/apply. Note that create will only work if the object does not already exist.
```bash
kubectl create -f pod.yml
kubectl apply -f pod.yml
```
Execute a command inside a pod.
```bash
kubectl exec my-pod -c busybox -- echo "Hello, world!"
```
Delete a pod.
```bash
kubectl delete pod my-pod
```
