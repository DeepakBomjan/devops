
## Install Kubernetes
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/


```bash
1  # Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
history
```


```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
```

## Install containerd

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install containerd.io
```
```bash
sudo containerd config default | sudo tee /etc/containerd/config.toml
```
Optional 
```bash
# /etc/containerd/config.toml

cat <<EOF | sudo tee /etc/containerd/config.toml
version = 2
[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
   [plugins."io.containerd.grpc.v1.cri".containerd]
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2"
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true
EOF
```
Change `SystemdCgroup = true` in /etc/containerd/config.toml


## Error

```
error execution phase preflight: [preflight] Some fatal errors occurred:
	[ERROR CRI]: container runtime is not running: output: time="2023-12-19T16:55:41Z" level=fatal msg="validate service connection: validate CRI v1 runtime API for endpoint \"unix:///var/run/containerd/containerd.sock\": rpc error: code = Unimplemented desc = unknown service runtime.v1.RuntimeService"
, error: exit status 1
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher
```

```bash
sudo systemctl restart containerd
sudo systemctl enable containerd


```
### Run only on master node !!!
```bash
sudo kubeadm init
```



```bash
sudo kubeadm join 172.31.58.149:6443 --token ww0doo.9s4l9e6u569iw4f3  --discovery-token-ca-cert-hash sha256:a1f7ba113c3498a17431ec135124e22b9c6dd69fd94f759c34de28f3dd5ad9bc
    ```


```
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

```


## Install ingress controller

https://kubernetes.github.io/ingress-nginx/deploy/

kubectl create secret generic jwt-secret --from-literal=JWT_KEY=thisissupersecretjwtkey -n development
kubectl create secret generic cookie-secret --from-literal=COOKIE_SIGNING_KEY=thisissupersecretcookiesigningkey -n development
kubectl create secret generic stripe-secret --from-literal=STRIPE_KEY=sk_test_51HjfSGCqMWa1qdglqmD9HYWyp1cvvUC4FoYEXW0mAkV8t8P0Kx26VY4psazschjhZF8juqAvuuaU19Iwwbx4ZKce00hcIwBHNU -n development



### Install Helm
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
./get_helm.sh
```
