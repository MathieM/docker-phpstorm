FROM ubuntu:vivid
MAINTAINER Iain Mckay "me@iainmckay.co.uk"

RUN apt-get update && \
    apt-get install -y software-properties-common wget git curl && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get update && \
    apt-get install -y graphviz phpunit nodejs \
        php7-cli php7-mcrypt php7-mysql php7-xdebug php7-curl php7-memcached php7-memcache php-pear php5-gd php7-apcu php7-imagick php7-imap php7-intl php7-sasl php7-xdebug \
        openjdk-8-jre libxext-dev libxrender-dev libxtst-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN useradd -m -s /bin/bash developer \
    && mkdir /home/developer/.PhpStorm-2021.1.2 \
    && touch /home/developer/.PhpStorm-2021.1.2/.keep \
    && chown -R developer.developer /home/developer \
    && mkdir /opt/phpstorm \
    && wget -O - https://download.jetbrains.com/webide/PhpStorm-2021.1.2.tar.gz | tar xzf - --strip-components=1 -C "/opt/phpstorm"

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin
RUN php7enmod mcrypt mysql xdebug curl memcached memcache gd apcu imagick imap intl sasl
RUN wget -c http://static.phpmd.org/php/latest/phpmd.phar -O /usr/bin/phpmd.phar && chmod +x /usr/bin/phpmd.phar
RUN pear install PHP_CodeSniffer
RUN npm install -g bower

USER developer
VOLUME /home/developer/.PhpStorm-2021.1.2
CMD /opt/phpstorm/bin/phpstorm.sh
