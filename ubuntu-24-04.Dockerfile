FROM --platform=$TARGETPLATFORM ubuntu:24.04 AS base

ARG BUILDPLATFORM
ARG TARGETPLATFORM

RUN echo "BUILDPLATFORM: $BUILDPLATFORM, TARGETPLATFORM: $TARGETPLATFORM"

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    fuse3 \
    && rm -rf /var/lib/apt/lists/*

ENV GCSFUSE_VERSION=3.4.0
ENV GCSFUSE_PLATFORM=${TARGETPLATFORM#linux/}
RUN echo "GCSFUSE_PLATFORM: $GCSFUSE_PLATFORM"
RUN echo "Downloading GCSFUSE from: https://github.com/GoogleCloudPlatform/gcsfuse/releases/download/v${GCSFUSE_VERSION}/gcsfuse_${GCSFUSE_VERSION}_${GCSFUSE_PLATFORM}.deb"
RUN curl -fsSL https://github.com/GoogleCloudPlatform/gcsfuse/releases/download/v${GCSFUSE_VERSION}/gcsfuse_${GCSFUSE_VERSION}_${GCSFUSE_PLATFORM}.deb -o gcsfuse_${GCSFUSE_VERSION}_${GCSFUSE_PLATFORM}.deb && \
    dpkg -i gcsfuse_${GCSFUSE_VERSION}_${GCSFUSE_PLATFORM}.deb && \
    rm gcsfuse_${GCSFUSE_VERSION}_${GCSFUSE_PLATFORM}.deb
