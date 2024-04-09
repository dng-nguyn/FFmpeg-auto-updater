#!/bin/bash

# Change to script directory
cd "$(dirname "$0")"
# Define the URLs and paths
FFMPEG_URL="https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-linux64-gpl.tar.xz"
LOG_FILE="ffmpeg_auto_install_log.txt"
INSTALL_PATH=" "
MAX_RETRIES=6  # Number of retries
INITIAL_RETRY_INTERVAL=300  # Initial retry interval in seconds (5 minutes)
MAX_RETRY_INTERVAL=1800  # Maximum retry interval in seconds (30 minutes)

# Function to log messages with timestamps
log() {
  echo "$(date +"%d:%m:%Y %H:%M") $1" >> "$LOG_FILE"
}

# Function to download with incremental retries
download_with_retry() {
  local retries=0
  local success=false
  local retry_interval=$INITIAL_RETRY_INTERVAL

  while [ $retries -lt $MAX_RETRIES ]; do
    log "Downloading ffmpeg.tar.xz (Attempt $((retries + 1)) of $MAX_RETRIES)..."
    (curl -sLo ffmpeg.tar.xz "$FFMPEG_URL" >> "$LOG_FILE" 2>&1) && success=true && break

    log "Download attempt $((retries + 1)) failed. Retrying in $retry_interval seconds..."
    sleep $retry_interval
    ((retries++))
    retry_interval=$((retry_interval + 300))  # Incremental retry interval of 5 minutes
    retry_interval=$((retry_interval > MAX_RETRY_INTERVAL ? MAX_RETRY_INTERVAL : retry_interval))  # Limit to max retry interval
  done

  if [ "$success" = false ]; then
    log "Download failed after $MAX_RETRIES attempts. Exiting."
    exit 1
  fi
}

# Download with incremental retries
download_with_retry

# Extract the tar.xz file
log "Extracting ffmpeg.tar.xz..."
(tar -xf ffmpeg.tar.xz -C "$INSTALL_PATH" ffmpeg-master-latest-linux64-gpl/bin/ffmpeg --strip-components=2 2>> "$LOG_FILE" 2>&1) || { log "Extraction failed."; exit 1; }

# Clean up: remove downloaded files and extracted directory
log "Cleaning up..."
(rm -rf ffmpeg* >> "$LOG_FILE" 2>&1) || { log "Cleanup failed."; exit 1; }

log "Installation complete."
