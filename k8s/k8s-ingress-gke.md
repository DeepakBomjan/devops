## Add Helm repo
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```
```bash
helm install nginx-ingress ingress-nginx/ingress-nginx
```
```bash
kubectl get all
```

```bash
helm get manifest nginx-ingress
```

https://learn.acloud.guru/course/gke-beginner-to-pro/learn/403ba976-e365-c11c-e2d5-43d6c799c142/637842ab-d5a1-5f1f-f39d-2a97aa0a2da3/watch

https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-ingress-guide-nginx-example.html
