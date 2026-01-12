# Research Findings: n8n v2 Docker Image

## The Problem
The official `n8nio/n8n:latest` image (v2.x) is now **hardened/distroless**, meaning it lacks a package manager (`apk` or `apt`) and even basic shell utilities like `ls` or `cat`. This is why the previous `apk add` command failed with `apk: not found`.

## The Solution
To extend n8n v2, we have two main options:
1.  **Re-install `apk`**: Use a static binary of `apk` to bootstrap the package manager back into the image.
2.  **Use a different base**: n8n provides a Debian-based image which might be more extensible, or we can use the `n8n-custom` approach.

However, the most reliable way for a Dockerfile is to use the **multi-stage build** or bootstrap `apk`.

### Bootstrapping `apk` Strategy:
```dockerfile
FROM n8nio/n8n:latest

USER root

# Bootstrap apk back into the hardened image
RUN wget https://gitlab.alpinelinux.org/api/v4/projects/5/packages/generic/v2.14.4/x86_64/apk.static && \
    chmod +x apk.static && \
    ./apk.static -X http://dl-cdn.alpinelinux.org/alpine/v3.21/main -U --allow-untrusted --initdb add apk-tools && \
    rm apk.static

# Now we can use apk normally
RUN apk add --no-cache python3 py3-pip ffmpeg yt-dlp

USER node
```

## Alternative: Debian Base
Some users suggest using a Debian-based version if available, but the official `latest` tag points to the hardened Alpine version. 

## Recommendation for Render
Since Render builds from the Dockerfile, bootstrapping `apk` is the cleanest way to keep using the official `latest` image while adding the necessary tools.
