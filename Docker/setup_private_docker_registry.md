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
