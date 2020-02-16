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
    rm -rf /var/lib/apt/lists/*

ARG USERNAME="dev"
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
############################
### --- CONDA CONFIG --- ###
############################

ARG CONDA_DIR="/opt/conda"
ARG CONDA_VERSION=4.7.12

## --- SHOULD STOP MOST WARNINGS --- ###
ARG DEBIAN_FRONTEND=noninteractive

ENV PATH="$CONDA_DIR/bin:$PATH" \
    ### STOP PYTHON FROM WRITING ENDLESS
    ### PYCACHE FILES AT RUNTIME
    PYTHONDONTWRITEBYTECODE=1 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

USER root
    
    ###########################
    ### --- ADD A NOT     --- ###
    ### --- ROOT USER WITH --- ###
    ### --PASSWORDLESS SUDO --- ####
    #################################
RUN groupadd --gid $USER_GID $USERNAME && \
	useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME && \
	echo "$USERNAME ALL=\(root\) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
	chmod 0440 /etc/sudoers.d/$USERNAME && \
    ##################################
    #### --- MINICONDA INSTALL --- ####
    ####################################
    mkdir -p "$CONDA_DIR" && \
    wget -q "http://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh" -O miniconda.sh && \
    /bin/bash miniconda.sh -f -b -p "$CONDA_DIR" && \
    echo "export PATH=$CONDA_DIR/bin:$PATH" > /etc/profile.d/conda.sh && \
    rm miniconda.sh && \
    conda config --prepend channels conda-forge && \
    conda config --set auto_update_conda false && \
    conda config --set show_channel_urls true && \
    conda update --all --quiet --yes && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/profile.d/conda.sh && \
    echo "conda activate base" >> ~/.bashrc && \  
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    conda clean -afy && \
    conda install jupyterlab && \
    conda create -n python==3.7 --yes \

ENTRYPOINT ["pyml-entry.sh"]
EXPOSE 8888
USER ${USERNAME}
CMD ["/bin/bash"]    