# Python: Docker Image Optimization

To containerize this app with Docker, create a Dockerfile with the following content:
FROM python:latest

1. Clone source code
    ```bash
    git clone https://gitlab.com/mattdark/python-blog/
    ```
2. Dockerfile
    ```bash
    WORKDIR /app

    COPY requirements.txt .
    RUN pip install --upgrade pip --no-cache-dir
    RUN pip install -r requirements.txt --no-cache-dir

    COPY . .

    EXPOSE 8080

    ENTRYPOINT ["gunicorn","--config", "gunicorn_config.py", "app:app"]
    ```
3. Now build the image by running:
    ```bash
    docker build . -t blog
    ```
4. Check image size
    ```bash
    docker image ls blog
    ```
## Optimize the images size
    * Use smaller base images
    * Multi-stage builds

### Use Smaller Base Images
    Using a smaller base image can help reduce the image size. Replace the python:latest image with the python:alpine3.19 image:
1. Dockerfile
    ```bash
    FROM python:alpine3.19

    WORKDIR /app

    COPY requirements.txt .
    RUN pip install --upgrade pip --no-cache-dir
    RUN pip install -r requirements.txt --no-cache-dir

    COPY . .

    EXPOSE 8080

    ENTRYPOINT ["gunicorn","--config", "gunicorn_config.py", "app:app"]
2. Build the image:
    ```bash
    docker build . -t blog
    ```
3. Check size now
    ```bash
    docker image ls blog
    ```
### Multi-stage builds
1. Dockerfile
    ```bash
    FROM python:alpine3.19 as builder

    ENV PATH="/app/venv/bin:$PATH"

    WORKDIR /app

    RUN python -m venv /app/venv
    COPY requirements.txt .

    RUN pip install --no-cache-dir -r requirements.txt

    FROM python:alpine3.19

    WORKDIR /app

    ENV PATH="/app/venv/bin:$PATH"

    COPY . .
    COPY --from=builder /app/venv /app/venv

    ENTRYPOINT ["gunicorn", "--config", "gunicorn_config.py", "app:app"]
    ```
2. Build the image:
    ```bash
    docker build . -t blog
    ```

## References
1. [Python: Docker Image Optimization](https://dev.to/mattdark/python-docker-image-optimization-50p0)
2. [Setting up python vertualenv](https://www.freecodecamp.org/news/how-to-setup-virtual-environments-in-python/)
3. [Optimizing Docker Images With Python](https://www.divio.com/blog/optimizing-docker-images-python/)