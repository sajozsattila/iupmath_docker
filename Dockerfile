FROM mur2/pandoc:1.0.11

ARG DEBIAN_FRONTEND=noninteractive

# the user which run the application
RUN useradd -s /bin/bash mur2
# user home dir
WORKDIR /home/mur2
RUN echo 'export PATH=/usr/local/texlive/2020/bin/x86_64-linux:$PATH' >> /root/.bashrc && \
    echo 'export PATH=/opt/pandoc-crossref/bin:$PATH' >> /root/.bashrc

# update nodehs and npm
RUN apt-get update -y && apt-get install -y git gnupg2  php-cli php-mbstring unzip php-curl php-dom curl dirmngr apt-transport-https lsb-release ca-certificates
RUN ( curl -sL https://deb.nodesource.com/setup_12.x | bash - ) && apt -y install nodejs && npm update npm -g  && node --version && npm --version
# i.upmath 
RUN apt-get -y install software-properties-common curl && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash -  
# add yarn
RUN (curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg > yarnkey.gpg) && \
    apt-key add yarnkey.gpg && \
    rm yarnkey.gpg && \
    (echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list) && \
    apt-get update &&  apt-get install yarn -y
# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&  php composer-setup.php --install-dir=/usr/local/bin --filename=composer
# get i.upmath
RUN wget https://github.com/sajozsattila/i.upmath.me/archive/master.zip &&  unzip master.zip && rm master.zip &&  mv i.upmath.me-master i.upmath.me 
WORKDIR /home/mur2/i.upmath.me
RUN yarn install && composer install && npm install -g bower grunt-cli && bower install --allow-root && grunt && apt-get -y install optipng && apt-get -y install librsvg2-bin
# setting config
COPY Resources/config.php  ./

# install php
RUN (wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -) && \
    (echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list) && \
    apt install -y php php-fpm 

# set some directory 
RUN mkdir /home/mur2/i.upmath.me/logs && \
    chown mur2:mur2 /home/mur2/i.upmath.me/logs && \
    mkdir www/tex_logs && \
    chmod 777 www/tex_logs && \
    chmod 777 www/tmp && \
    mkdir -p /var/run/php

# nginx
RUN apt-get install -y nginx  nginx-extras &&  rm /etc/nginx/sites-enabled/default
COPY Resources/nginx.conf /etc/nginx/sites-enabled/mur2
COPY  Resources/www.conf /etc/php/7.3/fpm/pool.d/www.conf


# CMD php-fpm7.3 ; /usr/sbin/nginx -g "daemon off;"

