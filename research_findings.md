# Research Findings: n8n with yt-dlp on Render

## Key Requirements
1.  **Base Image**: Use `docker.n8n.io/n8nio/n8n:latest` or a specific version.
2.  **Dependencies**:
    *   `yt-dlp` requires **Python 3**.
    *   `ffmpeg` is essential for `yt-dlp` to merge audio and video streams.
    *   `apk add` should be used as the base image is Alpine-based.
3.  **Permissions**:
    *   The Dockerfile must switch to `root` to install packages.
    *   Switch back to `node` user for security and compatibility with n8n's default behavior.
    *   Ensure the `node` user has permissions to execute `yt-dlp` and `ffmpeg`.
4.  **Render Specifics**:
    *   Render uses the `PORT` environment variable (default 10000).
    *   Persistent storage is needed for n8n data (`/home/node/.n8n`).
    *   `yt-dlp` might need a specific temporary directory if the default is restricted.

## Dockerfile Strategy
```dockerfile
FROM docker.n8n.io/n8nio/n8n:latest

USER root

# Install python3, ffmpeg, and yt-dlp
RUN apk add --no-cache \
    python3 \
    py3-pip \
    ffmpeg \
    yt-dlp

# Ensure yt-dlp is accessible
RUN ln -sf /usr/bin/yt-dlp /usr/local/bin/yt-dlp

USER node
```

## Potential Issues to Avoid
*   **Path Issues**: Ensure `yt-dlp` is in the system PATH.
*   **Python Version**: Alpine's `yt-dlp` package usually handles dependencies, but manual install via `pip` might be needed if the package is outdated.
*   **Disk Space**: Render's free tier has limited disk space; large video downloads might fail without a persistent disk.
