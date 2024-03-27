## Configuring the NGINX Ingress Controller on GKE

### Objectives
Successfully complete this lab by achieving the following learning objectives:

## Create and Connect to a GKE Cluster

## Install the Nginx Ingress Controller

From the Cloud Shell, run kubectl to install all of the Nginx Ingress Controller components by using the public provider manifest 


```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.1/deploy/static/provider/cloud/deploy.yaml
```


1. Confirm the controller is installed and running by viewing its deployment.
2. Find the external IP of Nginx.
3. Load the IP in a web browser. If you get an Nginx 404 Not Found error, everything is working fine. Nginx is up and running, but there are no Ingress objects, so no backend is found.

## Deploy the First Application and Ingress

1. Create the Hello World deployment using the container image `gcr.io/google-samples/hello-app:1.0` and expose it via a Kubernetes Service on port 8080.

2. Create a file called "`hello-ingress.yaml`" to define the Ingress object for the Hello World service.

> Note: The YAML you use will depend on the version of your GKE cluster. View the cluster information page to determine your Kubernetes version.

For cluster versions below 1.19:

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: hello-app-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /hello
        backend:
          serviceName: hello-app
          servicePort: 8080
```
For cluster versions 1.19 or above:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-app-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
   - http:
      paths:
      - path: /hello
        pathType: Prefix
        backend:
          service:
            name: hello-app
            port:
              number: 8080
```
3. Apply the manifest to the cluster.

4. Reload the NGINX IP address but add "/hello" to the URL. You should be able to see the Hello World service.

## Deploy the Second Application and Ingress

1. Create the Where Am I? deployment using the container image `gcr.io/google-samples/whereami:v1.1.1` and expose it via a Kubernetes Service on port 8080.

2. Create a file called "`whereami-ingress.yaml`" to define the Ingress object for the Where Am I? service.

> Note: The YAML you use will depend on the version of your GKE cluster. View the cluster information page to determine your Kubernetes version.

For cluster versions below 1.19:

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: whereami-app-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
    paths:
    - path: /whereami
      backend:
        serviceName: whereami-app
        servicePort: 8080

```
For cluster versions 1.19 or above:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: whereami-app-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /whereami
        pathType: Prefix
        backend:
          service:
            name: whereami-app
            port:
              number: 8080
```
3. Apply the manifest to the cluster.

4. Reload the NGINX IP address but add "/whereami" to the URL. You should be able to see the Hello World service.