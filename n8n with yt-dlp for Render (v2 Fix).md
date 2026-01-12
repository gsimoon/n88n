# n8n with yt-dlp for Render (v2 Fix)

This repository contains the configuration to deploy n8n on Render with `yt-dlp` and `ffmpeg` pre-installed.

## The v2 Fix
The official n8n v2 image is "hardened" and lacks a package manager. This Dockerfile includes a **bootstrapping step** that restores the `apk` package manager, allowing us to install the necessary tools (`yt-dlp`, `ffmpeg`, `python3`) while still using the official latest n8n image.

## Features
- **n8n**: Latest version (v2.x) of the workflow automation tool.
- **yt-dlp**: Command-line media downloader.
- **FFmpeg**: Essential for processing and merging media streams.
- **Render Optimized**: Pre-configured for Render's environment.

## Deployment Instructions

### 1. GitHub Repository
Create a new private repository on GitHub and upload the following files:
- `Dockerfile`
- `render.yaml`

### 2. Render Setup
1. Log in to your [Render Dashboard](https://dashboard.render.com/).
2. Click **New +** and select **Blueprint**.
3. Connect your GitHub repository.
4. Render will automatically detect the `render.yaml` file and configure the service.
5. Click **Apply** to start the deployment.

### 3. Using yt-dlp in n8n
In your n8n workflow, use the **Execute Command** node.
- **Command**: `yt-dlp [URL]`
- **Binary Path**: The binary is located at `/usr/bin/yt-dlp`.

### Important Notes
- **Persistent Disk**: The `render.yaml` includes a 1GB persistent disk mounted at `/home/node/.n8n` to save your workflows and credentials.
- **Memory**: n8n can be memory-intensive. If you experience crashes, consider upgrading to a higher Render plan.
- **Storage**: Downloaded files should be saved to `/home/node/downloads` or the persistent mount to avoid losing them on restart.
