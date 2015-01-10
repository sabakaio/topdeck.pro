FROM ubuntu:14.04
MAINTAINER Anton Egorov <anton.egoroff@gmail.com>

RUN locale-gen en_US.UTF-8 ru_RU.UTF-8 \
    && sed -i -e 's/archive.ubuntu.com/mirror.yandex.ru/g' /etc/apt/sources.list \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq && apt-get upgrade -qq \
    && apt-get install -qq \
        bash-completion \
        command-not-found \
        curl \
        htop \
        psmisc \
        tree \
        vim \
            build-essential \
            git-core \
            nginx-full \
            software-properties-common \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV NVM_DIR /root/.nvm
RUN echo 'Install NPM' \
    && curl https://raw.githubusercontent.com/creationix/nvm/v0.22.0/install.sh | bash \
    && . /root/.nvm/nvm.sh \
    && nvm install 0.11.14 \
    && npm install npm -g

WORKDIR /tmp/build
COPY package.json /tmp/build/
RUN . /root/.nvm/nvm.sh \
    && nvm use 0.11.14 \
    && npm install --loglevel error

COPY app/ /tmp/build/app/
COPY etc/ /etc/
COPY gulpfile.js /tmp/build/

RUN find . -name '*.swp' -delete \
    && API_HOST=topdeck.pro \
    && . /root/.nvm/nvm.sh \
    && nvm use 0.11.14 \
    && ./node_modules/.bin/gulp prod \
    && mkdir -p /opt/app/ \
    && mv /tmp/build/public/ /opt/app/public/ \
    && nginx -t
    #&& rm -rf /tmp/build \

EXPOSE 80
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
