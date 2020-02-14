 ##########################
### --- BASE IMAGE --- ###
##########################
FROM ubuntu:18.04

####################
### --- META --- ###
####################
LABEL maintainer="Brian Ross <brianthomasross.com>" \
        description="Basic-DS Dev Container Template"

###########################
### --- USER CONFIG --- ###
###########################
ARG USERNAME="btr"
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG USER_DIR='/home/$USERNAME'

############################
### --- CONDA CONFIG --- ###
############################
ARG CONDA_DIR="/opt/conda"
ARG CONDA_VERSION=4.7.12
ARG CONDA_URL="http://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh"


### --- SHOULD STOP MOST WARNINGS --- ###
ARG DEBIAN_FRONTEND=noninteractive

ENV PATH="$CONDA_DIR/bin:$PATH" \
    ### STOP PYTHON FROM WRITING ENDLESS
    ### PYCACHE FILES AT RUNTIME
    PYTHONDONTWRITEBYTECODE=1 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    SHELL=/bin/bash

###########################
### --- BUILD FILES --- ###
###########################

COPY ./src/fix-permissions /usr/local/bin/fix-permissions
USER root

RUN apt-get update --fix-missing && apt-get upgrade -y && \
    apt-get install -y \
# --- WHAT GOES HERE SHOULD BE IN ALPHABETICAL ORDER --- ###
# ------ # TO SAVE YOUR TEAM TIME DOWN THE ROAD # ------- ###
    apt-transport-https \
    bash \
    bash-completion \
    build-essential \
    bzip2 \
    ca-certificates \
    csh \
    curl \
    cmake \
    emacs \
    flex \
    fonts-liberation \
    g++ \
    gdebi-core \
    gfortran \
    git \
    graphviz \
    iproute2 \
    inkscape \
    jed \
    libboost-all-dev \
    libbz2-dev \
    libcairo2 \
    libcairo2-dev \
    libdb5.3-dev \
    libeigen3-dev \
    libexpat1-dev \
    libffi-dev \
    libgfortran3 \
    libgcc1 \
    libgdbm-dev \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsm6 \
    libssl-dev \
    libsqlite3-dev \
    libxext-dev \
    libxrender1 \
    lmodern \
    locales \
    lsb-base net-tools network-manager \
    lsb-core \
    man-db \
    nano \
    net-tools \
    openjdk-8-jdk \
    openssh-client \
    openssh-server \
    patch \
    python-dev \
    python3-venv \
    run-one \
    software-properties-common \
    sudo \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    tk-dev \
    vim \
    wget \
    xclip \
    xorg-dev \
    unzip \
    zlib1g-dev \
    zsh && \
##########################
### --- CLEAN CACHE --- ###
############################
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    chmod a+rx /usr/local/bin/fix-permissions && \
########################
#### --- PYTHON --- ###
######################
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install -y \
    python3.7 \
    python3-pip \
    ipython3 && \
############################    
### --- PIP PACKAGES ---###
##########################
    pip3 install jupyter && \
###########################
### --- ADD A NOT     --- ###
### --- ROOT USER WITH --- ###
### --PASSWORDLESS SUDO --- ####
#################################
    groupadd --gid $USER_GID $USERNAME && \
	useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME && \
	echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
	chmod 0440 /etc/sudoers.d/$USERNAME && \
##################################
#### --- MINICONDA INSTALL --- ####
####################################
    mkdir "$CONDA_DIR" && \
    cd /tmp && \
    ##################
    ### INSTALL #####
    ################
    wget -q "$CONDA_URL" -O miniconda.sh && \
	/bin/bash miniconda.sh -f -b -p "$CONDA_DIR" && \
    sudo echo "export PATH=$CONDA_DIR/bin:$PATH" > /etc/profile.d/conda.sh && \
	rm miniconda.sh && \
	$CONDA_DIR/bin/conda install --yes conda==$CONDA_VERSION && \
    #############
    ### CONFIG ###
    ###############
    echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    conda config --prepend channels conda-forge && \
    conda config --set auto_update_conda false && \
    conda config --set show_channel_urls true && \
	conda update --all --quiet --yes && \
    #####################
	### CONDA CLEAN UP ###
    #######################
	conda clean --all && \
    #################
	### FINALIZE ###
    ###############
    mkdir -p "$CONDA_DIR/locks" && \
    chmod 777 "$CONDA_DIR/locks"




WORKDIR $USER_DIR
EXPOSE 8888
USER $USERNAME