FROM condaforge/mambaforge:23.3.1-1 AS builder

# Use mamba to install tools and dependencies into /usr/local
RUN mamba create -qy -p /usr/local \
    -c bioconda \
    -c conda-forge \
    python=3.11

RUN wget https://github.com/BostonGene/Procrustes/archive/refs/tags/1.0.1.tar.gz -O /opt/Procrustes-1.0.1.tar.gz && \
    tar -xzf /opt/Procrustes-1.0.1.tar.gz -C /opt

COPY ./pyproject.toml /opt/Procrustes-1.0.1/

RUN cd /opt/Procrustes-1.0.1/ && \
    pip install . && \
    rm -rf /opt/Procrustes-1.0.1 /opt/Procrustes-1.0.1.tar.gz

# Deploy the target tools into a base image
FROM ubuntu:20.04
COPY --from=builder /usr/local /usr/local

# # ps and command for reporting mertics
RUN apt-get update && \
    apt-get install --no-install-recommends -y procps &&\
    rm -rf /var/lib/apt/lists/*

LABEL maintainer="Trevor Zhu <trevoer@valiussciences.com>"
