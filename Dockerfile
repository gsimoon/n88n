# Use the official n8n image as the base
FROM docker.n8n.io/n8nio/n8n:latest

# Switch to root to install system dependencies
USER root

# Install Python, FFmpeg, and yt-dlp
# Alpine-based images use apk
RUN apk add --no-cache \
    python3 \
    py3-pip \
    ffmpeg \
    yt-dlp \
    curl

# Optional: Ensure yt-dlp is the latest version via pip if the apk version is old
# RUN pip3 install -U yt-dlp --break-system-packages

# Create a directory for downloads and set permissions
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

# The base image already has an ENTRYPOINT and CMD to start n8n
