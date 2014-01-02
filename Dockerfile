FROM tianon/debian:wheezy
MAINTAINER Nat Welch <nat@natwelch.com>

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'deb http://gce_debian_mirror.storage.googleapis.com/ wheezy main contrib non-free' > /etc/apt/sources.list
RUN apt-key update
RUN apt-get update
RUN apt-get -qy install apt-utils build-essential checkinstall curl dialog git git-core imagemagick libcurl4-openssl-dev libffi-dev libgdbm-dev libicu-dev libncurses5-dev libpq-dev libreadline-dev libssl-dev libxml2-dev libxslt-dev libyaml-dev openssh-server pngcrush python python-docutils python-software-properties ssh vim zlib1g-dev

RUN mkdir -p /opt/ruby && cd /opt/ruby && curl --progress ftp://ftp.ruby-lang.org/pub/ruby/ruby-2.0.0-p353.tar.gz | tar xz
RUN cd /opt/ruby/ruby* && ./configure && make && make install
RUN echo "gem: --no-ri --no-rdoc" > /root/.gemrc
RUN gem install bundler

RUN echo " IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config
RUN mkdir -p /root/.ssh
RUN ssh-keyscan -t rsa,dsa github.com | sort -u > /root/.ssh/known_hosts
