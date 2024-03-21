Managing Access from Outside with K8s Ingress
Relevant Documentation
[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
[Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)
>Note: This lesson depends on objects that were created in the previous lesson. If you are following along, you will need to go through the previous lesson first.
Create an ingress that maps to a Service.
```bash
vi my-ingress.yml
```
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - http:
    paths:
    - path: /somepath
      pathType: Prefix
      backend:
        service:
          name: svc-clusterip
          port:
            number: 80
```
```bash
kubectl create -f my-ingress.yml
```
Check the status of the ingress.
```bash
kubectl describe ingress my-ingress
```
Update the Service to provide a name for the Service port.
```bash
vi svc-clusterip.yml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: svc-clusterip
spec:
  type: ClusterIP
  selector:
    app: svc-example
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 80
```
```bash
kubectl apply -f svc-clusterip.yml
```
Edit the Ingress to use the port name.
```bash
vi my-ingress.yml
```
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
    - http:
      paths:
        - path: /somepath
          pathType: Prefix
          backend:
            service:
              name: svc-clusterip
              port:
                name: http
```
```bash

kubectl apply -f my-ingress.yml
```
Check the status of the ingress again.
```bash
kubectl describe ingress my-ingress
```
