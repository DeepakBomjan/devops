To join a node to a Kubernetes cluster using `kubeadm join`, you typically need to run a command like this on the node you want to add to the cluster:

```bash
sudo kubeadm join <control-plane-host>:<port> --token <token> --discovery-token-ca-cert-hash <hash>
```

Here’s what each part means:
- `<control-plane-host>:<port>`: Replace this with the hostname and port of your Kubernetes control plane. This is where the API server is running.
- `<token>`: Replace this with the token generated during the `kubeadm init` process on your control plane node.
- `<hash>`: Replace this with the CA certificate hash. You can find this on the control plane node by running `openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'`.

Ensure you have `kubeadm` installed on the node where you want to run this command. This command should be run with `sudo` or as root.

If you need more specific details or have a different setup, let me know!

