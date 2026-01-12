# Use the official n8n image as the base (v2 is hardened/distroless)
FROM n8nio/n8n:latest

# Switch to root to install system dependencies
USER root

# 1. Bootstrap apk back into the hardened image
# We download a static version of apk to install the package manager itself
RUN wget https://gitlab.alpinelinux.org/api/v4/projects/5/packages/generic/v2.14.4/x86_64/apk.static && \
    chmod +x apk.static && \
    ./apk.static -X http://dl-cdn.alpinelinux.org/alpine/v3.21/main -U --allow-untrusted --initdb add apk-tools && \
    rm apk.static

# 2. Install Python, FFmpeg, and yt-dlp using the restored apk
RUN apk add --no-cache \
    python3 \
    py3-pip \
    ffmpeg \
    yt-dlp \
    curl

# 3. Create a directory for downloads and set permissions
RUN mkdir -p /home/node/downloads && \
    chown -R node:node /home/node/downloads

# Switch back to the node user
USER node

# Set environment variables for n8n
ENV N8N_PORT=10000
ENV N8N_PROTOCOL=https
ENV NODE_ENV=production

# Expose the port n8n will run on
EXPOSE 10000
