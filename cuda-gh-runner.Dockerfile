FROM ghcr.io/actions/actions-runner:latest
# FROM nvidia/cuda:13.0.2-runtime-ubuntu24.04 AS base
ENV NV_CUDA_LIB_VERSION="13.0.2-1"
ENV NV_CUDA_CUDART_VERSION=13.0.96-1

ENV NV_CUDA_CUDART_DEV_VERSION=13.0.96-1
ENV NV_NVML_DEV_VERSION=13.0.87-1
ENV NV_LIBCUSPARSE_DEV_VERSION=12.6.3.3-1
ENV NV_LIBNPP_DEV_VERSION=13.0.1.2-1
ENV NV_LIBNPP_DEV_PACKAGE=libnpp-dev-13-0=${NV_LIBNPP_DEV_VERSION}

ENV NV_LIBCUBLAS_DEV_VERSION=13.1.0.3-1
ENV NV_LIBCUBLAS_DEV_PACKAGE_NAME=libcublas-dev-13-0
ENV NV_LIBCUBLAS_DEV_PACKAGE=${NV_LIBCUBLAS_DEV_PACKAGE_NAME}=${NV_LIBCUBLAS_DEV_VERSION}

ENV NV_CUDA_NSIGHT_COMPUTE_VERSION=13.0.2-1
ENV NV_CUDA_NSIGHT_COMPUTE_DEV_PACKAGE=cuda-nsight-compute-13-0=${NV_CUDA_NSIGHT_COMPUTE_VERSION}

ENV NV_LIBNCCL_DEV_PACKAGE_NAME=libnccl-dev
ENV NV_LIBNCCL_DEV_PACKAGE_VERSION=2.28.3-1
ENV NCCL_VERSION=2.28.3-1
ENV NV_LIBNCCL_DEV_PACKAGE=${NV_LIBNCCL_DEV_PACKAGE_NAME}=${NV_LIBNCCL_DEV_PACKAGE_VERSION}+cuda13.0

USER root
RUN apt-get update && apt-get install -y wget curl

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb
RUN apt-get update
RUN apt-get -y install cuda-toolkit-13-0

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-13-0=${NV_CUDA_CUDART_VERSION} \
    cuda-compat-13-0 \
    && rm -rf /var/lib/apt/lists/*


# Required for nvidia-docker v1
RUN echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility


USER runner
