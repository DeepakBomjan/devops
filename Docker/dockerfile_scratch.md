To build a Docker image that includes the `cowsay` binary from scratch (i.e., starting from an empty image), you'll need to compile `cowsay` and its dependencies statically. Here’s a step-by-step guide to achieve this:

### 1. Prepare the Dockerfile

Create a `Dockerfile` with the following content:

```dockerfile
# Use a multi-stage build to compile cowsay
FROM alpine AS builder

# Install build dependencies
RUN apk add --no-cache gcc make musl-dev perl

# Download cowsay source and compile
RUN wget -O cowsay-3.03.tar.gz "https://web.archive.org/web/20201111132618/http://www.nog.net/~tony/warez/cowsay-3.03.tar.gz" && \
    tar -zxvf cowsay-3.03.tar.gz && \
    cd cowsay-3.03 && \
    ./configure --prefix=/usr && \
    make && \
    make install

# Build the final image from scratch
FROM scratch

# Copy the compiled cowsay binary and any necessary data files
COPY --from=builder /usr/bin/cowsay /usr/bin/cowsay
COPY --from=builder /usr/share/cowsay /usr/share/cowsay

# Set cowsay as the entrypoint
ENTRYPOINT ["/usr/bin/cowsay"]
```

### 2. Explanation

- **Multi-stage build**: This Dockerfile uses a multi-stage build. The first stage (`builder`) is based on Alpine Linux and is used to compile `cowsay` from source. Alpine Linux is chosen here for its lightweight nature and availability of build tools (`gcc`, `make`, etc.).

- **Install build dependencies**: The `apk add` command installs necessary build dependencies (`gcc`, `make`, `musl-dev`, `perl`).

- **Download and compile cowsay**: The `wget`, `tar`, and `make` commands download, extract, configure, compile, and install `cowsay` from source.

- **Second stage (scratch)**: The final image is based on `scratch`, which is an empty image. This means the resulting Docker image contains only your application and its dependencies—no extra layers or tools from a base OS.

- **Copy cowsay binary and data files**: From the `builder` stage, the `COPY` command copies the compiled `cowsay` binary (`/usr/bin/cowsay`) and any necessary data files (`/usr/share/cowsay`) into the final image.

- **Set entrypoint**: The `ENTRYPOINT` instruction sets `cowsay` as the default command to run when a container is started from the image.

### 3. Build the Docker Image

Save the `Dockerfile` in a directory and build the Docker image:

```bash
docker build -t cowsay .
```

This command builds the Docker image named `cowsay` using the `Dockerfile` in the current directory (`.`).

### 4. Run the Docker Container

After the image is built successfully, you can run a container:

```bash
docker run --rm cowsay Hello, Docker!
```

This command runs the `cowsay` command within the Docker container, which should output:

```
 _______
< Hello, Docker! >
 -------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

### Notes:

- The `cowsay` version used in this example is 3.03. Adjust the version in the `wget` command if a newer version is available.
- Ensure your Docker environment has internet access during the build process to download dependencies and the `cowsay` source.
- This example assumes basic familiarity with Docker and Dockerfile syntax. Adjustments may be needed based on your specific requirements or environment.
