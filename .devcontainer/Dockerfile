# builder-base ################################################################
FROM debian:bookworm-slim AS builder-base

WORKDIR /workspace

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies and tools in a single RUN to reduce layers
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    autoconf \
    automake \
    libtool \
    pkg-config \
    ca-certificates \
    apache2-utils \
    wget \
    gnupg && \
    # Install Helm
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    rm get_helm.sh && \
    # Add OpenResty GPG key and repository for arm64
    wget -O - https://openresty.org/package/pubkey.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/openresty.gpg && \
    echo "deb http://openresty.org/package/arm64/debian bookworm openresty" > /etc/apt/sources.list.d/openresty.list && \
    # Update and install OpenResty
    apt-get update && \
    apt-get install --no-install-recommends -y openresty && \
    # Clean up to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# devcontainer ################################################################
FROM builder-base AS devcontainer

LABEL artifact=false

ENV EDITOR=vim