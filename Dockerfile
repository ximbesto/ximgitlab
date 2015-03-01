FROM ximbesto/ximbase:latest
MAINTAINER Ximbesto

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E1DF1F24
RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv C3173AA6
RUN echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv C300EE8C
RUN echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu trusty main" >> /etc/apt/sources.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update
RUN apt-get install -y supervisor logrotate locales
RUN apt-get install -y nginx mysql-client postgresql-client redis-tools
RUN apt-get install -y git-core ruby2.1 python2.7 python-docutils
RUN apt-get install -y libmysqlclient18 libpq5 zlib1g libyaml-0-2 libssl1.0.0
RUN apt-get install -y libgdbm3 libreadline6 libncurses5 libffi6
RUN apt-get install -y libxml2 libxslt1.1 libcurl3 libicu52
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
RUN gem install --no-document bundler
RUN rm -rf /var/lib/apt/lists/* # 20150220

COPY assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

COPY assets/config/ /app/setup/config/
COPY assets/init /app/init
RUN chmod 755 /app/init

EXPOSE 22
EXPOSE 80
EXPOSE 443

VOLUME ["/home/git/data"]
VOLUME ["/var/log/gitlab"]
CMD ["/sbin/my_init"]
ENTRYPOINT ["/app/init"]
CMD ["app:start"]
