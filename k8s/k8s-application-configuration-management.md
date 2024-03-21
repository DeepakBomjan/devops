## Managing Application Configuration
Relevant Documentation
[ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
[Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
Create a ConfigMap.
```bash
vi my-configmap.yml
```
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-configmap
data:
  key1: Hello, world!
  key2: |
    Test
    multiple lines
    more lines
```

```bash
kubectl create -f my-configmap.yml
```

View your ConfigMap data.
```bash
kubectl describe configmap my-configmap
```
Create a secret.
Get two base64-encoded values.
```bash
echo -n 'secret' | base64
echo -n 'anothersecret' | base64
```
```bash
vi my-secret.yml
```

Include your two base64-encoded values in the file.
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  secretkey1: <base64 String 1>
  secretkey2: <base64 String 2>
```
```bash
kubectl create -f my-secret.yml

```
Create a pod and supply configuration data using environment variables.
```bash
vi env-pod.yml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: env-pod
spec:
  containers:
  - name: busybox
  image: busybox
  command: ['sh', '-c', 'echo "configmap: $CONFIGMAPVAR secret: $SECRETVAR"']
  env:
  - name: CONFIGMAPVAR
    valueFrom:
      configMapKeyRef:
        name: my-configmap
        key: key1
  - name: SECRETVAR
    valueFrom:
      secretKeyRef:
        name: my-secret
        key: secretkey1
```
```bash
kubectl create -f env-pod.yml
```
Check the log for the pod to see your configuration values!
```bash
kubectl logs env-pod
```
Create a pod and supply configuration data using volumes.
```bash
vi volume-pod.yml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: volume-pod
spec:
  containers:
  - name: busybox
    image: busybox
    command: ['sh', '-c', 'while true; do sleep 3600; done']
    volumeMounts:
    - name: configmap-volume
      mountPath: /etc/config/configmap
    - name: secret-volume
      mountPath: /etc/config/secret
  volumes:
  - name: configmap-volume
    configMap:
    name: my-configmap
  - name: secret-volume
    secret:
    secretName: my-secret
```
```bash
kubectl create -f volume-pod.yml
```
Use kubectl exec to navigate inside the pod and see your mounted config data files.
```bash
kubectl exec volume-pod -- ls /etc/config/configmap
kubectl exec volume-pod -- cat /etc/config/configmap/key1
kubectl exec volume-pod -- cat /etc/config/configmap/key2
kubectl exec volume-pod -- ls /etc/config/secret
kubectl exec volume-pod -- cat /etc/config/secret/secretkey1
kubectl exec volume-pod -- cat /etc/config/secret/secretkey2
```
