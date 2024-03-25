## Understanding ConfigMaps and Secrets in Kubernetes
1. ### Creating ConfigMap

We must note that _ConfigMap_ supports key-value pairs in plaintext format. Further, we need to specify all these values under the _data_ field.

```bash
cat > my-config.yaml
```
```yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: my-configmap
data:
  string-value: "Hello, world!"
  number-value: "42"
  boolean-value: "true"
  multiline-value: |
    This is a multiline value
    that spans multiple lines
  list-value: |
    - item1
    - item2
    - item3
  object-value: |
    key1: value1
    key2: value2
  json-value: |-
    {
      "key": "value",
      "array": [1, 2, 3],
      "nested": {
        "innerKey": "innerValue"
      }
    }
  yaml-value: |-
    key: value
    array:
      - 1
      - 2
      - 3
    nested:
      innerKey: innerValue
```

Now, let’s _apply_ the configuration to create the _my-config ConfigMap_:


```bash
kubectl apply -f my-config.yaml
```

Accessing the value
```bash
kubectl get configmap my-configmap -o jsonpath='{.data.string-value}'
```

2. ### Creating the _my-secret_ Secret

```bash
cat > my-secret.yaml
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  string-value: SGVsbG8sIHdvcmxkIQ==
  number-value: NDI=
  boolean-value: dHJ1ZQ==
  multiline-value: |
    VGhpcyBpcyBhIG1pbmxpbmUgdmFsdWUgZXZlcnkgdGhhdCBzcGFuIG11bHRpcGxlIGxpbmVzCg==
  json-value: eyAiY29tcGxleCI6ICIxMjM0NSIsICJzdHJpbmciOiAiSGVsbG8sIHdvcmxkISIsICJuZXN0ZWQiOiB7ICJpbnN0YW5jZSI6IDEsICJzdHJpbmciOiAxLCAibmVzdGVkIjogeyAiaW5uZXJLZXkiOiAiSW5uZXJWYWx1ZSJ9fX0=
  binary-value: YmFzZTY0IHN0cmluZwo=
stringData:
  list-value: |
    item1
    item2
    item3
  object-value: |
    key1: value1
    key2: value2
    key3: value3
  yaml-value: |
    key: value
    string: Hello, world!
    nested:
      innerKey: innerValue

```

It’s important to note that some values are in plaintext format, while some are in Base64-encoded format. Additionally, **we specify the Base64-encoded values under the data field, whereas the plaintext-formatted values are available under the stringData field**.

```bash
kubectl apply -f my-secret.yaml
```
Accessing the Values:
```bash
kubectl get secret my-secret -o jsonpath='{.data.string-value}' | base64 -d
```
```bash
kubectl get secret my-secret -o jsonpath='{.data.yaml-value}' | base64 -d
```

3. ### Environment Variables

We can inject them as environment variables into a Kubernetes pod.

```bash
cat > pod.yaml
```

```yaml

apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: ubuntu-container
      image: ubuntu
      command: ["sleep", "infinity"]
      env:
        - name: SECRET_VALUE
          valueFrom:
            secretKeyRef:
              name: my-secret
              key: string-value
        - name: CONFIG_VALUE
          valueFrom:
            configMapKeyRef:
              name: my-configmap
              key: number-value

```

We must note that **_we used the secretKeyRef field to refer to the my-secret Secret, and configMapKeyRef to refer to the my-configmap ConfigMap_**. Further, we named the environment variables as _SECRET_VALUE_ and _CONFIG_VALUE_.

```bash
kubectl apply -f pod.yaml
```

Use the kubectl exec command to check the environment variables inside the my-pod:

```bash
kubectl exec my-pod -- env | grep -i VALUE
```

4. ### Built-in Types and Usage
    4.1 **_Opaque Secrets_**  
    Let's create _mysql-secret_ to contain the credentials for a MySQL database.
     ```bawh
     cat > mysql-secret.yaml
     ```
     ```yaml
     
        apiVersion: v1
        kind: Secret
        metadata:
          name: mysql-secret
        type: Opaque
        data:
          username: bXktcHJvdG9jb2xvcmVk
          password: bXktcGFzc3dvcmQ=
          root-password: bXktcm9vdC1wYXNzd29yZA==
    ```
    Let's Create _mysql-pod.yaml_ manifest to hold the configuration for the _mysql-pod_:
    ```bash
    cat > mysql-pod.yaml
    ```
    ```yaml
    
    apiVersion: v1
    kind: Pod
    metadata:
      name: mysql-pod
    spec:
      containers:
        - name: mysql-container
          image: mysql
          env:
            - name: MYSQL_USER
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: username
            - name: MYSQL_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: password
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: root-password
          ports:
            - containerPort: 3306
      restartPolicy: Never
    ```

    ```bash
    kubectl apply -f mysql-secret.yaml -f mysql-pod.yaml
    ```
    Validate that the MySQL server is up and running inside the mysql-pod pod:
    ```bash
    kubectl exec -it mysql-pod -- mysql -uroot -pmy-root-password -e "SELECT VERSION();"
    ```
    
### References
[Managing Kubernetes Secret and Configuration](https://www.baeldung.com/ops/kubernetes-configmaps-secrets)

[Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)

[Example git clone init container](https://stefvnf.medium.com/cloning-git-repos-using-kubernetes-initcontainers-and-secrets-8609e3b2d238)



