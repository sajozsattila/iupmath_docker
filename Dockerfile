FROM mur2/pandoc:1.0.9

ARG DEBIAN_FRONTEND=noninteractive

# the user which run the application
RUN useradd -s /bin/bash mur2
# user home dir
WORKDIR /home/mur2
RUN echo 'export PATH=/usr/local/texlive/2020/bin/x86_64-linux:$PATH' >> .bashrc
RUN echo 'export PATH=/opt/pandoc-crossref/bin:$PATH' >> .bashrc


# i.upmath 
RUN apt-get update -y
RUN apt-get install -y git
RUN git clone git@github.com:sajozsattila/i.upmath.me.git
RUN cd i.upmath.me
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN yarn install
RUN composer install
RUN bower install
RUN grunt
# setting config
RUN cp config.php.dist config.php
RUN mcedit config.php # specify the LaTeX bin dir and other paths
RUN cp nginx.conf.dist /etc/nginx/sites-available/i.upmath.me
RUN mcedit /etc/nginx/sites-available/i.upmath.me

