FROM pyml-dev/base:latest

###########################
### --- USER CONFIG --- ###
###########################

ARG USERNAME="dev"
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
# ARG DEBIAN_FRONTEND=noninteractive

ENV PATH="$CONDA_DIR/bin:$PATH" \
    ### STOP PYTHON FROM WRITING ENDLESS
    ### PYCACHE FILES AT RUNTIME
    PYTHONDONTWRITEBYTECODE=1 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8   
    
    ###########################
    ### --- ADD A NOT     --- ###
    ### --- ROOT USER WITH --- ###
    ### --PASSWORDLESS SUDO --- ####
    #################################
RUN groupadd --gid $USER_GID $USERNAME && \
	useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME && \
	echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
	chmod 0440 /etc/sudoers.d/$USERNAME && \
    ##################################
    #### --- MINICONDA INSTALL --- ####
    ####################################
    mkdir "$CONDA_DIR" && \
    cd /tmp && \
    wget -q "CONDA_URL" -O miniconda.sh && \
    /bin/bash miniconda.sh -f -b -p "CONDA_DIR" && \
    sudo echo "export PATH=$CONDA_DIR/bin:$PATH" > /etc/profile.d/conda.sh && \
    rm miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    $CONDA_DIR/bin/conda install --yes conda==$CONDA_VERSION && \
    echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    conda config --prepend channels conda-forge && \
    conda config --set auto_update_conda false && \
    conda config --set show_channel_urls true && \
    conda update --all --quiet --yes && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/profile.d/conda.sh && \
    echo "conda activate base" >> ~/.bashrc && \  
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    conda clean -afy && \
    conda install jupyterlab && \
    conda create -n python==3.7 --yes

USER ${USERNAME}
CMD ["/bin/bash"]    