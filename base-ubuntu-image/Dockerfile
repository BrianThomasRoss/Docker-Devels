######################
# --- Base Image --- #
######################

FROM ubuntu:18.04
LABEL maintainer='BrianThomasRoss (---brian@brianthomasross.com---)' \
    description='base image for my personal dev container'

### --- SHOULD STOP MOST WARNINGS --- ###
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update --fix-missing && \
    apt-get install -y \
    apt-transport-https \
    bash \
    bash-completion \
    build-essential \
    bzip2 \
    ca-certificates \
    csh \
    curl \
    cmake \
    man-db \
    nano \
    net-tools \
    openssh-client \
    software-properties-common \
    sudo \
    vim \
    wget \
    unzip \
    zlib1g-dev \
    zsh && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    ########################
    #### --- PYTHON --- ###
    ######################
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \    
    apt-get install -y \
    python3.7 \
    python3-pip \
    ipython3 \
    python3-dev && \
    pip3 install jupyter