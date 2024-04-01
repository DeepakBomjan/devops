## RESTRICT A LINUX USER TO SPECIFIC KUBERNETES NAMESPACE
1. Create user
```bash
useradd -s /bin/bash -m john
```
2. Create namespace
```bash
kubectl create namespace dev
```

## CERTIFICATE MANAGEMENT
1. Create TLS Certificates for the User
```bash
openssl genrsa -out john.key 2048
openssl req -new -key john.key -out john.csr -subj "/CN=john"
```

> Note: Can’t load ./.rnd into RNG 10504:error:2406F079:random number generator:RAND_load_file:Cannotopen file:crypto\rand\randfile.c:98:Filename=./.rnd  
_Try removing or commenting RANDFILE = $ENV::HOME/.rnd line in /etc/ssl/openssl.cnf_

2. Create a certificate signing request (CSR) for the user with the below
```bash
vi john-csr.yaml
```
```yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: john-csr
spec:
  groups:
  - system:authenticated
  request: $(cat john.csr | base64 | tr -d "\n")
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - digital signature
  - key encipherment
  - client auth
  ```
  > Note: please paste the output
  > (cat  john.csr | base64 | tr -d “\n”)

  ```bash
  Kubectl apply -f john-csr.yaml
  ```
  3. Create a certificate signing request (CSR) for the user with the below
  ```bash
  kubectl certificate approve john-csr
  ```
  4. Create a Kubernetes configuration file for the new user
```bash
vi john.conf
```
```yaml
apiVersion: v1
kind: Config
clusters:
- name: <cluster_name>
  cluster:
    certificate-authority-data: $(kubectl config view --raw --flatten -o json | jq -r '.clusters[0].cluster."certificate-authority-data"')
    server: $(kubectl config view --raw --flatten -o json | jq -r '.clusters[0].cluster.server')
contexts:
- name: john-context
  context:
    cluster: <cluster_name>
    namespace: dev
    user: john
current-context: john-context
users:
- name: john
  user:
    client-certificate-data: $(kubectl get csr john-csr -o jsonpath='{.status.certificate}')
    client-key-data: $(cat john.key | base64 | tr -d '\n')
```

> Note: please replace “$ ()” with its actual values and cluster_name can be found by running the command ‘kubectl config get-contexts’

5. Create directory .kube/   in the user directory
```bash
su - john
mkdir ~/.kube/
```
6. Copy the above <user_name>.conf to .kube/config
```bash
cp -p john.conf ~/.kube/config 
```
7. Set permission for config file 
```bash
$ su - john
$ chmod 600 ~/.kube/config
```
8. Create Role manifest for setting permission for the user
```bash
vi john-role.yaml
```
```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: dev
  name: full-access-role
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
```
```bash
kubectl apply -f john-role.yaml
```
9. Create Role-binding manifest for binding  permission to the user
```bash
vi john-RoleBinding.yaml
```
```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: full-access-binding
  namespace: dev
subjects:
- kind: User
  name: john
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: full-access-role
  apiGroup: rbac.authorization.k8s.io
```
```bash
kubectl apply -f john-RoleBinding.yaml
```

### Context

### References
[rbac](https://www.ecloudcontrol.com/restrict-a-linux-user-to-specific-kubernetes-namespace/#:~:text=RESTRICT%20A%20LINUX%20USER%20TO%20SPECIFIC%20KUBERNETES%20NAMESPACE&text=Kubernetes%20RBAC%20is%20powered%20by,the%20namespace%20it%20belongs%20in.)
[rbac2](https://medium.com/containerum/configuring-permissions-in-kubernetes-with-rbac-a456a9717d5d)
[rbac3](https://medium.com/techbeatly/how-to-create-and-manage-user-access-in-kubernetes-with-rbac-54f9af6a204b)
