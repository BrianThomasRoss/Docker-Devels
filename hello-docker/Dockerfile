# --- BASE --- #
FROM ubuntu:18.04

# --- META --- #
LABEL maintainer="Brian Ross <brianthomasross.com>" \
	description="PyML Aide - A Python ML IDE Container"

# --- ENVIRONMENT CONFIG --- #
#----------------------------#
# ENV Persists into runtime  #
# ARG Persist during build   #
#----------------------------#
##############################

### --- USER CONFIG --- #
### Capital letters are foridden by ubuntu NAME_REGEX
ARG USERNAME=btr 
ARG USER_UID=1000 
ARG USER_GID=$USER_UID 
ARG PROJECT="dev-container" 
ARG USER_DIR="home/$USERNAME/$PROJECT" 
ARG VERSION="0.4" 
    
#--This should stop most warnings--#
ARG DEBIAN_FRONTEND=noninteractive 
    
### --- CONDA_CONFIG ----###
    
################################
#    Versions and MD5 info     #
#			       #
# repo.continuum.io/miniconda/ #
################################
    
ARG CONDA_DIR="/opt/conda" 
ARG CONDA_VERSION=4.7.12 
ARG CONDA_MD5="0dba759b8ecfc8948f626fa18785e3d8"

ENV PATH="$CONDA_DIR/bin:$PATH" \
    # --- PYTHON ---#
    # This enures python is not continuously writing redundant files at runtime
    PYTHONDONTWRITEBYTECODE=1 \
    # --- OS --- #
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    SHELL=/bin/bash
    

RUN apt-get update  && apt-get install -y \
# --- DEPENDENCIES --- #
	bash \
        bash-completion \
        build-essential \
        csh \
        curl \ 
        flex \
        g++ \
        gdebi-core \
        git \
	iproute2 \
        libboost-all-dev \
        libbz2-dev \
        libcairo2 \
        libcairo2-dev \
        libeigen3-dev \
        libgfortran3 \
        locales \
        lsb-base net-tools network-manager \
        lsb-core \
        man-db \
        net-tools \
        net-tools \
        openssh-client \
        openssh-server \
        patch \
        sudo \
        vim \
        wget \
        xclip \
        xorg-dev \
        zlib1g-dev \
	zsh && \
	\
	# ---- ADD USER ---- #
	\
	echo "*~*~*~*~* ADD USER *~*~*~*~*~*" && \
	\
	# Adds not root user with root permissions and passwordless sudo #
	groupadd --gid $USER_GID $USERNAME && \
	useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME && \
	echo "$USERNAME ALL=\(root\) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
	chmod 0440 /etc/sudoers.d/$USERNAME && \
	\
	# ---- Oh-My-Zsh ---- #
	\
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
	cp -R /root/.oh-my-zsh /home/$USERNAME && \
	cp /root/.zshrc /home/$USERNAME && \
	sed -i -e "s/\/root\/.oh-my-zsh/\/home\/$USERNAME\/.oh-my-zsh/g" /home/$USERNAME/.zshrc && \
	chown -R $USER_UID:$USER_GID /home/$USERNAME/.oh-my-zsh /home/$USERNAME/.zshrc && \
	# --- MAKE CONDA DIRECTORY AND CHANGE OWNERSHIP --- #
	mkdir -p $CONDA_DIR && \
	chown $USERNAME $CONDA_DIR && \
	# --- CLEAN DEPENDENCY CACHES --- #
	apt-get autoremove -y && \
	apt-get clean -y && \
	rm -rf /var/lib/apt/lists/*	 


USER $USERNAME
COPY $PROJECT  $USER_DIR/

# ----- MINICONDA INSTALL ------ #
	
	### DOWNLOAD CONDA ###

RUN cd /tmp && \
	echo "*******GET  CONDA********" && \
	wget "http://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh" -O miniconda.sh && \
	### CHECKSUM ### 
	echo "$CONDA_MD5  miniconda.sh" | md5sum -c  && \
	#### INSTALL ###
	echo "********INSTALL CONDA********" && \
	/bin/bash miniconda.sh -f -b -p "$CONDA_DIR" && \
	rm miniconda.sh && \
	$CONDA_DIR/bin/conda install --yes conda==$CONDA_VERSION && \
	### SETUP ###
	echo "******SETUP*******" && \
	conda upgrade -y pip && \
	conda update --all --yes && \
	conda config --set auto_update_conda False && \
	conda config --add channels conda-forge && \
	### CONDA CLEAN UP ###
	conda clean --all --force-pkgs-dirs --yes && \
	find "$CONDA_DIR" -follow -type f \( -iname '*.a' -o -iname '*.pyc' -o -iname '*.js.map' \) -delete && \
	### FINALIZE ###
	mkdir -p "$CONDA_DIR/locks" && \
    	chmod 777 "$CONDA_DIR/locks" 	


	### --- JUPYTER --- ###
	
RUN conda install --yes \
	'notebook=6.0.3' \
	'jupyterhub=1.1.0' \
    	'jupyterlab=1.2.5' && \
    	### --- CLEAN CACHE --- ###
	conda clean --all -f -y && \
    	jupyter notebook --generate-config && \
    	rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    	rm -rf /home/$USERNAME/.cache/yarn && \
	\
	### --- CREATE PROJECT ENV --- ###
	\
	conda env create -f $USER_DIR/environment.yml && \
	conda clean --all -f -y && \
	### --- ADD KERNEL TO JUPYTER --- #
	\
	python -m ipykernel install --user --name $PROJECT --display-name "$PROJECT" && \
	### START CONTAINER WITH PROJECT ENV ###
	echo "source activate $PROJECT" >> ~/.bashrc && \
	echo "*****CONFIGURING STARTING ENVIRONMENT*****"


# CONFIGURE CONTAINER STARTING POINT	
WORKDIR $USER_DIR
# Expose Jupyter port
EXPOSE 8888
ENTRYPOINT ["/bin/bash" "docker-entrypoint.sh" ]
# Switch to user
USER $USERNAME
