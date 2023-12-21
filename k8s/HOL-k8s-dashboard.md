## Install Dashboard
### Using helm
```bash
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard
```

### Install helm
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
./get_helm.sh
```

### Using kubectl
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

### check all information
```bash
kubectl get all -n kubernetes-dashboard
```

### Accessing the Kubernetes Dashboard

We can access the Kubernetes dashboard in the following ways:

1. kubectl port-forward (only from kubectl machine)
2. kubectl proxy (only from kubectl machine)
3. Kubernetes Service (NodePort/ClusterIp/LoadBalancer)
4. Ingress Controller (Layer 7)

### Using Node port; change ```ClusterIP``` to ```NodePort```
```bash
kubectl edit service/kubernetes-dashboard
kubectl get svc
```

## Access the Dashboard using 
`http://<NodeIp>:<dashboard port>`

## Create Login account
sa-admin-user.yaml
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
```
```bash
kubectl apply -f sa-admin-user.yaml
```
rolebinding-admin-user.yaml
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```
```bash
kubectl apply -f rolebinding-admin-user.yaml
```

```bash
# kubectl delete serviceaccount dashboard-admin -n kubernetes-dashboard
# kubectl delete clusterrolebinding cluster-admin-rolebinding

kubectl create -f dashboard-admin-user.yaml
```


## Get service account detail
```bash
kubectl get sa
```
```bash
kubectl describe sa dashboard-admin
```

## Getting Bearer Token
```bash
kubectl -n kubernetes-dashboard create token admin-user
```

## Ref:
https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md


