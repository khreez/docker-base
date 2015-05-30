FROM ubuntu:14.04

# Note: The official Debian and Ubuntu images automatically ``apt-get clean``
# after each ``apt-get``

ENV DEBIAN_FRONTEND noninteractive

# Install base dependencies
RUN apt-get update && apt-get install -y \
  software-properties-common \
  wget \
  vim \
  curl

# Installing Oracle java 8 and set it as default
RUN add-apt-repository -y ppa:webupd8team/java
# auto accept Oracle license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get update && apt-get install -y \
  oracle-java8-installer \
  oracle-java8-set-default

# Installing maven 3.3.3
RUN wget --no-verbose -O /tmp/apache-maven-3.3.3.tar.gz http://archive.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
RUN tar xzf /tmp/apache-maven-3.3.3.tar.gz -C /opt/
RUN rm -f /tmp/apache-maven-3.3.3.tar.gz
RUN ln -s /opt/apache-maven-3.3.3 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
ENV MAVEN_HOME /opt/maven

# Installing Node.js v0.12
RUN curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
RUN apt-get update && apt-get install -y nodejs

# Installing Postgresql 9.4
RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LC_COLLATE en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV PG_MAJOR 9.4
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get install -y \
  postgresql-$PG_MAJOR \
  postgresql-common

ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
ENV PGDATA /var/lib/postgresql/$PG_MAJOR/main

# Expose the PostgreSQL port
EXPOSE 5432
