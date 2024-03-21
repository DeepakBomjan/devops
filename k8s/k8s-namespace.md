## Using Namespaces in K8s
## Relevant Documentation
[Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
### List namespaces in the cluster.
```bash
kubectl get namespaces
```
### Specify a namespace when listing other objects such as pods.
```bash
kubectl get pods -n kube-system
```
### Create a namespace.
```bash
kubectl create namespace my-namespace
```
