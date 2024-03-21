## Exploring k8s Scheduling
Relevant Documentation
[Kubernetes Scheduler](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/)
[Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)
Log in to the Control Plane node.
List your nodes.
```bash
kubectl get nodes
```
Add a label to one of your worker nodes.
```bash
kubectl label nodes <node name> special=true
```
Create a pod that uses a nodeSelector to filter which nodes it can run on using labels.
```bash
vi nodeselector-pod.yml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nodeselector-pod
spec:
  nodeSelector:
    special: "true"
  containers:
  - name: nginx
    image: nginx:1.19.1
```bash
kubectl create -f nodeselector-pod.yml
```
Check your Pod's status and verify that it has been scheduled on the correct node.
```bash
kubectl get pod nodeselector-pod -o wide
```
Create a pod that uses nodeName to bypass scheduling and run on a specific node.
```bash
vi nodename-pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: nodename-pod
spec:
  nodeName: <node name>
  containers:
  - name: nginx
    image: nginx:1.19.1
```bash
kubectl create -f nodename-pod.yml
```
Check your Pod's status and verify that it is on the correct node.
```bash
kubectl get pod nodename-pod -o wide
```
