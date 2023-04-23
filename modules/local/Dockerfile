
# Base Image
FROM ubuntu:22.04

ARG RNA_FRAMEWORK_VERSION=e4e05f0088ff0f094a78648158a31a3e6c2e7a82
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Metadata
LABEL base_image="ubuntu:22.04" \
      version="0.1-dev"   \
      software="RNA Framework" \
      software.version=${RNA_FRAMEWORK_VERSION} \
      about.summary="RNA structure probing and post-transcriptional modifications mapping high-throughput data analysis" \
      about.home="https://github.com/dincarnato/RNAFramework" \
      about.documentation="https://rnaframework-docs.readthedocs.io/en/latest/" \
      about.license="SPDX:GPL-3.0-or-later"

# Maintainer
LABEL maintainer="Ken Brewer <ken@kenbrewer.com>"

ENV DEBIAN_FRONTEND=noninteractive
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    procps \
    build-essential \
    perl \
    cpanminus \
    libxml2-dev \
    libdbd-mysql-perl \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Install Mambaforge

USER ${USERNAME}
WORKDIR /home/${USERNAME}
RUN wget -O Mambaforge.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh" && \
    bash Mambaforge.sh -b -p "${HOME}/conda"
ENV PATH="/home/${USERNAME}/conda/bin:${PATH}"
# Setup Bioconda channel configuration
RUN conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda config --set channel_priority strict && \
    mamba install -y \
        python=3.9 \
        gxx_linux-64 \
        bowtie2>=2.3.5 \
        samtools>=1.2 \
        bedtools>=2.0 \
        cutadapt>=2.1 \
        viennarna>=2.4.0 \
        rnastructure>=5.6 && \
    mamba clean -a -y

# Install Perl non-core modules (XML::LibXML, Config::Simple)
RUN cpanm \
    inc::latest \
    XML::LibXML \
    Config::Simple

# Install RNA Framework
RUN mkdir rnaframework && \
    cd rnaframework && \
    git init . && \
    git remote add origin https://github.com/dincarnato/RNAFramework && \
    git fetch --depth 1 origin ${RNA_FRAMEWORK_VERSION} && \
    git checkout FETCH_HEAD

# Add RNA Framework to PATH
ENV PATH="${HOME}/rnaframework:${PATH}"
WORKDIR /data




