## Implementing Virtual Hosts across Namespaces in Kubernetes

## References
https://brokenco.de/2017/12/04/virtualhosts-across-namespaces-in-k8s.html
https://medium.com/avmconsulting-blog/ingress-service-types-in-kubernetes-3e9b68b78307
https://www.linkedin.com/pulse/automating-tls-name-based-hosting-kubernetes-google-cloud-mike-sparr/
https://akyriako.medium.com/configure-path-based-routing-with-nginx-ingress-controller-64a63cd4d6bd


## Add TLS to a Kubernetes Service with Ingress
 the control plane node server using the credentials provided:

1. Create nginx pod and service 
2.  Create a self-signed certificate and key for the `accounts-svc` Service:

```bash
openssl req -nodes -new -x509 -keyout accounts.key -out accounts.crt -subj "/CN=accounts.svc"
```
3. Create a Secret file to store the certificate and key:

```bash
vi accounts-tls-certs-secret.yml
```
4. Paste in the following YAML:
```yaml
apiVersion: v1
kind: Secret
type: kubernetes.io/tls
metadata:
  name: accounts-tls-certs
  namespace: accounts
data:
  tls.crt: |
    <base64-encoded cert data from accounts.crt>
  tls.key: |
    <base64-encoded key data from accounts.key>
```


5. Get a Base64-encoded version of the certificate:

```bash
base64 accounts.crt
```
6. Copy the Base64-encoded string output.

7. Edit the manifest file:


8. Under `tls.crt`:, replace the placeholder text with the copied Base64-encoded string output.


9. Get a Base64-encoded version of the key:

```bash
base64 accounts.key
```


10. Under `tls.key`:, replace the placeholder text with the copied Base64-encoded string output.



11. Create the Secret:

```bash
kubectl create -f accounts-tls-certs-secret.yml
```

## Create an Ingress on Top of the Service That Configures TLS Termination
1. Create a YAML manifest for the Ingress:

```bash
vi accounts-tls-ingress.yml
```
2. Paste in the following YAML:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: accounts-tls
  namespace: accounts
spec:
  tls:
  - hosts:
      - accounts.svc
    secretName: accounts-tls-certs
  rules:
  - host: accounts.svc
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: accounts-svc
            port:
              number: 80
```



3. Create the Ingress:

```bash
kubectl create -f accounts-tls-ingress.yml
```
4. Verify that the Ingress is appropriately mapping to the backend:

```bash
kubectl describe ingress accounts-tls -n accounts
```
