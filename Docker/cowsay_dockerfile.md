If you want to build a Docker image without using Alpine Linux or any other base image, and instead include the `cowsay` binary directly, you'll need to manually download and include the `cowsay` binary and any necessary dependencies. Here's how you can create a Dockerfile to achieve this:

### Dockerfile Without Alpine

```dockerfile
# Start from a scratch image (empty image)
FROM scratch

# Create necessary directories
RUN mkdir -p /usr/bin /usr/share/cowsay

# Copy cowsay binary and necessary data files
COPY cowsay /usr/bin/cowsay
COPY ./cowsay-files/* /usr/share/cowsay/

# Set cowsay as the entrypoint with default message
ENTRYPOINT ["/usr/bin/cowsay"]
CMD ["Hello, Docker!"]
```

### Explanation:

- **Scratch Image**: `scratch` is a special Docker image that is completely empty, meaning it has no installed operating system or libraries. You need to manually include all necessary files.

- **Create Directories**: The `RUN mkdir -p /usr/bin /usr/share/cowsay` command creates the necessary directories inside the image.

- **Copy Files**: 
  - `COPY cowsay /usr/bin/cowsay`: Copies the `cowsay` binary file (named `cowsay`) to `/usr/bin/cowsay` inside the Docker image.
  - `COPY ./cowsay-files/* /usr/share/cowsay/`: Copies any necessary data files (`cowsay-files` directory should contain the necessary files like `cowfiles`, etc.) to `/usr/share/cowsay/`.

- **Entrypoint and CMD**: 
  - `ENTRYPOINT ["/usr/bin/cowsay"]`: Sets `cowsay` as the default command to run when a container is started.
  - `CMD ["Hello, Docker!"]`: Provides a default message (`Hello, Docker!`) that `cowsay` will display if no command-line argument is provided.

### Build and Run:

1. Ensure you have the `cowsay` binary (`cowsay`) and any necessary data files (`cowsay-files` directory) in the same directory as your Dockerfile.

2. Build the Docker image:
   ```bash
   docker build -t cowsay-image .
   ```

3. Run a container:
   ```bash
   docker run --rm cowsay-image
   ```

   This will output:
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

- **Manual Setup**: Since you're starting from `scratch`, you must manually include all necessary files (`cowsay` binary and data files) needed by `cowsay` for it to function properly.
- **File Paths**: Adjust the paths (`COPY` commands) according to the actual location and structure of your `cowsay` binary and data files.
- **Dependencies**: Ensure all necessary dependencies (`perl`, `libc`, etc.) required by `cowsay` are included in the binary or are available in the environment where the Docker image will be run.
