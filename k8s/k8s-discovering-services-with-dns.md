## Discovering K8s Services With DNS
Relevant Documentation
[DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
>Note: This lesson depends on objects that were created in the previous lesson. If you are following along, you will need to go through the previous lesson first.
Get the IP address of the ClusterIP Service.
```bash
kubectl get service svc-clusterip
```
Perform a DNS lookup on the service from the busybox Pod.
```bash
kubectl exec pod-svc-test -- nslookup <Service IP Address>
```
Use the Service's IP address to make a request to the Service from the busybox pod.
```bash
kubectl exec pod-svc-test -- curl <Service IP Address>
```
Make a request using the service name.
```bash
kubectl exec pod-svc-test -- curl svc-clusterip
```
Make a request using the service fully-qualified domain name.
```bash
kubectl exec pod-svc-test -- curl svc-clusterip.default.svc.cluster.local
Create another busybox Pod in a new namespace.
kubectl create namespace new-namespace
```
```bash
vi pod-svc-test-new-namespace.yml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-svc-test-new-namespace
  namespace: new-namespace
spec:
  containers:
  - name: busybox
    image: radial/busyboxplus:curl
    command: ['sh', '-c', 'while true; do sleep 10; done']
```
```bash
kubectl create -f pod-svc-test-new-namespace.yml
```
Attempt to make a request to the Service from the busybox Pod that is in another Namespace.
```bash
kubectl exec -n new-namespace pod-svc-test-new-namespace -- curl svc-clusterip
kubectl exec -n new-namespace pod-svc-test-new-namespace -- curl svc-clusterip.default.svc.cluster.local
```
The request using just the Service name will fail, but it will succeed when using the fully-qualified domain name.