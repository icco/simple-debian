FROM tianon/debian:wheezy
MAINTAINER Nat Welch <nat@natwelch.com>

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'deb http://gce_debian_mirror.storage.googleapis.com/ wheezy main contrib non-free' > /etc/apt/sources.list
RUN apt-key update
RUN apt-get update
ADD packages.txt /tmp/
RUN apt-get -qy install `cat /tmp/packages.txt`

RUN apt-get install -y language-pack-en
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

RUN mkdir -p /opt/ruby && cd /opt/ruby && curl --progress ftp://ftp.ruby-lang.org/pub/ruby/ruby-2.0.0-p353.tar.gz | tar xz
RUN cd /opt/ruby/ruby* && ./configure && make && make install
RUN echo "gem: --no-ri --no-rdoc" > /root/.gemrc
RUN gem install bundler

RUN echo " IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config
RUN mkdir -p /root/.ssh
RUN ssh-keyscan -t rsa,dsa github.com | sort -u > /root/.ssh/known_hosts
