## Pushing a Docker Image to a Self-Hosted Registry
## Running a Docker registry
```bash
docker run -d -p 5000:5000 — name registry registry:latest
```
or
```bash
docker run -d -p 5000:5000 --name registry --restart=always registry:latest
```
## Save sample image in private registry
```bash
docker pull ubuntu
docker image tag ubuntu localhost:5000/ubuntu-local
docker push localhost:5000/ubuntu-local
```
## Push from other machine
1. Download sample image
```bash
docker pull ubuntu
```
2. Change tag name of image to match remote url
```bash
docker image tag ubuntu 3.91.199.175:5000/ubuntu-local
```
3. Push image
```bash
docker push 3.91.199.175:5000/ubuntu-local:latest
```
If you get following error:
> docker push 3.91.199.175:5000/ubuntu-local:latest The push refers to repository [3.91.199.175:5000/ubuntu-local] Get "https://3.91.199.175:5000/v2/": http: server gave HTTP response to HTTPS client


```bash
cat > /etc/docker/daemon.json
{
  "insecure-registries": ["3.91.199.175:5000"]
}

```
```bash
sudo systemctl restart docker
```




### List images
```bash
curl -X GET http://204.236.192.186:5000/v2/_catalog

curl -X GET -u <user>:<pass> https://myregistry:5000/v2/_catalog
curl -X GET -u <user>:<pass> https://myregistry:5000/v2/ubuntu/tags/list

```

### Docker registry UI
Try using
1. [harbor](https://github.com/goharbor/harbor)
2. [joxit](https://github.com/Joxit/docker-registry-ui)


### With SSL

### [Creating a Self-Signed Certificate With OpenSSL](https://www.baeldung.com/openssl-self-signed-cert)
1. Creating a Private Key
    ```bash
    openssl genrsa -des3 -out domain.key 2048
    ```
2. Creating a Certificate Signing Request
    ```bash
    openssl req -key domain.key -new -out domain.csr
   
    ```
> With single command ```openssl req -newkey rsa:2048 -keyout domain.key -out domain.csr```
> Unencrypted private key ```openssl req -newkey rsa:2048 -nodes -keyout domain.key -out domain.csr```
3. Creating a Self-Signed Certificate
    ```bash
    openssl x509 -signkey domain.key -in domain.csr -req -days 365 -out domain.crt
    ```
## Creating a CA-Signed Certificate With Our Own CA
1. Create a Self-Signed Root CA
    ```bash
    openssl req -x509 -sha256 -days 1825 -newkey rsa:2048 -keyout rootCA.key -out rootCA.crt
    ```
2. Sign Our CSR With Root CA
    1. First, Create a configuration text-file (domain.ext) with the following content
        ```bash
        authorityKeyIdentifier=keyid,issuer
        basicConstraints=CA:FALSE
        subjectAltName = @alt_names
        [alt_names]
        DNS.1 = domain
        ```
    2. sign our CSR (domain.csr) with the root CA certificate and its private key:
        ```bash
        openssl x509 -req -CA rootCA.crt -CAkey rootCA.key -in domain.csr -out domain.crt -days 365 -CAcreateserial -extfile domain.ext
        ```
3. View Certificates
        ```bash
        openssl x509 -text -noout -in domain.crt
        ```
4. Convert Certificate Formats
    1. Convert PEM to DER
        ```bash
            openssl x509 -in domain.crt -outform der -out domain.der
        ```
    2. Convert PEM to PKCS12
        ```bash
        openssl pkcs12 -inkey domain.key -in domain.crt -export -out domain.pfx
        ```
    
### References
1. [Generate self signed certificate](https://gist.github.com/taoyuan/39d9bc24bafc8cc45663683eae36eb1a)
2. [Adding a Self-Signed Certificate to the Trusted List](https://www.baeldung.com/linux/add-self-signed-certificate-trusted-list#:~:text=On%20Chrome&text=Let's%20click%20on%20the%20%E2%80%9CImport,will%20be%20trusted%20on%20Chrome.)
3. [Create your own Secured Docker Private Registry with SSL](https://medium.com/@deekonda.ajay/create-your-own-secured-docker-private-registry-with-ssl-6a44539f74b8)
4. [Setting Up A Docker Registry With HTTPS(LetsEncrypt) and Basic Authentication(htpasswd)](https://ivhani.medium.com/setting-up-a-docker-registry-with-https-letsencrypt-and-basic-authentication-htpasswd-3ea1961a4144)


