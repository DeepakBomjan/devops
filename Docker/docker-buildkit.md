## Cleaning up Docker artifacts
### How much disk space is Docker using?
```bash
docker system df
```
### Removing containers from the Docker cache
```bash
docker container prune -f
```
### Removing images
```bash
docker image prune -f
```
### Removing volumes
```bash
docker volume prune -f
```
### Removing build cache
```bash
docker buildx prune -f
```
If we want to remove the build cache for a specific builder, we can use the --builder flag to specify the builder name.
```bash
docker buildx prune --builder builder-name -f
```

### Removing networks
```bash
docker network prune -f
```

### Debug build error
```bash
docker build $PWD/[MY SOURCE] --tag “MY TAG” --progress plain
DOCKER_BUILDKIT=0;docker build -t ibc_build . --progress plain --no-cache

```

### How to debug docker build with Dockerfile
1. delete the following part causing errors
```bash
FROM busybox
RUN echo 'hello world'

RUN exit 1
....
```


## Reference
1. [How to clear Docker cache and free up space on your system](https://depot.dev/blog/docker-clear-cache#removing-networks)

2. [debug docker build](https://www.docker.com/blog/how-to-fix-and-debug-docker-containers-like-a-superhero/)

3. [How to debug docker build with Dockerfile](https://www.linkedin.com/pulse/how-debug-docker-build-dockerfile-joey-wang/)

4. [Debug monitor](https://github.com/docker/buildx/blob/v0.11.2/docs/guides/debugging.md)