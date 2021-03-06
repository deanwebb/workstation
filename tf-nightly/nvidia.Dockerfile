
# THIS IS A GENERATED DOCKERFILE.
#
# This file was assembled from multiple pieces, whose use is documented
# below. Please refer to the the TensorFlow dockerfiles documentation for
# more information. Build args are documented as their default value.
#
# Ubuntu-based, Nvidia-GPU-enabled environment for using TensorFlow.
#
# NVIDIA with CUDA and CuDNN, no dev stuff
# --build-arg UBUNTU_VERSION=16.04
#    ( no description )
#
# Python is required for TensorFlow and other libraries.
# --build-arg USE_PYTHON_3_NOT_2=True
#    Install python 3 over Python 2
#
# Install the TensorFlow Python package.
# --build-arg TF_PACKAGE=tensorflow-gpu (tensorflow|tensorflow-gpu|tf-nightly|tf-nightly-gpu)
#    The specific TensorFlow Python package to install
#
# Configure TensorFlow's shell prompt and login tools.

#FROM nvcr.io/nvidia/cuda:9.0-cudnn7.2-devel-ubuntu16.04
FROM nvidia/cuda:9.0-base-ubuntu16.04
# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        aria2 \
        build-essential \
        curl \
        cuda-command-line-tools-9-0 \
        cuda-cublas-9-0 \
        cuda-cufft-9-0 \
        cuda-curand-9-0 \
        cuda-cusolver-9-0 \
        cuda-cusparse-9-0 \
        fdupes \
        htop \
        man \
        imagemagick \
        libcudnn7=7.2.1.38-1+cuda9.0 \
        libnccl2=2.2.13-1+cuda9.0 \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libpng12-dev \
        libcurl4-gnutls-dev \
        libzmq3-dev \
        openssh-server \
        openssl \
        pkg-config \
        software-properties-common \
        sudo \
        unzip \
        git \
        vim \
        wget \
        zsh && \
        rm -rf /var/lib/apt/lists/* && \
        apt-get clean
        

RUN apt-get update && \
        apt-get install nvinfer-runtime-trt-repo-ubuntu1604-4.0.1-ga-cuda9.0 && \
        apt-get update && \
        apt-get install libnvinfer4=4.1.2-1+cuda9.0

ARG USE_PYTHON_3_NOT_2=True
ARG _PY_SUFFIX=${USE_PYTHON_3_NOT_2:+3.6}
ARG _PIP_SUFFIX=${USE_PYTHON_3_NOT_2:+3}
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PIP_SUFFIX}

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture)" \
        && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture).asc" \
            && gpg --verify /usr/local/bin/gosu.asc \
                && rm /usr/local/bin/gosu.asc \
                    && chmod +x /usr/local/bin/gosu

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:george-edison55/cmake-3.x && \
    apt-get install -y cmake && \
    apt-get update


#ld config over ssh
RUN ldconfig

RUN apt-get update && \
    add-apt-repository ppa:jonathonf/python-3.6 &&\
    apt-get update && \
    apt-get install -y \
    ${PYTHON} \
    python-pip

RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3.6 get-pip.py
    
RUN ${PYTHON} -m pip install --upgrade \
    pip \
    opencv-python \
    numpy \
    matplotlib \
    scipy \
    setuptools 

ARG TF_PACKAGE=tf-nightly-gpu
RUN ${PYTHON} -m pip install ${TF_PACKAGE} 

RUN chmod a+rwx /etc/bash.bashrc

# Oh my zsh
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "zsh"]
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Rmate
RUN curl -Lo /bin/rmate https://raw.githubusercontent.com/textmate/rmate/master/bin/rmate && \
        chmod a+x /bin/rmate

# Display VNC
RUN apt-get install -y x11vnc
EXPOSE 5920
ENV DISPLAY :20

# Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["sh","/usr/local/bin/entrypoint.sh"]