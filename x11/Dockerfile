FROM  nvcr.io/nvidia/tensorflow:18.08-py3
LABEL maintainer caffe-maint@googlegroups.com 


RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
        aria2 \
        git \
	fuse \
	snapd \
	snap-confine \ 
	squashfuse \ 
	zsh \
        vim \
        sudo \
        htop \
        imagemagick \
        man \
        fdupes \
	openssl \
        libcurl4-gnutls-dev \
        wget \
        tmux \
        openssh-server \
        curl \
        python3-tk &&\
        rm -rf /var/lib/apt/lists/* &&\
        apt-get clean


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

# Pip installs
RUN python3 -m pip install opencv-contrib-python


#ld config over ssh
RUN ldconfig

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
ENV DISPLAY 10.21.18.200:20

# Entrypoint
COPY x11/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["sh","/usr/local/bin/entrypoint.sh"]

WORKDIR /workspace
