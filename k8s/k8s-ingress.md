## Exposing Applications with Ingress
[ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

* An Ingress manages external access to Kubernetes applications.
* An Ingress routes to 1 or more Kubernetes Services.
* You need an Ingress controller to implement the Ingress functionality. Which controller you use determines the specifics of how the Ingress will work.

Create a Pod.
```bash
vi ingress-test-pod.yml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ingress-test-pod
  labels:
    app: ingress-test
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
    - containerPort: 80
```

```bash
kubectl apply -f ingress-test-pod.yml
```
Create a ClusterIP Service for the Pod.
```bash
vi ingress-test-service.yml
```
```yaml
apiVersion: v1
kind: Service
metadata:
  name: ingress-test-service
spec:
  type: ClusterIP
  selector:
    app: ingress-test
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```
```bash
kubectl apply -f ingress-test-service.yml
```
Get the Service's cluster IP address.
```bash
kubectl get service ingress-test-service
```
Use the cluster IP address to test the Service.

```bash
curl <Service cluster IP address>
```
Create an Ingress.
```bash
vi ingress-test-ingress.yml
```

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-test-ingress
spec:
  ingressClassName: nginx
  rules:
- host: ingresstest.example.local
  http:
    paths:
    - path: /
      pathType: Prefix
      backend:
        service:
          name: ingress-test-service
          port:
            number: 80
```
```bash
kubectl apply -f ingress-test-ingress.yml
```
View a list of ingress objects.
```bash
kubectl get ingress
```
Get more details about the ingress. You should notice ingress-test-service listed as one of the backends.
```bash
kubectl describe ingress ingress-test-ingress
```
If you want to try accessing your Service through an Ingress controller, you will need to do some additional configuration.
First, use Helm to install the nginx Ingress controller.
```bash
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
kubectl create namespace nginx-ingress
helm install nginx-ingress nginx-stable/nginx-ingress -n nginx-ingress
```
Get the cluster IP of the Ingress controller's Service.
```bash
kubectl get svc nginx-ingress-nginx-ingress -n nginx-ingress
```
Edit your hosts file.
```bash
sudo vi /etc/host
```
Use the cluster IP to add an entry to the hosts file.
```bash
<Nginx ingress controller Service cluster IP> ingresstest.example.local
```
Now, test your setup.
```bash
curl ingresstest.example.local
```
