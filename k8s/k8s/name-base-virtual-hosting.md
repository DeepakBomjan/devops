## Name based virtual hosting

[Name based virtual hosting](https://kubernetes.io/docs/concepts/services-networking/ingress/#name-based-virtual-hosting)
![image](../../images/ingressNameBased.svg)


1. Build Docker images for each service
``bash
docker build -t my-clothe-service -f Dockerfile.clothe .   
...
```
2. Push to Docker hub
3. Update image name in Deployment file
4. Apply all k8s object
5. Install nginx ingress controller
6. Map hostname to ingress controller clusterip in /etc/hosts

e.g.
```bash
cat /etc/hosts
192.168.1.100 shopping.example.com rent.example.com neapli.music.com english-music.com

```